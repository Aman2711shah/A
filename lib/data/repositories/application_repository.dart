import '../../core/network/dio_client.dart';
import '../../config/constants/api_constants.dart';
import '../models/application_model.dart';

class ApplicationRepository {
  final DioClient dioClient;

  ApplicationRepository({required this.dioClient});

  Future<List<ApplicationModel>> getApplications() async {
    try {
      final response = await dioClient.get(ApiConstants.getApplications);
      final List data = response.data['data'];
      return data.map((json) => ApplicationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch applications: ${e.toString()}');
    }
  }

  Future<ApplicationModel> applyForTradeLicense({
    required String jurisdiction,
    required String emirateFreeZone,
    required String packageId,
    required Map<String, dynamic> contactDetails,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.applyTradeLicense,
        data: {
          'jurisdiction': jurisdiction,
          'emirateFreeZone': emirateFreeZone,
          'packageId': packageId,
          'contactDetails': contactDetails,
        },
      );
      return ApplicationModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to apply for trade license: ${e.toString()}');
    }
  }

  Future<ApplicationModel> trackApplication(String applicationId) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.getApplications}/$applicationId',
      );
      return ApplicationModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to track application: ${e.toString()}');
    }
  }
}