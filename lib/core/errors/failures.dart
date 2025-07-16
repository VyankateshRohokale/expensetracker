import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}