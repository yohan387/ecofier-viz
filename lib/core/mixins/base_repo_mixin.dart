import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:ecofier_viz/core/connection_checker.dart';
import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/errors/exceptions.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/core/typedefs.dart';
import 'package:flutter/foundation.dart';

mixin BaseRepoMixin {
  static const int maxTransactionCheckingRetries = 10;
  ResultFuture<T> _execute<T>({
    required Future<T> Function() action,
    IConnectionChecker? connectionChecker,
    bool checkConnection = false,
  }) async {
    try {
      if (checkConnection) {
        final isConnected = await connectionChecker!.isConnected;
        if (!isConnected) return Left(Failure.network(AppException.network()));
      }

      final result = await action();
      return Right(result);
    } catch (e) {
      if (kDebugMode) log(e.toString());

      if (e is AppException) {
        switch (e.type) {
          case AppExceptionType.network:
            return Left(Failure.network(e));
          case AppExceptionType.api:
            return Left(Failure.api(e));
          case AppExceptionType.localStorage:
            return Left(Failure.localStorage(e));
          case AppExceptionType.internal:
            return Left(Failure.internal(e));

          default:
            return Left(Failure.internal(e));
        }
      } else {
        return Left(
            Failure.internal(AppException.internal(description: e.toString())));
      }
    }
  }

  ResultFuture<T> executeWithFailureHandling<T>(Future<T> Function() action) {
    return _execute(action: action);
  }

  ResultFuture<T> executeWithConnectionCheck<T>(
    IConnectionChecker connectionChecker,
    Future<T> Function() action,
  ) {
    return _execute(
      action: action,
      connectionChecker: connectionChecker,
      checkConnection: true,
    );
  }
}
