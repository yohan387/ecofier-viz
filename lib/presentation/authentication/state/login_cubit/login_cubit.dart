import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit(this._authRepository) : super(const LoginInitial());

  Future<void> login(String phoneNumber, String password) async {
    emit(const LoginLoading());
    final result = await _authRepository.login(phoneNumber, password);
    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (user) => emit(LoginSuccess(user)),
    );
  }
}
