import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ecofier_viz/core/utils/excel_export_service.dart';
import 'package:ecofier_viz/models/weighing.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'export_weighings_state.dart';

class ExportWeighingsCubit extends Cubit<ExportWeighingsState> {
  final ExcelExportService _exportService;

  ExportWeighingsCubit(this._exportService)
      : super(const ExportWeighingsInitial());

  /// Exporte les pesées vers Excel
  Future<void> exportWeighings({
    required List<Weighing> weighings,
    required List<String> selectedColumns,
  }) async {
    try {
      emit(const ExportWeighingsLoading(10));

      // Vérifier et demander les permissions
      final permissionGranted = await _requestStoragePermission();
      if (!permissionGranted) {
        emit(const ExportWeighingsFailure(
            "Permission de stockage refusée. Veuillez autoriser l'accès au stockage dans les paramètres."));
        return;
      }

      emit(const ExportWeighingsLoading(30));

      // Exporter les données
      final filePath = await _exportService.exportWeighingsToExcel(
        weighings: weighings,
        selectedColumnKeys: selectedColumns,
      );

      emit(const ExportWeighingsLoading(90));
      emit(ExportWeighingsSuccess(filePath));
    } catch (e) {
      emit(ExportWeighingsFailure(
          "Erreur lors de l'export: ${e.toString()}"));
    }
  }

  /// Demande la permission de stockage
  Future<bool> _requestStoragePermission() async {
    // Pour iOS, toujours retourner true car path_provider gère l'accès
    if (Platform.isIOS) {
      return true;
    }

    // Pour Android
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      // Android 13+ (API 33+) : Pas besoin de permission pour Downloads/Documents
      if (androidInfo.version.sdkInt >= 33) {
        return true;
      }

      // Android 10-12 (API 29-32) : Vérifier permission storage
      if (androidInfo.version.sdkInt >= 29) {
        final status = await Permission.storage.status;
        if (status.isGranted) {
          return true;
        }

        final result = await Permission.storage.request();
        if (result.isGranted) {
          return true;
        }

        if (result.isPermanentlyDenied) {
          await openAppSettings();
        }

        return false;
      }

      // Android < 10 : Demander permission storage
      final status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      }

      final result = await Permission.storage.request();
      if (result.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      return result.isGranted;
    }

    // Par défaut pour autres plateformes
    return true;
  }

  /// Réinitialise l'état
  void reset() => emit(const ExportWeighingsInitial());
}
