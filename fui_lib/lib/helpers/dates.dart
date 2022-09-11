import 'package:intl/intl.dart';

int getPeriodFromNow() {
  var date = DateTime.now();
  return date.year * 100 + date.month;
}

String uuidWithPeriod(String uuid, int year, int month) {
  return '$uuid-$year-$month';
}

String periodToHuman(int period) {
  int year = (period / 100).floor();
  int month = period % 100;
  var date = DateTime(year, month);
  return DateFormat.yMMMM().format(date);
}

String dateToHumanPeriod(DateTime date) {
  return DateFormat.yMMMM().format(date);
}

String stampToHumanPeriod(int stamp) {
  return dateToHumanPeriod(DateTime.fromMillisecondsSinceEpoch(stamp * 1000));
}

String stampToDateAndTime(int stamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(stamp * 1000);
  return DateFormat.yMMMd().add_jm().format(date);
}
