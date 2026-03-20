// This file can provide convenient mock data for UI testing.

import 'user.dart';
import 'student_profile.dart';
import 'parent_profile.dart';
import 'post.dart';
import 'ad.dart';
import 'group.dart';

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

  static final List<Ad> ads = [
    Ad(
      adId: 'ad1',
      title: 'Ad 1',
      description: 'Special offer 1',
      imageUrl: 'assets/ad 1.jpeg',
      targetCountry: 'Global',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    ),
    Ad(
      adId: 'ad2',
      title: 'Ad 2',
      description: 'Special offer 2',
      imageUrl: 'assets/ad 2.jpeg',
      targetCountry: 'Global',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    ),
    Ad(
      adId: 'ad3',
      title: 'Ad 3',
      description: 'Special offer 3',
      imageUrl: 'assets/ad 3.webp',
      targetCountry: 'Global',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    ),
    Ad(
      adId: 'ad4',
      title: 'Ad 4',
      description: 'Special offer 4',
      imageUrl: 'assets/ad 4.png',
      targetCountry: 'Global',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    ),
    Ad(
      adId: 'ad5',
      title: 'Ad 5',
      description: 'Special offer 5',
      imageUrl: 'assets/ad 5.jpeg',
      targetCountry: 'Global',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    ),
  ];

  static final List<Group> cityGroups = [
    Group(
      groupId: 'g_city1',
      name: 'London Explorers',
      description: 'Find friends and events in your current city.',
      type: GroupType.topic,
      createdBy: 'u1',
      createdAt: DateTime.now(),
    ),
    Group(
      groupId: 'g_city2',
      name: 'Birmingham Locals',
      description: 'Connect with people in Birmingham.',
      type: GroupType.topic,
      createdBy: 'u2',
      createdAt: DateTime.now(),
    ),
  ];

  static final List<Group> originCityGroups = [
    Group(
      groupId: 'g_origin1',
      name: 'Mumbai to UK',
      description: 'Connect with folks from Mumbai.',
      type: GroupType.topic,
      createdBy: 'u1',
      createdAt: DateTime.now(),
    ),
    Group(
      groupId: 'g_origin2',
      name: 'Delhi NCR Students',
      description: 'For students hailing from Delhi.',
      type: GroupType.topic,
      createdBy: 'u2',
      createdAt: DateTime.now(),
    ),
  ];

  static final List<Group> universityGroups = [
    Group(
      groupId: 'g_uni1',
      name: 'Oxford Fall 2026',
      description: 'Join your batchmates at Oxford.',
      type: GroupType.university,
      createdBy: 'u1',
      createdAt: DateTime.now(),
    ),
    Group(
      groupId: 'g_uni2',
      name: 'Cambridge Grads',
      description: 'Network with other postgraduate students.',
      type: GroupType.university,
      createdBy: 'u2',
      createdAt: DateTime.now(),
    ),
  ];
}
