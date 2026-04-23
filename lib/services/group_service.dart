import '../models/user.dart';

class Group {
  final String name;
  final String type;

  Group({
    required this.name,
    required this.type,
  });
}

class GroupService {
  /// Generates dynamic groups based on the user's properties.
  Future<List<Group>> generateGroups(User user) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate backend request

    List<Group> groups = [];

    // 1. Country group: "{user.migratedCountry} Students"
    if (_isValid(user.migratedCountry)) {
      groups.add(
        Group(
          name: '${user.migratedCountry} Students',
          type: 'Country',
        ),
      );
    }

    // 2. City + Course: "{user.currentCity} {user.course}"
    if (_isValid(user.currentCity) && _isValid(user.course)) {
      groups.add(
        Group(
          name: '${user.currentCity} ${user.course}',
          type: 'Academic',
        ),
      );
    }

    // 3. Origin to destination: "{user.originCity} → {user.currentCity}"
    if (_isValid(user.originCity) && _isValid(user.currentCity)) {
      groups.add(
        Group(
          name: '${user.originCity} → ${user.currentCity}',
          type: 'Migration',
        ),
      );
    }

    return groups;
  }

  /// Helper to ensure the property is valid (not null, empty, or 'N/A').
  bool _isValid(String? value) {
    if (value == null) return false;
    final trimmed = value.trim();
    return trimmed.isNotEmpty && trimmed.toLowerCase() != 'n/a';
  }
}
