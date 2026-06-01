import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../../common/extension/optional_x.dart';
import '../../../../core/app/app_router.dart';
import '../../../../core/datasource/local/hive/term_hive_repository.dart';
import '../../../../core/datasource/local/shared_prederences/storage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:flutter/cupertino.dart';
import '../../../../common/data/measurement.dart';
import '../../../../common/extension/context_x.dart';
import '../../../../common/extension/datetime_x.dart';
import '../../../../common/extension/double_x.dart';
import '../../../../common/extension/markdown_x.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_circle_button.dart';
import '../../../../common/widgets/app_text.dart';
import '../../../../common/widgets/app_textfield.dart';
import '../../../../common/widgets/app_cupertino_alert_dialog.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../client/cubit/client_cubit.dart';
import '../../../client/domain/model/client.dart';
import '../../../estimate/domain/model/estimate.dart';
import '../../cubit/proposal_detail_cubit.dart';
import '../../domain/model/proposal.dart';
import '../../domain/model/proposal_status.dart';

part 'proposal_detail_widgets/proposal_app_bar.dart';
part 'proposal_detail_widgets/proposal_tab_header.dart';
part 'proposal_detail_widgets/proposal_edit_tab.dart';
part 'proposal_detail_widgets/proposal_preview_tab.dart';
part 'proposal_detail_widgets/edit_tab_widgets/scope_of_work_widget.dart';
part 'proposal_detail_widgets/edit_tab_widgets/scrope_of_work_bottomsheet/add_scope_bottom_sheet.dart';
part 'proposal_detail_widgets/edit_tab_widgets/scrope_of_work_bottomsheet/add_work_bottom_sheet.dart';
part 'proposal_detail_widgets/edit_tab_widgets/scrope_of_work_bottomsheet/add_proposal_item_bottom_sheet.dart';
part 'proposal_detail_widgets/edit_tab_widgets/scrope_of_work_bottomsheet/unit_selection_bottom_sheet.dart';
part 'proposal_detail_widgets/edit_tab_widgets/scope_of_work_widgets/proposal_work_card.dart';
part 'proposal_detail_widgets/edit_tab_widgets/scope_of_work_widgets/proposal_work_item_card.dart';
part 'proposal_detail_widgets/edit_tab_widgets/company_card.dart';
part 'proposal_detail_widgets/edit_tab_widgets/client_card.dart';
part 'proposal_detail_widgets/edit_tab_widgets/client_selection_bottom_sheet.dart';
part 'proposal_detail_widgets/edit_tab_widgets/term_widget.dart';

@RoutePage()
class ProposalDetailPage extends StatelessWidget {
  const ProposalDetailPage({super.key, this.proposal});

  final Proposal? proposal;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProposalDetailCubit>(),
      child: ProposalDetailBody(proposal: proposal),
    );
  }
}

class ProposalDetailBody extends StatefulWidget {
  const ProposalDetailBody({super.key, this.proposal});

  final Proposal? proposal;

  @override
  State<ProposalDetailBody> createState() => _ProposalDetailBodyState();
}

class _ProposalDetailBodyState extends State<ProposalDetailBody> {
  late TextEditingController _titleController;
  late TextEditingController _clientMessageController;
  late TextEditingController _warrantyController;
  late TextEditingController _exclusionController;
  late TextEditingController _paymentTermController;
  late TextEditingController _paymentInfoController;
  late TextEditingController _noteController;

  late TextEditingController _companyNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  late TextEditingController _discountController;
  late TextEditingController _taxController;

  late QuillController _introQuillController;
  late QuillController _overviewQuillController;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<ProposalDetailCubit>();
    if (widget.proposal != null) {
      cubit.transferProposal(widget.proposal!);
    }
    final proposal = cubit.state.proposal;

    _companyNameController = TextEditingController(
      text: (widget.proposal.isNull)
          ? AppStorage.companyName
          : proposal?.companyName,
    );
    _emailController = TextEditingController(
      text: (widget.proposal.isNull) ? AppStorage.email : proposal?.email,
    );
    _phoneController = TextEditingController(
      text: (widget.proposal.isNull) ? AppStorage.phone : proposal?.phone,
    );
    _addressController = TextEditingController(
      text: (widget.proposal.isNull) ? AppStorage.address : proposal?.address,
    );

    _titleController = TextEditingController(text: proposal?.title ?? '');
    _clientMessageController = TextEditingController(
      text: proposal?.clientMessage ?? '',
    );
    _warrantyController = TextEditingController(text: proposal?.warranty ?? '');
    _exclusionController = TextEditingController(
      text: proposal?.exclusion ?? '',
    );
    _paymentTermController = TextEditingController(
      text: proposal?.paymentTerm ?? '',
    );
    _paymentInfoController = TextEditingController(
      text: proposal?.paymentInfor ?? '',
    );
    _noteController = TextEditingController(text: proposal?.note ?? '');

    _discountController = TextEditingController(
      text: (proposal?.discountPercent ?? proposal?.discountAmount ?? 0)
          .toString(),
    );
    _taxController = TextEditingController(
      text: proposal?.taxPercent?.toString() ?? '0',
    );

    _introQuillController = QuillController.basic();
    if ((proposal?.introduction ?? '').isNotEmpty) {
      _introQuillController.document = proposal!.introduction!.toDelta();
    }

    _overviewQuillController = QuillController.basic();
    if ((proposal?.overview ?? '').isNotEmpty) {
      _overviewQuillController.document = proposal!.overview!.toDelta();
    }

    _titleController.addListener(
      () => cubit.onChangeTitle(_titleController.text),
    );
    _companyNameController.addListener(
      () => cubit.onChangeCompanyName(_companyNameController.text),
    );
    _emailController.addListener(
      () => cubit.onChangeEmail(_emailController.text),
    );
    _phoneController.addListener(
      () => cubit.onChangePhoneNumber(_phoneController.text),
    );
    _addressController.addListener(
      () => cubit.onChangeAddress(_addressController.text),
    );
    _clientMessageController.addListener(
      () => cubit.onChangeClientMessage(_clientMessageController.text),
    );
    _warrantyController.addListener(
      () => cubit.onChangeWarranty(_warrantyController.text),
    );
    _exclusionController.addListener(
      () => cubit.onChangeExclusion(_exclusionController.text),
    );
    _paymentTermController.addListener(
      () => cubit.onChangePaymentTerm(_paymentTermController.text),
    );
    _paymentInfoController.addListener(
      () => cubit.onChangePaymentInfo(_paymentInfoController.text),
    );
    _noteController.addListener(() => cubit.onChangeNote(_noteController.text));
    _taxController.addListener(() => cubit.onChangeTax(_taxController.text));

    _introQuillController.document.changes.listen((_) {
      cubit.onChangeIntroduction(_introQuillController.document.toMarkdown());
    });
    _overviewQuillController.document.changes.listen((_) {
      cubit.onChangeOverview(_overviewQuillController.document.toMarkdown());
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _clientMessageController.dispose();
    _warrantyController.dispose();
    _exclusionController.dispose();
    _paymentTermController.dispose();
    _paymentInfoController.dispose();
    _noteController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    _introQuillController.dispose();
    _overviewQuillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailCubit, ProposalDetailState>(
      builder: (context, state) {
        final canEdit = state.proposal?.status?.canEdit ?? true;
        return Scaffold(
          appBar: _ProposalAppBar(canEdit),
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              children: [
                _ProposalTabHeader(
                  currentTab: state.tab,
                  onChangeTab: (tab) {
                    context.read<ProposalDetailCubit>().onChangeTab(tab);
                  },
                ),
                Expanded(
                  child: IndexedStack(
                    index: state.tab == ProposalTab.proposal ? 0 : 1,
                    children: [
                      SingleChildScrollView(
                        child: _buildEditTab(state, canEdit),
                      ),
                      SingleChildScrollView(child: _buildPreviewTab(state)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
