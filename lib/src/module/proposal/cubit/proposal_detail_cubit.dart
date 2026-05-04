import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../estimate/domain/model/estimate.dart';
import '../domain/model/proposal.dart';
import '../data/repository/proposal_repository.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../core/datasource/local/hive/logo_hive_repository.dart';

part 'proposal_detail_state.dart';
part 'proposal_detail_cubit.freezed.dart';

enum ProposalTab { proposal, preview }

@injectable
class ProposalDetailCubit extends Cubit<ProposalDetailState> {
  final ProposalRepository _repository;

  ProposalDetailCubit(this._repository) : super(const ProposalDetailState()) {
    _init();
  }

  static const bool _isSimulated = false;

  final _mockProposal = Proposal(
    discountPercent: 10,
    discountAmount: 100,
    taxPercent: 5,
    id: 'mock-123',
    title: 'Biệt thự sân vườn hiện đại',
    clientMessage:
        'Chào anh/chị, đây là bản đề xuất sơ bộ cho dự án cải tạo sân vườn biệt thự tại Quận 2.',
    introduction:
        '### Giới thiệu dự án\nDự án tập trung vào việc tạo ra không gian xanh, hiện đại và thư giãn cho gia đình. Chúng tôi sử dụng các vật liệu cao cấp và giải pháp thông minh để tối ưu hóa không gian.',
    overview:
        '### Tổng quan quy trình\n1. Khảo sát thực tế\n2. Thiết kế 3D\n3. Thi công phần thô\n4. Lắp đặt hệ thống tưới và chiếu sáng\n5. Hoàn thiện cảnh quan.',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 30)),
    warranty:
        'Bảo hành 12 tháng cho toàn bộ công trình và 24 tháng cho hệ thống kỹ thuật.',
    exclusion:
        'Không bao gồm chi phí san lấp mặt bằng nếu phát hiện nền yếu ngoài dự kiến.',
    paymentTerm:
        'Thanh toán làm 3 đợt: 30% khi ký hợp đồng, 40% sau khi xong phần thô, 30% sau khi bàn giao.',
    paymentInfor:
        'Ngân hàng Techcombank - STK: 123456789 - Chủ TK: Công ty Xây dựng ABC',
    note:
        'Giá trên chưa bao gồm thuế VAT 10%. Đề xuất có hiệu lực trong vòng 15 ngày.',
    scopeOfWork: [
      ScopeOfWork(
        name: 'Gói thi công cảnh quan cao cấp',
        price: 150000000,
        currencyUnit: 'VNĐ',
        works: [
          ProposalWork(
            name: 'Hạng mục xây dựng cơ bản',
            items: [
              EstimateItem(
                name: 'Xây bồn hoa gạch thẻ',
                quantity: 10,
                unit: 'm2',
                price: 550000,
              ),
              EstimateItem(
                name: 'Lát đá granite lối đi',
                quantity: 25,
                unit: 'm2',
                price: 1200000,
              ),
            ],
          ),
          ProposalWork(
            name: 'Hạng mục cây xanh & hệ thống tưới',
            items: [
              EstimateItem(
                name: 'Cây lộc vừng cổ thụ',
                quantity: 2,
                unit: 'Cây',
                price: 15000000,
              ),
              EstimateItem(
                name: 'Hệ thống tưới thông minh',
                quantity: 1,
                unit: 'Gói',
                price: 12500000,
              ),
            ],
          ),
        ],
      ),
    ],
  );

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
        proposal: shouldSetInitial
            ? (_isSimulated ? _mockProposal : Proposal())
            : currentProposal,
        initialProposal: shouldSetInitial
            ? (_isSimulated ? _mockProposal : Proposal())
            : currentProposal,
      ),
    );
  }

  void transferProposal(Proposal proposal) {
    emit(state.copyWith(proposal: proposal, initialProposal: proposal));
  }

  void onChangeTab(ProposalTab tab) {
    emit(state.copyWith(tab: tab));
  }

  void onChangeCompanyName(String value) {
    emit(state.copyWith(proposal: state.proposal?.copyWith(companyName: value)));
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
    final proposal = state.proposal;
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
}

extension ProposalCopyWith on Proposal {
  Proposal copyWith({
    String? id,
    String? userId,
    String? projectId,
    String? clientId,
    String? title,
    String? clientMessage,
    String? introduction,
    String? overview,
    String? companyName,
    String? email,
    String? phone,
    String? address,
    DateTime? dueDate,
    int? taxPercent,
    int? discountPercent,
    int? discountAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? paymentTerm,
    String? exclusion,
    String? warranty,
    String? term,
    String? paymentInfor,
    String? note,
    String? sourceEstimateId,
    List<ScopeOfWork>? scopeOfWork,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Proposal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      clientMessage: clientMessage ?? this.clientMessage,
      introduction: introduction ?? this.introduction,
      overview: overview ?? this.overview,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dueDate: dueDate ?? this.dueDate,
      taxPercent: taxPercent ?? this.taxPercent,
      discountPercent: discountPercent ?? this.discountPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      paymentTerm: paymentTerm ?? this.paymentTerm,
      exclusion: exclusion ?? this.exclusion,
      warranty: warranty ?? this.warranty,
      term: term ?? this.term,
      paymentInfor: paymentInfor ?? this.paymentInfor,
      note: note ?? this.note,
      sourceEstimateId: sourceEstimateId ?? this.sourceEstimateId,
      scopeOfWork: scopeOfWork ?? this.scopeOfWork,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
