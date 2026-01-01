import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../utils/network/networkServices.dart';
class LoginViewModel extends ChangeNotifier{
  bool hasInternet = true;
  final NetworkService _network = NetworkService.instance;
  StreamSubscription? _netSub;

  LoginViewModel(){
    _listenNetwork();
  }

  void _listenNetwork() {
    _netSub = _network.onStatusChange.listen((online) {
      hasInternet = online;
      // if (online && list.isEmpty) {
      //   getSampleApiData();
      // }
      notifyListeners();
    });
  }

}