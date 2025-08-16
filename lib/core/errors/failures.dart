import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/errors/error.dart';
import 'package:ecofier_viz/core/errors/exceptions.dart';

/// Classe unique pour représenter les erreurs côté métier
class Failure extends AppBaseError {
  final String howToResolveError;
  final FailureType type;

  const Failure({
    required super.statusCode,
    required super.description,
    required super.userMessage,
    required this.howToResolveError,
    required this.type,
  });

  /// Factories pour instancier rapidement selon le type
  factory Failure.api(AppException exception) => Failure(
        statusCode: exception.statusCode,
        userMessage: exception.userMessage,
        description: exception.description,
        howToResolveError: exception.howToResolveError,
        type: FailureType.api,
      );

  factory Failure.localStorage(AppException exception) => Failure(
        statusCode: exception.statusCode,
        userMessage: exception.userMessage,
        description: exception.description,
        howToResolveError: exception.howToResolveError,
        type: FailureType.localStorage,
      );

  factory Failure.internal(AppException exception) => Failure(
        statusCode: exception.statusCode,
        userMessage: exception.userMessage,
        description: exception.description,
        howToResolveError: exception.howToResolveError,
        type: FailureType.internal,
      );

  factory Failure.network(AppException exception) => Failure(
        statusCode: exception.statusCode,
        userMessage: exception.userMessage,
        description: exception.description,
        howToResolveError: exception.howToResolveError,
        type: FailureType.network,
      );
}
