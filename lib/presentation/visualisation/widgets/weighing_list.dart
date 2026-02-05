import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_list/get_weighing_list_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/shimmer_widgets.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WeighingList extends StatelessWidget {
  final int totalWeighingsCount;

  const WeighingList({super.key, required this.totalWeighingsCount});

  /// Génère le message d'absence de pesées selon le filtre actuel
  String _getEmptyMessage(
    String filterID,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    switch (filterID) {
      case "1":
        return "Aucune pesée aujourd'hui";
      case "2":
        return "Aucune pesée cette semaine";
      case "3":
        return "Aucune pesée ce mois";
      case "4":
        if (startDate != null && endDate != null) {
          final formattedStart = DateFormat('dd/MM/yyyy').format(startDate);
          final formattedEnd = DateFormat('dd/MM/yyyy').format(endDate);
          return "Aucune pesée pour la période du $formattedStart au $formattedEnd";
        }
        return "Aucune pesée pour la période sélectionnée";
      default:
        return "Aucune pesée disponible";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Historique",
              style: TextStyle(
                fontSize: 18, // Increased from 14 to 18 for better hierarchy
                color: AppColors.green2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _builWeighingList(),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  BlocBuilder<GetWeighingListCubit, GetWeighingListState> _builWeighingList() {
    return BlocBuilder<GetWeighingListCubit, GetWeighingListState>(
      builder: (context, state) {
        if (state is GetWeighingListLoading) {
          return const WeighingListShimmer();
        } else if (state is GetWeighingListSuccess) {
          final weighings = state.weighings;

          // Si la liste est vide, afficher le message personnalisé
          if (weighings.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: Text(
                _getEmptyMessage(
                  state.currentFilterID,
                  state.customStartDate,
                  state.customEndDate,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: weighings.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WeighingDetailPage(weighing: weighings[index]),
                    ),
                  );
                },
                title: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(weighings[index].codePesee),
                      Text(
                        "${weighings[index].poidsNet?.toStringAsFixed(2) ?? 'N/A'} kg",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
