import 'package:local_auth/local_auth.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/secure_storage.dart';
import '../../config/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthRepository {
  final DioClient dioClient;
  final SecureStorage secureStorage;
  final LocalAuthentication localAuth;

  AuthRepository({
    required this.dioClient,
    required this.secureStorage,
    required this.localAuth,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data['data'];
      final user = UserModel.fromJson(data['user']);
      
      await secureStorage.saveAccessToken(data['accessToken']);
      await secureStorage.saveRefreshToken(data['refreshToken']);
      await secureStorage.saveUser(user);

      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> register({
    required String email,
    required String phone,
    required String fullName,
    required String password,
  }) async {
    try {
      await dioClient.post(
        ApiConstants.register,
        data: {
          'email': email,
          'phone': phone,
          'fullName': fullName,
          'password': password,
        },
      );
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<UserModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.verifyOtp,
        data: {
          'phone': phone,
          'otp': otp,
        },
      );

      final data = response.data['data'];
      final user = UserModel.fromJson(data['user']);
      
      await secureStorage.saveAccessToken(data['accessToken']);
      await secureStorage.saveRefreshToken(data['refreshToken']);
      await secureStorage.saveUser(user);

      return user;
    } catch (e) {
      throw Exception('OTP verification failed: ${e.toString()}');
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final canAuthenticate = await localAuth.canCheckBiometrics;
      if (!canAuthenticate) return false;

      return await localAuth.authenticate(
        localizedReason: 'Authenticate to access WAZEET',
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await dioClient.post(ApiConstants.logout);
      await secureStorage.clearAll();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await secureStorage.getAccessToken();
    return token != null;
  }

  Future<UserModel> getCurrentUser() async {
    final user = await secureStorage.getUser();
    if (user == null) {
      throw Exception('No user found');
    }
    return user;
  }
}