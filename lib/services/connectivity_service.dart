import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  static final _controller = StreamController<bool>.broadcast();

  ConnectivityService._internal() {
    // Listen to connectivity changes (WiFi/Mobile)
    Connectivity().onConnectivityChanged.listen((_) async {
      final hasInternet = await InternetConnectionChecker.instance.hasConnection;
      _controller.sink.add(hasInternet);
    });

    // Listen to internet connection status directly
    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      _controller.sink.add(status == InternetConnectionStatus.connected);
    });
  }

  static final ConnectivityService instance = ConnectivityService._internal();

  Stream<bool> get connectivityStream => _controller.stream;

  void dispose() => _controller.close();
}
