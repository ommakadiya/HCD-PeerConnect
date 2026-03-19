class Like {
  final String likeId;
  final String userId;
  final String postId;
  final DateTime createdAt;

  Like({
    required this.likeId,
    required this.userId,
    required this.postId,
    required this.createdAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      likeId: json['like_id'] ?? '',
      userId: json['user_id'] ?? '',
      postId: json['post_id'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'like_id': likeId,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
