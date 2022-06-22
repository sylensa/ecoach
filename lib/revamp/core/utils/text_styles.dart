import 'package:flutter/material.dart';

class TextStyles {
  /// predefined text styles

  static TextStyle display4(BuildContext context) {
    return Theme.of(context).textTheme.headline1!.copyWith();
  }

  static TextStyle display3(BuildContext context) {
    return Theme.of(context).textTheme.headline2!.copyWith();
  }

  static TextStyle display2(BuildContext context) {
    return Theme.of(context).textTheme.headline3!.copyWith();
  }

  static TextStyle display1(BuildContext context) {
    return Theme.of(context).textTheme.headline4!.copyWith();
  }

  static TextStyle headline(BuildContext context) {
    return Theme.of(context).textTheme.headline5!.copyWith();
  }

  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.headline6!.copyWith();
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: 18,
        );
  }

  static TextStyle subhead(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1!.copyWith();
  }

  static TextStyle body2(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith();
  }

  static TextStyle body1(BuildContext context) {
    return Theme.of(context).textTheme.bodyText2!.copyWith();
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.caption!.copyWith();
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.button!.copyWith();
  }

  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle2!.copyWith();
  }

  static TextStyle overline(BuildContext context) {
    return Theme.of(context).textTheme.overline!.copyWith();
  }
}
