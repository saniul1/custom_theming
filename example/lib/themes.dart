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
  static final Map<String, ThemeManagerData> themes = {
    'default-dark': ThemeManagerData(
      name: 'Default Dark',
      createdBy: '',
      themeData: ThemeData.dark(),
    ),
    'default-light': ThemeManagerData(
      name: 'Default Light',
      createdBy: '',
      themeData: ThemeData(),
    ),
    'default-light2': ThemeManagerData(
      name: 'Default Light 2',
      createdBy: '',
      themeData: ThemeData().copyWith(
        primaryColor: Colors.teal,
      ),
    ),
    'darker-dark': ThemeManagerData(
      name: 'Darker Dark',
      createdBy: '',
      themeData: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
      ),
    ),
    'test*dark': ThemeManagerData(
      name: 'Test Dark',
      createdBy: '',
      themeData: ThemeData.dark().copyWith(
        primaryColor: Colors.grey,
      ),
    ),
    'test*light': ThemeManagerData(
      name: 'Test Light',
      createdBy: '',
      themeData: ThemeData.light().copyWith(
        primaryColor: Colors.pink,
      ),
    ),
  };
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
  static final Map<String, CustomCupertinoThemeData> cupertinoThemes = {
    'default': CustomCupertinoThemeData(
      name: 'Default',
      createdBy: 'Dev',
      themeData: CupertinoThemeData().copyWith(
        primaryColor: Colors.amber,
      ),
    ),
    'green': CustomCupertinoThemeData(
      name: 'Green',
      createdBy: 'Dev',
      themeData: CupertinoThemeData().copyWith(
        primaryColor: Colors.green,
      ),
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
