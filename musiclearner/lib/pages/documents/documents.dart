// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  Future<List<FileObject>>? _filesFuture;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure context is available for the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshFiles();
    });
  }

  void _refreshFiles() {
    if (!mounted) return;
    setState(() {
      _filesFuture = _fetchFilesFromStorage();
    });
  }

  Future<List<FileObject>> _fetchFilesFromStorage() async {
    final authProvider = context.read<AuthProvider>();
    // Updated to match your new studentData schema mapping
    final rollNo = authProvider.studentData?['student_rollnotext'] ?? 
                   authProvider.studentData?['student_rollno'];

    if (rollNo == null) return [];

    try {
      final supabase = Supabase.instance.client;
      // Fetch list of files in the student's specific folder
      final List<FileObject> objects = await supabase.storage
          .from('student_docs')
          .list(path: '$rollNo');
      
      return objects.where((file) => file.name != '.emptyFolderPlaceholder').toList();
    } catch (e) {
      debugPrint("Storage fetch error: $e");
      return [];
    }
  }

  Future<void> _handleUpload() async {
    final authProvider = context.read<AuthProvider>();
    final rollNo = authProvider.studentData?['student_rollno'] ?? 
                   authProvider.studentData?['student_rollno'];
    
    if (rollNo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User session not found. Please log in again."))
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      withData: true, 
    );

    if (result != null) {
      setState(() => _isUploading = true);
      
      final fileBytes = result.files.single.bytes;
      final fileName = result.files.single.name;
      final storagePath = '$rollNo/$fileName';

      try {
        final supabase = Supabase.instance.client;
        
        if (kIsWeb || fileBytes != null) {
          // Reliable method for Web and Mobile when bytes are available
          await supabase.storage.from('student_docs').uploadBinary(
            storagePath,
            fileBytes!,
            fileOptions: const FileOptions(upsert: true),
          );
        } else {
          // Fallback for Mobile if bytes somehow missing but path exists
          final file = File(result.files.single.path!);
          await supabase.storage.from('student_docs').upload(
            storagePath,
            file,
            fileOptions: const FileOptions(upsert: true),
          );
        }
        
        _refreshFiles(); 
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Upload Successful!"), backgroundColor: Color(0xFF38B982)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload failed: $e"), backgroundColor: Colors.redAccent),
          );
        }
      } finally {
        if (mounted) setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFB7BDF7);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
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
            const LinearProgressIndicator(
              backgroundColor: Color(0xFF1A1E36),
              color: accentColor,
            ),
          Expanded(
            child: FutureBuilder<List<FileObject>>(
              future: _filesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: accentColor));
                }

                final files = snapshot.data ?? [];

                return RefreshIndicator(
                  color: accentColor,
                  backgroundColor: const Color(0xFF1A1E36),
                  onRefresh: () async => _refreshFiles(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recent Uploads", 
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                            TextButton.icon(
                              onPressed: _isUploading ? null : _handleUpload,
                              icon: const Icon(Icons.add_circle_outline, size: 18, color: accentColor),
                              label: Text(
                                "Upload new", 
                                style: TextStyle(
                                  color: _isUploading ? Colors.grey : accentColor, 
                                  fontWeight: FontWeight.w900
                                )
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.white10),
                        const SizedBox(height: 10),
                        if (files.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Column(
                                children: const [
                                  Icon(Icons.folder_open_rounded, size: 64, color: Colors.white10),
                                  SizedBox(height: 16),
                                  Text("No documents found.", style: TextStyle(color: Colors.white38)),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: files.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final file = files[index];
                              final isPdf = file.name.toLowerCase().endsWith('.pdf');
                              final sizeInKb = (file.metadata?['size'] ?? 0) / 1024;
                              
                              return Documentscard(
                                title: file.name,
                                subTitle: "${sizeInKb.toStringAsFixed(1)} KB • ${file.createdAt?.split('T')[0] ?? 'N/A'}",
                                leadingIcon: isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
                                onDownload: () {
                                  // Add download logic here if needed
                                },
                              );
                            },
                          ),
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