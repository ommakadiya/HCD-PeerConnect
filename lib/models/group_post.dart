class GroupPost {
  final String groupPostId;
  final String groupId;
  final String userId;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  GroupPost({
    required this.groupPostId,
    required this.groupId,
    required this.userId,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  factory GroupPost.fromJson(Map<String, dynamic> json) {
    return GroupPost(
      groupPostId: json['group_post_id'] ?? '',
      groupId: json['group_id'] ?? '',
      userId: json['user_id'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_post_id': groupPostId,
      'group_id': groupId,
      'user_id': userId,
      'content': content,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
