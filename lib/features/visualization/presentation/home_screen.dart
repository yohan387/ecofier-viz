import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/features/visualization/presentation/widgets/app_options_selector.dart';
import 'package:ecofier_viz/features/visualization/presentation/widgets/weighing_summary_item.dart';
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
            const Padding(
              padding: EdgeInsets.all(16),
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
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 230, 237, 231)
                        .withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Pesées",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.green2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GridView.builder(
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return const WeighingSummaryItem();
                    },
                  ),
                ],
              ),
            ),

            // Create history
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Historique",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.green2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Item $index"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
