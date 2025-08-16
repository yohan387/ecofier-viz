import 'package:equatable/equatable.dart';

/// Classe de base pour toutes les erreurs
abstract class AppBaseError extends Equatable {
  final int statusCode;
  final String description;
  final String userMessage;

  const AppBaseError({
    required this.statusCode,
    required this.description,
    required this.userMessage,
  });

  @override
  List<Object?> get props => [statusCode, description, userMessage];
}
