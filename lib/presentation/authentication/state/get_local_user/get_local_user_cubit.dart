import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_local_user_state.dart';

class GetLocalUserCubit extends Cubit<GetLocalUserState> {
  final AuthRepository _authRepository;

  GetLocalUserCubit(this._authRepository) : super(const GetLocalUserInitial());

  Future<void> call() async {
    emit(const GetLocalUserLoading());
    final result = await _authRepository.getLocalUser();
    result.fold(
      (failure) => emit(GetLocalUserError(failure)),
      (user) => emit(GetLocalUserLoaded(user)),
    );
  }
}
