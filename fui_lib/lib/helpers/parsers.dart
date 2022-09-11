import 'package:flutter/material.dart';

bool readBool(Map<String, dynamic> body, String key) {
  bool? value = body[key];
  if (value == null) {
    throw Exception('Null value for bool key: $key');
  }
  return value;
}

bool readBoolFromString(Map<String, dynamic> body, String key) {
  String? value = body[key];
  if (value == null) {
    throw Exception('Null value for bool key: $key');
  }
  value = value.toLowerCase();
  if (value == 'true') {
    return true;
  }
  return false;
}

double readDouble(Map<String, dynamic> body, String key) {
  double? value = body[key];
  if (value == null) {
    throw Exception('Null value for int key: $key');
  }
  return value;
}

int readInt(Map<String, dynamic> body, String key) {
  int? value = body[key];
  if (value == null) {
    throw Exception('Null value for int key: $key');
  }
  return value;
}

List<dynamic> readList(Map<String, dynamic> body, String key) {
  List<dynamic>? value = body[key];
  if (value == null) {
    throw Exception('Null value for string key: $key');
  }
  return value;
}

List<String> readListOfString(Map<String, dynamic> body, String key) {
  List<dynamic>? value = body[key];
  if (value == null) {
    throw Exception('Null value for string key: $key');
  }
  List<String> parsed = List<String>.from(value);
  return parsed;
}

Map<String, dynamic> readMap(Map<String, dynamic> body, String key) {
  Map<String, dynamic>? value = body[key];
  if (value == null) {
    throw Exception('Null value for string key: $key');
  }
  return value;
}

String readString(Map<String, dynamic> body, String key) {
  String? value = body[key];
  if (value == null) {
    throw Exception('Null value for string key: $key');
  }
  return value;
}

String stringFromColor(Color color) {
  return [color.red, color.green, color.blue].join(',');
}

Color colorFromString(String colorString) {
  var rgb = colorString.split(',');
  if (rgb.length != 3) {
    return const Color(0xFF00CC88);
  }
  return Color.fromRGBO(
    int.parse(rgb[0]),
    int.parse(rgb[1]),
    int.parse(rgb[2]),
    1.0,
  );
}
