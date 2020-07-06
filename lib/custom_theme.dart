import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

/// Base class
class CustomTheme extends StatefulWidget {
  final Widget child;
  final String defaultLightTheme;
  final String defaultDarkTheme;
  final String defaultCupertinoTheme;
  final ThemeMode themeMode;
  final Map<String, ThemeData> themes;
  final Map<String, CupertinoThemeData> cupertinoThemes;
  final bool keepOnDisableFollow;

  /// [CustomTheme] needs to be on top of [MaterialApp] or [CupertinoApp],
  ///
  /// pass app [BuildContext] like this from your [MaterialApp] or [CupertinoApp]
  /// ```
  /// builder: (context, child) {
  ///   CustomTheme.of(context).setMediaContext(context);
  ///   return child;
  /// },
  /// ```
  /// pass [themes] using a map [Map<String, ThemeData>] and use key of [map] as [themeName]
  ///
  /// hard code some default setting for [defaultLightTheme], [defaultDarkTheme], [themeMode]
  ///
  /// set [keepOnDisableFollow] to [true] to keep current applied theme even if [themeMode] changes from [ThemeMode.system]
  const CustomTheme({
    Key key,
    this.defaultLightTheme,
    this.defaultDarkTheme,
    this.defaultCupertinoTheme,
    this.themeMode,
    this.themes,
    this.cupertinoThemes,
    this.keepOnDisableFollow = false,
    @required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => new CustomThemeState();

  static CustomThemeState of(BuildContext context) {
    _CustomTheme inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  SharedPreferences sharedPrefs;

  BuildContext _mediaContext;

  String _currentThemeName;

  ThemeData _light;

  ThemeData _dark;

  ThemeMode _mode;

  CupertinoThemeData _cupertinoTheme;

  Map<String, ThemeData> get themes => widget.themes;

  Map<String, CupertinoThemeData> get cupertinoThemes => widget.cupertinoThemes;

  String get currentThemeName => _currentThemeName;

  CupertinoThemeData get cupertinoTheme => _cupertinoTheme;

  ThemeData get lightTheme => _light;

  ThemeData get darkTheme => _dark;

  ThemeMode get themeMode => _mode;

  void setMediaContext(BuildContext ctx) {
    _mediaContext = ctx;
  }

  @override
  void initState() {
    _light = _getTheme(widget.defaultLightTheme);
    _dark = _getTheme(widget.defaultDarkTheme);
    _cupertinoTheme = _getCupertinoTheme(widget.defaultCupertinoTheme);
    _mode = widget.themeMode;
    SharedPreferences.getInstance().then((prefs) {
      sharedPrefs = prefs;
      final isDark = sharedPrefs.getBool('dark-mode');
      final followSystem = sharedPrefs.getBool('follow-system');
      final dLight = sharedPrefs.getString('default-light');
      final dDark = sharedPrefs.getString('default-dark');
      final dCupertino = sharedPrefs.getString('default-cupertino');
      if (dCupertino != null && widget.cupertinoThemes.containsKey(dCupertino))
        _cupertinoTheme = widget.cupertinoThemes[dCupertino];
      if (dLight != null && widget.themes.containsKey(dLight))
        _light = widget.themes[dLight];
      if (dDark != null && widget.themes.containsKey(dDark))
        _dark = widget.themes[dDark];
      // print("Theme: followSystem - $followSystem, isDark -$isDark");
      if (followSystem != null && !followSystem) setDarkMode(isDark ?? false);
      if (followSystem != null && followSystem) {
        setState(() {
          _mode = ThemeMode.system;
        });
      }
      _setCurrentTheme();
    });
    super.initState();
  }

  /// get [ThemeData] by [key] name of [themes]
  /// returns [ThemeData.fallback()] if theme not found
  ThemeData _getTheme(String key) {
    final isExist = widget.themes.containsKey(key);
    return isExist ? widget.themes[key] : ThemeData.fallback();
  }

  /// get [ThemeData] by [key] name of [themes]
  /// returns [ThemeData.fallback()] if theme not found
  CupertinoThemeData _getCupertinoTheme(String key) {
    final isExist = widget.cupertinoThemes.containsKey(key);
    return isExist ? widget.cupertinoThemes[key] : CupertinoThemeData();
  }

  /// set default themes for [darkTheme] or [lightTheme]
  ///
  /// to apply them straightaway set [apply] to [true]
  ///
  /// Note: Doing this changes [themeMode] to [ThemeMode.dark] or [ThemeMode.light] based on the theme selected, even if [themeMode] was [ThemeMode.system]
  void setTheme(String themeKey, {bool apply = false}) {
    final theme = _getTheme(themeKey);
    if (theme.brightness == Brightness.dark) {
      setState(() {
        _dark = _getTheme(themeKey);
        if (apply) {
          _mode = ThemeMode.dark;
        }
      });
      sharedPrefs.setString('default-dark', themeKey);
      if (apply) {
        sharedPrefs.setBool('dark-mode', true);
        sharedPrefs.setBool('follow-system', false);
      }
    } else {
      setState(() {
        _light = _getTheme(themeKey);
        if (apply) {
          _mode = ThemeMode.light;
        }
      });
      sharedPrefs.setString('default-light', themeKey);
      if (apply) {
        sharedPrefs.setBool('dark-mode', false);
        sharedPrefs.setBool('follow-system', false);
      }
    }
    _setCurrentTheme();
  }

  /// set default theme for [cupertinoTheme]
  void setCupertinoTheme(String themeKey) {
    setState(() {
      _cupertinoTheme = _getCupertinoTheme(themeKey);
    });
    sharedPrefs.setString('default-cupertino', themeKey);
  }

  /// set default theme for [lightTheme]
  void setLightTheme(String themeKey) {
    setState(() {
      _light = _getTheme(themeKey);
    });
  }

  /// set default theme for [darkTheme]
  void setDarkTheme(String themeKey) {
    setState(() {
      _dark = _getTheme(themeKey);
    });
  }

  /// toggle between [ThemeMode.dark] and [ThemeMode.light]
  void toggleDarkMode(bool _) {
    setState(() {
      _mode = checkDark() ? ThemeMode.light : ThemeMode.dark;
    });
    _setCurrentTheme();
    if (sharedPrefs != null) {
      sharedPrefs.setBool('dark-mode', _mode == ThemeMode.dark);
      sharedPrefs.setBool('follow-system', false);
    }
  }

  /// set [themeMode] to [ThemeMode.dark] or [ThemeMode.light] by passing [value]
  void setDarkMode(bool value) {
    setState(() {
      _mode = value ? ThemeMode.dark : ThemeMode.light;
    });
    _setCurrentTheme();
  }

  /// sets [currentThemeName] to currently applied theme
  void _setCurrentTheme() {
    setState(() {
      _currentThemeName = checkDark()
          ? widget.themes.keys.firstWhere((key) => widget.themes[key] == _dark)
          : widget.themes.keys
              .firstWhere((key) => widget.themes[key] == _light);
    });
  }

  /// change [themeMode] value to [ThemeMode.system] by setting [value] to [true] or [false] to [ThemeMode.dark] | [ThemeMode.light]
  void setThemeModeToSystem(bool value) {
    setState(() {
      if (widget.keepOnDisableFollow) {
        _mode = value
            ? ThemeMode.system
            : checkDark() ? ThemeMode.dark : ThemeMode.light;
      } else {
        final isDark = sharedPrefs.getBool('dark-mode');
        _mode = value
            ? ThemeMode.system
            : isDark ? ThemeMode.dark : ThemeMode.light;
      }
    });
    _setCurrentTheme();
    if (sharedPrefs != null) {
      sharedPrefs.setBool('follow-system', value);
      if (widget.keepOnDisableFollow)
        sharedPrefs.setBool('dark-mode', _mode == ThemeMode.dark);
    }
  }

  /// check if a theme is currently default or not.
  bool checkIfDefault(String key) {
    return widget.themes[key] == _light || widget.themes[key] == _dark;
  }

  /// check if current theme is dark or not.
  /// check for [system] if [themeMode] is [ThemeMode.system]
  bool checkDark() {
    final Brightness systemBrightnessValue =
        MediaQuery.of(_mediaContext).platformBrightness;
    return _mode == ThemeMode.system
        ? systemBrightnessValue == Brightness.dark
        : _mode == ThemeMode.dark;
  }

  /// reset every settings, Go back to hard coded settings.
  Future<void> resetSettings() async {
    await sharedPrefs.remove('dark-mode');
    await sharedPrefs.remove('follow-system');
    await sharedPrefs.remove('default-light');
    await sharedPrefs.remove('default-dark');
    await sharedPrefs.remove('default-cupertino');
    // Todo: set values to defaults
  }

  @override
  Widget build(BuildContext context) {
    return new _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}
