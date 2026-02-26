// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_provider.dart';
import 'package:musiclearner/components/feescard.dart';
import 'package:musiclearner/components/paidfees.dart';

class Fees extends StatelessWidget {
  const Fees({super.key});

  Future<List<Map<String, dynamic>>> _fetchPaymentHistory(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final rollNo = authProvider.studentProfile?['student_rollno'];

    if (rollNo == null) return [];

    final supabase = Supabase.instance.client;

    final List<dynamic> payments = await supabase
        .from('Fees_payment')
        .select()
        .eq('student_rollno', rollNo)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(payments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F24),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Fees",
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPaymentHistory(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFB7BDF7)));
          }

          final paymentList = snapshot.data ?? [];

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Feescard(
                  label: "Balance",
                  value: "₹0.00",
                  icon: Icons.account_balance_wallet_outlined,
                ),
                const SizedBox(height: 10),
                const Feescard(
                  label: "Summary",
                  value: "Record Updated",
                  icon: Icons.calendar_today_outlined,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Paid Fees",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                if (paymentList.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No payment records found.", style: TextStyle(color: Colors.white54)),
                    ),
                  )
                else
                  ...paymentList.map((payment) {
                    return Paidfees(
                      title: payment['fee_category'] ?? "General Fee",
                      date: "Paid on ${payment['created_at'].toString().split('T')[0]}",
                      amount: payment['payment_amount'] ?? "0.00",
                    );
                  }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}