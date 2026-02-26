import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclearner/components/documentscard.dart';

class Documents extends StatelessWidget {
  const Documents({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        ),
        title: const Text(
          "Documents Center",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),


       body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
            // SEARCH BAR
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2140),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white54, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            "Search for documents",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
              const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Recent Uploads",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Upload new",
                    style: TextStyle(
                      color: Color(0xFFB7BDF7),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
Documentscard(
  title: "Student ID Card",
  subTitle: "PDF • 1.2 MB • Oct 12, 2023",
  leadingIcon: Icons.badge_outlined,
  onDownload: () {
    print("Downloading ID...");
  },
),
Documentscard(
  title: "Grade Report - Semester 1",
  subTitle: "PDF • 450 KB • Jan 20, 2024",
  leadingIcon: Icons.article_outlined,
  onDownload: () {},
),
Documentscard(
  title: "Web Dev Certification",
  subTitle: "JPG • 3.4 MB • Feb 05, 2024",
  leadingIcon: Icons.workspace_premium_outlined,
  onDownload: () {},
),

            ],
          ),
          ),
        ),
      );
    
  }
}