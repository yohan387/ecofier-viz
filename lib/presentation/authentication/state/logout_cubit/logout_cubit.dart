import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/errors/exceptions.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository _authRepository;
  LogoutCubit(this._authRepository) : super(const LogoutInitial());

  Future<void> logout() async {
    emit(const LogoutLoading());
    try {
      await _authRepository.logout();
      emit(const LogoutSuccess());
    } catch (error) {
      if (error is Failure) {
        emit(LogoutFailure(error));
      } else {
        emit(
          LogoutFailure(
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
