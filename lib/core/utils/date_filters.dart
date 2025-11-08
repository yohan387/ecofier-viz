import 'package:ecofier_viz/models/weighing.dart';

/// Filtre les pesées selon différentes périodes
class DateFilters {
  /// Filtre les pesées d'aujourd'hui
  static List<Weighing> filterToday(List<Weighing> weighings) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return weighings.where((weighing) {
      final date = weighing.datePesee1 ?? weighing.datePesee2;
      if (date == null) return false;

      return date.isAfter(today.subtract(const Duration(microseconds: 1))) &&
          date.isBefore(tomorrow);
    }).toList();
  }

  /// Filtre les pesées de la semaine en cours (7 derniers jours)
  static List<Weighing> filterThisWeek(List<Weighing> weighings) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    return weighings.where((weighing) {
      final date = weighing.datePesee1 ?? weighing.datePesee2;
      if (date == null) return false;

      return date.isAfter(weekAgo.subtract(const Duration(microseconds: 1)));
    }).toList();
  }

  /// Filtre les pesées du mois en cours
  static List<Weighing> filterThisMonth(List<Weighing> weighings) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    return weighings.where((weighing) {
      final date = weighing.datePesee1 ?? weighing.datePesee2;
      if (date == null) return false;

      return date.isAfter(firstDayOfMonth.subtract(const Duration(microseconds: 1)));
    }).toList();
  }

  /// Filtre les pesées selon une plage de dates personnalisée
  static List<Weighing> filterByDateRange(
    List<Weighing> weighings,
    DateTime startDate,
    DateTime endDate,
  ) {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day)
        .add(const Duration(days: 1));

    return weighings.where((weighing) {
      final date = weighing.datePesee1 ?? weighing.datePesee2;
      if (date == null) return false;

      return date.isAfter(start.subtract(const Duration(microseconds: 1))) &&
          date.isBefore(end);
    }).toList();
  }

  /// Applique le filtre selon l'ID sélectionné
  static List<Weighing> applyFilter(
    String filterID,
    List<Weighing> weighings, {
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    switch (filterID) {
      case "1": // D'aujourd'hui
        return filterToday(weighings);
      case "2": // De la semaine
        return filterThisWeek(weighings);
      case "3": // Du mois
        return filterThisMonth(weighings);
      case "4": // Autre (plage personnalisée)
        if (customStartDate != null && customEndDate != null) {
          return filterByDateRange(weighings, customStartDate, customEndDate);
        }
        return weighings; // Retourner tout si pas de dates personnalisées
      default:
        return weighings; // Pas de filtre
    }
  }
}
