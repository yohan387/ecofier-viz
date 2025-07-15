import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Colors.black;
  static const Color green1 = Color(0xFF0A400A);
  static const Color green2 = Color.fromARGB(255, 17, 99, 17);
  static const Color green3 = Color.fromARGB(255, 181, 209, 181);
  static const Color green4 = Color.fromARGB(88, 211, 233, 211);
  static const Color white = Colors.white;
  static const Color grey = Color.fromARGB(255, 90, 89, 88);
  static const Color red = Color(0xFFE7140C);
  static const Color transparent = Colors.transparent;
}

class AppIcons {
  static const avatar = Icon(Icons.person, color: AppColors.green1);
  static const lock = Icon(Icons.lock, color: AppColors.green1);
  static const closedEye = Icon(Icons.visibility, color: AppColors.green1);
  static const openedEye = Icon(Icons.visibility_off, color: AppColors.green1);
  static const phone = Icon(Icons.phone, color: AppColors.green1);
}
