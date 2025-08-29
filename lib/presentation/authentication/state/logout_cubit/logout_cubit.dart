import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository _authRepository;
  LogoutCubit(this._authRepository) : super(const LogoutInitial());

  Future<void> logout() async {
    emit(const LogoutLoading());
    final result = await _authRepository.logout();
    result.fold(
      (failure) => emit(LogoutFailure(failure)),
      (_) => emit(const LogoutSuccess()),
    );
  }
}
