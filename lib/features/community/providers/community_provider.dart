import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/services/firebase_firestore_service.dart';
import '../models/community_post.dart';

class CommunityProvider extends ChangeNotifier {
  CommunityProvider({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirestoreService? firestoreService,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _rawFirestore = firestore ?? FirebaseFirestore.instance,
        _firestoreService = firestoreService ?? FirestoreService() {
    _subscribeToPosts();
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _rawFirestore;
  final FirestoreService _firestoreService;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _postSubscription;

  List<CommunityPost> _posts = const [];
  bool _isLoading = false;
  String? _error;

  List<CommunityPost> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> refresh() async {
    await _postSubscription?.cancel();
    _subscribeToPosts();
  }

  Future<void> createPost(String content) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('You must be signed in to create a post.');
    }
    if (content.trim().isEmpty) {
      throw ArgumentError('Post content cannot be empty.');
    }

    final authorName = await _resolveUserName(user);
    await _firestoreService.createCommunityPost({
      'authorId': user.uid,
      'authorName': authorName,
      'content': content.trim(),
      'likes': <String>[],
    });
  }

  Future<void> toggleLike(CommunityPost post) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('You must be signed in to like a post.');
    }

    final alreadyLiked = post.isLikedBy(user.uid);
    await _firestoreService.toggleCommunityPostLike(
      postId: post.id,
      userId: user.uid,
      like: !alreadyLiked,
    );
  }

  Future<void> addComment({
    required CommunityPost post,
    required String text,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('You must be signed in to comment.');
    }
    if (text.trim().isEmpty) {
      throw ArgumentError('Comment cannot be empty.');
    }

    final authorName = await _resolveUserName(user);
    await _firestoreService.addCommunityComment(
      postId: post.id,
      commentData: {
        'authorId': user.uid,
        'authorName': authorName,
        'text': text.trim(),
      },
    );
  }

  Stream<List<CommunityComment>> commentsStream(String postId) {
    return _firestoreService
        .listenToComments(postId)
        .map((snapshot) => snapshot.docs
            .map((doc) => CommunityComment.fromDoc(doc))
            .toList());
  }

  void _subscribeToPosts() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _postSubscription = _firestoreService.listenToCommunityPosts().listen(
      (snapshot) {
        _posts = snapshot.docs
            .map((doc) => CommunityPost.fromDoc(doc))
            .toList(growable: false);
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<String> _resolveUserName(User user) async {
    try {
      final doc = await _rawFirestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        final name = data['name'] as String?;
        if (name != null && name.trim().isNotEmpty) {
          return name;
        }
      }
    } catch (e) {
      debugPrint('Unable to read user profile: $e');
    }
    return user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : (user.email ?? 'Community Member');
  }

  @override
  void dispose() {
    _postSubscription?.cancel();
    super.dispose();
  }
}
