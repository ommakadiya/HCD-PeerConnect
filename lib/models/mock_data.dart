// This file can provide convenient mock data for UI testing.

import 'user.dart';
import 'student_profile.dart';
import 'parent_profile.dart';
import 'post.dart';

class MockData {
  static final User studentUser = User(
    userId: 'u1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    passwordHash: '...',
    role: UserRole.student,
    country: 'India',
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  );

  static final StudentProfile studentProfile = StudentProfile(
    studentId: 'u1',
    university: 'University of Oxford',
    course: 'MSc Computer Science',
    intakeYear: 2026,
    city: 'Oxford',
    country: 'UK',
  );

  static final User parentUser = User(
    userId: 'u2',
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
    passwordHash: '...',
    role: UserRole.parent,
    country: 'India',
    createdAt: DateTime.now().subtract(const Duration(days: 9)),
  );

  static final ParentProfile parentProfile = ParentProfile(
    parentId: 'u2',
    studentId: 'u1',
    relation: ParentRelation.mother,
  );

  static final Post samplePost = Post(
    postId: 'p1',
    userId: 'u1',
    content: 'Just arrived in the UK! Excited to start my master\'s journey.',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    visibility: PostVisibility.public,
  );
}
