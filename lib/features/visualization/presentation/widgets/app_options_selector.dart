import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/extensions.dart';
import 'package:flutter/material.dart';

class AppOptionSelector extends StatefulWidget {
  final List<Map<String, String>> dataList;
  final double width;
  final String? selectedID;
  final ValueChanged<String> value;

  const AppOptionSelector({
    super.key,
    required this.dataList,
    this.width = 124,
    this.selectedID,
    required this.value,
  });

  @override
  State<AppOptionSelector> createState() => _AppOptionSelectorState();
}

class _AppOptionSelectorState extends State<AppOptionSelector> {
  String? selectedID;

  @override
  void initState() {
    selectedID = widget.selectedID;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.dataList.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, String> data = entry.value;
          final String? id = data["id"];
          final String? code = data["code"];

          return Row(
            children: [
              if (id == widget.dataList.first["id"])
                const SizedBox(
                  width: 16,
                ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedID = id;
                  });
                  widget.value(id!);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  alignment: Alignment.center,
                  height: 34,
                  width: widget.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.green3),
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    color:
                        selectedID == id ? AppColors.green4 : AppColors.white,
                  ),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    code!.capitalizeFirstLetters(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selectedID == id
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              if (id == widget.dataList.last["id"])
                const SizedBox(
                  width: 16,
                ),
              if (index < widget.dataList.length - 1) const SizedBox(width: 4),
            ],
          );
        }).toList(),
      ),
    );
  }
}
