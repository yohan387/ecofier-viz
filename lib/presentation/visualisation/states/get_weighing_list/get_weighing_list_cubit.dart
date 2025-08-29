import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/models/weighing.dart';
import 'package:ecofier_viz/repositories/viz_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_weighing_list_state.dart';

class GetWeighingListCubit extends Cubit<GetWeighingListState> {
  final VizRepository _repository;
  GetWeighingListCubit(this._repository)
      : super(const GetWeighingListInitial());

  Future<void> getWeighingList() async {
    emit(const GetWeighingListLoading());
    final result = await _repository.getWeighingList();

    result.fold(
      (failure) => emit(GetWeighingListFailure(failure)),
      (weighingList) => emit(GetWeighingListSuccess(weighingList)),
    );
  }
}
