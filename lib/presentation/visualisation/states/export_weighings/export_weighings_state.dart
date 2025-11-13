part of 'export_weighings_cubit.dart';

sealed class ExportWeighingsState extends Equatable {
  const ExportWeighingsState();

  @override
  List<Object> get props => [];
}

final class ExportWeighingsInitial extends ExportWeighingsState {
  const ExportWeighingsInitial();
}

final class ExportWeighingsLoading extends ExportWeighingsState {
  final int progress; // 0-100

  const ExportWeighingsLoading(this.progress);

  @override
  List<Object> get props => [progress];
}

final class ExportWeighingsSuccess extends ExportWeighingsState {
  final String filePath;

  const ExportWeighingsSuccess(this.filePath);

  @override
  List<Object> get props => [filePath];
}

final class ExportWeighingsFailure extends ExportWeighingsState {
  final String errorMessage;

  const ExportWeighingsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
