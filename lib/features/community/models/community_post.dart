import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityComment {
  CommunityComment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime createdAt;

  factory CommunityComment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return CommunityComment(
      id: doc.id,
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Anonymous',
      text: data['text'] as String? ?? '',
      createdAt: _parseTimestamp(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class CommunityPost {
  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
    required this.likes,
    this.attachments,
    this.commentCount = 0,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;
  final List<String> likes;
  final List<String>? attachments;
  final int commentCount;

  bool get hasAttachments => attachments != null && attachments!.isNotEmpty;

  bool isLikedBy(String userId) => likes.contains(userId);

  CommunityPost copyWith({
    List<String>? likes,
    int? commentCount,
  }) {
    return CommunityPost(
      id: id,
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: createdAt,
      likes: likes ?? this.likes,
      attachments: attachments,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  factory CommunityPost.fromDoc(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? <String, dynamic>{};
    return CommunityPost(
      id: document.id,
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Anonymous',
      content: data['content'] as String? ?? '',
      createdAt: _parseTimestamp(data['createdAt']),
      likes: List<String>.from(data['likes'] as List? ?? const []),
      attachments:
          (data['attachments'] as List?)?.map((e) => e.toString()).toList(),
      commentCount: (data['commentCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
      'likes': likes,
      'attachments': attachments ?? [],
      'commentCount': commentCount,
    };
  }
}

DateTime _parseTimestamp(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is DateTime) {
    return value;
  }
  return DateTime.now();
}
