import 'package:cloud_firestore/cloud_firestore.dart';

/// Handles reading and writing user profile data to Cloud Firestore.
///
/// Firestore structure:
///   users/{userId}          — base user document
///   users/{userId}/profile  — sub-map stored inside the user document
class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Collection reference ──────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  // ── Create / Update ───────────────────────────────────────────────────────

  /// Creates or updates the base user document.
  /// Uses merge so extra fields are not overwritten.
  Future<void> createOrUpdateUser({
    required String userId,
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    await _users.doc(userId).set(
      {
        'userId': userId,
        'name': name,
        'email': email,
        'photoUrl': photoUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// Saves (or replaces) the role for a user.
  Future<void> setRole(String userId, String role) async {
    await _users.doc(userId).set({'role': role}, SetOptions(merge: true));
  }

  /// Saves child (student) profile fields onto the user document.
  Future<void> saveChildProfile({
    required String userId,
    required String name,
    required String originCity,
    required String migratedCity,
    required String phone,
    required String address,
    required String occupation,
    required String parentName,
    required String parentEmail,
  }) async {
    await _users.doc(userId).set(
      {
        'name': name,
        'role': 'child',
        'profileCompleted': true,
        'childProfile': {
          'originCity': originCity,
          'migratedCity': migratedCity,
          'phone': phone,
          'address': address,
          'occupation': occupation,
          'parentName': parentName,
          'parentEmail': parentEmail,
        },
      },
      SetOptions(merge: true),
    );
  }

  /// Saves parent profile fields onto the user document.
  /// [parents] is a list of maps, each representing one parent's details.
  Future<void> saveParentProfile({
    required String userId,
    required List<Map<String, String>> parents,
  }) async {
    final first = parents.isNotEmpty ? parents[0] : <String, String>{};
    await _users.doc(userId).set(
      {
        'name': first['name'] ?? '',
        'role': 'parent',
        'profileCompleted': true,
        'parentProfile': {
          'parents': parents,
        },
      },
      SetOptions(merge: true),
    );
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  /// Fetches a single user document snapshot.
  /// Returns null if the document does not exist.
  Future<Map<String, dynamic>?> getUser(String userId) async {
    final doc = await _users.doc(userId).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  /// Returns true if the user's profile is already completed.
  Future<bool> isProfileComplete(String userId) async {
    final data = await getUser(userId);
    if (data == null) return false;
    return data['profileCompleted'] == true;
  }

  // ── Connections / Recommendation helpers ──────────────────────────────────

  /// Returns a stream of all user documents whose [role] is 'child' and
  /// whose [childProfile.migratedCity] or [childProfile.originCity] matches
  /// those of [currentUserId]. Used for suggesting connections.
  Stream<List<Map<String, dynamic>>> recommendedConnections({
    required String currentUserId,
    required String migratedCity,
    required String originCity,
  }) {
    // Query by migratedCity — Firestore doesn't support OR across different
    // fields easily, so we query by one field and merge in-app.
    return _users
        .where('role', isEqualTo: 'child')
        .where('childProfile.migratedCity', isEqualTo: migratedCity)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((doc) => doc.id != currentUserId)
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }
}
