import 'package:flutter/foundation.dart';

/// Controller for managing user profile state
class ProfileController extends ChangeNotifier {
  String _userName = 'Guest User';
  String _userEmail = '';
  bool _isLoading = false;

  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isLoading => _isLoading;

  /// Update user profile information
  void updateProfile({String? name, String? email}) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    notifyListeners();
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Reset profile to default state
  void reset() {
    _userName = 'Guest User';
    _userEmail = '';
    _isLoading = false;
    notifyListeners();
  }
}
