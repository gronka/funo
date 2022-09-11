String multiplyString(String input, double multiplier) {
  double? parsed = double.tryParse(input);
  if (parsed == null) {
    return 'error';
  } else {
    return (parsed * multiplier).toStringAsFixed(2);
  }
}

bool stringIsZeroCents(String value) {
  if (value == '0.00') {
    return true;
  }
  if (value == '-0.00') {
    return true;
  }
  return false;
}
