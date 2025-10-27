import 'package:flutter/material.dart';

import '../../../core/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _userToken;
  Map<String, dynamic>? _userData;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get userToken => _userToken;
  Map<String, dynamic>? get userData => _userData;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userToken = StorageService.getString('user_token');
      _userData = StorageService.getData('user_data');
      _isAuthenticated = _userToken != null && _userData != null;
    } catch (e) {
      debugPrint('Error loading auth state: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful login
      if (email.isNotEmpty && password.isNotEmpty) {
        _userToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        _userData = {
          'id': '1',
          'firstName': 'John',
          'lastName': 'Doe',
          'email': email,
          'phone': '+971 50 123 4567',
          'profileImage': null,
          'createdAt': DateTime.now().toIso8601String(),
        };
        
        _isAuthenticated = true;
        
        // Save to storage
        await StorageService.setString('user_token', _userToken!);
        await StorageService.setData('user_data', _userData);
        
        notifyListeners();
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String phone,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful registration
      _userToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      _userData = {
        'id': '1',
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'profileImage': null,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      _isAuthenticated = true;
      
      // Save to storage
      await StorageService.setString('user_token', _userToken!);
      await StorageService.setData('user_data', _userData);
      
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _isAuthenticated = false;
      _userToken = null;
      _userData = null;
      
      // Clear storage
      await StorageService.remove('user_token');
      await StorageService.removeData('user_data');
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    if (_userData != null) {
      _userData = {..._userData!, ...updatedData};
      await StorageService.setData('user_data', _userData);
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful password reset request
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
