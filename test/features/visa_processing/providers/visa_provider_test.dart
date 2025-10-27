import 'package:flutter_test/flutter_test.dart';
import 'package:wazeet_app/features/visa_processing/providers/visa_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late VisaProvider provider;

  setUp(() {
    provider = VisaProvider();
  });

  test('loads mock visa applications', () async {
    expect(provider.applications, isEmpty);
    await provider.loadApplications();
    expect(provider.applications, isNotEmpty);
    expect(provider.isLoading, isFalse);
  });

  test('submits new visa application and stores it', () async {
    await provider.loadApplications();
    final initialCount = provider.applications.length;

    await provider.submitVisaApplication({
      'employeeName': 'Jane Doe',
      'passportNumber': 'Z1234567',
      'position': 'Engineer',
      'visaType': 'Employment Visa',
      'nationality': 'Canadian',
      'salary': '15000',
    });

    expect(provider.applications.length, initialCount + 1);
    expect(provider.applications.last['status'], 'Submitted');
  });

  test('filters applications by status', () async {
    await provider.loadApplications();
    final inReview = provider.getApplicationsByStatus('In Review');

    expect(inReview, isNotEmpty);
    expect(inReview.every((app) => app['status'] == 'In Review'), isTrue);
  });
}
