// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_provider.dart';
import 'package:musiclearner/components/feescard.dart';
import 'package:musiclearner/components/paidfees.dart';

class Fees extends StatelessWidget {
  const Fees({super.key});

  /// Fetches payment records from the Fees_payment table
  Future<List<Map<String, dynamic>>> _fetchPaymentHistory(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    
    // Using the mapped roll number from our new schema
    final rollNo = authProvider.studentData?['student_rollno'] ?? 
                   authProvider.studentData?['student_rollno'];

    if (rollNo == null) return [];

    try {
      final supabase = Supabase.instance.client;

      // Ensure the column name matches your database (e.g., student_rollnotext)
      final List<dynamic> payments = await supabase
          .from('Fees_payment')
          .select()
          .eq('student_rollno', rollNo) // Verify if this column is student_rollno or student_rollnotext
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(payments);
    } catch (e) {
      debugPrint("Error fetching fees: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFB7BDF7);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F24),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Fees & Payments",
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPaymentHistory(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: accentColor));
          }

          final paymentList = snapshot.data ?? [];
          
          // Logic to calculate total paid if needed
          double totalPaid = 0;
          for (var item in paymentList) {
            totalPaid += double.tryParse(item['payment_amount']?.toString() ?? '0') ?? 0;
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Trigger a rebuild by calling the fetch again
              (context as Element).markNeedsBuild();
            },
            color: accentColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Balance Card ---
                  const Feescard(
                    label: "Current Balance",
                    value: "₹0.00", // You can map this to a 'pending_fees' column if it exists
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  const SizedBox(height: 10),
                  
                  // --- Total Paid Card ---
                  Feescard(
                    label: "Total Fees Paid",
                    value: "₹${totalPaid.toStringAsFixed(2)}",
                    icon: Icons.check_circle_outline_rounded,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // --- Payment History Header ---
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "Payment History",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white12, height: 25),

                  if (paymentList.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: const [
                            Icon(Icons.receipt_long_outlined, size: 50, color: Colors.white10),
                            SizedBox(height: 10),
                            Text("No payment records found.", style: TextStyle(color: Colors.white38)),
                          ],
                        ),
                      ),
                    )
                  else
                    ...paymentList.map((payment) {
                      // Formatting date safely
                      String dateStr = "N/A";
                      if (payment['created_at'] != null) {
                        dateStr = payment['created_at'].toString().split('T')[0];
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Paidfees(
                          title: payment['fee_category'] ?? "Tuition Fee",
                          date: "Paid on $dateStr",
                          amount: "₹${payment['payment_amount'] ?? "0.00"}",
                        ),
                      );
                    }).toList(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}