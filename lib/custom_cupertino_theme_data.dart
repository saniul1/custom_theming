import 'package:flutter/cupertino.dart';

class CustomCupertinoThemeData {
  final String key;
  final String name;
  final String createdBy;
  final CupertinoThemeData themeData;
  final dynamic customData;
  CustomCupertinoThemeData({
    this.key,
    this.name,
    this.createdBy,
    @required this.themeData,
    this.customData,
  });
}
