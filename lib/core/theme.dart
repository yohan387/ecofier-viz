import 'package:ecofier_viz/core/constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,

          // ···
          brightness: Brightness.light,
        ),
        primaryColor: AppColors.green1,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: const AppBarTheme(
          color: AppColors.white,
          iconTheme: IconThemeData(color: AppColors.green1),
          titleTextStyle: TextStyle(
            color: AppColors.green1,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.green1,
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.grey,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.green3,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.green1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.red,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.red,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          labelStyle: const TextStyle(
            color: AppColors.grey,
          ),
          hintStyle: const TextStyle(
            color: AppColors.grey,
            fontSize: 12,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.green1;
            }
            return AppColors.transparent;
          }),
          checkColor: WidgetStateProperty.all<Color>(Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: const BorderSide(
            color: AppColors.grey,
            width: 1.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      );
}
