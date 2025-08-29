import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/extensions.dart';
import 'package:flutter/material.dart';

class AmountDisplay extends StatelessWidget {
  final num amount;
  final bool isNegative;
  final double textSize;
  final Color? color;
  final FontWeight? fontWeight;
  final bool displayAddSign;

  const AmountDisplay({
    super.key,
    required this.amount,
    this.isNegative = false,
    this.textSize = 14,
    this.color,
    this.fontWeight,
    this.displayAddSign = false,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedAmount = amount.ceilToDouble().formatAsAmount();
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: color ?? AppColors.green1,
            fontWeight: fontWeight ?? FontWeight.bold,
            fontSize: textSize,
          ),
          children: [
            isNegative
                ? const TextSpan(text: '- ')
                : displayAddSign
                    ? const TextSpan(text: '+ ')
                    : const TextSpan(text: ''),
            TextSpan(text: formattedAmount),
            const TextSpan(text: ' F'),
            TextSpan(
              text: ' Cfa',
              style: TextStyle(
                fontSize: textSize * 0.6,
                color: color ?? AppColors.green1,
                fontWeight: fontWeight ?? FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
