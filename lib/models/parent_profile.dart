enum ParentRelation {
  father,
  mother,
  guardian,
}

class ParentProfile {
  final String parentId;
  final String studentId;
  final ParentRelation relation;

  ParentProfile({
    required this.parentId,
    required this.studentId,
    required this.relation,
  });

  factory ParentProfile.fromJson(Map<String, dynamic> json) {
    return ParentProfile(
      parentId: json['parent_id'] ?? '',
      studentId: json['student_id'] ?? '',
      relation: ParentRelation.values.firstWhere(
        (e) => e.toString().split('.').last == json['relation'],
        orElse: () => ParentRelation.guardian,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      'student_id': studentId,
      'relation': relation.toString().split('.').last,
    };
  }
}
