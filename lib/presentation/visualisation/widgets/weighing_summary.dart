import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_summary/get_weighing_summary_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_summary_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeighingSummary extends StatelessWidget {
  const WeighingSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Résumé",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.green2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocBuilder<GetWeighingSummaryCubit, GetWeighingSummaryState>(
            builder: (context, state) {
              if (state is GetWeighingSummaryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetWeighingSummarySuccess) {
                final summary = state.summary;
                return GridView(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                  ),
                  children: [
                    WeighingSummaryItem(
                      title: "Poids net",
                      value: summary.totalWeight.toString(),
                      icon: Image.asset(
                        'lib/core/assets/weight-scale.png',
                        fit: BoxFit.cover,
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child:
                              const Center(child: Icon(Icons.image, size: 80)),
                        ),
                      ),
                    ),
                    WeighingSummaryItem(
                        title: "Revenu",
                        value: summary.totalItems.toString(),
                        icon: Image.asset(
                          'lib/core/assets/low-income.png',
                          fit: BoxFit.cover,
                          width: 32,
                          height: 32,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[300],
                            child: const Center(
                                child: Icon(Icons.image, size: 80)),
                          ),
                        )),
                    WeighingSummaryItem(
                      title: "Anomalies",
                      value: summary.lastUpdated.toString(),
                      icon: Image.asset(
                        'lib/core/assets/alert.png',
                        fit: BoxFit.cover,
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child:
                              const Center(child: Icon(Icons.image, size: 80)),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
