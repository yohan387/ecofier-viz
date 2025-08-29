import 'package:equatable/equatable.dart';

class WeighingSummary extends Equatable {
  final double totalWeight;
  final double totalEarned;
  final int totalAnomalies;
  final int totalItems;
  final DateTime lastUpdated;

  const WeighingSummary({
    required this.totalWeight,
    required this.totalEarned,
    required this.totalAnomalies,
    required this.totalItems,
    required this.lastUpdated,
  });

  @override
  String toString() {
    return 'WeighingSummary(totalWeight: $totalWeight, totalItems: $totalItems, lastUpdated: $lastUpdated)';
  }

  @override
  List<Object?> get props =>
      [totalWeight, totalEarned, totalAnomalies, totalItems, lastUpdated];
}
