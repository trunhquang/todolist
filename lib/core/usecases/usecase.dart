import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todolist/core/errors/failures.dart';

/// Base class for all use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case that doesn't take any parameters
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// Use case that returns void
abstract class UseCaseVoid<Params> {
  Future<Either<Failure, void>> call(Params params);
}

/// Use case that returns void and takes no parameters
abstract class UseCaseVoidNoParams {
  Future<Either<Failure, void>> call();
}

/// Base class for parameters
abstract class Params extends Equatable {
  const Params();
}

/// Parameters for use cases that don't need any parameters
class NoParams extends Params {
  const NoParams();

  @override
  List<Object?> get props => [];
}
