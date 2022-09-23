import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

class AddressPool {
  AddressPool({this.timeout = 3});

  final List<Address> addresses = [];
  Address? bestAddress;
  int lastCheckTime = 0;
  int timeout;

  void addAddress(
    String origin,
    String pathRoot,
  ) {
    print('adding address $origin');
    addresses.add(Address(
      checkIndex: addresses.length,
      origin: origin,
      pathRoot: pathRoot,
      timeout: timeout,
    ));
  }

  void _findBestAddress() {
    bool wasAHealthyAddressFound = false;
    for (final address in addresses) {
      if (address.isHealthy) {
        wasAHealthyAddressFound = true;
        if (bestAddress == null) {
          bestAddress = address;
        } else {
          if ((bestAddress?.ping ?? 0) > address.ping) {
            bestAddress = address;
          }
        }
      }
    }

    if (!wasAHealthyAddressFound) {
      // if there are no healthy addresses, then set bestAddress to null
      bestAddress = null;
    }
  }

  void checkAddresses() async {
    var now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastCheckTime < 4000) {
      // if it's been less than 4 seconds, don't check
      return;
    }

    lastCheckTime = DateTime.now().millisecondsSinceEpoch;
    for (final address in addresses) {
      address.check();
    }

    while (_isAnyCheckRunning) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    _findBestAddress();
  }

  bool get _isAnyCheckRunning {
    for (final address in addresses) {
      if (address.isCheckRunning) {
        return true;
      }
    }
    return false;
  }

  Uri? makeUri(String path, {bool usePathRoot = true}) {
    return bestAddress?.makeUri(path);
  }

  bool get isEmpty {
    return addresses.isEmpty;
  }

  String printfAddresses() {
    String addrs = '';
    for (final address in addresses) {
      addrs += ' ${address.healthCheckUri.toString()}';
    }
    return addrs;
  }
}

class Address {
  Address({
    required this.origin,
    required this.pathRoot,
    required this.checkIndex,
    required this.timeout,
  }) {
    healthCheckUri = Uri.parse('$origin/$pathRoot');
  }

  late final Uri healthCheckUri;
  final String origin;
  final String pathRoot;
  final int timeout;
  bool isHealthy = false;
  bool isCheckRunning = false;
  final int checkIndex;
  int ping = 0;

  Uri makeUri(String path, {bool usePathRoot = true}) {
    if (usePathRoot) {
      return Uri.parse('$origin/$pathRoot/$path');
    } else {
      return Uri.parse('$origin/$path');
    }
  }

  check() async {
    isCheckRunning = true;
    bool isOk = false;
    try {
      var startTime = DateTime.now().millisecondsSinceEpoch;
      print('POOL: checking address $healthCheckUri');
      var response =
          await http.get(healthCheckUri).timeout(Duration(seconds: timeout));
      var endTime = DateTime.now().millisecondsSinceEpoch;
      ping = endTime - startTime;
      print('POOL: ${response.statusCode}');
      if (response.statusCode == 200) {
        isOk = true;
      }
    } on SocketException {
      print('POOL: Failed to get health due to bad socket: $healthCheckUri');
      isOk = false;
    } on TimeoutException {
      print('POOL: Failed to get health due to timeout: $healthCheckUri');
      isOk = false;
    } catch (e, s) {
      print(e);
      print(s);
      print('POOL: Failed to get health due to unknown: $healthCheckUri');
      isOk = false;
    }
    isHealthy = isOk;
    print('POOL: is $origin okay? $isHealthy');
    isCheckRunning = false;
  }
}
