import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/errors/exceptions.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/models/user.dart';
import 'package:ecofier_viz/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit(this._authRepository) : super(const LoginInitial());

  Future<void> login(String username, String password) async {
    emit(const LoginLoading());
    try {
      final user = await _authRepository.login(username, password);
      emit(LoginSuccess(user));
    } catch (error) {
      if (error is Failure) {
        emit(LoginFailure(error));
      } else {
        emit(
          LoginFailure(
            Failure.internal(
              AppException.internal(
                statusCode: AppErrorStatusCode.internal,
                description: error.toString(),
                userMessage: "Erreur inattendue lors de la connexion.",
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
