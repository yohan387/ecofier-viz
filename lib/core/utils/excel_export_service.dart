import 'dart:io';
import 'package:ecofier_viz/core/models/excel_column.dart';
import 'package:ecofier_viz/models/weighing.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ExcelExportService {
  /// Liste de toutes les colonnes disponibles pour l'export
  static const List<ExcelColumn> availableColumns = [
    ExcelColumn(
        displayName: "Code Pesée", key: "codePesee", isDefaultColumn: true),
    ExcelColumn(
        displayName: "Date Pesée 1", key: "datePesee1", isDefaultColumn: true),
    ExcelColumn(displayName: "Heure Pesée 1", key: "heurePesee1"),
    ExcelColumn(
        displayName: "Date Pesée 2", key: "datePesee2", isDefaultColumn: true),
    ExcelColumn(displayName: "Heure Pesée 2", key: "heurePesee2"),
    ExcelColumn(
        displayName: "Poids 1 (kg)", key: "poids1", isDefaultColumn: true),
    ExcelColumn(
        displayName: "Poids 2 (kg)", key: "poids2", isDefaultColumn: true),
    ExcelColumn(
        displayName: "Poids Net (kg)", key: "poidsNet", isDefaultColumn: true),
    ExcelColumn(displayName: "Réfraction (%)", key: "refraction"),
    ExcelColumn(displayName: "Poids Réfracté (kg)", key: "poidsRefracte"),
    ExcelColumn(
        displayName: "Produit", key: "produit", isDefaultColumn: true),
    ExcelColumn(
        displayName: "Prix Produit (FCFA/kg)",
        key: "prixProduit",
        isDefaultColumn: true),
    ExcelColumn(
        displayName: "Montant Total (FCFA)",
        key: "montantTotal",
        isDefaultColumn: true),
    ExcelColumn(displayName: "Client", key: "client", isDefaultColumn: true),
    ExcelColumn(displayName: "Représentant", key: "representant"),
    ExcelColumn(
        displayName: "Transporteur",
        key: "transporteur",
        isDefaultColumn: true),
    ExcelColumn(
        displayName: "Immatriculation",
        key: "immatriculation",
        isDefaultColumn: true),
    ExcelColumn(displayName: "Contenant", key: "contenantPesee"),
    ExcelColumn(displayName: "Mouvement", key: "mouvement"),
    ExcelColumn(displayName: "Provenance", key: "provenance"),
    ExcelColumn(
        displayName: "Statut", key: "statutPesee", isDefaultColumn: true),
    ExcelColumn(displayName: "Motif Annulation", key: "motifAnnulation"),
    ExcelColumn(displayName: "Référence Pièce", key: "referencePiece"),
    ExcelColumn(displayName: "Client ID", key: "clientId"),
    ExcelColumn(displayName: "Utilisateur ID", key: "utilisateurId"),
  ];

  /// Retourne les colonnes par défaut
  static List<String> get defaultColumnKeys {
    return availableColumns
        .where((col) => col.isDefaultColumn)
        .map((col) => col.key)
        .toList();
  }

  /// Retourne toutes les clés de colonnes
  static List<String> get allColumnKeys {
    return availableColumns.map((col) => col.key).toList();
  }

  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');
  final DateFormat _timeFormatter = DateFormat('HH:mm');

  /// Exporte les pesées vers un fichier Excel
  Future<String> exportWeighingsToExcel({
    required List<Weighing> weighings,
    required List<String> selectedColumnKeys,
  }) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel['Pesées'];

    // Filtrer les colonnes sélectionnées
    final selectedColumns = availableColumns
        .where((col) => selectedColumnKeys.contains(col.key))
        .toList();

    // 1. Créer l'en-tête
    _createHeader(sheet, selectedColumns);

    // 2. Remplir les données
    for (int i = 0; i < weighings.length; i++) {
      _addWeighingRow(sheet, weighings[i], selectedColumns, i + 1);
    }

    // 3. Ajouter la ligne de totaux
    if (weighings.isNotEmpty) {
      _addTotalsRow(sheet, weighings, selectedColumns, weighings.length + 1);
    }

    // 4. Ajuster la largeur des colonnes
    _autoSizeColumns(sheet, selectedColumns.length);

    // 5. Sauvegarder le fichier
    return await _saveExcelFile(excel);
  }

  /// Crée l'en-tête du fichier Excel
  void _createHeader(Sheet sheet, List<ExcelColumn> columns) {
    for (int i = 0; i < columns.length; i++) {
      final cell = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(columns[i].displayName);
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.green800,
        fontColorHex: ExcelColor.white,
        horizontalAlign: HorizontalAlign.Center,
      );
    }
  }

  /// Ajoute une ligne de données pour une pesée
  void _addWeighingRow(
      Sheet sheet, Weighing weighing, List<ExcelColumn> columns, int rowIndex) {
    for (int colIndex = 0; colIndex < columns.length; colIndex++) {
      final column = columns[colIndex];
      final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex));

      dynamic value = _getWeighingValue(weighing, column.key);

      // Toujours créer une cellule, même si vide
      if (value == null) {
        cell.value = TextCellValue("");
      } else if (value is String) {
        cell.value = TextCellValue(value);
      } else if (value is num) {
        cell.value = DoubleCellValue(value.toDouble());
      } else if (value is DateTime) {
        cell.value = TextCellValue(_formatDate(value));
      } else {
        cell.value = TextCellValue(value.toString());
      }
    }
  }

  /// Récupère la valeur d'une colonne pour une pesée
  dynamic _getWeighingValue(Weighing weighing, String columnKey) {
    switch (columnKey) {
      case "codePesee":
        return weighing.codePesee;
      case "datePesee1":
        return weighing.datePesee1 != null
            ? _dateFormatter.format(weighing.datePesee1!)
            : null;
      case "heurePesee1":
        return weighing.heurePesee1 != null
            ? _timeFormatter.format(weighing.heurePesee1!)
            : null;
      case "datePesee2":
        return weighing.datePesee2 != null
            ? _dateFormatter.format(weighing.datePesee2!)
            : null;
      case "heurePesee2":
        return weighing.heurePesee2 != null
            ? _timeFormatter.format(weighing.heurePesee2!)
            : null;
      case "poids1":
        return weighing.poids1;
      case "poids2":
        return weighing.poids2;
      case "poidsNet":
        return weighing.poidsNet;
      case "refraction":
        return weighing.refraction;
      case "poidsRefracte":
        return weighing.poidsRefracte;
      case "produit":
        return weighing.produit;
      case "prixProduit":
        return weighing.prixProduit;
      case "montantTotal":
        return _calculateTotalAmount(weighing.prixProduit, weighing.poidsNet);
      case "client":
        return weighing.client;
      case "representant":
        return weighing.representant;
      case "transporteur":
        return weighing.transporteur;
      case "immatriculation":
        return weighing.immatriculation;
      case "contenantPesee":
        return weighing.contenantPesee;
      case "mouvement":
        return weighing.mouvement;
      case "provenance":
        return weighing.provenance;
      case "statutPesee":
        return weighing.statutPesee;
      case "motifAnnulation":
        return weighing.motifAnnulation;
      case "referencePiece":
        return weighing.referencePiece;
      case "clientId":
        return weighing.clientId;
      case "utilisateurId":
        return weighing.utilisateurId;
      default:
        return null;
    }
  }

  /// Calcule le montant total
  double? _calculateTotalAmount(double? prix, double? poids) {
    if (prix != null && poids != null) {
      return prix * poids;
    }
    return null;
  }

  /// Formate une date
  String _formatDate(DateTime? date) {
    if (date == null) return "";
    // Si c'est une date complète avec heure
    if (date.hour != 0 || date.minute != 0) {
      return _timeFormatter.format(date);
    }
    return _dateFormatter.format(date);
  }

  /// Ajoute la ligne de totaux
  void _addTotalsRow(Sheet sheet, List<Weighing> weighings,
      List<ExcelColumn> columns, int rowIndex) {
    // Calculer les totaux
    double totalPoidsNet = 0;
    double totalMontant = 0;

    for (var weighing in weighings) {
      totalPoidsNet += weighing.poidsNet ?? 0;
      totalMontant +=
          _calculateTotalAmount(weighing.prixProduit, weighing.poidsNet) ?? 0;
    }

    for (int colIndex = 0; colIndex < columns.length; colIndex++) {
      final column = columns[colIndex];
      final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex));

      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.green50,
      );

      switch (column.key) {
        case "codePesee":
          cell.value = TextCellValue("TOTAL (${weighings.length} pesées)");
          break;
        case "poidsNet":
          cell.value = DoubleCellValue(totalPoidsNet);
          cell.cellStyle = CellStyle(
            bold: true,
            backgroundColorHex: ExcelColor.green50,
          );
          break;
        case "montantTotal":
          cell.value = DoubleCellValue(totalMontant);
          cell.cellStyle = CellStyle(
            bold: true,
            backgroundColorHex: ExcelColor.green50,
          );
          break;
        default:
          break;
      }
    }
  }

  /// Ajuste automatiquement la largeur des colonnes
  void _autoSizeColumns(Sheet sheet, int columnCount) {
    for (int i = 0; i < columnCount; i++) {
      sheet.setColumnWidth(i, 20);
    }
  }

  /// Sauvegarde le fichier Excel et retourne le chemin
  Future<String> _saveExcelFile(Excel excel) async {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'Pesees_$timestamp.xlsx';

    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
      // Créer le dossier Ecofier dans Downloads
      final downloadsPath =
          directory!.path.replaceAll('Android/data/com.example.ecofier_viz/files', 'Download/Ecofier');
      directory = Directory(downloadsPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      final ecofierDir = Directory('${directory.path}/Ecofier');
      if (!await ecofierDir.exists()) {
        await ecofierDir.create(recursive: true);
      }
      directory = ecofierDir;
    } else {
      directory = await getDownloadsDirectory();
    }

    final filePath = '${directory!.path}/$fileName';
    final file = File(filePath);

    // Encoder et sauvegarder
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }

    return filePath;
  }
}
