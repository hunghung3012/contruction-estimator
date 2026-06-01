import 'package:equatable/equatable.dart';
import '../../domain/model/estimate.dart';

class EstimateSaveOutcome {
  final bool success;
  final bool isCreate;
  final String? errorMessage;

  EstimateSaveOutcome({
    required this.success,
    required this.isCreate,
    this.errorMessage,
  });
}

class EstimateCoreState extends Equatable {
  final Estimate? estimator;
  final Estimate? initialEstimator;
  final bool isSaving;
  final bool isCreating;
  final EstimateSaveOutcome? saveOutcome;

  const EstimateCoreState({
    this.estimator,
    this.initialEstimator,
    this.isSaving = false,
    this.isCreating = false,
    this.saveOutcome,
  });

  bool get isEditting => estimator != initialEstimator;

  @override
  List<Object?> get props => [
    estimator,
    initialEstimator,
    isSaving,
    isCreating,
    saveOutcome,
  ];

  EstimateCoreState copyWith({
    Estimate? estimator,
    Estimate? initialEstimator,
    bool? isSaving,
    bool? isCreating,
    EstimateSaveOutcome? saveOutcome,
    bool clearSaveOutcome = false,
  }) {
    return EstimateCoreState(
      estimator: estimator ?? this.estimator,
      initialEstimator: initialEstimator ?? this.initialEstimator,
      isSaving: isSaving ?? this.isSaving,
      isCreating: isCreating ?? this.isCreating,
      saveOutcome: clearSaveOutcome ? null : (saveOutcome ?? this.saveOutcome),
    );
  }
}
