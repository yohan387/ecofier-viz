import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/core/utils/date_filters.dart';
import 'package:ecofier_viz/models/weighing.dart';
import 'package:ecofier_viz/repositories/viz_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_weighing_list_state.dart';

class GetWeighingListCubit extends Cubit<GetWeighingListState> {
  final VizRepository _repository;
  List<Weighing> _allWeighings = [];

  GetWeighingListCubit(this._repository)
      : super(const GetWeighingListInitial());

  Future<void> getWeighingList() async {
    emit(const GetWeighingListLoading());
    final result = await _repository.getWeighingList();

    result.fold(
      (failure) => emit(GetWeighingListFailure(failure)),
      (weighingList) {
        _allWeighings = weighingList;
        // Par défaut, filtrer par "D'aujourd'hui" (ID = "1")
        final filteredList = DateFilters.applyFilter("1", _allWeighings);
        emit(GetWeighingListSuccess(filteredList, currentFilterID: "1"));
      },
    );
  }

  /// Filtre les pesées selon l'ID du filtre sélectionné
  void filterWeighings(
    String filterID, {
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    if (state is! GetWeighingListSuccess) return;

    final filteredList = DateFilters.applyFilter(
      filterID,
      _allWeighings,
      customStartDate: customStartDate,
      customEndDate: customEndDate,
    );

    emit(GetWeighingListSuccess(
      filteredList,
      currentFilterID: filterID,
      customStartDate: customStartDate,
      customEndDate: customEndDate,
    ));
  }

  /// Retourne la liste complète (sans filtre)
  void showAllWeighings() {
    emit(GetWeighingListSuccess(_allWeighings, currentFilterID: "0"));
  }
}
