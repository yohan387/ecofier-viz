import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/errors/error.dart';

/// Classe de base pour les Exceptions (côté technique)
/// Types d’exception possibles

/// Exception unique pour représenter toutes les erreurs
class AppException extends AppBaseError implements Exception {
  final String howToResolveError;
  final AppExceptionType type;

  const AppException({
    required super.statusCode,
    required super.description,
    required super.userMessage,
    required this.howToResolveError,
    required this.type,
  });

  /// ---- Factories avec valeurs par défaut ----

  factory AppException.api({
    String userMessage = "Erreur API.",
    String description = "La communication avec le serveur a échoué.",
    String howToResolveError = "Veuillez réessayer ultérieurement.",
    int statusCode = AppErrorStatusCode.api,
  }) {
    return AppException(
      statusCode: statusCode,
      userMessage: userMessage,
      description: description,
      howToResolveError: howToResolveError,
      type: AppExceptionType.api,
    );
  }

  factory AppException.localStorage({
    String userMessage = "Erreur de stockage local.",
    String description = "Impossible d'accéder au stockage local.",
    String howToResolveError = "Veuillez fermer l'application puis réessayer. "
        "Si le problème persiste, désinstallez puis réinstallez l'application.",
    int statusCode = AppErrorStatusCode.localStorage,
  }) {
    return AppException(
      statusCode: statusCode,
      userMessage: userMessage,
      description: description,
      howToResolveError: howToResolveError,
      type: AppExceptionType.localStorage,
    );
  }

  factory AppException.network({
    String userMessage = "Problème réseau.",
    String description = "Problème de connexion internet.",
    String howToResolveError =
        "Vérifiez que votre connexion internet est activée puis réessayez.",
    int statusCode = AppErrorStatusCode.network,
  }) {
    return AppException(
      statusCode: statusCode,
      userMessage: userMessage,
      description: description,
      howToResolveError: howToResolveError,
      type: AppExceptionType.network,
    );
  }

  factory AppException.internal({
    String userMessage = "Un problème interne est survenu.",
    String description = "Erreur interne de l'application.",
    String howToResolveError = "Veuillez réessayer ultérieurement.",
    int statusCode = AppErrorStatusCode.internal,
  }) {
    return AppException(
      statusCode: statusCode,
      userMessage: userMessage,
      description: description,
      howToResolveError: howToResolveError,
      type: AppExceptionType.internal,
    );
  }
}
