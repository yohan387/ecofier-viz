import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/presentation/authentication/screens/auth_screen.dart';
import 'package:ecofier_viz/presentation/authentication/state/logout_cubit/logout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatelessWidget {
  final User user;

  const SettingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paramètres',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.green1,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthScreen()),
              (Route<dynamic> route) => false,
            );
          } else if (state is LogoutFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.failure.userMessage)));
          }
        },
        child: Column(
          children: [
            // En-tête du profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: AppColors.green1),
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
                    user.fullName,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email ?? user.phoneNumber,
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
                await _requestStoragePermission(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Déconnexion"),
              onTap: () {
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
            "Permission refusée de manière permanente. Veuillez l'activer dans les paramètres.",
          ),

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
}
