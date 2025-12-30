import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService {
  NetworkService._internal();
  static final NetworkService instance = NetworkService._internal();

  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get onStatusChange => _controller.stream;

  bool _isOnline = false;
  bool get isOnline => _isOnline;

  StreamSubscription? _subscription;

  void init() {
    _subscription ??=
        Connectivity().onConnectivityChanged.listen((_) async {
          final online = await InternetConnection().hasInternetAccess;

          if (_isOnline != online) {
            _isOnline = online;
            _controller.add(_isOnline);
          }
        });
  }

  Future<bool> checkInternet() async {
    _isOnline = await InternetConnection().hasInternetAccess;
    return _isOnline;
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
