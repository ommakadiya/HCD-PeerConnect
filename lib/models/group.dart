enum GroupType {
  country,
  university,
  topic,
}

class Group {
  final String groupId;
  final String name;
  final String description;
  final GroupType type;
  final String createdBy;
  final DateTime createdAt;

  Group({
    required this.groupId,
    required this.name,
    required this.description,
    required this.type,
    required this.createdBy,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['group_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: GroupType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => GroupType.topic,
      ),
      createdBy: json['created_by'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
