import '../../core/network/dio_client.dart';
import '../../config/constants/api_constants.dart';
import '../models/company_setup_model.dart';

class CompanySetupRepository {
  final DioClient dioClient;

  CompanySetupRepository({required this.dioClient});

  Future<List<BusinessActivity>> getActivities() async {
    try {
      final response = await dioClient.get(ApiConstants.activities);
      final List data = response.data['data'];
      return data.map((json) => BusinessActivity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch activities: ${e.toString()}');
    }
  }

  Future<void> saveDraft(CompanySetupModel setup) async {
    try {
      await dioClient.post(
        ApiConstants.saveDraft,
        data: setup.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to save draft: ${e.toString()}');
    }
  }

  Future<double> calculateCost({
    required List<String> activities,
    required int visaCount,
    required int licenseTenure,
    required String entityType,
    required String freeZone,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.calculateCost,
        data: {
          'activities': activities,
          'visaCount': visaCount,
          'licenseTenure': licenseTenure,
          'entityType': entityType,
          'freeZone': freeZone,
        },
      );
      return response.data['data']['estimatedCost'].toDouble();
    } catch (e) {
      throw Exception('Failed to calculate cost: ${e.toString()}');
    }
  }
}