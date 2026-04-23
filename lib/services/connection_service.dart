import '../models/user.dart';

class ConnectionMatch {
  final User user;
  final int score;
  final List<String> reasons;

  ConnectionMatch({
    required this.user,
    required this.score,
    required this.reasons,
  });
}

class ConnectionService {
  /// Calculates the compatibility score between two users.
  int calculateScore(User a, User b) {
    int score = 0;

    if (_isValid(a.university) && a.university == b.university) score += 40;
    if (_isValid(a.migratedCountry) && a.migratedCountry == b.migratedCountry) score += 30;
    if (_isValid(a.currentCity) && a.currentCity == b.currentCity) score += 25;
    if (_isValid(a.course) && a.course == b.course) score += 20;
    if (_isValid(a.company) && a.company == b.company) score += 15;
    if (_isValid(a.originCity) && a.originCity == b.originCity) score += 10;

    return score;
  }

  /// Generates a list of string reasons explaining why the two users match.
  List<String> getReasons(User a, User b) {
    List<String> reasons = [];

    if (_isValid(a.university) && a.university == b.university) {
      reasons.add('Same University');
    }
    if (_isValid(a.migratedCountry) && a.migratedCountry == b.migratedCountry) {
      reasons.add('Same Country');
    }
    if (_isValid(a.currentCity) && a.currentCity == b.currentCity) {
      reasons.add('Same City');
    }
    if (_isValid(a.course) && a.course == b.course) {
      reasons.add('Same Course');
    }
    if (_isValid(a.company) && a.company == b.company) {
      reasons.add('Same Company');
    }
    if (_isValid(a.originCity) && a.originCity == b.originCity) {
      reasons.add('Same Origin City');
    }

    return reasons;
  }

  /// Generates recommended connections for the current user.
  /// Skips the user themselves, calculates scores, filters by >= 30, and sorts descending.
  Future<List<ConnectionMatch>> generateConnections(User currentUser, List<User> users) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate backend processing

    List<ConnectionMatch> matches = [];

    for (var user in users) {
      // Skip the current user
      if (user.id == currentUser.id) continue;

      int score = calculateScore(currentUser, user);

      // Include only users with score >= 30
      if (score >= 30) {
        matches.add(
          ConnectionMatch(
            user: user,
            score: score,
            reasons: getReasons(currentUser, user),
          ),
        );
      }
    }

    // Sort by highest score first
    matches.sort((a, b) => b.score.compareTo(a.score));

    return matches;
  }

  /// Helper to ignore empty strings or 'N/A' placeholders.
  bool _isValid(String? value) {
    if (value == null) return false;
    final trimmed = value.trim();
    return trimmed.isNotEmpty && trimmed.toLowerCase() != 'n/a';
  }
}
