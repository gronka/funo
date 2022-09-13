import 'package:flutter/material.dart';

optionInfoStyle() {
  return const TextStyle(
    color: Colors.grey,
  );
}

failureStyle() {
  return const TextStyle(
    color: Colors.red,
  );
}

class Bast {
  static TextStyle greyItalic = const TextStyle(
    color: Colors.grey,
    fontStyle: FontStyle.italic,
  );
  static TextStyle failure = const TextStyle(
    color: Colors.red,
    fontStyle: FontStyle.italic,
  );
  static TextStyle optionInfo = const TextStyle(color: Colors.grey);
}
