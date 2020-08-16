import 'dart:math';
import 'package:theme_manager/theme_manager.dart';
import 'package:example/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

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
  bool noAppWidget = false;

  bool onlyWidgetApp = false;

  bool isMultiTheme = true;

  bool isCupertino = false;

  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 1), () {
    //   ThemeManager.of(context).resetSettings();
    // });
    if (true)
      return Stack(
        children: [
          if (noAppWidget && onlyWidgetApp) NoAppWidget(),
          if (onlyWidgetApp && !noAppWidget) WidgetApp(),
          if (isMultiTheme && !isCupertino && !onlyWidgetApp)
            MultiMaterialApp(),
          if (isMultiTheme && isCupertino && !onlyWidgetApp)
            MultiCupertinoApp(),
          if (isCupertino && !isMultiTheme && !onlyWidgetApp) TestCupertino(),
          if (!isCupertino && !isMultiTheme && !onlyWidgetApp) TestMaterial(),
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
              child: Container(
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
                    color: Colors.amber,
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
                                    label: 'Show Widget App',
                                    onTap: () {
                                      setState(() {
                                        onlyWidgetApp = true;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                height: 2,
                              ),
                            ],
                          ),
                        )
                      : Icon(Icons.more_horiz),
                ),
              ),
            ),
          ),
        ],
      );
  }
}

class CheckBox extends StatelessWidget {
  const CheckBox({
    Key key,
    this.active = false,
    this.label = '',
    this.onTap,
  }) : super(key: key);

  final bool active;
  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black12,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Container(
              height: 30,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  if (active)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
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
      // localizationsDelegates: <LocalizationsDelegate<dynamic>>[
      //   DefaultMaterialLocalizations.delegate,
      //   // DefaultWidgetsLocalizations.delegate,
      //   // DefaultCupertinoLocalizations.delegate,
      // ],
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
              child: TestCupertino(),
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
                        "${ThemeManager.customDataOf<Name>(context, ThemeTypes.cupertino)?.no ?? -1}/${ThemeManager.of(context).cupertinoThemes.length.toString()}",
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
          child: TestMaterial(),
        ),
      ),
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
      // color: ThemeManager.themeOf(context).themeData.primaryColor,
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

class Radio extends StatelessWidget {
  const Radio({
    Key key,
    this.active = false,
    this.label = '',
    this.onTap,
  }) : super(key: key);

  final bool active;

  final String label;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2.0),
        color: Colors.black12,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                ),
                child: active
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TestMaterial extends StatelessWidget {
  const TestMaterial({
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
          themeData: ThemeManagerData(
            key: 'generated-theme',
            name: 'Generated Theme',
            createdBy: '',
            themeData: ThemeData.dark().copyWith(),
          ),
        );
        return child;
      },
    );
  }
}

class TestCupertino extends StatelessWidget {
  const TestCupertino({
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
          themeData: CupertinoThemeManagerData(
            key: 'generated',
            name: 'Generated on Build',
            createdBy: 'Dev',
            themeData: CupertinoThemeData().copyWith(
              primaryColor: Colors.purple,
            ),
          ),
          customData: Name(
            name: 'Generated',
            description: "This is a test",
            no: 4,
          ),
        );
        final Name name = ThemeManager.of(context)
            .customData[ThemeManager.of(context).currentCupertinoThemeKey];
        print(name?.description);
        return child;
      },
    );
  }
}

class CupertinoStoreHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 1), () {
    //   ThemeManager.of(context).resetSettings();
    // });

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text('Products'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart),
            title: Text('Cart'),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ThemeManager.of(context)
                      .cupertinoThemes
                      .keys
                      .map((themeKey) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100.0,
                        vertical: 5,
                      ),
                      child: CupertinoButton(
                        onPressed: () => ThemeManager.of(context)
                            .setCupertinoTheme(themeKey),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ThemeManager.of(context)
                                    .cupertinoThemes[themeKey]
                                    .name,
                              ),
                            ),
                          ],
                        ),
                        color:
                            ThemeManager.of(context).currentCupertinoThemeKey ==
                                    themeKey
                                ? CupertinoTheme.of(context).primaryColor
                                : Colors.blue,
                      ),
                    );
                  }).toList(),
                ),
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          ThemeManager.customDataOf<Name>(
                                      context, ThemeTypes.cupertino)
                                  ?.name ??
                              '',
                        ),
                        Text(
                          ThemeManager.customDataOf<Name>(
                                      context, ThemeTypes.cupertino)
                                  ?.description ??
                              '...',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: SizedBox(),
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          RaisedButton(
            onPressed: ThemeManager.of(context).resetSettings,
            child: Text('Delete'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Switch(
                value: ThemeManager.of(context).checkDark(),
                onChanged: (_) => ThemeManager.of(context).toggleDarkMode(),
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: ThemeManager.of(context).themeMode == ThemeMode.system,
                  onChanged: ThemeManager.of(context).setThemeModeToSystem,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  'Follow system setting',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            Column(
              children: [
                ...ThemeManager.of(context).themes.keys.map((themeKey) {
                  return RaisedButton(
                    onPressed: () {
                      ThemeManager.of(context)
                          .setTheme(themeKey, both: true, apply: true);
                      print(ThemeManager.customDataOf<Name>(context)
                          ?.description);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (ThemeManager.of(context).checkIfDefault(themeKey))
                          Icon(
                            Icons.star,
                            size: 14,
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ThemeManager.of(context).themes[themeKey].name,
                          ),
                        ),
                      ],
                    ),
                    color: ThemeManager.of(context).checkIfCurrent(themeKey)
                        ? Colors.green
                        : Colors.blue,
                  );
                }).toList(),
              ],
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
