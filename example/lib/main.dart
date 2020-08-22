import 'dart:math';
import 'package:example/util.dart/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_manager/theme_manager.dart';
import 'package:example/themes.dart';
import 'package:flutter/material.dart' hide Radio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'models.dart';
import 'widgets/app_settings.dart';
import 'widgets/cupertino_page.dart';
import 'widgets/material_page.dart';

void main() {
  runApp(
    ReloadChildWidget(
      // sets [ThemeManager] for the whole app
      child: ThemeManager(
        defaultLightTheme: 'default-light',
        defaultDarkTheme: 'default-dark',
        defaultCupertinoTheme: 'default',
        themeMode: ThemeMode.system,
        themes: MyThemes.themes,
        cupertinoThemes: MyThemes.cupertinoThemes,
        // yu can pass any kind of data, even your own theme data.
        customData: MyThemes.customData,
        keepSettingOnDisableFollow: true,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  SharedPreferences _sharedPrefs;

  bool isCupertino = false;
  bool onlyWidgetApp = false;
  bool noAppWidget = false;
  bool isMultiTheme = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _sharedPrefs = prefs;
      setState(() {
        isCupertino = _sharedPrefs?.getBool('is-cupertino') ?? isCupertino;
        onlyWidgetApp =
            _sharedPrefs?.getBool('only-widget-app') ?? onlyWidgetApp;
        noAppWidget = _sharedPrefs?.getBool('no-app-widget') ?? noAppWidget;
        isMultiTheme = _sharedPrefs?.getBool('is-multi-theme') ?? isMultiTheme;
      });
    });
  }

  // only for debug example app
  setApp({bool isMulti, bool isCuper, bool isOnly, bool noApp}) {
    setState(() {
      isCupertino = isCuper ?? isCupertino;
      onlyWidgetApp = isOnly ?? onlyWidgetApp;
      isMultiTheme = isMulti ?? isMultiTheme;
      noAppWidget = noApp ?? noAppWidget;
    });
    _sharedPrefs?.setBool('is-cupertino', isCupertino);
    _sharedPrefs?.setBool('only-widget-app', onlyWidgetApp);
    _sharedPrefs?.setBool('is-multi-theme', isMultiTheme);
    _sharedPrefs?.setBool('no-app-widget', noAppWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (noAppWidget && onlyWidgetApp) NoAppWidget(),
        if (onlyWidgetApp && !noAppWidget) WidgetApp(),
        if (isMultiTheme && !isCupertino && !onlyWidgetApp) MultiMaterialApp(),
        if (isMultiTheme && isCupertino && !onlyWidgetApp) MultiCupertinoApp(),
        if (isCupertino && !isMultiTheme && !onlyWidgetApp) TestCupertinoApp(),
        if (!isCupertino && !isMultiTheme && !onlyWidgetApp) TestMaterialApp(),
        Align(
          alignment: Alignment.bottomRight,
          child: AppSettings(
            isMultiTheme: isMultiTheme,
            noAppWidget: noAppWidget,
            isCupertino: isCupertino,
            onlyWidgetApp: onlyWidgetApp,
            setApp: setApp,
          ),
        ),
      ],
    );
  }
}

class MultiMaterialApp extends StatelessWidget {
  const MultiMaterialApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // pass [ThemeManger] data to effect material app across app
      theme: ThemeManager.of(context).lightTheme,
      darkTheme: ThemeManager.of(context).darkTheme,
      themeMode: ThemeManager.of(context).themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
              "${ThemeManager.of(context).currentThemeKey} / ${ThemeManager.of(context).themesMap.length}" ??
                  ''),
          leading: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => ThemeManager.of(context).setTheme(
              ThemeManager.of(context).themesMap.keys.toList()[Random().nextInt(
                ThemeManager.of(context).themesMap.keys.toList().length,
              )],
              apply: true,
            ),
          ),
        ),
        body: ThemeManager(
          id: '2nd',
          defaultLightTheme: 'default-light',
          defaultDarkTheme: 'default-dark',
          themeMode: ThemeMode.light,
          themes: MyThemes.themes,
          customData: MyThemes.customData,
          keepSettingOnDisableFollow: false,
          child: TestMaterialApp(),
        ),
      ),
    );
  }
}

class TestMaterialApp extends StatelessWidget {
  const TestMaterialApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeManager.of(context).lightTheme,
      darkTheme: ThemeManager.of(context).darkTheme,
      themeMode: ThemeManager.of(context).themeMode,
      initialRoute: "/",
      title: 'Theming',
      color: Theme.of(context).primaryColor,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (context, child) {
        // Add additional theme after app initialization (even after app is build)
        ThemeManager.of(context).generateTheme(
          ThemeManagerData(
            key: 'generated-theme',
            name: 'Generated Theme',
            creator: '',
            themeData: ThemeData.dark().copyWith(),
          ),
        );
        return child;
      },
    );
  }
}

class MultiCupertinoApp extends StatelessWidget {
  const MultiCupertinoApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // theme for [CupertinoApp]
      theme: ThemeManager.of(context).cupertinoTheme,
      home: CupertinoPageScaffold(
        child: Stack(
          children: [
            ThemeManager(
              // set [id] to differentiate data in storage
              id: '2nd',
              defaultCupertinoTheme: 'default',
              cupertinoThemes: MyThemes.cupertinoThemes,
              customData: MyThemes.customData,
              keepSettingOnDisableFollow: false,
              child: TestCupertinoApp(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: ThemeManager.cupertinoThemeOf(context).primaryColor,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${ThemeManager.customDataOf<Name>(context, ThemeType.cupertino)?.no ?? -1}",
                      ),
                    ),
                    CupertinoButton(
                      child: Icon(
                        Icons.refresh,
                        color: ThemeManager.cupertinoThemeOf(context)
                            .primaryContrastingColor,
                      ),
                      onPressed: () =>
                          ThemeManager.of(context).setCupertinoTheme(
                        ThemeManager.of(context)
                            .cupertinoThemesMap
                            .keys
                            .toList()[Random().nextInt(
                          ThemeManager.of(context)
                              .cupertinoThemesMap
                              .keys
                              .toList()
                              .length,
                        )],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ThemeManager.of(context).currentCupertinoThemeKey,
                        style: TextStyle(
                          color: ThemeManager.cupertinoThemeOf(context)
                              .primaryContrastingColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TestCupertinoApp extends StatelessWidget {
  const TestCupertinoApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeManager.of(context).cupertinoTheme,
      initialRoute: "/",
      title: 'Theming',
      color: Theme.of(context).primaryColor,
      home: CupertinoStoreHomePage(),
      builder: (context, child) {
        ThemeManager.of(context).generateCupertinoTheme(
          CupertinoThemeManagerData(
            key: 'generated',
            name: 'Generated on Build',
            creator: 'Dev',
            themeData: CupertinoThemeData().copyWith(
              primaryColor: Colors.purple,
            ),
          ),
        );
        ThemeManager.of(context).addToCustomData(
          CustomThemeManagerData(
            key: 'generated',
            data: Name(
              name: 'Generated',
              description: "This is a test",
              no: 4,
            ),
          ),
        );
        //! getting data this way is possible too
        final Name name = ThemeManager.of(context)
            .customDataMap[ThemeManager.of(context).currentCupertinoThemeKey]
            ?.data;
        print(name?.description);
        return child;
      },
    );
  }
}

class WidgetApp extends StatelessWidget {
  const WidgetApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tou can use only [WidgetsApp] to build your app and [ThemeManager] to access [themeData]
    return WidgetsApp(
      title: 'Theming',
      builder: (context, int) {
        return Container(
          color: ThemeManager.themeOf(context).canvasColor,
          child: Center(
            child: RaisedButton(
              onPressed: ThemeManager.of(context).toggleDarkMode,
              child: Text(
                'Hello, world!',
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        );
      },
      color: Colors.red,
    );
  }
}

class NoAppWidget extends StatelessWidget {
  const NoAppWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You don't even need any app widget, because [ThemeManger] itself is one.
    return Container(
      color: ThemeManager.themeOf(context).canvasColor,
      child: Center(
        child: Column(children: [
          Container(
            color: ThemeManager.themeOf(context).primaryColor,
            height: 100,
            child: Center(
              child: RaisedButton(
                onPressed: ThemeManager.of(context).toggleDarkMode,
                child: Text(
                  'Toggle',
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          ),
          ...ThemeManager.of(context).themesMap.keys.map((themeKey) {
            return RaisedButton(
              color: ThemeManager.of(context)
                  .themesMap[themeKey]
                  .themeData
                  .primaryColor,
              onPressed: () => ThemeManager.of(context)
                  .setTheme(themeKey, apply: true, both: false),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (ThemeManager.of(context).checkIfDefault(themeKey))
                    Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.yellow,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ThemeManager.of(context).themesMap[themeKey].name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  if (ThemeManager.of(context).checkIfCurrent(themeKey))
                    Icon(
                      Icons.done_outline,
                      size: 14,
                      color: Colors.amber,
                    ),
                ],
              ),
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ThemeManager.customDataOf<Name>(context, ThemeType.material)
                      ?.name ??
                  'Nothing!',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ThemeManager.customDataOf<Name>(context, ThemeType.material)
                      ?.no
                      ?.toString() ??
                  'Nothing!!',
            ),
          )
        ]),
      ),
    );
  }
}
