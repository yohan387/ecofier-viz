import 'package:flutter/material.dart';

enum ApiMethod { get, post, put, delete, unknown }

const String apiBaseUrl = "http://192.168.88.15:8000";

class AppColors {
  static const Color black = Colors.black;
  static const Color green1 = Color(0xFF0A400A);
  static const Color green2 = Color.fromARGB(255, 17, 99, 17);
  static const Color green3 = Color.fromARGB(255, 181, 209, 181);
  static const Color green4 = Color.fromARGB(88, 211, 233, 211);
  static const Color white = Colors.white;
  static const Color grey = Color.fromARGB(255, 90, 89, 88);
  static const Color grey2 = Color(0xFFF6F8FE);
  static const Color grey3 = Color(0xFFDDE1EF);
  static const Color grey4 = Color(0xFFF1F3FA);
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

class AppErrorStatusCode {
  static const int api = 1000;
  static const int localStorage = 2000;
  static const int network = 3000;
  static const int internal = 4000;
  static const int socket = 6000;
  static const int invalideToken = 6000;
}

/// Types de Failure possibles
enum FailureType {
  api,
  localStorage,
  internal,
  network,
}

enum AppExceptionType {
  api,
  localStorage,
  network,
  internal,
}

const filtersOptionList = [
  {
    "id": "1",
    "code": "D'aujourd'hui",
  },
  {
    "id": "2",
    "code": "De la semaine",
  },
  {
    "id": "3",
    "code": "Du mois",
  },
  {
    "id": "4",
    "code": "Autre",
  },
];
