enum GroupRole {
  member,
  admin,
}

class GroupMember {
  final String id;
  final String groupId;
  final String userId;
  final GroupRole role;
  final DateTime joinedAt;

  GroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.role,
    required this.joinedAt,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id'] ?? '',
      groupId: json['group_id'] ?? '',
      userId: json['user_id'] ?? '',
      role: GroupRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => GroupRole.member,
      ),
      joinedAt: DateTime.tryParse(json['joined_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'user_id': userId,
      'role': role.toString().split('.').last,
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}
