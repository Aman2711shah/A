import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/firebase_storage_service.dart';
import '../../../core/services/firebase_firestore_service.dart';

class DocumentUploadService {
  final FirebaseStorageService _storageService = FirebaseStorageService();
  final FirestoreService _firestoreService = FirestoreService();

  /// Upload a document for company setup
  Future<Map<String, dynamic>> uploadDocument({
    required String documentId,
    required String documentType,
    required String applicationId,
    Function(double)? onProgress,
  }) async {
    try {
      // Pick file using file_picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        throw Exception('No file selected');
      }

      final file = result.files.first;
      final fileName = file.name;
      final fileExtension = fileName.split('.').last.toLowerCase();

      // Validate file size (max 10MB)
      final fileSize = file.size;
      if (fileSize > 10 * 1024 * 1024) {
        throw Exception('File size must be less than 10MB');
      }

      // Validate file type
      final allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'];
      if (!allowedExtensions.contains(fileExtension)) {
        throw Exception(
            'Invalid file type. Allowed: ${allowedExtensions.join(", ")}');
      }

      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      String downloadUrl;

      if (kIsWeb) {
        // For web, upload from bytes
        if (file.bytes == null) {
          throw Exception('Unable to read file');
        }

        final contentType = _getContentType(fileExtension);
        downloadUrl = await _storageService.uploadFileFromBytes(
          bytes: file.bytes!,
          storagePath:
              'applications/$applicationId/documents/$documentId/$fileName',
          contentType: contentType,
          onProgress: onProgress,
        );
      } else {
        // For mobile/desktop, upload from path
        if (file.path == null) {
          throw Exception('Unable to read file path');
        }

        downloadUrl = await _storageService.uploadFile(
          filePath: file.path!,
          storagePath:
              'applications/$applicationId/documents/$documentId/$fileName',
          onProgress: onProgress,
        );
      }

      // Create document metadata
      final documentData = {
        'id': documentId,
        'name': fileName,
        'type': documentType,
        'url': downloadUrl,
        'size': fileSize,
        'extension': fileExtension,
        'uploadedBy': user.uid,
        'uploadedAt': DateTime.now().toIso8601String(),
        'applicationId': applicationId,
      };

      // Save metadata to Firestore
      await _firestoreService.uploadDocumentMetadata({
        ...documentData,
        'userId': user.uid,
      });

      return documentData;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a document
  Future<void> deleteDocument({
    required String documentUrl,
    required String documentMetadataId,
  }) async {
    try {
      // Delete from Storage
      await _storageService.deleteFileByUrl(documentUrl);

      // Delete metadata from Firestore
      await _firestoreService.deleteDocumentMetadata(documentMetadataId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get content type from file extension
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  /// Get file size in readable format
  static String getReadableFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
