class Comment {
  final String commentId;
  final String userId;
  final String postId;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.commentId,
    required this.userId,
    required this.postId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'] ?? '',
      userId: json['user_id'] ?? '',
      postId: json['post_id'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'user_id': userId,
      'post_id': postId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
