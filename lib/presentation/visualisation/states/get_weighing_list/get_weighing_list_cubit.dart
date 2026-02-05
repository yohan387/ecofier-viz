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

  /// Getter pour accéder à toutes les pesées (pour l'export)
  List<Weighing> get allWeighings => List.unmodifiable(_allWeighings);

  GetWeighingListCubit(this._repository)
      : super(const GetWeighingListInitial());

  Future<void> getWeighingList() async {
    // Sauvegarder le filtre actuel avant le chargement
    String currentFilterID = "1"; // Par défaut
    DateTime? currentStartDate;
    DateTime? currentEndDate;

    if (state is GetWeighingListSuccess) {
      final successState = state as GetWeighingListSuccess;
      currentFilterID = successState.currentFilterID;
      currentStartDate = successState.customStartDate;
      currentEndDate = successState.customEndDate;
    }

    emit(const GetWeighingListLoading());
    final result = await _repository.getWeighingList();

    result.fold(
      (failure) => emit(GetWeighingListFailure(failure)),
      (weighingList) {
        _allWeighings = weighingList;
        // Appliquer le filtre actuel (ou par défaut "1" si premier chargement)
        final filteredList = DateFilters.applyFilter(
          currentFilterID,
          _allWeighings,
          customStartDate: currentStartDate,
          customEndDate: currentEndDate,
        );
        emit(GetWeighingListSuccess(
          filteredList,
          currentFilterID: currentFilterID,
          customStartDate: currentStartDate,
          customEndDate: currentEndDate,
        ));
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
