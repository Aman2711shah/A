import 'package:flutter_test/flutter_test.dart';
import 'package:wazeet_app/core/services/firestore/trade_license_firestore_service.dart';
import 'package:wazeet_app/features/trade_license/providers/trade_license_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TradeLicenseProvider provider;
  late _FakeTradeLicenseDataSource dataSource;

  setUp(() {
    dataSource = _FakeTradeLicenseDataSource();
    provider = TradeLicenseProvider(dataSource: dataSource);
  });

  test('loads mock applications', () async {
    expect(provider.applications, isEmpty);
    await provider.loadApplications();
    expect(provider.applications, isNotEmpty);
    expect(provider.isLoading, isFalse);
  });

  test('submits new application and stores it locally', () async {
    await provider.loadApplications();
    final initialCount = provider.applications.length;

    await provider.submitTradeLicenseApplication({
      'companyName': 'Demo LLC',
      'tradeName': 'Demo Trading',
      'licenseType': 'commercial',
      'businessActivity': 'Import/Export',
    });

    expect(provider.applications.length, initialCount + 1);
    expect(provider.applications.last['status'], 'Submitted');
  });

  test('updates application status', () async {
    await provider.loadApplications();
    final id = provider.applications.first['id'] as String;

    provider.updateApplicationStatus(id, 'Completed');

    expect(
      provider.applications.firstWhere((app) => app['id'] == id)['status'],
      'Completed',
    );
  });
}

class _FakeTradeLicenseDataSource implements TradeLicenseDataSource {
  final List<Map<String, dynamic>> _store = [
    {
      'id': 'app-1',
      'companyName': 'Alpha LLC',
      'status': 'Pending',
    },
  ];

  @override
  Future<String> submitApplication(Map<String, dynamic> applicationData) async {
    final id = 'fake-${_store.length + 1}';
    _store.add({
      'id': id,
      'status': 'Submitted',
      ...applicationData,
    });
    return id;
  }

  @override
  Future<List<Map<String, dynamic>>> getUserApplications() async {
    return List<Map<String, dynamic>>.from(_store);
  }

  @override
  Future<Map<String, dynamic>?> getApplicationById(String applicationId) async {
    try {
      return _store.firstWhere((app) => app['id'] == applicationId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateApplicationStatus(String applicationId, String newStatus) async {
    final index = _store.indexWhere((app) => app['id'] == applicationId);
    if (index != -1) {
      _store[index]['status'] = newStatus;
    }
  }

  @override
  Future<void> updateApplication(String applicationId, Map<String, dynamic> updates) async {}

  @override
  Future<void> deleteApplication(String applicationId) async {}

  @override
  Stream<List<Map<String, dynamic>>> streamUserApplications() async* {
    yield List<Map<String, dynamic>>.from(_store);
  }
}
