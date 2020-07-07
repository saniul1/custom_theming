import 'package:flutter/material.dart';
import 'package:custom_theming/custom_theme.dart';

class MyThemes {
  static final Map<String, CustomThemeData> themes = {
    'default-dark': CustomThemeData(
      name: 'Default Dark',
      createdBy: '',
      themeData: ThemeData.dark(),
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
    ),
  };
}
