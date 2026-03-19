enum UserRole {
  student,
  parent,
}

class User {
  final String userId;
  final String name;
  final String email;
  final String passwordHash;
  final UserRole role;
  final String? profileImage;
  final String country;
  final DateTime createdAt;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.role,
    this.profileImage,
    required this.country,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.student,
      ),
      profileImage: json['profile_image'],
      country: json['country'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'password_hash': passwordHash,
      'role': role.toString().split('.').last,
      'profile_image': profileImage,
      'country': country,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
