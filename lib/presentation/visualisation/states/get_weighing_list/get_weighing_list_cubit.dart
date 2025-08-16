import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/constants.dart';
import 'package:ecofier_viz/core/errors/exceptions.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/models/weighing.dart';
import 'package:ecofier_viz/repositories/viz_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_weighing_list_state.dart';

class GetWeighingListCubit extends Cubit<GetWeighingListState> {
  final VizRepository _repository;
  GetWeighingListCubit(this._repository)
      : super(const GetWeighingListInitial());

  Future<void> fetchWeighingList() async {
    emit(const GetWeighingListLoading());
    try {
      final list = await _repository.getWeighingList();
      emit(GetWeighingListSuccess(list));
    } catch (e) {
      emit(
        GetWeighingListFailure(
          Failure.internal(
            AppException.internal(
              statusCode: AppErrorStatusCode.internal,
              description: e.toString(),
              userMessage:
                  "Erreur inattendue lors de la récupération de la liste de pesée.",
              howToResolveError:
                  'Veuillez réessayer plus tard. Si le problème persiste, contactez le support.',
            ),
          ),
        ),
      );
    }
  }
}
