import 'package:flutter/cupertino.dart';

class CustomCupertinoThemeData {
  final String key;
  final String name;
  final String createdBy;
  final CupertinoThemeData themeData;

  /// Don't access [customData] from [CustomCupertinoThemeData] directly. instead use
  /// ```
  /// CustomTheme.customCupertinoDataOf<Type>(context)
  /// ```
  final dynamic customData;
  CustomCupertinoThemeData({
    this.key,
    this.name,
    this.createdBy,
    @required this.themeData,
    this.customData,
  });
}
