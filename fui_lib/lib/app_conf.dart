import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_io/io.dart';

import 'package:fui_lib/services/address_pool.dart';

enum ClockFormat { twelve, twentyFour }

enum ToddMode { none, admin, developer, surfer }

enum DevicePlatform { none, and }

class AppConf {
  final AddressPool apiPool = AddressPool();

  final String appName = 'fui_web';
  final String env = 'dev';
  final String firebaseToken = '';
  final String logLevel = 'all';
  final String stripePublishableKey = '';
  final String tzFormat = 'standard';

  final int cacheTimeoutMinutes = 3;
  final ToddMode toddMode = ToddMode.admin;
  final bool debug = true;
  late String platform;
  final int requestTimeout = 10;

  AppConf() {
    //print('Configuration initializaing...');

    if (kIsWeb) {
      platform = 'web';
    } else {
      if (Platform.isAndroid) {
        platform = 'android';
      } else if (Platform.isIOS) {
        platform = 'ios';
      } else if (Platform.isLinux) {
        platform = 'linux';
      } else if (Platform.isWindows) {
        platform = 'windows';
      } else if (Platform.isMacOS) {
        platform = 'macos';
      } else if (Platform.isFuchsia) {
        platform = 'fuchsia';
      }
    }

    switch (env) {
      case 'dev':
        switch (platform) {
          case 'web':
          case 'ios':
            apiPool.addAddress('http://localhost:8000', 'api');
            apiPool.addAddress('http://localhost:80', 'api');
            break;

          case 'android':
            //apiPool.addAddress('http://10.0.2.2:8000', 'api');
            apiPool.addAddress('http://10.0.2.2:80', 'api');
            break;

          case 'linux':
          case 'windows':
          case 'macos':
          case 'fuchsia':
          default:
            apiPool.addAddress('http://localhost:800', 'api');
        }
        break;

      case 'lab':
        throw Exception('lab environment not configured');

      case 'prod':
        apiPool.addAddress('https://fridayy.io', 'api');
        break;

      default:
        throw Exception('ERROR: env could not be found: $env');
    }

    print('API Url Pool: ${apiPool.printfAddresses()}');
    if (apiPool.isEmpty) {
      throw Exception('ERROR: no apiPool are set');
    }
    print('Configuration initialization completed.');
  }

  bool get isAndroid {
    return platform == 'android';
  }

  bool get isIos {
    return platform == 'ios';
  }

  bool get isLinux {
    return platform == 'linux';
  }

  bool get isMacOs {
    return platform == 'ios';
  }

  bool get isWeb {
    return platform == 'web';
  }

  String get signInWithAppleClientId {
    if (isAndroid) {
      return 'io.fridayy.and';
    } else if (isIos || isMacOs) {
      return 'io.fridayy.ios';
    } else {
      return 'PlatformNotSupported';
    }
  }

  Uri get signInWithApplePapiCallback {
    if (isWeb) {
      return Uri.parse('https://fridayy.me');
    } else if (isAndroid) {
      return Uri.parse(
          'https://fridayy.me/api/v1/surfer/signIn.withApple.callback.android');
    } else {
      return Uri.parse('https://notset');
    }
  }

  String calling() {
    var data = {'hi': 'okay'};
    return 'intent://callback?$data#Intent;package=YOUR.PACKAGE.IDENTIFIER;scheme=signinwithapple;end';
  }
}
