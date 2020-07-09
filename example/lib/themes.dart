import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_theming/custom_theme.dart';

class Name {
  final String name;
  final int no;
  Name({this.name, this.no});
}

class MyThemes {
  static final Map<String, CustomThemeData> themes = {
    'default-dark': CustomThemeData(
      name: 'Default Dark',
      createdBy: '',
      themeData: ThemeData.dark(),
      customData: Name(name: 'Example default'),
    ),
    'default-light': CustomThemeData(
      name: 'Default Light',
      createdBy: '',
      themeData: ThemeData(),
    ),
    'default-light2': CustomThemeData(
      name: 'Default Light 2',
      createdBy: '',
      themeData: ThemeData().copyWith(
        primaryColor: Colors.teal,
      ),
    ),
    'darker-dark': CustomThemeData(
      name: 'Darker Dark',
      createdBy: '',
      themeData: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
      ),
    ),
    'test*dark': CustomThemeData(
      name: 'Test Dark',
      createdBy: '',
      themeData: ThemeData.dark().copyWith(
        primaryColor: Colors.grey,
      ),
    ),
    'test*light': CustomThemeData(
      name: 'Test Light',
      createdBy: '',
      themeData: ThemeData.light().copyWith(
        primaryColor: Colors.pink,
      ),
      customData: Name(name: 'Example Pink', no: 1),
    ),
  };
  static final Map<String, CustomCupertinoThemeData> cupertinoThemes = {
    'default': CustomCupertinoThemeData(
      name: 'Default',
      createdBy: 'Dev',
      themeData: CupertinoThemeData().copyWith(
        primaryColor: Colors.amber,
      ),
      customData: Name(name: "I'm Default", no: 1),
    ),
    'green': CustomCupertinoThemeData(
      name: 'Green',
      createdBy: 'Dev',
      themeData: CupertinoThemeData().copyWith(
        primaryColor: Colors.green,
      ),
      customData: Name(name: "I'm Green", no: 2),
    ),
    'red': CustomCupertinoThemeData(
      name: 'Red',
      createdBy: 'Dev',
      themeData: CupertinoThemeData().copyWith(
        primaryColor: Colors.red,
      ),
      // customData: Name(no: 3),
    ),
  };
}
