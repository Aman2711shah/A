import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file
  Future<String> uploadFile({
    required String filePath,
    required String storagePath,
    Function(double)? onProgress,
  }) async {
    try {
      final file = File(filePath);
      final ref = _storage.ref().child(storagePath);

      final uploadTask = ref.putFile(file);

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      await uploadTask;
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Upload file from bytes (for web)
  Future<String> uploadFileFromBytes({
    required Uint8List bytes,
    required String storagePath,
    required String contentType,
    Function(double)? onProgress,
  }) async {
    try {
      final ref = _storage.ref().child(storagePath);
      final metadata = SettableMetadata(contentType: contentType);

      final uploadTask = ref.putData(bytes, metadata);

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      await uploadTask;
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Upload user document
  Future<String> uploadUserDocument({
    required String userId,
    required String filePath,
    required String fileName,
    required String documentType, // 'passport', 'visa', 'license', etc.
    Function(double)? onProgress,
  }) async {
    final storagePath = 'users/$userId/documents/$documentType/$fileName';
    return await uploadFile(
      filePath: filePath,
      storagePath: storagePath,
      onProgress: onProgress,
    );
  }

  // Upload company document
  Future<String> uploadCompanyDocument({
    required String companyId,
    required String filePath,
    required String fileName,
    required String documentType,
    Function(double)? onProgress,
  }) async {
    final storagePath =
        'companies/$companyId/documents/$documentType/$fileName';
    return await uploadFile(
      filePath: filePath,
      storagePath: storagePath,
      onProgress: onProgress,
    );
  }

  // Upload user avatar
  Future<String> uploadUserAvatar({
    required String userId,
    required String filePath,
    Function(double)? onProgress,
  }) async {
    final extension = filePath.split('.').last;
    final storagePath = 'users/$userId/avatar/avatar.$extension';
    return await uploadFile(
      filePath: filePath,
      storagePath: storagePath,
      onProgress: onProgress,
    );
  }

  // Upload user avatar from bytes (web)
  Future<String> uploadUserAvatarFromBytes({
    required String userId,
    required Uint8List bytes,
    required String contentType,
    Function(double)? onProgress,
  }) async {
    final extension = contentType.split('/').last;
    final storagePath = 'users/$userId/avatar/avatar.$extension';
    return await uploadFileFromBytes(
      bytes: bytes,
      storagePath: storagePath,
      contentType: contentType,
      onProgress: onProgress,
    );
  }

  // Delete file
  Future<void> deleteFile(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  // Delete file by URL
  Future<void> deleteFileByUrl(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  // Get download URL
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  // List files in directory
  Future<List<String>> listFiles(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final result = await ref.listAll();

      final urls = await Future.wait(
        result.items.map((item) => item.getDownloadURL()),
      );

      return urls;
    } catch (e) {
      rethrow;
    }
  }

  // Get file metadata
  Future<FullMetadata> getFileMetadata(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getMetadata();
    } catch (e) {
      rethrow;
    }
  }

  // Update file metadata
  Future<void> updateFileMetadata(
    String storagePath,
    Map<String, String> customMetadata,
  ) async {
    try {
      final ref = _storage.ref().child(storagePath);
      await ref.updateMetadata(
        SettableMetadata(customMetadata: customMetadata),
      );
    } catch (e) {
      rethrow;
    }
  }
}
