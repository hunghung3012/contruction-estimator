import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../common/utils/logger.dart';
import '../../domain/repository/estimate_repository.dart';
import 'estimate_actions_state.dart';

@injectable
class EstimateActionsCubit extends Cubit<EstimateActionsState> {
  final EstimateRepository _repository;

  EstimateActionsCubit(this._repository) : super(const EstimateActionsState());

  void convertToInvoice(String estimateId) async {
    emit(state.copyWith(isConverting: true, error: null, success: false));

    final result = await _repository.convertToInvoice(estimateId);
    result.fold(
      (success) {
        emit(state.copyWith(isConverting: false, success: true));
      },
      (error) {
        logger.e("Error converting to invoice: $error");
        emit(state.copyWith(isConverting: false, error: error.toString()));
      },
    );
  }

  void convertToProposal(String estimateId) async {
    emit(state.copyWith(isConverting: true, error: null, success: false));

    final result = await _repository.convertToProposal(estimateId);
    result.fold(
      (success) {
        emit(state.copyWith(isConverting: false, success: true));
      },
      (error) {
        logger.e("Error converting to proposal: $error");
        emit(state.copyWith(isConverting: false, error: error.toString()));
      },
    );
  }
}
