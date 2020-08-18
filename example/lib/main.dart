import 'dart:math';
import 'package:theme_manager/theme_manager.dart';
import 'package:example/themes.dart';
import 'package:flutter/material.dart' hide Radio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'models.dart';
import 'widgets/check_box.dart';
import 'widgets/cupertino_page.dart';
import 'widgets/material_page.dart';
import 'widgets/radio.dart';
import 'widgets/theme_selector.dart';

void main() {
  runApp(
    ThemeManager(
      defaultLightTheme: 'default-light',
      defaultDarkTheme: 'default-dark',
      defaultCupertinoTheme: 'default',
      themeMode: ThemeMode.system,
      themes: MyThemes.themes,
      cupertinoThemes: MyThemes.cupertinoThemes,
      customData: MyThemes.customData,
      keepOnDisableFollow: false,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isCupertino = false;
  bool onlyWidgetApp = false;
  bool noAppWidget = false;
  bool isMultiTheme = false;

  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 1), () {
    //   ThemeManager.of(context).resetSettings();
    // });
    return Stack(
      children: [
        if (noAppWidget && onlyWidgetApp) NoAppWidget(),
        if (onlyWidgetApp && !noAppWidget) WidgetApp(),
        if (isMultiTheme && !isCupertino && !onlyWidgetApp) MultiMaterialApp(),
        if (isMultiTheme && isCupertino && !onlyWidgetApp) MultiCupertinoApp(),
        if (isCupertino && !isMultiTheme && !onlyWidgetApp) TestCupertinoApp(),
        if (!isCupertino && !isMultiTheme && !onlyWidgetApp) TestMaterialApp(),
        if (_showMore)
          GestureDetector(
            onTap: () {
              setState(() {
                _showMore = false;
              });
            },
            child: Container(
              color: Colors.black12,
            ),
          ),
        Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showMore = !_showMore;
              });
            },
            child: ThemeManager(
              customData: ThemeSelectorThemes.themeData,
              child: Builder(builder: (context) {
                return Container(
                  constraints: BoxConstraints(
                    maxHeight: 300,
                    maxWidth: 300,
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 50),
                    margin: const EdgeInsets.all(8.0),
                    width: _showMore ? null : 40,
                    height: _showMore ? null : 40,
                    decoration: BoxDecoration(
                      color: ThemeManager.customDataOf<ThemeSelectorThemes>(
                                  context)
                              ?.color ??
                          Colors.amber,
                      shape: _showMore ? BoxShape.rectangle : BoxShape.circle,
                    ),
                    child: _showMore
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CheckBox(
                                      active: isMultiTheme,
                                      label: 'Multiple Apps',
                                      onTap: () {
                                        setState(() {
                                          isMultiTheme = !isMultiTheme;
                                        });
                                      },
                                    ),
                                    CheckBox(
                                      active: noAppWidget,
                                      label: 'No Parent App',
                                      onTap: () {
                                        setState(() {
                                          noAppWidget = !noAppWidget;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Radio(
                                      active: !isCupertino && !onlyWidgetApp,
                                      label: 'Show Material App',
                                      onTap: () {
                                        setState(() {
                                          isCupertino = false;
                                          onlyWidgetApp = false;
                                        });
                                      },
                                    ),
                                    Radio(
                                      active: isCupertino && !onlyWidgetApp,
                                      label: 'Show Cupertino App',
                                      onTap: () {
                                        setState(() {
                                          isCupertino = true;
                                          onlyWidgetApp = false;
                                        });
                                      },
                                    ),
                                    Radio(
                                      active: onlyWidgetApp,
                                      label: 'Show Widgets App Only',
                                      onTap: () {
                                        setState(() {
                                          onlyWidgetApp = true;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Row(
                                      children: ThemeManager.of(context)
                                          .customDataMap
                                          .entries
                                          .map((entries) {
                                        final data = entries.value.data
                                            as ThemeSelectorThemes;
                                        return ThemeSelector(
                                          color: data.color,
                                          themeKey: entries.key,
                                          active: entries.key ==
                                              ThemeManager.of(context)
                                                  .currentCustomDataKey,
                                        );
                                      }).toList(),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                        ),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Icon(Icons.more_horiz),
                  ),
                );
              }),
            ),
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
      theme: ThemeManager.of(context).lightTheme,
      darkTheme: ThemeManager.of(context).darkTheme,
      themeMode: ThemeManager.of(context).themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
              "${ThemeManager.of(context).currentThemeKey} / ${ThemeManager.of(context).themes.length}" ??
                  ''),
          leading: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => ThemeManager.of(context).setTheme(
              ThemeManager.of(context).themes.keys.toList()[Random().nextInt(
                ThemeManager.of(context).themes.keys.toList().length,
              )],
              apply: true,
            ),
          ),
        ),
        body: ThemeManager(
          prefix: '2nd',
          defaultLightTheme: 'default-light',
          defaultDarkTheme: 'default-dark',
          themeMode: ThemeMode.light,
          themes: MyThemes.themes,
          customData: MyThemes.customData,
          keepOnDisableFollow: false,
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
      theme: ThemeManager.of(context).cupertinoTheme,
      home: CupertinoPageScaffold(
        child: Stack(
          children: [
            ThemeManager(
              prefix: '2nd',
              defaultCupertinoTheme: 'default',
              cupertinoThemes: MyThemes.cupertinoThemes,
              customData: MyThemes.customData,
              keepOnDisableFollow: false,
              child: TestCupertinoApp(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: ThemeManager.cupertinoThemeOf(context)
                      .themeData
                      .primaryColor,
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
                            .themeData
                            .primaryContrastingColor,
                      ),
                      onPressed: () =>
                          ThemeManager.of(context).setCupertinoTheme(
                        ThemeManager.of(context)
                            .cupertinoThemes
                            .keys
                            .toList()[Random().nextInt(
                          ThemeManager.of(context)
                              .cupertinoThemes
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
                              .themeData
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
    return WidgetsApp(
      title: 'Theming',
      builder: (context, int) {
        return Container(
          color: ThemeManager.themeOf(context).themeData.canvasColor,
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
    return Container(
      color: ThemeManager.themeOf(context).themeData.canvasColor,
      child: Center(
        child: Column(children: [
          Container(
            color: ThemeManager.themeOf(context).themeData.primaryColor,
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
          ...ThemeManager.of(context).themes.keys.map((themeKey) {
            return RaisedButton(
              color: ThemeManager.of(context)
                  .themes[themeKey]
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
                      ThemeManager.of(context).themes[themeKey].name,
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
              ThemeManager.customDataOf<Name>(context)?.name ?? 'Nothing!',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ThemeManager.customDataOf<Name>(context)?.no?.toString() ??
                  'Nothing!!',
            ),
          )
        ]),
      ),
    );
  }
}
