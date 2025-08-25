import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class IConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionChecker implements IConnectionChecker {
  final Connectivity connectivity;

  ConnectionChecker(this.connectivity);

  @override
  Future<bool> get isConnected async {
    List<ConnectivityResult> connectivityResult = [];
    connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    }
    return false;
  }
}
