import 'package:flutter/material.dart';

class MyThemes {
  static final Map<String, ThemeData> themes = {
    'default-dark': ThemeData.dark(),
    'default-light': ThemeData.light(),
    'default-light2': ThemeData.light().copyWith(
      primaryColor: Colors.teal,
    ),
    'darker-dark': ThemeData.dark().copyWith(
      primaryColor: Colors.black,
    ),
    'test*dark': ThemeData.dark().copyWith(
      primaryColor: Colors.grey,
    ),
    'test*light': ThemeData.light().copyWith(
      primaryColor: Colors.pink,
    ),
  };
}
