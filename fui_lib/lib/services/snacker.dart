import 'dart:async';
import 'package:mobx/mobx.dart';

class Snacker {
  ObservableList<Snack> snacks = ObservableList<Snack>();

  void addSnack(Snack snack) {
    snacks.removeWhere((item) => (item.code == snack.code));
    snacks.add(snack);
  }

  void removeSnack(Snack snack) {
    snacks.removeWhere((item) => (item.code == snack.code));
  }

  void startTimer(Snack snack) {
    if (snack.timeout > 0) {
      Timer(Duration(milliseconds: snack.timeout), () {
        removeSnack(snack);
      });
    }
  }
}

class Snack {
  Snack(this.code, this.msg, {this.timeout = 0});
  int code;
  String msg;
  int timeout;
}
