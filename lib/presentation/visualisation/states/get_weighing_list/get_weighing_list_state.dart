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
  final List<Weighing> weighings;

  const GetWeighingListSuccess(this.weighings);

  @override
  List<Object> get props => [weighings];
}

final class GetWeighingListFailure extends GetWeighingListState {
  final Failure failure;

  const GetWeighingListFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
