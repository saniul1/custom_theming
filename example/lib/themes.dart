import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_manager/theme_manager.dart';

import 'models.dart';

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
  static final List<CustomThemeManagerData> customData = [
    CustomThemeManagerData(
      key: 'default',
      data: Name(
        name: 'Default',
        description: 'This is default cupertino theme',
        no: 1,
      ),
    ),
    CustomThemeManagerData(
      key: 'green',
      data: Name(
        name: 'Green',
        description: 'This is green cupertino theme...',
        no: 2,
      ),
    ),
    CustomThemeManagerData(
      key: 'red',
      data: Name(
        name: 'Red',
        description: 'This is red cupertino theme!',
        no: 3,
      ),
    ),
    CustomThemeManagerData(
      key: 'default-light',
      data: Name(
        name: 'Default Light',
        description: 'This is default "light" theme for material',
        no: 01,
      ),
    ),
    CustomThemeManagerData(
      key: 'default-dark',
      data: Name(
        name: 'Default Dark',
        description: 'This is default "dark" theme for material',
        no: 02,
      ),
    ),
  ];
}
