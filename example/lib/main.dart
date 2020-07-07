import 'package:custom_theming/custom_theme.dart';
import 'package:example/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(
    CustomTheme(
      defaultLightTheme: 'default-light',
      defaultDarkTheme: 'default-dark',
      defaultCupertinoTheme: 'default',
      themeMode: ThemeMode.dark,
      themes: MyThemes.themes,
      cupertinoThemes: {
        'default': CustomCupertinoThemeData(
            name: 'Default',
            createdBy: 'Dev',
            themeData:
                CupertinoThemeData().copyWith(primaryColor: Colors.amber)),
        'green': CustomCupertinoThemeData(
            name: 'Green',
            createdBy: 'Dev',
            themeData:
                CupertinoThemeData().copyWith(primaryColor: Colors.green)),
        'red': CustomCupertinoThemeData(
            name: 'Red',
            createdBy: 'Dev',
            themeData: CupertinoThemeData().copyWith(primaryColor: Colors.red)),
      },
      keepOnDisableFollow: false,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final isCupertino = false;
  @override
  Widget build(BuildContext context) {
    // final CustomData a = MyThemes.data['key'][theme.CUSTOM];
    // print(a.text);
    if (isCupertino)
      return CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.of(context).cupertinoTheme,
        initialRoute: "/",
        title: 'Theming',
        color: Theme.of(context).primaryColor,
        home: CupertinoStoreHomePage(),
        builder: (context, child) {
          CustomTheme.of(context).setMediaContext(context);
          CustomTheme.of(context).generateCupertinoTheme(
            key: 'generated',
            data: CustomCupertinoThemeData(
                name: 'Generated on Build',
                createdBy: 'Dev',
                themeData: CupertinoThemeData().copyWith(
                  primaryColor: Colors.purple,
                )),
          );
          return child;
        },
      );
    else
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.of(context).lightTheme,
        darkTheme: CustomTheme.of(context).darkTheme,
        themeMode: CustomTheme.of(context).themeMode,
        initialRoute: "/",
        title: 'Theming',
        color: Theme.of(context).primaryColor,
        home: MyHomePage(title: 'Flutter Demo Home Page'),
        builder: (context, child) {
          // print('app build context');
          CustomTheme.of(context).setMediaContext(context);
          CustomTheme.of(context).generateTheme(
            key: 'generated-theme',
            name: 'Generated Theme',
            createdBy: '',
            data: ThemeData.dark().copyWith(),
          );
          return child;
        },
      );
  }
}

class CupertinoStoreHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 1), () {
    //   CustomTheme.of(context).resetSettings();
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
                  children: CustomTheme.of(context)
                      .cupertinoThemes
                      .keys
                      .map((themeKey) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100.0,
                        vertical: 5,
                      ),
                      child: CupertinoButton(
                        onPressed: () =>
                            CustomTheme.of(context).setCupertinoTheme(themeKey),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                CustomTheme.of(context)
                                    .cupertinoThemes[themeKey]
                                    .name,
                              ),
                            ),
                          ],
                        ),
                        color:
                            CustomTheme.of(context).currentCupertinoThemeKey ==
                                    themeKey
                                ? Colors.green
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
                child: SizedBox(),
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Switch(
                value: CustomTheme.of(context).checkDark(),
                onChanged: CustomTheme.of(context).toggleDarkMode,
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: CustomTheme.of(context).themeMode == ThemeMode.system,
                  onChanged: CustomTheme.of(context).setThemeModeToSystem,
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
              children: CustomTheme.of(context).themes.keys.map((themeKey) {
                return RaisedButton(
                  onPressed: () => CustomTheme.of(context)
                      .setTheme(themeKey, both: true, apply: true),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (CustomTheme.of(context).checkIfDefault(themeKey))
                        Icon(
                          Icons.star,
                          size: 14,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          CustomTheme.of(context).themes[themeKey].name,
                        ),
                      ),
                    ],
                  ),
                  color: CustomTheme.of(context).checkIfCurrent(themeKey)
                      ? Colors.green
                      : Colors.blue,
                );
              }).toList(),
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
