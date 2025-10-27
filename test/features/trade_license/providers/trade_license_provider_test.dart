import 'package:flutter_test/flutter_test.dart';
import 'package:wazeet_app/features/trade_license/providers/trade_license_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TradeLicenseProvider provider;

  setUp(() {
    provider = TradeLicenseProvider(
      loadDelay: Duration.zero,
      submitDelay: Duration.zero,
    );
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
