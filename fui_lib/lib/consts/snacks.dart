import 'package:fui_lib/fui_lib.dart';

class Snacks {
  static var networkError = Snack(1000, 'Error contacting network');
  static var signOutError = Snack(1001, 'Error signing out');
  static var copiedToClipboard = Snack(
    2000,
    'Copied!',
    timeout: 1000,
  );

  static var paymentError = Snack(300, 'Payment error.');
  static var stripeLaunchError =
      Snack(301, 'Failed to launch Stripe website for payment');

  static var subscriptionAdded = Snack(9000, 'Subscribed!');
}
