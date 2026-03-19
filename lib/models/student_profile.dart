class StudentProfile {
  final String studentId;
  final String university;
  final String course;
  final int intakeYear;
  final String city;
  final String country;

  StudentProfile({
    required this.studentId,
    required this.university,
    required this.course,
    required this.intakeYear,
    required this.city,
    required this.country,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      studentId: json['student_id'] ?? '',
      university: json['university'] ?? '',
      course: json['course'] ?? '',
      intakeYear: json['intake_year'] ?? 0,
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'university': university,
      'course': course,
      'intake_year': intakeYear,
      'city': city,
      'country': country,
    };
  }
}
