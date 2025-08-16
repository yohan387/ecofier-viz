import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/errors/exceptions.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/models/weighing_summary.dart';
import 'package:ecofier_viz/repositories/viz_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_weighing_summary_state.dart';

class GetWeighingSummaryCubit extends Cubit<GetWeighingSummaryState> {
  final VizRepository _repository;

  GetWeighingSummaryCubit(this._repository)
      : super(const GetWeighingSummaryInitial());

  Future<void> fetchWeighingSummary() async {
    emit(const GetWeighingSummaryLoading());
    try {
      final summary = await _repository.getWeighingSummary();
      emit(GetWeighingSummarySuccess(summary));
    } catch (e) {
      emit(
        GetWeighingSummaryFailure(
          Failure.internal(
            AppException.internal(
              statusCode: AppErrorStatusCode.internal,
              description: e.toString(),
              userMessage:
                  "Erreur inattendue lors de la récupération du résumé de pesée.",
              howToResolveError:
                  'Veuillez réessayer plus tard. Si le problème persiste, contactez le support.',
            ),
          ),
        ),
      );
    }
  }
}
