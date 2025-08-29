import 'package:dartz/dartz.dart';
import 'package:ecofier_viz/core/errors/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
