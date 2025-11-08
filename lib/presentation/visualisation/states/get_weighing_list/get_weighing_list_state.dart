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
  final String currentFilterID;
  final DateTime? customStartDate;
  final DateTime? customEndDate;

  const GetWeighingListSuccess(
    this.weighings, {
    this.currentFilterID = "1", // Par défaut: D'aujourd'hui
    this.customStartDate,
    this.customEndDate,
  });

  @override
  List<Object> get props => [weighings, currentFilterID];

  GetWeighingListSuccess copyWith({
    List<Weighing>? weighings,
    String? currentFilterID,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    return GetWeighingListSuccess(
      weighings ?? this.weighings,
      currentFilterID: currentFilterID ?? this.currentFilterID,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
    );
  }
}

final class GetWeighingListFailure extends GetWeighingListState {
  final Failure failure;

  const GetWeighingListFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
