import 'package:flutter/material.dart';

class CustomThemeData {
  final String key;
  final String name;
  final String createdBy;
  final ThemeData themeData;
  final dynamic customData;
  CustomThemeData({
    this.key,
    this.name,
    this.createdBy,
    @required this.themeData,
    this.customData,
  });
}
