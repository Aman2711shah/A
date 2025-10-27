import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wazeet_app/core/services/firebase_firestore_service.dart';
import 'package:wazeet_app/features/company_setup/providers/company_setup_provider.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockFirebaseAuth auth;
  late _MockUser user;
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late CompanySetupProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    auth = _MockFirebaseAuth();
    user = _MockUser();
    when(() => auth.currentUser).thenReturn(user);
    when(() => user.uid).thenReturn('test-user');

    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);

    provider = CompanySetupProvider(
      auth: auth,
      firestoreService: firestoreService,
    );
    provider.setAutoSave(false);
  });

  test('advances steps and validates form sections', () {
    expect(provider.currentStep, 0);
    expect(provider.isStepValid(0), isFalse);

    provider.setSelectedActivity('consulting');
    expect(provider.isStepValid(0), isTrue);

    provider.nextStep();
    expect(provider.currentStep, 1);

    provider.setSelectedLegalStructure('llc');
    expect(provider.isStepValid(1), isTrue);

    provider.nextStep();
    expect(provider.currentStep, 2);

    provider.previousStep();
    expect(provider.currentStep, 1);
  });

  test('submits form to firestore and clears progress', () async {
    provider
      ..setSelectedActivity('consulting')
      ..setSelectedLegalStructure('llc')
      ..setNumberOfShareholders(2)
      ..setVisaType('employment')
      ..setNumberOfVisas(3)
      ..setOfficeSpaceType('virtual')
      ..setHasEjari(true)
      ..addDocument('passport', details: {'name': 'Passport Copy'});

    final applicationId = await provider.submitForm();
    expect(applicationId, isNotEmpty);

    final snapshot =
        await fakeFirestore.collection('applications').doc(applicationId).get();
    expect(snapshot.exists, isTrue);
    expect(snapshot.data()?['activity'], 'consulting');
    expect(snapshot.data()?['userId'], 'test-user');
  });
}
