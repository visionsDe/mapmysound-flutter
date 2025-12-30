// class SampleApiViewModel extends ChangeNotifier{}

import 'dart:async';

import 'package:flutter/foundation.dart';

class SplashViewModel extends ChangeNotifier{
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // SplashViewModel() {
  //   _startSplash();
  // }

  void startSplash() {
    // Simulate some initialization like API call, DB check, etc.
    Timer(const Duration(seconds: 5), () {
      _isLoading = true;
      notifyListeners(); // notify UI to update
    });
  }
}
