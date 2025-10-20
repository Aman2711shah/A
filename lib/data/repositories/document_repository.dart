import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../config/constants/api_constants.dart';
import '../models/application_model.dart';

class DocumentRepository {
  final DioClient dioClient;

  DocumentRepository({required this.dioClient});

  Future<DocumentModel> uploadDocument({
    required File file,
    required String documentType,
    required String applicationId,
    Function(double)? onProgress,
  }) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        'documentType': documentType,
        'applicationId': applicationId,
      });

      final response = await dioClient.post(
        ApiConstants.uploadDocument,
        data: formData,
      );

      return DocumentModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Document upload failed: ${e.toString()}');
    }
  }

  Future<List<DocumentModel>> getDocuments(String applicationId) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.getDocuments}?applicationId=$applicationId',
      );
      final List data = response.data['data'];
      return data.map((json) => DocumentModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch documents: ${e.toString()}');
    }
  }
}