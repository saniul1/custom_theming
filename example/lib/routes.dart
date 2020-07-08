import 'package:custom_theming/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Route generate(RouteSettings settings) {
  Route page;
  switch (settings.name) {
    case "/":
      page = PageRouteBuilder(pageBuilder: (BuildContext context,
          Animation<double> animation, Animation<double> secondaryAnimation) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                // color: CustomTheme.themeOf(context).themeData.primaryColor,
              ),
              Text(
                CustomTheme.themeOf(context).name,
                textDirection: TextDirection.ltr,
              ),
              const Padding(padding: const EdgeInsets.all(10.0)),
            ]);
      }, transitionsBuilder: (_, Animation<double> animation,
          Animation<double> second, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(second),
            child: child,
          ),
        );
      });
      break;
  }
  return page;
}

Route unKnownRoute(RouteSettings settings) {
  return PageRouteBuilder(pageBuilder: (BuildContext context,
      Animation<double> animation, Animation<double> secondaryAnimation) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Unknown Page",
            textDirection: TextDirection.ltr,
          ),
          const Padding(padding: const EdgeInsets.all(10.0)),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              // color: MyColors.blue,
              child: const Text("Back"),
            ),
          )
        ]);
  });
}
