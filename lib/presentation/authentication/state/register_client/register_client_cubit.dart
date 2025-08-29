import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/errors/exceptions.dart';
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
    try {
      await _authRepository.registerClient(
        firstname: firstname,
        lastname: lastname,
        phoneNumber: phoneNumber,
        password: password,
      );
      emit(const RegisterClientSuccess());
    } catch (error) {
      if (error is Failure) {
        emit(RegisterClientFailure(error));
      } else {
        emit(
          RegisterClientFailure(
            Failure.internal(
              AppException.internal(
                statusCode: AppErrorStatusCode.internal,
                description: error.toString(),
                userMessage: "Erreur inattendue lors de la création du compte.",
                howToResolveError:
                    'Veuillez réessayer plus tard. Si le problème persiste, contactez le support.',
              ),
            ),
          ),
        );
      }
    }
  }
}
