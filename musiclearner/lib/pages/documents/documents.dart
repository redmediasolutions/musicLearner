// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/auth_provider.dart';
import 'package:musiclearner/components/documentscard.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  bool _isUploading = false;
  late Future<List<FileObject>> _filesFuture;

  @override
  void initState() {
    super.initState();
    _refreshFiles();
  }

  void _refreshFiles() {
    setState(() {
      _filesFuture = _fetchFilesFromStorage();
    });
  }

  Future<List<FileObject>> _fetchFilesFromStorage() async {
    final authProvider = context.read<AuthProvider>();
    final rollNo = authProvider.studentProfile?['student_rollno'];

    if (rollNo == null) return [];

    try {
      final supabase = Supabase.instance.client;
      // Scans the folder matching the student's unique roll number
      final List<FileObject> objects = await supabase.storage
          .from('student_docs')
          .list(path: '$rollNo');
      
      return objects.where((file) => file.name != '.emptyFolderPlaceholder').toList();
    } catch (e) {
      debugPrint("Fetch error: $e");
      return [];
    }
  }

  Future<void> _handleUpload() async {
    final authProvider = context.read<AuthProvider>();
    final rollNo = authProvider.studentProfile?['student_rollno'];
    
    if (rollNo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User session not found."))
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => _isUploading = true);
      
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;
      final storagePath = '$rollNo/$fileName';

      try {
        final supabase = Supabase.instance.client;
        
        await supabase.storage.from('student_docs').upload(
          storagePath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload Successful!"))
        );
        _refreshFiles(); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e"))
        );
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

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
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
        ),
      ),
      body: Column(
        children: [
          if (_isUploading) 
            const LinearProgressIndicator(backgroundColor: Colors.transparent, color: Color(0xFFB7BDF7)),
          
          Expanded(
            child: FutureBuilder<List<FileObject>>(
              future: _filesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFB7BDF7)));
                }

                final files = snapshot.data ?? [];

                return RefreshIndicator(
                  onRefresh: () async => _refreshFiles(),
                  color: const Color(0xFFB7BDF7),
                  backgroundColor: const Color(0xFF1A1E40),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recent Uploads", 
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                            GestureDetector(
                              onTap: _isUploading ? null : _handleUpload,
                              child: Text(
                                "Upload new", 
                                style: TextStyle(
                                  color: _isUploading ? Colors.grey : const Color(0xFFB7BDF7), 
                                  fontWeight: FontWeight.w900
                                )
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        if (files.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 80),
                            child: Center(
                              child: Text("No documents found.", style: TextStyle(color: Colors.white38))
                            ),
                          )
                        else
                          ...files.map((file) {
                            final isPdf = file.name.toLowerCase().endsWith('.pdf');
                            final double sizeInKb = (file.metadata?['size'] ?? 0) / 1024;
                            final String sizeText = sizeInKb > 1024 
                                ? "${(sizeInKb / 1024).toStringAsFixed(1)} MB" 
                                : "${sizeInKb.toStringAsFixed(1)} KB";

                            return Documentscard(
                              title: file.name,
                              // Null-safe date parsing
                              subTitle: "$sizeText • ${file.createdAt?.split('T')[0] ?? 'N/A'}",
                              leadingIcon: isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
                              onDownload: () {
                                final authProvider = context.read<AuthProvider>();
                                final rollNo = authProvider.studentProfile?['student_rollno'];
                                final url = Supabase.instance.client.storage
                                    .from('student_docs')
                                    .getPublicUrl('$rollNo/${file.name}');
                                
                                debugPrint("Access URL: $url");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Download link generated."))
                                );
                              },
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}