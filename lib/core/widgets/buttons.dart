import 'package:ecofier_viz/core/constants.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Widget icon;
  final double? width;
  final VoidCallback? onTap;

  const AppButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 54,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.green1,
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [AppColors.green1, AppColors.green2],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            icon
          ],
        ),
      ),
    );
  }
}
