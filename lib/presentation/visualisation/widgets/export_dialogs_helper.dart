import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/utils/excel_export_service.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

enum ExportScope { filtered, all }

class ExportDialogsHelper {
  /// Affiche le dialog de sélection de scope (filtre actuel vs tout)
  static Future<ExportScope?> showExportScopeDialog(
    BuildContext context, {
    required int filteredCount,
    required int totalCount,
  }) async {
    ExportScope selectedScope = ExportScope.filtered;

    return showDialog<ExportScope>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            "Options d'export",
            style: TextStyle(
              color: AppColors.green1,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Que souhaitez-vous exporter ?",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              RadioListTile<ExportScope>(
                title: Text("Filtre actuel ($filteredCount pesées)"),
                value: ExportScope.filtered,
                groupValue: selectedScope,
                activeColor: AppColors.green1,
                onChanged: (value) {
                  setState(() => selectedScope = value!);
                },
              ),
              RadioListTile<ExportScope>(
                title: Text("Toutes les pesées ($totalCount pesées)"),
                value: ExportScope.all,
                groupValue: selectedScope,
                activeColor: AppColors.green1,
                onChanged: (value) {
                  setState(() => selectedScope = value!);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedScope),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green1,
                foregroundColor: AppColors.white,
              ),
              child: const Text("Suivant"),
            ),
          ],
        ),
      ),
    );
  }

  /// Affiche le dialog de sélection de colonnes
  static Future<List<String>?> showColumnSelectionDialog(
    BuildContext context,
  ) async {
    // Initialement, toutes les colonnes sont sélectionnées
    List<String> selectedColumns =
        List.from(ExcelExportService.allColumnKeys);

    return showDialog<List<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            "Sélectionner les colonnes",
            style: TextStyle(
              color: AppColors.green1,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Boutons rapides
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedColumns =
                              List.from(ExcelExportService.allColumnKeys);
                        });
                      },
                      icon: const Icon(Icons.select_all, size: 18),
                      label: const Text("Tout", style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.green1,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedColumns =
                              List.from(ExcelExportService.defaultColumnKeys);
                        });
                      },
                      icon: const Icon(Icons.star, size: 18),
                      label: const Text("Par défaut",
                          style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.green2,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedColumns.clear();
                        });
                      },
                      icon: const Icon(Icons.clear, size: 18),
                      label: const Text("Aucun",
                          style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.red,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                // Liste scrollable de checkboxes
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ExcelExportService.availableColumns.length,
                    itemBuilder: (context, index) {
                      final column =
                          ExcelExportService.availableColumns[index];
                      final isSelected =
                          selectedColumns.contains(column.key);
                      return CheckboxListTile(
                        title: Text(
                          column.displayName,
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: column.isDefaultColumn
                            ? const Text(
                                "Par défaut",
                                style: TextStyle(
                                    fontSize: 11, color: AppColors.green2),
                              )
                            : null,
                        value: isSelected,
                        activeColor: AppColors.green1,
                        dense: true,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedColumns.add(column.key);
                            } else {
                              selectedColumns.remove(column.key);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                Text(
                  "${selectedColumns.length}/${ExcelExportService.availableColumns.length} colonnes sélectionnées",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.green1,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton.icon(
              onPressed: selectedColumns.isEmpty
                  ? null
                  : () => Navigator.pop(context, selectedColumns),
              icon: const Icon(Icons.file_download),
              label: const Text("Exporter"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green1,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.grey3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Affiche le dialog de progression
  static void showProgressDialog(BuildContext context, int progress) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.green1),
            ),
            const SizedBox(height: 16),
            Text("Export en cours... $progress%"),
          ],
        ),
      ),
    );
  }

  /// Affiche le dialog de succès post-export
  static Future<void> showPostExportDialog(
    BuildContext context,
    String filePath,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 32),
            const SizedBox(width: 8),
            const Text(
              "Export réussi !",
              style: TextStyle(
                color: AppColors.green1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Le fichier Excel a été créé avec succès :"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.grey4,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                filePath,
                style: const TextStyle(fontSize: 11, color: AppColors.grey),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await Share.shareXFiles([XFile(filePath)],
                  text: 'Export des pesées Ecofier');
            },
            icon: const Icon(Icons.share),
            label: const Text("Partager"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green2,
              foregroundColor: AppColors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await OpenFile.open(filePath);
            },
            icon: const Icon(Icons.folder_open),
            label: const Text("Ouvrir"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green1,
              foregroundColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Affiche un message d'erreur
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "OK",
          textColor: AppColors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
