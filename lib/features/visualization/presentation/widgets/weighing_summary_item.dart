import 'package:ecofier_viz/core/constants.dart';
import 'package:flutter/material.dart';

class WeighingSummaryItem extends StatelessWidget {
  const WeighingSummaryItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
          color: AppColors.grey2,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.monitor_weight),
              Text(
                "Pesées",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey3,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "1 225 Kg",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  AppIcons.openedEye,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
