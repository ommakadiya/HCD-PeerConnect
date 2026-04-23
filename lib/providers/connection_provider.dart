import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/connection_service.dart';

class ConnectionProvider extends ChangeNotifier {
  final ConnectionService _connectionService = ConnectionService();

  List<Map<String, dynamic>> _connections = [];
  bool _isLoading = false;

  /// Returns the current list of generated connections.
  List<Map<String, dynamic>> get connections => _connections;

  /// Returns true if connections are currently being loaded.
  bool get isLoading => _isLoading;

  /// Uses [ConnectionService] to generate connections for the [currentUser] 
  /// against a list of [users], stores the result, and updates listeners.
  Future<void> loadConnections(User currentUser, List<User> users) async {
    _isLoading = true;
    notifyListeners();

    // 1. Generate connections using the service
    final matches = await _connectionService.generateConnections(currentUser, users);

    // 2. Map the strongly-typed ConnectionMatch objects to the requested Map structure
    _connections = matches.map((match) {
      return {
        'user': match.user,
        'score': match.score,
        'reasons': match.reasons,
      };
    }).toList();

    _isLoading = false;

    // 3. Notify UI to reactively rebuild
    notifyListeners();
  }

  /// Clears the connection data on logout or account deletion.
  void clear() {
    _connections = [];
    _isLoading = false;
    notifyListeners();
  }
}
