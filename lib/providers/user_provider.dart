import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  /// Returns the currently logged in or active user.
  User? get currentUser => _currentUser;

  /// Updates the current user and notifies listeners.
  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Clears the current user (e.g., on logout).
  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
