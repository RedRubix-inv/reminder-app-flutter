import 'package:flutter/material.dart';

Color getPrimaryColor(BuildContext context) {
  return Theme.of(context).colorScheme.primary;
}

Color getOnPrimaryColor(BuildContext context) {
  return Theme.of(context).colorScheme.onPrimary;
}

TextTheme getTextTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

ThemeData getThemeData(BuildContext context) {
  return Theme.of(context);
}

ColorScheme getColorScheme(BuildContext context) {
  return Theme.of(context).colorScheme;
}
