part of 'register_client_cubit.dart';

sealed class RegisterClientState extends Equatable {
  const RegisterClientState();

  @override
  List<Object> get props => [];
}

final class RegisterClientInitial extends RegisterClientState {
  const RegisterClientInitial();
}

final class RegisterClientLoading extends RegisterClientState {
  const RegisterClientLoading();
}

final class RegisterClientSuccess extends RegisterClientState {
  const RegisterClientSuccess();
}

final class RegisterClientFailure extends RegisterClientState {
  final Failure failure;

  const RegisterClientFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
