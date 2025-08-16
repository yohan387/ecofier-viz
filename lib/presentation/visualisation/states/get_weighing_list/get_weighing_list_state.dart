part of 'get_weighing_list_cubit.dart';

sealed class GetWeighingListState extends Equatable {
  const GetWeighingListState();

  @override
  List<Object> get props => [];
}

final class GetWeighingListInitial extends GetWeighingListState {
  const GetWeighingListInitial();
}

final class GetWeighingListLoading extends GetWeighingListState {
  const GetWeighingListLoading();
}

final class GetWeighingListSuccess extends GetWeighingListState {
  final List<Weighing> summaries;

  const GetWeighingListSuccess(this.summaries);

  @override
  List<Object> get props => [summaries];
}

final class GetWeighingListFailure extends GetWeighingListState {
  final Failure failure;

  const GetWeighingListFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
