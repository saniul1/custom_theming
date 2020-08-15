import 'package:flutter/material.dart' show ThemeData, ThemeMode, Brightness;
import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cupertino_theme_data.dart';
import 'theme_data.dart';

export 'theme_data.dart';
export 'cupertino_theme_data.dart';

enum ThemeTypes { material, cupertino }

class _ThemeManager extends InheritedWidget {
  final ThemeManagerState data;

  _ThemeManager({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_ThemeManager oldWidget) {
    return true;
  }
}

/// Base class
// ignore: must_be_immutable
class ThemeManager extends StatefulWidget {
  final Widget child;
  final String prefix;
  final String defaultLightTheme;
  final String defaultDarkTheme;
  final String defaultCupertinoTheme;
  final ThemeMode themeMode;
  final bool keepOnDisableFollow;
  final Color appColor;
  final List<ThemeManagerData> themes;
  final List<CupertinoThemeManagerData> cupertinoThemes;

  /// [customData] needs to be carefully mapped to a existing theme key. like so -
  /// ```
  /// class Example {
  ///   final String data;
  ///   Example({this.data});
  /// }
  ///
  /// customData: {
  /// 'default': Example(data: 'your data'),
  /// 'another-existing-theme-key': Example(data: 'your data'),
  /// }
  /// ```
  Map<String, dynamic> customData = Map();

  /// [ThemeManager] is best used as parent of [MaterialApp] or [CupertinoApp] or [WidgetsApp],
  /// but you can also use it without any of these widget.
  ///
  /// Add [prefix] to separate data on different part in the app.
  ///
  /// pass [themes] using a map [Map<String, ThemeManagerData>] and use key of [map] as [themeKey]
  ///
  /// hard code some default setting for [defaultLightTheme], [defaultDarkTheme] and [themeMode]
  ///
  /// set [keepOnDisableFollow] to [true] to keep current applied theme even if [themeMode] changes from [ThemeMode.system]
  ///
  /// [cupertinoThemes] does not support [themeMode]. it always follow system setting.
  ThemeManager({
    Key key,
    this.prefix = 'app',
    this.keepOnDisableFollow = false,
    this.themeMode = ThemeMode.system,
    this.defaultLightTheme,
    this.defaultDarkTheme,
    this.defaultCupertinoTheme,
    this.themes,
    this.cupertinoThemes,
    this.customData,
    this.appColor,
    @required this.child,
  }) : super(key: key) {
    assert(
      themes == null && defaultLightTheme == null && defaultDarkTheme == null ||
          themes != null &&
              defaultLightTheme != null &&
              defaultDarkTheme != null,
      '''[themes], [defaultLightTheme] and [defaultDarkTheme] can't be null!''',
    );
    assert(
      (cupertinoThemes == null && defaultCupertinoTheme == null) ||
          (cupertinoThemes != null && defaultCupertinoTheme != null),
      '''[cupertinoThemes] and [defaultCupertinoTheme] can't be null!''',
    );
  }

  @override
  ThemeManagerState createState() => ThemeManagerState();

  static ThemeManagerState of(BuildContext context) {
    _ThemeManager inherited =
        (context.dependOnInheritedWidgetOfExactType<_ThemeManager>());
    return inherited.data;
  }

  static ThemeManagerData themeOf(BuildContext context) {
    _ThemeManager inherited =
        (context.dependOnInheritedWidgetOfExactType<_ThemeManager>());
    return inherited.data.themes[inherited.data.currentThemeKey];
  }

  static CupertinoThemeManagerData cupertinoThemeOf(BuildContext context) {
    _ThemeManager inherited =
        (context.dependOnInheritedWidgetOfExactType<_ThemeManager>());
    return inherited
        .data.cupertinoThemes[inherited.data.currentCupertinoThemeKey];
  }

  /// [customData] could be null.
  /// always check for null before using.
  /// ```
  /// ThemeManager.customDataOf<ExampleClass>(context)?.example ?? null
  /// ```
  /// to get data for current cupertino theme
  /// ```
  /// ThemeManager.customDataOf<ExampleClass>(context, true)?.example
  /// ```
  static T customDataOf<T>(BuildContext context,
      [ThemeTypes type = ThemeTypes.material]) {
    _ThemeManager inherited =
        (context.dependOnInheritedWidgetOfExactType<_ThemeManager>());
    return inherited.data.customData[type == ThemeTypes.cupertino
        ? inherited.data.currentCupertinoThemeKey
        : inherited.data.currentThemeKey] as T;
  }
}

class ThemeManagerState extends State<ThemeManager> {
  SharedPreferences _sharedPrefs;

  BuildContext _mediaContext;

  Map<String, ThemeManagerData> _themes = Map();

  Map<String, CupertinoThemeManagerData> _cupertinoThemes = Map();

  Map<String, dynamic> _customData = Map();

  String _currentLightThemeKey;

  String _currentDarkThemeKey;

  String _currentCupertinoThemeKey;

  ThemeMode _mode;

  Map<String, ThemeManagerData> get themes => _themes;

  Map<String, CupertinoThemeManagerData> get cupertinoThemes =>
      _cupertinoThemes;

  /// [key] could be absent in the map.
  /// always check for null before using.
  /// ```
  /// ThemeManager.of(context).customData[key] ?? null
  /// ```
  Map<String, dynamic> get customData => _customData;

  /// [key] could be absent in the map.
  /// always check for null before using.
  /// ```
  /// ThemeManager.of(context).customCupertinoData[key] ?? null

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

  // set default values
  setDefaults() {
    _mode = widget.themeMode;
    _currentLightThemeKey = widget.defaultLightTheme ?? 'default-light';
    _currentDarkThemeKey = widget.defaultDarkTheme ?? 'default-dark';
    _currentCupertinoThemeKey = widget.defaultCupertinoTheme ?? 'default';
  }

  // set default settings either from hard code or from system storage or server.
  @override
  void initState() {
    _customData = widget.customData ?? _customData;
    if (widget.themes == null) {
      _themes = {
        'default-light': ThemeManagerData(
          key: 'default-light',
          name: 'Default Light',
          createdBy: '',
          themeData: ThemeData.light(),
        ),
        'default-dark': ThemeManagerData(
          key: 'default-dark',
          name: 'Default Dark',
          createdBy: '',
          themeData: ThemeData.dark(),
        ),
      };
    } else {
      widget.themes.forEach((value) {
        _themes[value.key] = ThemeManagerData(
          key: value.key,
          name: value.name ?? '',
          createdBy: value.createdBy ?? '',
          themeData: value.themeData ?? ThemeData(),
        );
      });
    }
    //
    if (widget.cupertinoThemes == null) {
      _cupertinoThemes = {
        'default': CupertinoThemeManagerData(
          key: 'default',
          name: 'Default',
          createdBy: '',
          themeData: CupertinoThemeData(),
        ),
      };
    } else {
      widget.cupertinoThemes.forEach((value) {
        _cupertinoThemes[value.key] = CupertinoThemeManagerData(
          key: value.key,
          name: value.name ?? '',
          createdBy: value.createdBy ?? '',
          themeData: value.themeData ?? CupertinoThemeData(),
        );
      });
    }
    setDefaults();
    SharedPreferences.getInstance().then((prefs) {
      _sharedPrefs = prefs;
      final isDark = _sharedPrefs?.getBool('${widget.prefix}-dark-mode');
      final followSystem =
          _sharedPrefs?.getBool('${widget.prefix}-follow-system');
      final dLight = _sharedPrefs?.getString('${widget.prefix}-default-light');
      final dDark = _sharedPrefs?.getString('${widget.prefix}-default-dark');
      final dCupertino =
          _sharedPrefs?.getString('${widget.prefix}-default-cupertino');
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
      builder: (context, _) {
        _mediaContext = context;
        return _ThemeManager(
          data: this,
          child: widget.child,
        );
      },
      color: widget.appColor ?? Color(0xFF2196F3),
    );
  }

  /// get [ThemeData] by [key] name of [themes]
  /// returns [null] if theme not found
  ThemeManagerData _getThemeData(String key) {
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
  /// Note: To apply related theme correctly [themeKey] needs to be correctly configured in  [themes] data passed on to [ThemeManager].
  ///
  /// follow these kind of structure for related themes [example-light], [example-dark] or [vary_simple_light_theme], [vary_simple_dark_theme].
  /// Don't use camel cases in [themeKey] like [exampleLight], [exampleDark].
  void setTheme(String themeKey, {bool apply = false, bool both = false}) {
    final theme = _getThemeData(themeKey).themeData;
    if (theme.brightness == Brightness.dark) {
      if (both) {
        final key = themeKey.replaceAll('dark', 'light');
        if (key != themeKey && _themes.containsKey(key)) setLightTheme(key);
      }
      setDarkTheme(themeKey, apply: apply);
      if (apply) setDarkMode(true);
    } else {
      if (both) {
        final key = themeKey.replaceAll('light', 'dark');
        if (key != themeKey && _themes.containsKey(key)) setDarkTheme(key);
      }
      setLightTheme(themeKey, apply: apply);
      if (apply) setDarkMode(false);
    }
  }

  /// set default theme for [cupertinoTheme]
  void setCupertinoTheme(String themeKey) {
    setState(() {
      _currentCupertinoThemeKey = themeKey;
    });
    _sharedPrefs?.setString('${widget.prefix}-default-cupertino', themeKey);
  }

  /// set default theme for [lightTheme]
  void setLightTheme(String themeKey, {bool apply = false}) {
    setState(() {
      _currentLightThemeKey = themeKey;
    });
    _sharedPrefs?.setString('${widget.prefix}-default-light', themeKey);
  }

  /// set default theme for [darkTheme]
  void setDarkTheme(String themeKey, {bool apply = false}) {
    setState(() {
      _currentDarkThemeKey = themeKey;
    });
    _sharedPrefs?.setString('${widget.prefix}-default-dark', themeKey);
  }

  /// toggle between [ThemeMode.dark] and [ThemeMode.light]
  void toggleDarkMode() {
    setDarkMode(!checkDark());
  }

  /// set [themeMode] to [ThemeMode.dark] or [ThemeMode.light] by passing [value]
  void setDarkMode(bool value) {
    setState(() {
      _mode = value ? ThemeMode.dark : ThemeMode.light;
    });
    _sharedPrefs?.setBool('${widget.prefix}-dark-mode', value);
    _sharedPrefs?.setBool('${widget.prefix}-follow-system', false);
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
        final isDark = _sharedPrefs?.getBool('${widget.prefix}-dark-mode');
        _mode = value
            ? ThemeMode.system
            : isDark != null && isDark ? ThemeMode.dark : ThemeMode.light;
      }
    });

    _sharedPrefs?.setBool('${widget.prefix}-follow-system', value);
    if (widget.keepOnDisableFollow)
      _sharedPrefs?.setBool(
          '${widget.prefix}-dark-mode', _mode == ThemeMode.dark);
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
        ? key == _currentDarkThemeKey
        : key == _currentLightThemeKey;
  }

  /// Make sure [ThemeManager] exist in the widget tree, above of the widget where you are trying to add new themes.
  /// ```
  /// builder: (context, child) {
  ///   ...
  ///   ThemeManager.of(context).generateTheme(
  ///     key: <themeKey>,
  ///     data: <ThemeData>,
  ///   );
  ///   return child;
  /// },
  /// ```
  void generateTheme({
    @required ThemeManagerData themeData,
    dynamic customData,
  }) {
    assert(themeData != null, "[themeData] can't be null");
    _themes[themeData.key] = themeData;
    _customData[themeData.key] = customData;
  }

  /// Make sure [ThemeManager] exist in the widget tree, above of the widget where you are trying to add new themes.
  /// ```
  /// builder: (context, child) {
  ///   ...
  ///   ThemeManager.of(context).generateTheme(
  ///     key: <themeKey>,
  ///     data: <CupertinoThemeData>,
  ///   );
  ///   return child;
  /// },
  /// ```
  void generateCupertinoTheme({
    @required CupertinoThemeManagerData themeData,
    dynamic customData,
  }) {
    assert(themeData != null, "[themeData] can't be null");
    _cupertinoThemes[themeData.key] = themeData;
    _customData[themeData.key] = customData;
  }

  /// reset every settings, Go back to hard coded settings.
  Future<void> resetSettings() async {
    await _sharedPrefs?.remove('${widget.prefix}-dark-mode');
    await _sharedPrefs?.remove('${widget.prefix}-follow-system');
    await _sharedPrefs?.remove('${widget.prefix}-default-light');
    await _sharedPrefs?.remove('${widget.prefix}-default-dark');
    await _sharedPrefs?.remove('${widget.prefix}-default-cupertino');
    setDefaults();
    setState(() {});
  }
}
