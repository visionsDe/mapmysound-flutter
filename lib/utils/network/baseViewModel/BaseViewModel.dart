import 'dart:async';
import 'package:flutter/material.dart';
import '../networkServices.dart';
abstract class BaseViewModel extends ChangeNotifier {
  final NetworkService network = NetworkService.instance;
  bool hasInternet = true;
  bool loader = false;

  StreamSubscription? _netSub;

  BaseViewModel() {
    _netSub = network.onStatusChange.listen((status) {
      hasInternet = status;
      onNetworkChange(status);
      notifyListeners();
    });
  }

  void onNetworkChange(bool online) {}

  @override
  void dispose() {
    _netSub?.cancel();
    super.dispose();
  }
}
