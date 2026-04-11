import 'package:equatable/equatable.dart';

class EstimateActionsState extends Equatable {
  final bool isConverting;
  final String? error;
  final bool success;

  const EstimateActionsState({
    this.isConverting = false,
    this.error,
    this.success = false,
  });

  @override
  List<Object?> get props => [isConverting, error, success];

  EstimateActionsState copyWith({
    bool? isConverting,
    String? error,
    bool? success,
  }) {
    return EstimateActionsState(
      isConverting: isConverting ?? this.isConverting,
      error: error,
      success: success ?? this.success,
    );
  }
}
