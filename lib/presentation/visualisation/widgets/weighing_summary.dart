import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/extensions.dart';
import 'package:ecofier_viz/core/widgets/amount_display.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_summary/get_weighing_summary_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/shimmer_widgets.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_summary_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeighingSummary extends StatelessWidget {
  const WeighingSummary({super.key});

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
                fontSize: 14,
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
                return SizedBox(
                  height: 120,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: 160,
                        child: WeighingSummaryItem(
                          title: "Poids net",
                          value: Text(
                            textAlign: TextAlign.center,
                            '${summary.totalWeight.formatAsAmount()} Kg',
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: Image.asset(
                            'lib/core/assets/weight-scale.png',
                            fit: BoxFit.cover,
                            width: 28,
                            height: 28,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image, size: 80),
                                  ),
                                ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 160,
                        child: WeighingSummaryItem(
                          title: "Revenu",
                          value: AmountDisplay(
                            amount: summary.totalEarned,
                            textSize: 12,
                          ),
                          icon: Image.asset(
                            'lib/core/assets/low-income.png',
                            fit: BoxFit.cover,
                            width: 28,
                            height: 28,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image, size: 80),
                                  ),
                                ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 160,
                        child: WeighingSummaryItem(
                          title: "Anomalies",
                          value: Text(
                            textAlign: TextAlign.center,
                            summary.totalAnomalies.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: Image.asset(
                            'lib/core/assets/alert.png',
                            fit: BoxFit.cover,
                            width: 28,
                            height: 28,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image, size: 80),
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
