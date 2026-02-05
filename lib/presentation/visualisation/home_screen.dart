import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/presentation/visualisation/analytics_screen.dart';
import 'package:ecofier_viz/presentation/visualisation/settings_screen.dart';
import 'package:ecofier_viz/presentation/visualisation/states/export_weighings/export_weighings_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_list/get_weighing_list_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_summary/get_weighing_summary_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/app_options_selector.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/export_dialogs_helper.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_list.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    context.read<GetWeighingListCubit>().getWeighingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _buildFloatingBottomNav(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<GetWeighingListCubit>().getWeighingList();
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<GetWeighingListCubit, GetWeighingListState>(
              listener: (context, state) {
                if (state is GetWeighingListSuccess) {
                  context.read<GetWeighingSummaryCubit>().getWeighingSummary();
                } else if (state is GetWeighingListFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failure.userMessage)),
                  );
                }
              },
            ),
            BlocListener<GetWeighingSummaryCubit, GetWeighingSummaryState>(
              listener: (context, state) {
                if (state is GetWeighingSummaryFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failure.userMessage)),
                  );
                }
              },
            ),
            BlocListener<ExportWeighingsCubit, ExportWeighingsState>(
              listener: (context, state) {
                if (state is ExportWeighingsLoading) {
                  ExportDialogsHelper.showProgressDialog(
                    context,
                    state.progress,
                  );
                } else if (state is ExportWeighingsSuccess) {
                  Navigator.pop(context); // Fermer dialog progression
                  ExportDialogsHelper.showPostExportDialog(
                    context,
                    state.filePath,
                  );
                  context.read<ExportWeighingsCubit>().reset();
                } else if (state is ExportWeighingsFailure) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(
                      context,
                    ); // Fermer dialog progression si ouvert
                  }
                  ExportDialogsHelper.showErrorSnackBar(
                    context,
                    state.errorMessage,
                  );
                  context.read<ExportWeighingsCubit>().reset();
                }
              },
            ),
          ],
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<GetWeighingListCubit>().getWeighingList();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bannière image
                  _buildBanner(),
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
                  BlocBuilder<GetWeighingListCubit, GetWeighingListState>(
                    builder: (context, state) {
                      String selectedFilterID = "1"; // Par défaut
                      if (state is GetWeighingListSuccess) {
                        selectedFilterID = state.currentFilterID;
                      }
                      return AppOptionSelector(
                        dataList: filtersOptionList,
                        selectedID: selectedFilterID,
                        value: (filterID) {
                          if (filterID == "4") {
                            // Option "Autre" - Afficher le sélecteur de dates
                            _showDateRangePicker(context);
                          } else {
                            // Appliquer le filtre directement
                            context
                                .read<GetWeighingListCubit>()
                                .filterWeighings(filterID);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  const WeighingSummary(),

                  BlocBuilder<GetWeighingListCubit, GetWeighingListState>(
                    builder: (context, state) {
                      final totalCount = context
                          .read<GetWeighingListCubit>()
                          .allWeighings
                          .length;
                      return WeighingList(totalWeighingsCount: totalCount);
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
        "4", // ID pour "Autre"
        customStartDate: pickedRange.start,
        customEndDate: pickedRange.end,
      );
    }
  }

  /// Construit la bottom navigation bar flottante
  Widget _buildFloatingBottomNav() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.green1,
        borderRadius: BorderRadius.circular(
          32,
        ), // Corrected from 30 to 32 (Multiple of 8)
        boxShadow: [
          BoxShadow(
            color: AppColors.green1.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home_rounded,
            label: 'Accueil',
            index: 0,
            isSelected: _currentIndex == 0,
          ),
          _buildNavItem(
            icon: Icons.analytics_rounded,
            label: 'Analyses',
            index: 1,
            isSelected: _currentIndex == 1,
          ),
          _buildNavItem(
            icon: Icons.settings_rounded,
            label: 'Paramètres',
            index: 2,
            isSelected: _currentIndex == 2,
          ),
        ],
      ),
    );
  }

  /// Construit un élément de navigation
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          // Navigation vers la page d'analyses
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnalyticsScreen(user: widget.user),
            ),
          );
        } else if (index == 2) {
          // Navigation vers la page des paramètres
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(user: widget.user),
            ),
          );
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.yellow : AppColors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.yellow : AppColors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildBanner() {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          // Fond avec dégradé au lieu de l'image
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.green1, AppColors.green2],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(56),
              ), // Corrected from 54 to 56 (Multiple of 8)
            ),
          ),

          Positioned(
            top: 32,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 8,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.white, width: 3),
                        borderRadius: BorderRadius.circular(38),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.green1,
                        size: 32,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Akwaba,",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.user.fullName,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
