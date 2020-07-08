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
    this.prefix = 'app',
    this.defaultLightTheme = 'default-light',
    this.defaultDarkTheme = 'default-dark',
    this.defaultCupertinoTheme = 'default',
    this.themeMode = ThemeMode.system,
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
    if (widget.themes == null) {
      widget.themes = {
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
    }
    widget.themes.forEach((key, value) {
      value.key = key;
    });
    //
    if (widget.cupertinoThemes == null) {
      widget.cupertinoThemes = {
        'default': CustomCupertinoThemeData(
          key: 'default',
          name: 'Default',
          createdBy: '',
          themeData: CupertinoThemeData(),
        ),
      };
    }
    widget.cupertinoThemes.forEach((key, value) {
      value.key = key;
    });
    //
    _mode = widget.themeMode;
    setCupertinoTheme(widget.defaultCupertinoTheme);
    // TODO: listen to System [ThemeMode] to change theme accordingly.
    setTheme(
      _mode == ThemeMode.dark
          ? widget.defaultDarkTheme
          : widget.defaultLightTheme,
      both: true,
      apply: true,
    );
    //
    SharedPreferences.getInstance().then((prefs) {
      sharedPrefs = prefs;
      final isDark = sharedPrefs.getBool('${widget.prefix}-dark-mode');
      final followSystem =
          sharedPrefs.getBool('${widget.prefix}-follow-system');
      final dLight = sharedPrefs.getString('${widget.prefix}-default-light');
      final dDark = sharedPrefs.getString('${widget.prefix}-default-dark');
      final dCupertino =
          sharedPrefs.getString('${widget.prefix}-default-cupertino');
      //
      if (dCupertino != null &&
          widget.cupertinoThemes.containsKey(dCupertino)) {
        setCupertinoTheme(dCupertino);
      }
      if (dLight != null && widget.themes.containsKey(dLight))
        setLightTheme(dLight);
      if (dDark != null && widget.themes.containsKey(dDark))
        setDarkTheme(dDark);
      if (followSystem != null && !followSystem) setDarkMode(isDark ?? false);
      if (followSystem != null && followSystem) {
        setThemeModeToSystem(true);
      }
    });

    super.initState();
  }

  /// get [ThemeData] by [key] name of [themes]
  /// returns [null] if theme not found
  CustomThemeData _getThemeData(String key) {
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
    final theme = _getThemeData(themeKey).themeData;
    if (theme.brightness == Brightness.dark) {
      if (both) {
        final key = themeKey.replaceAll('dark', 'light');
        if (widget.themes.containsKey(key)) setLightTheme(key);
      }
      setDarkTheme(themeKey, apply: apply);
      if (apply) setDarkMode(true);
    } else {
      if (both) {
        final key = themeKey.replaceAll('light', 'dark');
        if (widget.themes.containsKey(key)) setDarkTheme(key);
      }
      setLightTheme(themeKey, apply: apply);
      if (apply) setDarkMode(false);
    }
  }

  /// set default theme for [cupertinoTheme]
  void setCupertinoTheme(String themeKey) {
    // print(themeKey);
    setState(() {
      _cupertinoTheme = _getCupertinoThemeData(themeKey);
      _currentCupertinoThemeKey = themeKey;
    });
    if (sharedPrefs != null)
      sharedPrefs.setString('${widget.prefix}-default-cupertino', themeKey);
  }

  /// set default theme for [lightTheme]
  void setLightTheme(String themeKey, {bool apply = false}) {
    setState(() {
      _light = _getThemeData(themeKey);
      if (apply) _currentThemeKey = themeKey;
    });
    if (sharedPrefs != null)
      sharedPrefs.setString('${widget.prefix}-default-light', themeKey);
  }

  /// set default theme for [darkTheme]
  void setDarkTheme(String themeKey, {bool apply = false}) {
    setState(() {
      _dark = _getThemeData(themeKey);
      if (apply) _currentThemeKey = themeKey;
    });
    if (sharedPrefs != null)
      sharedPrefs.setString('${widget.prefix}-default-dark', themeKey);
  }

  /// toggle between [ThemeMode.dark] and [ThemeMode.light]
  void toggleDarkMode() {
    final isDark = checkDark();
    setState(() {
      _mode = isDark ? ThemeMode.light : ThemeMode.dark;
      _currentThemeKey = isDark ? _dark.key : _light.key;
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
      _currentThemeKey = value ? _dark.key : _light.key;
    });
    if (sharedPrefs != null) {
      sharedPrefs.setBool('${widget.prefix}-dark-mode', value);
      sharedPrefs.setBool('${widget.prefix}-follow-system', false);
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
        final isDark = sharedPrefs.getBool('${widget.prefix}-dark-mode');
        _mode = value
            ? ThemeMode.system
            : isDark != null && isDark ? ThemeMode.dark : ThemeMode.light;
      }
      _currentThemeKey = checkDark() ? _dark.key : _light.key;
    });

    if (sharedPrefs != null) {
      sharedPrefs.setBool('${widget.prefix}-follow-system', value);
      if (widget.keepOnDisableFollow)
        sharedPrefs.setBool(
            '${widget.prefix}-dark-mode', _mode == ThemeMode.dark);
    }
  }

  /// check current theme is dark or not.
  /// if [themeMode] is [ThemeMode.system] check current [ThemeMode] of [system].
  bool checkDark() {
    final Brightness systemBrightnessValue =
        MediaQuery.of(_mediaContext).platformBrightness;
    return _mode == ThemeMode.system
        ? systemBrightnessValue == Brightness.dark
        : _mode == ThemeMode.dark;
  }

  /// check if a theme is currently default or not.
  bool checkIfDefault(String key) {
    return key == _light.key || key == _dark.key;
  }

  /// check if theme is currently applied
  bool checkIfCurrent(String key) {
    return checkDark()
        ? widget.themes[key].key == _dark.key
        : widget.themes[key].key == _light.key;
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
