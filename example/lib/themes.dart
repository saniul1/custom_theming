import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_manager/theme_manager.dart';

class Name {
  final String name;
  final String description;
  final int no;
  Name({this.name, this.description, this.no});
}

class MyThemes {
  static final List<ThemeManagerData> themes = [
    ThemeManagerData(
      key: 'default-dark',
      name: 'Default Dark',
      createdBy: '',
      themeData: ThemeData.dark(),
    ),
    ThemeManagerData(
      key: 'default-light',
      name: 'Default Light',
      createdBy: '',
      themeData: ThemeData(),
    ),
    ThemeManagerData(
      key: 'default-light2',
      name: 'Default Light 2',
      createdBy: '',
      themeData: ThemeData().copyWith(
        primaryColor: Colors.teal,
      ),
    ),
    ThemeManagerData(
      key: 'darker-dark',
      name: 'Darker Dark',
      createdBy: '',
      themeData: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
      ),
    ),
    ThemeManagerData(
      key: 'test*dark',
      name: 'Test Dark',
      createdBy: '',
      themeData: ThemeData.dark().copyWith(
        primaryColor: Colors.grey,
      ),
    ),
    ThemeManagerData(
      key: 'test*light',
      name: 'Test Light',
      createdBy: '',
      themeData: ThemeData.light().copyWith(
        primaryColor: Colors.pink,
      ),
    ),
  ];
  static final List<CupertinoThemeManagerData> cupertinoThemes = [
    CupertinoThemeManagerData(
      key: 'default',
      name: 'Default',
      createdBy: 'Dev',
      themeData: CupertinoThemeData().copyWith(
        primaryColor: Colors.amber,
      ),
    ),
    CupertinoThemeManagerData(
      key: 'green',
      name: 'Green',
      createdBy: 'Dev',
      themeData: CupertinoThemeData().copyWith(
        primaryColor: Colors.green,
      ),
    ),
    CupertinoThemeManagerData(
      key: 'red',
      name: 'Red',
      createdBy: 'Dev',
      themeData: CupertinoThemeData().copyWith(
        primaryColor: Colors.red,
      ),
      // customData: Name(no: 3),
    ),
  ];
  static final Map<String, Name> customData = {
    'default': Name(
      name: 'Default',
      description: 'This is default cupertino theme',
      no: 1,
    ),
    'green': Name(
      name: 'Green',
      description: 'This is green cupertino theme',
      no: 2,
    ),
    'red': Name(
      name: 'Red',
      description: 'This is red cupertino theme',
      no: 3,
    ),
    'default-light': Name(
      name: 'Default Light',
      description: 'This is default light theme for material',
      no: 01,
    ),
    'default-dark': Name(
      name: 'Default Dark',
      description: 'This is default dark theme for material',
      no: 02,
    ),
  };
}
