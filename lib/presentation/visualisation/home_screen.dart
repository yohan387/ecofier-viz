import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/presentation/authentication/screens/auth_screen.dart';
import 'package:ecofier_viz/presentation/authentication/state/logout_cubit/logout_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/export_weighings/export_weighings_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_list/get_weighing_list_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/states/get_weighing_summary/get_weighing_summary_cubit.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/app_options_selector.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/export_dialogs_helper.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_list.dart';
import 'package:ecofier_viz/presentation/visualisation/widgets/weighing_summary.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<GetWeighingListCubit>().getWeighingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _buildEndDrawer(),
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
            BlocListener<LogoutCubit, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                    (Route<dynamic> route) => false,
                  );
                } else if (state is LogoutFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failure.userMessage)),
                  );
                }
              },
            ),
            BlocListener<ExportWeighingsCubit, ExportWeighingsState>(
              listener: (context, state) {
                if (state is ExportWeighingsLoading) {
                  ExportDialogsHelper.showProgressDialog(context, state.progress);
                } else if (state is ExportWeighingsSuccess) {
                  Navigator.pop(context); // Fermer dialog progression
                  ExportDialogsHelper.showPostExportDialog(context, state.filePath);
                  context.read<ExportWeighingsCubit>().reset();
                } else if (state is ExportWeighingsFailure) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context); // Fermer dialog progression si ouvert
                  }
                  ExportDialogsHelper.showErrorSnackBar(context, state.errorMessage);
                  context.read<ExportWeighingsCubit>().reset();
                }
              },
            ),
          ],
          child: SingleChildScrollView(
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
                    final totalCount = context.read<GetWeighingListCubit>().allWeighings.length;
                    return WeighingList(totalWeighingsCount: totalCount);
                  },
                ),

                const Center(
                  child: Text("By Ecofier",
                      style: TextStyle(
                        color: AppColors.green1,
                        fontStyle: FontStyle.italic,
                      )),
                ),

                const SizedBox(height: 32),
              ],
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

  /// Construit le drawer latéral avec les options
  Widget _buildEndDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // En-tête du drawer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.green1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.white,
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: AppColors.green1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.user.fullName,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.user.email ?? widget.user.phoneNumber,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Options
            ListTile(
              leading: const Icon(Icons.folder_open, color: AppColors.green1),
              title: const Text("Accès au stockage"),
              subtitle: const Text("Gérer les permissions"),
              onTap: () async {
                Navigator.pop(context); // Fermer le drawer
                await _requestStoragePermission(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.red),
              title: const Text("Déconnexion"),
              onTap: () {
                Navigator.pop(context); // Fermer le drawer
                context.read<LogoutCubit>().logout();
              },
            ),
            const Spacer(),
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Ecofier Viz v1.0.0",
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Demande la permission d'accès au stockage
  Future<void> _requestStoragePermission(BuildContext context) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ : Demander les permissions média
        status = await Permission.photos.request();
      } else {
        // Android < 13 : Demander la permission de stockage
        status = await Permission.storage.request();
      }
    } else {
      // iOS
      status = await Permission.photos.request();
    }

    if (!context.mounted) return;

    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Accès au stockage accordé"),
          backgroundColor: AppColors.green1,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              "Permission refusée de manière permanente. Veuillez l'activer dans les paramètres."),
          backgroundColor: AppColors.red,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: "Paramètres",
            textColor: AppColors.white,
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Accès au stockage refusé"),
          backgroundColor: AppColors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  SizedBox _buildBanner() {
    return SizedBox(
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
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Row(
                      children: [
                        IconButton(
                          color: AppColors.white,
                          onPressed: () {},
                          icon: const Icon(Icons.notifications),
                        ),
                        Builder(
                          builder: (context) => IconButton(
                            color: AppColors.white,
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            icon: const Icon(Icons.menu),
                          ),
                        ),
                      ],
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
