import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  User? getuser() {
    return _user;
  }

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // Additional methods to handle user-related operations (e.g., sign out).
}
