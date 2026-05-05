import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../estimate/domain/model/estimate.dart';
import '../../client/domain/model/client.dart';
import '../../client/cubit/client_cubit.dart';
import '../domain/model/proposal.dart';
import '../data/repository/proposal_repository.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../core/datasource/local/hive/logo_hive_repository.dart';
import '../../../core/datasource/local/hive/term_hive_repository.dart';

part 'proposal_detail_state.dart';
part 'proposal_detail_cubit.freezed.dart';

enum ProposalTab { proposal, preview }

@injectable
class ProposalDetailCubit extends Cubit<ProposalDetailState> {
  final ProposalRepository _repository;

  ProposalDetailCubit(this._repository) : super(const ProposalDetailState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(isLoading: true));

    // Load logo from Hive
    File? logoFile;
    final logoBytes = getIt<LogoHiveRepository>().get();
    if (logoBytes != null) {
      final tempDir = await getTemporaryDirectory();
      logoFile = File('${tempDir.path}/company_logo.png');
      await logoFile.writeAsBytes(logoBytes);
    }

    // Only set proposal if it's currently null or empty (e.g. not transferred from another screen)
    final currentProposal = state.proposal;
    final shouldSetInitial =
        currentProposal == null || currentProposal.id == null;

    emit(
      state.copyWith(
        isLoading: false,
        logoFile: logoFile,
        proposal: shouldSetInitial ? Proposal() : currentProposal,
        initialProposal: shouldSetInitial ? Proposal() : currentProposal,
      ),
    );
  }

  void transferProposal(Proposal proposal) {
    TermModel? initialTerm;
    if (proposal.term != null) {
      initialTerm = TermModel(
        id: '',
        title: '',
        markdownContent: proposal.term!,
      );
    }
    emit(
      state.copyWith(
        proposal: proposal,
        initialProposal: proposal,
        currentTerm: initialTerm,
        selectedClient: getIt<ClientCubit>().getClientById(proposal.clientId),
      ),
    );
  }

  void onChangeTab(ProposalTab tab) {
    emit(state.copyWith(tab: tab));
  }

  void onChangeCompanyName(String value) {
    emit(
      state.copyWith(proposal: state.proposal?.copyWith(companyName: value)),
    );
  }

  void onChangeEmail(String value) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(email: value)));
  }

  void onChangePhoneNumber(String value) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(phone: value)));
  }

  void onChangeAddress(String value) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(address: value)));
  }

  Future<void> pickLogoImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final tempDir = await getTemporaryDirectory();
      final logoFile = File('${tempDir.path}/company_logo.png');
      final bytes = await image.readAsBytes();
      await logoFile.writeAsBytes(bytes);

      await getIt<LogoHiveRepository>().save(logoFile);

      emit(state.copyWith(logoFile: logoFile));
    }
  }

  void onChangeTitle(String value) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(title: value)));
  }

  void onChangeIntroduction(String value) {
    emit(
      state.copyWith(proposal: state.proposal?.copyWith(introduction: value)),
    );
  }

  void onChangeOverview(String value) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(overview: value)));
  }

  void onChangeClientMessage(String value) {
    emit(
      state.copyWith(proposal: state.proposal?.copyWith(clientMessage: value)),
    );
  }

  void onChangeWarranty(String value) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(warranty: value)));
  }

  void onChangeExclusion(String value) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(exclusion: value)));
  }

  void onChangePaymentTerm(String value) {
    emit(
      state.copyWith(proposal: state.proposal?.copyWith(paymentTerm: value)),
    );
  }

  void onChangePaymentInfo(String value) {
    emit(
      state.copyWith(proposal: state.proposal?.copyWith(paymentInfor: value)),
    );
  }

  void onChangeNote(String value) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(note: value)));
  }

  void onChangeTerm(TermModel? term) {
    if (state.currentTerm?.id == term?.id) return;
    emit(state.copyWith(currentTerm: term));
  }

  void onChangeClient(Client? client) {
    if (state.selectedClient?.id == client?.id) return;
    emit(
      state.copyWith(
        selectedClient: client,
        proposal: state.proposal?.copyWith(clientId: client?.id),
      ),
    );
  }

  void onChangeStartDate(DateTime date) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(startDate: date)));
  }

  void onChangeEndDate(DateTime date) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(endDate: date)));
  }

  void onChangeTax(String value) {
    final tax = int.tryParse(value) ?? 0;
    emit(state.copyWith(proposal: state.proposal?.copyWith(taxPercent: tax)));
  }

  void onChangeDiscountPercent(String value) {
    final discount = int.tryParse(value) ?? 0;
    emit(
      state.copyWith(
        proposal: state.proposal?.copyWith(
          discountPercent: discount,
          discountAmount: 0,
        ),
      ),
    );
  }

  void onChangeDiscountAmount(String value) {
    final discount = int.tryParse(value) ?? 0;
    emit(
      state.copyWith(
        proposal: state.proposal?.copyWith(
          discountAmount: discount,
          discountPercent: 0,
        ),
      ),
    );
  }

  Future<void> saveProposal() async {
    if (state.isLoading) return;
    final proposal = state.proposal?.copyWith(
      term: state.currentTerm?.markdownContent,
      clientId: state.selectedClient?.id,
    );
    if (proposal == null) return;

    emit(state.copyWith(isLoading: true));

    final result;
    if (proposal.id != null) {
      result = await _repository.updateProposal(
        proposalId: proposal.id!,
        proposal: proposal,
      );
    } else {
      result = await _repository.createProposal(proposal: proposal);
    }

    result.fold(
      (success) {
        emit(state.copyWith(isLoading: false, initialProposal: proposal));
        // Maybe emit a success state or pop the page
      },
      (failure) {
        emit(state.copyWith(isLoading: false));
        // Maybe emit an error state
      },
    );
  }

  void addScopeOfWork(ScopeOfWork scope) {
    final currentScopes = List<ScopeOfWork>.from(
      state.proposal?.scopeOfWork ?? [],
    );
    currentScopes.add(scope);
    emit(
      state.copyWith(
        proposal: state.proposal?.copyWith(scopeOfWork: currentScopes),
      ),
    );
  }

  void updateScopeOfWork(ScopeOfWork scope) {
    final currentScopes = List<ScopeOfWork>.from(
      state.proposal?.scopeOfWork ?? [],
    );
    final index = currentScopes.indexWhere((s) => s.id == scope.id);
    if (index != -1) {
      currentScopes[index] = scope;
      emit(
        state.copyWith(
          proposal: state.proposal?.copyWith(scopeOfWork: currentScopes),
        ),
      );
    }
  }

  void removeScopeOfWork(String id) {
    final currentScopes = List<ScopeOfWork>.from(
      state.proposal?.scopeOfWork ?? [],
    );
    currentScopes.removeWhere((s) => s.id == id);
    emit(
      state.copyWith(
        proposal: state.proposal?.copyWith(scopeOfWork: currentScopes),
      ),
    );
  }

  void addProposalWork(String scopeId, ProposalWork work) {
    final currentScopes = List<ScopeOfWork>.from(
      state.proposal?.scopeOfWork ?? [],
    );
    final scopeIndex = currentScopes.indexWhere((s) => s.id == scopeId);
    if (scopeIndex != -1) {
      final scope = currentScopes[scopeIndex];
      final currentWorks = List<ProposalWork>.from(scope.works ?? []);
      currentWorks.add(work);
      currentScopes[scopeIndex] = scope.copyWith(works: currentWorks);
      emit(
        state.copyWith(
          proposal: state.proposal?.copyWith(scopeOfWork: currentScopes),
        ),
      );
    }
  }

  void updateProposalWork(String scopeId, ProposalWork work) {
    final currentScopes = List<ScopeOfWork>.from(
      state.proposal?.scopeOfWork ?? [],
    );
    final scopeIndex = currentScopes.indexWhere((s) => s.id == scopeId);
    if (scopeIndex != -1) {
      final scope = currentScopes[scopeIndex];
      final currentWorks = List<ProposalWork>.from(scope.works ?? []);
      final workIndex = currentWorks.indexWhere((w) => w.id == work.id);
      if (workIndex != -1) {
        currentWorks[workIndex] = work;
        currentScopes[scopeIndex] = scope.copyWith(works: currentWorks);
        emit(
          state.copyWith(
            proposal: state.proposal?.copyWith(scopeOfWork: currentScopes),
          ),
        );
      }
    }
  }

  void removeProposalWork(String scopeId, String workId) {
    final currentScopes = List<ScopeOfWork>.from(
      state.proposal?.scopeOfWork ?? [],
    );
    final scopeIndex = currentScopes.indexWhere((s) => s.id == scopeId);
    if (scopeIndex != -1) {
      final scope = currentScopes[scopeIndex];
      final currentWorks = List<ProposalWork>.from(scope.works ?? []);
      currentWorks.removeWhere((w) => w.id == workId);
      currentScopes[scopeIndex] = scope.copyWith(works: currentWorks);
      emit(
        state.copyWith(
          proposal: state.proposal?.copyWith(scopeOfWork: currentScopes),
        ),
      );
    }
  }

  void addEstimateItem(String scopeId, String workId, EstimateItem item) {
    final currentScopes = List<ScopeOfWork>.from(
      state.proposal?.scopeOfWork ?? [],
    );
    final scopeIndex = currentScopes.indexWhere((s) => s.id == scopeId);
    if (scopeIndex != -1) {
      final scope = currentScopes[scopeIndex];
      final currentWorks = List<ProposalWork>.from(scope.works ?? []);
      final workIndex = currentWorks.indexWhere((w) => w.id == workId);
      if (workIndex != -1) {
        final work = currentWorks[workIndex];
        final currentItems = List<EstimateItem>.from(work.items ?? []);
        currentItems.add(item);
        currentWorks[workIndex] = work.copyWith(items: currentItems);
        currentScopes[scopeIndex] = scope.copyWith(works: currentWorks);
        emit(
          state.copyWith(
            proposal: state.proposal?.copyWith(scopeOfWork: currentScopes),
          ),
        );
      }
    }
  }

  void updateEstimateItem(String scopeId, String workId, EstimateItem item) {
    final currentScopes = List<ScopeOfWork>.from(
      state.proposal?.scopeOfWork ?? [],
    );
    final scopeIndex = currentScopes.indexWhere((s) => s.id == scopeId);
    if (scopeIndex != -1) {
      final scope = currentScopes[scopeIndex];
      final currentWorks = List<ProposalWork>.from(scope.works ?? []);
      final workIndex = currentWorks.indexWhere((w) => w.id == workId);
      if (workIndex != -1) {
        final work = currentWorks[workIndex];
        final currentItems = List<EstimateItem>.from(work.items ?? []);
        final itemIndex = currentItems.indexWhere((i) => i.id == item.id);
        if (itemIndex != -1) {
          currentItems[itemIndex] = item;
          currentWorks[workIndex] = work.copyWith(items: currentItems);
          currentScopes[scopeIndex] = scope.copyWith(works: currentWorks);
          emit(
            state.copyWith(
              proposal: state.proposal?.copyWith(scopeOfWork: currentScopes),
            ),
          );
        }
      }
    }
  }

  void removeEstimateItem(String scopeId, String workId, String itemId) {
    final currentScopes = List<ScopeOfWork>.from(
      state.proposal?.scopeOfWork ?? [],
    );
    final scopeIndex = currentScopes.indexWhere((s) => s.id == scopeId);
    if (scopeIndex != -1) {
      final scope = currentScopes[scopeIndex];
      final currentWorks = List<ProposalWork>.from(scope.works ?? []);
      final workIndex = currentWorks.indexWhere((w) => w.id == workId);
      if (workIndex != -1) {
        final work = currentWorks[workIndex];
        final currentItems = List<EstimateItem>.from(work.items ?? []);
        currentItems.removeWhere((i) => i.id == itemId);
        currentWorks[workIndex] = work.copyWith(items: currentItems);
        currentScopes[scopeIndex] = scope.copyWith(works: currentWorks);
        emit(
          state.copyWith(
            proposal: state.proposal?.copyWith(scopeOfWork: currentScopes),
          ),
        );
      }
    }
  }
}
