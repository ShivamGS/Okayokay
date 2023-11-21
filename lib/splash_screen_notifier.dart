import 'package:flutter/material.dart';

class SplashScreenNotifier extends ChangeNotifier {
  String? user;

  void setLoaded(String value) {
    user = value;
    notifyListeners();
  }
}
