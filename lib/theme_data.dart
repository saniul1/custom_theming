import 'package:flutter/material.dart' show ThemeData;

class ThemeManagerData {
  final String key;
  final String name;
  final String createdBy;
  final ThemeData themeData;
  ThemeManagerData({
    this.key,
    this.name,
    this.createdBy,
    this.themeData,
  });
}
