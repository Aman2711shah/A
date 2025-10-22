import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'user_profile.dart';

abstract class IUserRepository {
  User? get currentUser;
  Stream<User?> authChanges();
  Future<UserProfile?> getCurrent();
  Stream<UserProfile?> watchCurrent();
  Future<void> upsert(UserProfile data);
  Future<String> uploadProfileImage(XFile file);
  Future<void> signOut();
}

class UserRepository implements IUserRepository {
  UserRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> authChanges() => _auth.userChanges();

  @override
  Future<UserProfile?> getCurrent() async {
    final user = currentUser;
    if (user == null) return null;

    final docRef = _usersCollection.doc(user.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      final profile = UserProfile(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        profileImage: user.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(profile.toMap(), SetOptions(merge: true));
      return profile;
    }

    final data = snapshot.data();
    if (data == null) return null;
    return UserProfile.fromMap(data);
  }

  @override
  Stream<UserProfile?> watchCurrent() {
    final user = currentUser;
    if (user == null) {
      return const Stream<UserProfile?>.empty();
    }
    return _usersCollection.doc(user.uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return UserProfile.fromMap(data);
    });
  }

  @override
  Future<void> upsert(UserProfile data) async {
    await _usersCollection.doc(data.uid).set(
          data.copyWith(updatedAt: DateTime.now()).toMap(),
          SetOptions(merge: true),
        );
  }

  @override
  Future<String> uploadProfileImage(XFile file) async {
    final user = currentUser;
    if (user == null) {
      throw StateError('Cannot upload image without an authenticated user.');
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final ref =
        _storage.ref().child('profileImages/${user.uid}/$fileName');

    final bytes = await file.readAsBytes();
    await ref.putData(bytes);

    return ref.getDownloadURL();
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
