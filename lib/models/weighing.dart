import 'package:equatable/equatable.dart';

class Weighing extends Equatable {
  final double weight;
  final DateTime timestamp;

  const Weighing({
    required this.weight,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [weight, timestamp];
}
