import 'package:equatable/equatable.dart';
import '../../domain/model/estimate.dart';

class EstimateCoreState extends Equatable {
  final Estimate? estimator;
  final Estimate? initialEstimator;
  final bool isSaving;

  const EstimateCoreState({
    this.estimator,
    this.initialEstimator,
    this.isSaving = false,
  });

  bool get isEditting => estimator != initialEstimator;

  @override
  List<Object?> get props => [estimator, initialEstimator, isSaving];

  EstimateCoreState copyWith({
    Estimate? estimator,
    Estimate? initialEstimator,
    bool? isSaving,
  }) {
    return EstimateCoreState(
      estimator: estimator ?? this.estimator,
      initialEstimator: initialEstimator ?? this.initialEstimator,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
