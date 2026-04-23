class ParentChildLink {
  final String parentId;
  final String childId;
  final String status;

  ParentChildLink({
    required this.parentId,
    required this.childId,
    this.status = 'pending',
  });

  factory ParentChildLink.fromJson(Map<String, dynamic> json) {
    return ParentChildLink(
      parentId: json['parent_id'] as String? ?? '',
      childId: json['child_id'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      'child_id': childId,
      'status': status,
    };
  }
}
