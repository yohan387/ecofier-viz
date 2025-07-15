import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/features/visualization/presentation/widgets/app_options_selector.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var optionsList = [
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bannière image
            SizedBox(
              height: 216,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(64),
                    ),
                    child: Image.asset(
                      'lib/core/assets/bg_1.jpeg',
                      fit: BoxFit.cover,
                      height: 192,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image, size: 80)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 16,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.green1),
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.green1,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Pesées",
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.green2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppOptionSelector(
              dataList: optionsList,
              value: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
