import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  List<ConnectivityResult> _connectivityResult = [];

  ConnectivityProvider() {
    checkInitialConnectivity();
  }

  /// Checks the current connectivity state and updates listeners.
  Future<void> checkInitialConnectivity() async {
    _connectivityResult = await Connectivity().checkConnectivity();
    notifyListeners();
  }

  /// Returns `true` if internet is available via mobile data or WiFi.
  Future<bool> checkInternetConnection() async {
    await checkInitialConnectivity();
    return _connectivityResult.contains(ConnectivityResult.mobile) ||
        _connectivityResult.contains(ConnectivityResult.wifi);
  }

  /// Getter for the current connectivity results.
  List<ConnectivityResult> get connectivityResult => _connectivityResult;
}
