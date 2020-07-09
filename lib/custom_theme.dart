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
  final Color appColor;
  final Map<String, CustomThemeData> themes;
  final Map<String, CustomCupertinoThemeData> cupertinoThemes;

  /// [CustomTheme] is best used as parent of [MaterialApp] or [CupertinoApp] or [WidgetsApp],
  /// but you can also use it without any of these widget.
  ///
  /// Add [prefix] to separate data on different part in the app.
  ///
  /// pass [themes] using a map [Map<String, CustomThemeData>] and use key of [map] as [themeKey]
  ///
  /// hard code some default setting for [defaultLightTheme], [defaultDarkTheme] and [themeMode]
  ///
  /// set [keepOnDisableFollow] to [true] to keep current applied theme even if [themeMode] changes from [ThemeMode.system]
  ///
  /// [cupertinoThemes] does not support [themeMode]. it always follow system setting.
  CustomTheme({
    Key key,
    this.prefix = 'app',
    this.defaultLightTheme = 'default-light',
    this.defaultDarkTheme = 'default-dark',
    this.defaultCupertinoTheme = 'default',
    this.themeMode = ThemeMode.system,
    this.keepOnDisableFollow = false,
    this.themes,
    this.cupertinoThemes,
    this.appColor,
    @required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => new CustomThemeState();

  static CustomThemeState of(BuildContext context) {
    _CustomTheme inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited.data;
  }

  static CustomThemeData themeOf(BuildContext context) {
    _CustomTheme inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited.data.themes[inherited.data.currentThemeKey];
  }

  static CustomCupertinoThemeData cupertinoThemeOf(BuildContext context) {
    _CustomTheme inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited
        .data.cupertinoThemes[inherited.data.currentCupertinoThemeKey];
  }
}

class CustomThemeState extends State<CustomTheme> {
  SharedPreferences _sharedPrefs;

  BuildContext _mediaContext;

  Map<String, CustomThemeData> _themes;

  Map<String, CustomCupertinoThemeData> _cupertinoThemes;

  String _currentLightThemeKey;

  String _currentDarkThemeKey;

  String _currentCupertinoThemeKey;

  ThemeMode _mode;

  Map<String, CustomThemeData> get themes => _themes;

  Map<String, CustomCupertinoThemeData> get cupertinoThemes => _cupertinoThemes;

  CupertinoThemeData get cupertinoTheme =>
      _cupertinoThemes[_currentCupertinoThemeKey]?.themeData ?? null;

  ThemeData get lightTheme => _themes[_currentLightThemeKey]?.themeData ?? null;

  ThemeData get darkTheme => _themes[_currentDarkThemeKey]?.themeData ?? null;

  ThemeMode get themeMode => _mode;

  /// get [themeKey] of currently applied cupertino theme.
  String get currentCupertinoThemeKey => _currentCupertinoThemeKey;

  /// get [themeKey] of currently applied theme.
  String get currentThemeKey =>
      checkDark() ? _currentDarkThemeKey : _currentLightThemeKey;

  // set default settings either from hard code or from system storage or server.
  @override
  void initState() {
    if (widget.themes == null) {
      _themes = {
        'default-light': CustomThemeData(
          key: 'default-light',
          name: 'Default Light',
          createdBy: '',
          themeData: ThemeData.light(),
        ),
        'default-dark': CustomThemeData(
          key: 'default-dark',
          name: 'Default Dark',
          createdBy: '',
          themeData: ThemeData.dark(),
        ),
      };
    } else {
      _themes = widget.themes;
      _themes.forEach((key, value) {
        value.key = key;
      });
    }
    //
    if (widget.cupertinoThemes == null) {
      _cupertinoThemes = {
        'default': CustomCupertinoThemeData(
          key: 'default',
          name: 'Default',
          createdBy: '',
          themeData: CupertinoThemeData(),
        ),
      };
    } else {
      _cupertinoThemes = widget.cupertinoThemes;
      _cupertinoThemes.forEach((key, value) {
        value.key = key;
      });
    }
    //
    _mode = widget.themeMode;
    _currentLightThemeKey = widget.defaultLightTheme;
    _currentDarkThemeKey = widget.defaultDarkTheme;
    _currentCupertinoThemeKey = widget.defaultCupertinoTheme;
    //
    SharedPreferences.getInstance().then((prefs) {
      _sharedPrefs = prefs;
      final isDark = _sharedPrefs.getBool('${widget.prefix}-dark-mode');
      final followSystem =
          _sharedPrefs.getBool('${widget.prefix}-follow-system');
      final dLight = _sharedPrefs.getString('${widget.prefix}-default-light');
      final dDark = _sharedPrefs.getString('${widget.prefix}-default-dark');
      final dCupertino =
          _sharedPrefs.getString('${widget.prefix}-default-cupertino');
      //
      if (dCupertino != null && _cupertinoThemes.containsKey(dCupertino))
        _currentCupertinoThemeKey = dCupertino;
      if (dLight != null && _themes.containsKey(dLight))
        _currentLightThemeKey = dLight;
      if (dDark != null && _themes.containsKey(dDark))
        _currentDarkThemeKey = dDark;
      if (followSystem != null && !followSystem) setDarkMode(isDark ?? false);
      if (followSystem != null && followSystem && _mode != ThemeMode.system)
        setThemeModeToSystem(true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      debugShowCheckedModeBanner: false,
      builder: (context, int) {
        _mediaContext = context;
        return _CustomTheme(
          data: this,
          child: widget.child,
        );
      },
      color: widget.appColor ?? checkDark()
          ? darkTheme?.primaryColor
          : lightTheme?.primaryColor ?? Colors.blue,
    );
  }

  /// get [ThemeData] by [key] name of [themes]
  /// returns [null] if theme not found
  CustomThemeData _getThemeData(String key) {
    return _themes.containsKey(key) ? _themes[key] : null;
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
    final theme = _getThemeData(themeKey).themeData;
    if (theme.brightness == Brightness.dark) {
      if (both) {
        final key = themeKey.replaceAll('dark', 'light');
        if (_themes.containsKey(key)) setLightTheme(key);
      }
      setDarkTheme(themeKey, apply: apply);
      if (apply) setDarkMode(true);
    } else {
      if (both) {
        final key = themeKey.replaceAll('light', 'dark');
        if (_themes.containsKey(key)) setDarkTheme(key);
      }
      setLightTheme(themeKey, apply: apply);
      if (apply) setDarkMode(false);
    }
  }

  /// set default theme for [cupertinoTheme]
  void setCupertinoTheme(String themeKey) {
    // print(themeKey);
    setState(() {
      _currentCupertinoThemeKey = themeKey;
    });
    if (_sharedPrefs != null)
      _sharedPrefs.setString('${widget.prefix}-default-cupertino', themeKey);
  }

  /// set default theme for [lightTheme]
  void setLightTheme(String themeKey, {bool apply = false}) {
    setState(() {
      _currentLightThemeKey = themeKey;
    });
    if (_sharedPrefs != null)
      _sharedPrefs.setString('${widget.prefix}-default-light', themeKey);
  }

  /// set default theme for [darkTheme]
  void setDarkTheme(String themeKey, {bool apply = false}) {
    setState(() {
      _currentDarkThemeKey = themeKey;
    });
    if (_sharedPrefs != null)
      _sharedPrefs.setString('${widget.prefix}-default-dark', themeKey);
  }

  /// toggle between [ThemeMode.dark] and [ThemeMode.light]
  void toggleDarkMode() {
    final isDark = checkDark();
    setState(() {
      _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    });
    if (_sharedPrefs != null) {
      _sharedPrefs.setBool(
          '${widget.prefix}-dark-mode', _mode == ThemeMode.dark);
      _sharedPrefs.setBool('${widget.prefix}-follow-system', false);
    }
  }

  /// set [themeMode] to [ThemeMode.dark] or [ThemeMode.light] by passing [value]
  void setDarkMode(bool value) {
    setState(() {
      _mode = value ? ThemeMode.dark : ThemeMode.light;
    });
    if (_sharedPrefs != null) {
      _sharedPrefs.setBool('${widget.prefix}-dark-mode', value);
      _sharedPrefs.setBool('${widget.prefix}-follow-system', false);
    }
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
        final isDark = _sharedPrefs.getBool('${widget.prefix}-dark-mode');
        _mode = value
            ? ThemeMode.system
            : isDark != null && isDark ? ThemeMode.dark : ThemeMode.light;
      }
    });

    if (_sharedPrefs != null) {
      _sharedPrefs.setBool('${widget.prefix}-follow-system', value);
      if (widget.keepOnDisableFollow)
        _sharedPrefs.setBool(
            '${widget.prefix}-dark-mode', _mode == ThemeMode.dark);
    }
  }

  /// check current theme is dark or not.
  /// if [themeMode] is [ThemeMode.system] check current [ThemeMode] of [system].
  bool checkDark() {
    if (_mediaContext == null) return false;
    final Brightness systemBrightnessValue =
        MediaQuery.of(_mediaContext).platformBrightness;
    return _mode == ThemeMode.system
        ? systemBrightnessValue == Brightness.dark
        : _mode == ThemeMode.dark;
  }

  /// check if a theme is currently default or not.
  bool checkIfDefault(String key) {
    return key == _currentLightThemeKey || key == _currentDarkThemeKey;
  }

  /// check if theme is currently applied
  bool checkIfCurrent(String key) {
    return checkDark()
        ? _themes[key].key == _currentDarkThemeKey
        : _themes[key].key == _currentLightThemeKey;
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
    _themes[key] = CustomThemeData(
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
    _cupertinoThemes[key] = data;
  }

  /// reset every settings, Go back to hard coded settings.
  Future<void> resetSettings() async {
    await _sharedPrefs.remove('${widget.prefix}-dark-mode');
    await _sharedPrefs.remove('${widget.prefix}-follow-system');
    await _sharedPrefs.remove('${widget.prefix}-default-light');
    await _sharedPrefs.remove('${widget.prefix}-default-dark');
    await _sharedPrefs.remove('${widget.prefix}-default-cupertino');
    // Todo: set values to defaults

    print('All Deleted');
  }
}
