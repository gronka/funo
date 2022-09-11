import 'package:intl/intl.dart' as intl;

import 'package:fui_lib/fui_lib.dart';

extension ParseCents on int {
  String get uncents {
    //NOTE: add a tiny bit to make it positive
    return (this / 100.0 + .0000001).toStringAsFixed(2);
  }

  String get toUsd {
    return '\$${this.uncents}';
  }

  String get display {
    return intl.NumberFormat.decimalPattern().format(this);
  }

  String get pad02 {
    return intl.NumberFormat('00').format(this);
  }
}

extension ToddModeExtensions on ToddMode {
  String get refreshEndpoint {
    return EndpointsV1.toddJwtRefresh;
  }

  String get registerWithEmailEndpoint {
    return EndpointsV1.toddRegisterWithEmail;
  }

  String get signInWithAppleEndpoint {
    return EndpointsV1.toddSignInWithApple;
  }

  String get signInWithEmailEndpoint {
    return EndpointsV1.toddSignInWithEmail;
  }

  String get signInWithGoogleEndpoint {
    return EndpointsV1.toddSignInWithGoogle;
  }

  String get signOutEndpoint {
    return EndpointsV1.toddSignOut;
  }
}
