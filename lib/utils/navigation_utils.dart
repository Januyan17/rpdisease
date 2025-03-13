import 'package:flutter/material.dart';

void grabFocus(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

void focusNext(BuildContext context) {
  try {
    FocusScope.of(context).nextFocus();
  } catch (e) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

bool canPop(BuildContext context) => Navigator.of(context).canPop();

void popScreen(BuildContext context, {result}) {
  // _navigateBack();
  Navigator.of(context).pop(result);
}

Future pushScreen(BuildContext context, String route,
    {Object? arguments}) async {
  return await Navigator.of(context).pushNamed(
    route,
    arguments: arguments,
  );
}

Future pushReplacementScreen(BuildContext context, String route,
    {Object? arguments}) async {
  return await Navigator.of(context).pushReplacementNamed(
    route,
    arguments: arguments,
  );
}

void moveToScreen(BuildContext context, String route, {Object? arguments}) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    route,
    (route) => false,
    arguments: arguments,
  );
}

void popUntilScreen(BuildContext context, String routeName) {
  // _navigateBack(route: routeName);
  Navigator.of(context).popUntil((route) {
    return route.settings.name == routeName;
  });
}

void pushAndPopuntilScreen(
    BuildContext context, String pushName, String popUntilName,
    {Object? arguments}) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    pushName,
    (route) => route.settings.name == popUntilName,
    arguments: arguments,
  );
}
