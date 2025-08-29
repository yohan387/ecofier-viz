part of 'get_local_user_cubit.dart';

sealed class GetLocalUserState extends Equatable {
  const GetLocalUserState();

  @override
  List<Object?> get props => [];
}

final class GetLocalUserInitial extends GetLocalUserState {
  const GetLocalUserInitial();
}

final class GetLocalUserLoading extends GetLocalUserState {
  const GetLocalUserLoading();
}

final class GetLocalUserLoaded extends GetLocalUserState {
  final User localUser;
  const GetLocalUserLoaded(this.localUser);

  @override
  List<Object> get props => [localUser];
}

final class GetLocalUserError extends GetLocalUserState {
  final Failure? failure;
  const GetLocalUserError(this.failure);

  @override
  List<Object?> get props => [failure];
}
