import 'package:flutter/material.dart';

String? phoneNumberValidator(p0) {
  if (p0 == null || p0.isEmpty) {
    return 'Le numéro de téléphone est requis';
  }

  if (p0.length != 10) {
    return '10 chiffres max';
  }
  return null;
}

class ScreenUtil {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
}
