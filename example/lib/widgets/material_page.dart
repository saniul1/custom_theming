import 'package:flutter/material.dart';
import 'package:theme_manager/theme_manager.dart';

import '../models.dart';

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
                      print(ThemeManager.customDataOf<Name>(
                              context, ThemeType.material)
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
                        ? ThemeManager.themeOf(context).themeData.primaryColor
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
