class User {
  final String id;
  final String name;
  final String email;
  final String university;
  final String course;
  final String currentCity;
  final String originCity;
  final String migratedCountry;
  final String? company;
  final String? jobRole;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.course,
    required this.currentCity,
    required this.originCity,
    required this.migratedCountry,
    this.company,
    this.jobRole,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      university: json['university'] as String? ?? '',
      course: json['course'] as String? ?? '',
      currentCity: json['currentCity'] as String? ?? '',
      originCity: json['originCity'] as String? ?? '',
      migratedCountry: json['migratedCountry'] as String? ?? '',
      company: json['company'] as String?,
      jobRole: json['jobRole'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'university': university,
      'course': course,
      'currentCity': currentCity,
      'originCity': originCity,
      'migratedCountry': migratedCountry,
      if (company != null) 'company': company,
      if (jobRole != null) 'jobRole': jobRole,
    };
  }
}
