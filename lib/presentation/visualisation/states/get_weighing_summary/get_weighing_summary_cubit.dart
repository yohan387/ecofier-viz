import 'package:bloc/bloc.dart';
import 'package:ecofier_viz/core/errors/failures.dart';
import 'package:ecofier_viz/models/weighing_summary.dart';
import 'package:ecofier_viz/repositories/viz_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_weighing_summary_state.dart';

class GetWeighingSummaryCubit extends Cubit<GetWeighingSummaryState> {
  final VizRepository _repository;

  GetWeighingSummaryCubit(this._repository)
      : super(const GetWeighingSummaryInitial());

  Future<void> getWeighingSummary() async {
    emit(const GetWeighingSummaryLoading());
    final result = await _repository.getWeighingSummary();

    result.fold(
      (failure) => emit(GetWeighingSummaryFailure(failure)),
      (summary) => emit(GetWeighingSummarySuccess(summary)),
    );
  }
}
