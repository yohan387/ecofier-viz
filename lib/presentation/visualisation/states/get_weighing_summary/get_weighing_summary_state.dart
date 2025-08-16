part of 'get_weighing_summary_cubit.dart';

sealed class GetWeighingSummaryState extends Equatable {
  const GetWeighingSummaryState();

  @override
  List<Object> get props => [];
}

final class GetWeighingSummaryInitial extends GetWeighingSummaryState {
  const GetWeighingSummaryInitial();
}

final class GetWeighingSummaryLoading extends GetWeighingSummaryState {
  const GetWeighingSummaryLoading();
}

final class GetWeighingSummarySuccess extends GetWeighingSummaryState {
  final WeighingSummary summary;

  const GetWeighingSummarySuccess(this.summary);

  @override
  List<Object> get props => [summary];
}

final class GetWeighingSummaryFailure extends GetWeighingSummaryState {
  final Failure failure;

  const GetWeighingSummaryFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
