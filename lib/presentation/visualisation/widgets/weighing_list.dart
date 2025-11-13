import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/presentation/visualisation/states/export_weighings/export_weighings_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_list/get_weighing_list_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/export_dialogs_helper.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeighingList extends StatelessWidget {
  final int totalWeighingsCount;

  const WeighingList({
    super.key,
    required this.totalWeighingsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and export button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Historique",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.green2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _handleExportClick(context),
                  icon: const Icon(Icons.file_download, size: 18),
                  label: const Text("Exporter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green1,
                    foregroundColor: AppColors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _builWeighingList(),
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 164,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 227, 236, 227),
                  borderRadius: BorderRadius.circular(16)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Text(
                      "Rechercher",
                      style: TextStyle(color: AppColors.green1),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.zoom_in,
                    color: AppColors.green1,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  BlocBuilder<GetWeighingListCubit, GetWeighingListState> _builWeighingList() {
    return BlocBuilder<GetWeighingListCubit, GetWeighingListState>(
      builder: (context, state) {
        if (state is GetWeighingListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetWeighingListSuccess) {
          final weighings = state.weighings;
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
                      builder: (context) => WeighingDetailPage(
                        weighing: weighings[index],
                      ),
                    ),
                  );
                },
                title: Container(
                  padding: const EdgeInsets.all(4),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        weighings[index].codePesee,
                      ),
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

  /// Gère le clic sur le bouton d'export
  Future<void> _handleExportClick(BuildContext context) async {
    final weighingListState = context.read<GetWeighingListCubit>().state;

    if (weighingListState is! GetWeighingListSuccess) {
      ExportDialogsHelper.showErrorSnackBar(
        context,
        "Aucune pesée à exporter",
      );
      return;
    }

    final filteredWeighings = weighingListState.weighings;

    // Step 1: Choisir le scope (filtre actuel vs tout)
    final scope = await ExportDialogsHelper.showExportScopeDialog(
      context,
      filteredCount: filteredWeighings.length,
      totalCount: totalWeighingsCount,
    );

    if (scope == null) return; // Annulé

    if (!context.mounted) return;

    // Step 2: Sélectionner les colonnes
    final selectedColumns =
        await ExportDialogsHelper.showColumnSelectionDialog(context);

    if (selectedColumns == null || selectedColumns.isEmpty) return; // Annulé

    if (!context.mounted) return;

    // Step 3: Déterminer quelles pesées exporter
    final weighingsToExport = scope == ExportScope.all
        ? context.read<GetWeighingListCubit>().allWeighings
        : filteredWeighings;

    // Step 4: Lancer l'export avec BlocListener
    context.read<ExportWeighingsCubit>().exportWeighings(
          weighings: weighingsToExport,
          selectedColumns: selectedColumns,
        );
  }
}
