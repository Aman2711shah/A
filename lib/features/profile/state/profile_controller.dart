import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../data/user_profile.dart';
import '../data/user_repository.dart';

class ProfileController extends ChangeNotifier {
  ProfileController(this._repository, {bool listenAuthChanges = true})
      : _listenAuthChanges = listenAuthChanges {
    if (_listenAuthChanges) {
      _authSubscription = _repository.authChanges().listen(_onAuthChanged);
    }
    _initialize();
  }

  final IUserRepository _repository;
  final bool _listenAuthChanges;

  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<UserProfile?>? _profileSubscription;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isAuthenticated => _repository.currentUser != null;

  Future<void> _initialize() async {
    final user = _repository.currentUser;
    if (user != null) {
      await load();
    }
  }

  Future<void> load() async {
    _setLoading(true);
    try {
      final data = await _repository.getCurrent();
      _profile = data;
      _error = null;
      _listenToProfileChanges();
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to load profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> save(UserProfile updated) async {
    _setLoading(true);
    try {
      await _repository.upsert(updated);
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> pickAndUploadImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: source, imageQuality: 80);
      if (file == null) return null;

      _setLoading(true);
      final downloadUrl = await _repository.uploadProfileImage(file);
      return downloadUrl;
    } catch (e) {
      _error = e.toString();
      debugPrint('Image upload failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _listenToProfileChanges() {
    _profileSubscription?.cancel();
    _profileSubscription = _repository.watchCurrent().listen(
      (data) {
        _profile = data;
        notifyListeners();
      },
      onError: (Object e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  void _onAuthChanged(User? user) {
    _profileSubscription?.cancel();
    if (user == null) {
      _profile = null;
      notifyListeners();
    } else {
      unawaited(load());
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _profileSubscription?.cancel();
    super.dispose();
  }

  Future<void> signOut() => _repository.signOut();

  @visibleForTesting
  void setProfileForTesting(UserProfile? value) {
    _profile = value;
    notifyListeners();
  }

  @visibleForTesting
  void setLoadingForTesting(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
