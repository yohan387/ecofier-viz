import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'register_client_state.dart';

class RegisterClientCubit extends Cubit<RegisterClientState> {
  final AuthRepository _authRepository;

  RegisterClientCubit(this._authRepository)
      : super(const RegisterClientInitial());

  Future<void> register({
    required String firstname,
    required String lastname,
    required String phoneNumber,
    required String password,
  }) async {
    emit(const RegisterClientLoading());
    final result = await _authRepository.registerClient(
      firstname: firstname,
      lastname: lastname,
      phoneNumber: phoneNumber,
      password: password,
    );

    result.fold(
      (failure) => emit(RegisterClientFailure(failure)),
      (_) => emit(const RegisterClientSuccess()),
    );
  }
}
