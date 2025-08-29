import 'package:ecofier_viz/core/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeighingSummaryItem extends StatefulWidget {
  final String title;
  final Widget value;
  final Widget icon;
  const WeighingSummaryItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  State<WeighingSummaryItem> createState() => _WeighingSummaryItemState();
}

class _WeighingSummaryItemState extends State<WeighingSummaryItem> {
  bool _hideValue = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 234, 240, 235).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              widget.icon,
              const SizedBox(width: 8),
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 239, 241, 247),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _hideValue
                      ? const Text(
                          "••••••••",
                          style: TextStyle(
                              color: AppColors.green1,
                              fontWeight: FontWeight.bold),
                        )
                      : Expanded(
                          child: widget.value,
                        ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _hideValue = !_hideValue;
                      });
                    },
                    child: _hideValue ? AppIcons.closedEye : AppIcons.openedEye,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
