import 'package:flutter/cupertino.dart';
import 'package:theme_manager/theme_manager.dart';

import '../models.dart';

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
                                : Color(0xFF2196F3),
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
