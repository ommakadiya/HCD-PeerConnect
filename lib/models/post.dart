enum PostVisibility {
  public,
  connections,
  group,
}

class Post {
  final String postId;
  final String userId;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final PostVisibility visibility;

  Post({
    required this.postId,
    required this.userId,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.visibility,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'] ?? '',
      userId: json['user_id'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      visibility: PostVisibility.values.firstWhere(
        (e) => e.toString().split('.').last == json['visibility'],
        orElse: () => PostVisibility.public,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'visibility': visibility.toString().split('.').last,
    };
  }
}
