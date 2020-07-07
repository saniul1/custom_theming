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

class CustomThemeData {
  /// **Warning:** Never set value outside of class.
  /// *Internal use only*
  String key;
  final String name;
  final String createdBy;
  final ThemeData themeData;
  final dynamic customData;
  CustomThemeData({
    this.key,
    @required this.name,
    @required this.createdBy,
    @required this.themeData,
    this.customData,
  });
}

class CustomCupertinoThemeData {
  /// **Warning:** Never set value outside of class.
  /// *Internal use only*
  String key;
  final String name;
  final String createdBy;
  final CupertinoThemeData themeData;
  final dynamic customData;
  CustomCupertinoThemeData({
    this.key,
    @required this.name,
    @required this.createdBy,
    @required this.themeData,
    this.customData,
  });
}

/// Base class
// ignore: must_be_immutable
class CustomTheme extends StatefulWidget {
  final Widget child;
  final String prefix;
  final String defaultLightTheme;
  final String defaultDarkTheme;
  final String defaultCupertinoTheme;
  final ThemeMode themeMode;
  final bool keepOnDisableFollow;
  Map<String, CustomThemeData> themes;
  Map<String, CustomCupertinoThemeData> cupertinoThemes;

  /// [CustomTheme] needs to be on top of [MaterialApp] or [CupertinoApp],
  /// Add [prefix] to separate data on storage.
  ///
  /// pass app [BuildContext] like this from your [MaterialApp] or [CupertinoApp]
  /// ```
  /// builder: (context, child) {
  ///   CustomTheme.of(context).setMediaContext(context);
  ///   return child;
  /// },
  /// ```
  /// pass [themes] using a map [Map<String, ThemeData>] and use key of [map] as [themeKey]
  ///
  /// hard code some default setting for [defaultLightTheme], [defaultDarkTheme] and [themeMode]
  ///
  /// set [keepOnDisableFollow] to [true] to keep current applied theme even if [themeMode] changes from [ThemeMode.system]
  ///
  /// [cupertinoThemes] does not support [themeMode]. it always follow system setting.
  CustomTheme({
    Key key,
    this.prefix = '',
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

  String _currentThemeKey;

  String _currentCupertinoThemeKey;

  CustomCupertinoThemeData _cupertinoTheme;

  CustomThemeData _light;

  CustomThemeData _dark;

  ThemeMode _mode;

  Map<String, CustomThemeData> get themes => widget.themes;

  Map<String, CustomCupertinoThemeData> get cupertinoThemes =>
      widget.cupertinoThemes;

  CupertinoThemeData get cupertinoTheme => _cupertinoTheme.themeData;

  ThemeData get lightTheme => _light.themeData;

  ThemeData get darkTheme => _dark.themeData;

  ThemeMode get themeMode => _mode;

  /// get [themeKey] of currently applied cupertino theme.
  String get currentCupertinoThemeKey => _currentCupertinoThemeKey;

  /// get [themeKey] of currently applied theme.
  String get currentThemeKey => _currentThemeKey;

  void setMediaContext(BuildContext ctx) {
    _mediaContext = ctx;
  }

  // set default settings either from hard code or from system storage or server.
  @override
  void initState() {
    if (widget.themes == null)
      widget.themes = {
        'default-light': CustomThemeData(
          key: 'default-light',
          name: 'Default Light',
          createdBy: '',
          themeData: ThemeData.light(),
        ),
        'default-dark': CustomThemeData(
          key: 'default-dark',
          name: 'Default Light',
          createdBy: '',
          themeData: ThemeData.dark(),
        ),
      };
    widget.themes.forEach((key, value) {
      value.key = key;
    });
    if (widget.cupertinoThemes == null)
      widget.cupertinoThemes = {
        'default': CustomCupertinoThemeData(
          name: 'default',
          createdBy: '',
          themeData: CupertinoThemeData(),
        ),
      };
    _light = _getTheme(widget.defaultLightTheme);
    _dark = _getTheme(widget.defaultDarkTheme);
    _cupertinoTheme = _getCupertinoThemeData(widget.defaultCupertinoTheme);
    _mode = widget.themeMode;
    SharedPreferences.getInstance().then((prefs) {
      sharedPrefs = prefs;
      final isDark = sharedPrefs.getBool('${widget.prefix}-dark-mode');
      final followSystem =
          sharedPrefs.getBool('${widget.prefix}-follow-system');
      final dLight = sharedPrefs.getString('${widget.prefix}-default-light');
      final dDark = sharedPrefs.getString('${widget.prefix}-default-dark');
      final dCupertino =
          sharedPrefs.getString('${widget.prefix}-default-cupertino');
      if (dCupertino != null &&
          widget.cupertinoThemes.containsKey(dCupertino)) {
        _cupertinoTheme = widget.cupertinoThemes[dCupertino];
        _currentCupertinoThemeKey = dCupertino;
      }
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
    });
    Future.delayed(Duration(milliseconds: 0), () {
      setState(() {
        _currentThemeKey = getCurrentThemeData().key;
      });
    });
    super.initState();
  }

  /// get [ThemeData] by [key] name of [themes]
  /// returns [null] if theme not found
  CustomThemeData _getTheme(String key) {
    return widget.themes.containsKey(key) ? widget.themes[key] : null;
  }

  /// get [ThemeData] by [key] name of [themes]
  /// returns [null] if theme not found
  CustomCupertinoThemeData _getCupertinoThemeData(String key) {
    return widget.cupertinoThemes.containsKey(key)
        ? widget.cupertinoThemes[key]
        : null;
  }

  /// set default themes for [darkTheme] or [lightTheme]
  ///
  /// to apply them straightaway set [apply] to [true]
  ///
  /// Note: Doing this changes [themeMode] to [ThemeMode.dark] or [ThemeMode.light] based on the theme selected, even if [themeMode] was [ThemeMode.system]
  ///
  /// set [both] to [true] to set related theme to [darkTheme] or [lightTheme],
  /// if no related theme found keeps the previous theme.
  ///
  /// Note: To apply related theme correctly [themeKey] needs to be correctly configured in  [themes] data passed on to [CustomTheme].
  ///
  /// follow these kind of structure for related themes [example-light], [example-dark] or [vary_simple_light_theme], [vary_simple_dark_theme].
  /// Don't use camel cases in [themeKey] like [exampleLight], [exampleDark].
  void setTheme(String themeKey, {bool apply = false, bool both = false}) {
    final theme = _getTheme(themeKey).themeData;
    if (theme.brightness == Brightness.dark) {
      if (both) {
        final key = themeKey.replaceAll('dark', 'light');
        final CustomThemeData lightTheme =
            key == themeKey ? null : _getTheme(key);
        if (lightTheme != null) {
          setState(() {
            _light = lightTheme;
          });
          sharedPrefs.setString('${widget.prefix}-default-light', key);
        }
      }
      setState(() {
        _dark = _getTheme(themeKey);
        if (apply) {
          _mode = ThemeMode.dark;
        }
      });
      sharedPrefs.setString('${widget.prefix}-default-dark', themeKey);
      if (apply) {
        sharedPrefs.setBool('${widget.prefix}-dark-mode', true);
        sharedPrefs.setBool('${widget.prefix}-follow-system', false);
      }
    } else {
      if (both) {
        final key = themeKey.replaceAll('light', 'dark');
        final CustomThemeData darkTheme =
            key == themeKey ? null : _getTheme(key);
        if (darkTheme != null) {
          setState(() {
            _dark = darkTheme;
          });
          sharedPrefs.setString('${widget.prefix}-default-dark', key);
        }
      }
      setState(() {
        _light = _getTheme(themeKey);
        if (apply) {
          _mode = ThemeMode.light;
        }
      });
      sharedPrefs.setString('${widget.prefix}-default-light', themeKey);
      if (apply) {
        sharedPrefs.setBool('${widget.prefix}-dark-mode', false);
        sharedPrefs.setBool('${widget.prefix}-follow-system', false);
      }
    }
    setState(() {
      _currentThemeKey = themeKey;
    });
  }

  /// set default theme for [cupertinoTheme]
  void setCupertinoTheme(String themeKey) {
    // print(themeKey);
    setState(() {
      _cupertinoTheme = _getCupertinoThemeData(themeKey);
      _currentCupertinoThemeKey = themeKey;
    });
    sharedPrefs.setString('${widget.prefix}-default-cupertino', themeKey);
  }

  /// set default theme for [lightTheme]
  void setLightTheme(String themeKey) {
    setState(() {
      _light = _getTheme(themeKey);
      _currentThemeKey = themeKey;
    });
  }

  /// set default theme for [darkTheme]
  void setDarkTheme(String themeKey) {
    setState(() {
      _dark = _getTheme(themeKey);
      _currentThemeKey = themeKey;
    });
  }

  /// toggle between [ThemeMode.dark] and [ThemeMode.light]
  void toggleDarkMode(bool _) {
    setState(() {
      _mode = checkDark() ? ThemeMode.light : ThemeMode.dark;
    });

    if (sharedPrefs != null) {
      sharedPrefs.setBool(
          '${widget.prefix}-dark-mode', _mode == ThemeMode.dark);
      sharedPrefs.setBool('${widget.prefix}-follow-system', false);
    }
  }

  /// set [themeMode] to [ThemeMode.dark] or [ThemeMode.light] by passing [value]
  void setDarkMode(bool value) {
    setState(() {
      _mode = value ? ThemeMode.dark : ThemeMode.light;
    });
  }

  /// set [themeMode] value to [ThemeMode.system] by passing [true],
  /// or pass [false] to change [themeMode] to [ThemeMode.dark] or [ThemeMode.light]
  void setThemeModeToSystem(bool value) {
    setState(() {
      if (widget.keepOnDisableFollow) {
        _mode = value
            ? ThemeMode.system
            : checkDark() ? ThemeMode.dark : ThemeMode.light;
      } else {
        final isDark = sharedPrefs.getBool('${widget.prefix}-dark-mode');
        _mode = value
            ? ThemeMode.system
            : isDark != null && isDark ? ThemeMode.dark : ThemeMode.light;
      }
    });

    if (sharedPrefs != null) {
      sharedPrefs.setBool('${widget.prefix}-follow-system', value);
      if (widget.keepOnDisableFollow)
        sharedPrefs.setBool(
            '${widget.prefix}-dark-mode', _mode == ThemeMode.dark);
    }
  }

  /// check if current theme is dark or not.
  /// if [themeMode] is [ThemeMode.system] check current [ThemeMode] of [system].
  bool checkDark() {
    final Brightness systemBrightnessValue =
        MediaQuery.of(_mediaContext).platformBrightness;
    return _mode == ThemeMode.system
        ? systemBrightnessValue == Brightness.dark
        : _mode == ThemeMode.dark;
  }

  /// check if a theme is currently default or not.
  // ! returns true for (all) themes with the same properties.
  bool checkIfDefault(String key) {
    return widget.themes[key].key == _light.key ||
        widget.themes[key].key == _dark.key;
  }

  bool checkIfCurrent(String key) {
    return checkDark()
        ? widget.themes[key].key == _dark.key
        : widget.themes[key].key == _light.key;
  }

  /// get [CustomThemeData] of current theme.
  ///
  /// make sure [_mediaContext] is not null before using these function.
  CustomThemeData getCurrentThemeData() {
    final currentKey =
        widget.themes.keys.firstWhere((key) => checkIfCurrent(key));
    return widget.themes[currentKey];
  }

  /// [key] is [themeKey]
  ///
  /// theme can be generated anywhere on the app but the best place to make new theme is in
  /// [MaterialApp]. like these -
  /// ```
  /// builder: (context, child) {
  ///   ...
  ///   CustomTheme.of(context).generateTheme(
  ///     key: <themeKey>,
  ///     data: <ThemeData>,
  ///   );
  ///   return child;
  /// },
  /// ```
  void generateTheme({
    @required String key,
    @required String name,
    @required String createdBy,
    @required ThemeData data,
    dynamic customData,
  }) {
    widget.themes[key] = CustomThemeData(
      key: key,
      name: name,
      createdBy: createdBy,
      themeData: data,
    );
    // print('theme generated!');
  }

  /// [key] is [themeKey]
  ///
  /// theme can be generated anywhere on the app but the best place to make new cupertino theme is in
  /// [CupertinoApp]. like these -
  /// ```
  /// builder: (context, child) {
  ///   ...
  ///   CustomTheme.of(context).generateTheme(
  ///     key: <themeKey>,
  ///     data: <ThemeData>,
  ///   );
  ///   return child;
  /// },
  /// ```
  void generateCupertinoTheme({
    @required String key,
    @required CustomCupertinoThemeData data,
    dynamic customData,
  }) {
    widget.cupertinoThemes[key] = data;
  }

  /// reset every settings, Go back to hard coded settings.
  Future<void> resetSettings() async {
    await sharedPrefs.remove('${widget.prefix}-dark-mode');
    await sharedPrefs.remove('${widget.prefix}-follow-system');
    await sharedPrefs.remove('${widget.prefix}-default-light');
    await sharedPrefs.remove('${widget.prefix}-default-dark');
    await sharedPrefs.remove('${widget.prefix}-default-cupertino');
    // Todo: set values to defaults

    print('All Deleted');
  }

  @override
  Widget build(BuildContext context) {
    return new _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}
