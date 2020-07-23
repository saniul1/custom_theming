import 'package:flutter/cupertino.dart' show CupertinoThemeData;

class CupertinoThemeManagerData {
  final String key;
  final String name;
  final String createdBy;
  final CupertinoThemeData themeData;
  CupertinoThemeManagerData({
    this.key,
    this.name,
    this.createdBy,
    this.themeData,
  });
}
