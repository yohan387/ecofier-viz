import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_list/get_weighing_list_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/app_options_selector.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/shimmer_widgets.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatefulWidget {
  final User user;
  const AnalyticsScreen({super.key, required this.user});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les données si nécessaire
    if (context.read<GetWeighingListCubit>().allWeighings.isEmpty) {
      context.read<GetWeighingListCubit>().getWeighingList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analyses',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.green1,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: BlocListener<GetWeighingListCubit, GetWeighingListState>(
        listener: (context, state) {
          if (state is GetWeighingListFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure.userMessage)),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<GetWeighingListCubit>().getWeighingList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtre de dates
                  BlocBuilder<GetWeighingListCubit, GetWeighingListState>(
                    builder: (context, state) {
                      String selectedFilterID = "3"; // Par défaut: mois
                      if (state is GetWeighingListSuccess) {
                        selectedFilterID = state.currentFilterID;
                      }
                      return AppOptionSelector(
                        dataList: filtersOptionList,
                        selectedID: selectedFilterID,
                        value: (filterID) {
                          if (filterID == "4") {
                            _showDateRangePicker(context);
                          } else {
                            context.read<GetWeighingListCubit>().filterWeighings(
                              filterID,
                            );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Histogramme
                  const Text(
                    "Transactions par jour",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.green2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<GetWeighingListCubit, GetWeighingListState>(
                    builder: (context, state) {
                      if (state is GetWeighingListLoading) {
                        return const HistogramShimmer();
                      } else if (state is GetWeighingListSuccess) {
                        return _buildHistogram(state.weighings);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 32),

                  // Liste des transactions
                  const Text(
                    "Transactions",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.green2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<GetWeighingListCubit, GetWeighingListState>(
                    builder: (context, state) {
                      if (state is GetWeighingListLoading) {
                        return const WeighingListShimmer();
                      } else if (state is GetWeighingListSuccess) {
                        final weighings = state.weighings;
                        if (weighings.isEmpty) {
                          return _buildEmptyState(state);
                        }
                        return _buildTransactionsList(weighings);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Affiche un sélecteur de plage de dates personnalisée
  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.green1,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null && context.mounted) {
      context.read<GetWeighingListCubit>().filterWeighings(
        "4",
        customStartDate: pickedRange.start,
        customEndDate: pickedRange.end,
      );
    }
  }

  /// Construit l'histogramme des transactions par jour
  Widget _buildHistogram(List weighings) {
    // Grouper les pesées par jour
    Map<String, int> transactionsByDay = {};

    for (var weighing in weighings) {
      // Utiliser datePesee2 ou datePesee1, avec priorité à datePesee2 (date la plus récente)
      final date = weighing.datePesee2 ?? weighing.datePesee1;
      if (date != null) {
        final dateKey = DateFormat('dd/MM').format(date);
        transactionsByDay[dateKey] = (transactionsByDay[dateKey] ?? 0) + 1;
      }
    }

    // Trier les jours par date
    final sortedEntries = transactionsByDay.entries.toList()
      ..sort((a, b) {
        // Parser les dates pour un tri correct
        final dateA = DateFormat('dd/MM').parse(a.key);
        final dateB = DateFormat('dd/MM').parse(b.key);
        return dateA.compareTo(dateB);
      });

    if (sortedEntries.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.grey2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            "Aucune donnée disponible",
            style: TextStyle(color: AppColors.grey),
          ),
        ),
      );
    }

    // Trouver la valeur maximale pour normaliser les hauteurs
    final maxValue = sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: sortedEntries.map((entry) {
                final heightRatio = entry.value / maxValue;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${entry.value}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.green2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 150 * heightRatio,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AppColors.green1, AppColors.green2],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la liste des transactions
  Widget _buildTransactionsList(List weighings) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: weighings.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final weighing = weighings[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeighingDetailPage(weighing: weighing),
              ),
            );
          },
          title: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weighing.codePesee,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      () {
                        final date = weighing.datePesee2 ?? weighing.datePesee1;
                        if (date != null) {
                          return DateFormat('dd/MM/yyyy HH:mm').format(date);
                        }
                        return 'Date inconnue';
                      }(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${weighing.poidsNet?.toStringAsFixed(2) ?? 'N/A'} kg",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.green2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Construit l'état vide
  Widget _buildEmptyState(GetWeighingListSuccess state) {
    String message = "Aucune transaction disponible";

    switch (state.currentFilterID) {
      case "1":
        message = "Aucune transaction aujourd'hui";
        break;
      case "2":
        message = "Aucune transaction cette semaine";
        break;
      case "3":
        message = "Aucune transaction ce mois";
        break;
      case "4":
        if (state.customStartDate != null && state.customEndDate != null) {
          final formattedStart = DateFormat('dd/MM/yyyy').format(state.customStartDate!);
          final formattedEnd = DateFormat('dd/MM/yyyy').format(state.customEndDate!);
          message = "Aucune transaction pour la période du $formattedStart au $formattedEnd";
        }
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.grey.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
