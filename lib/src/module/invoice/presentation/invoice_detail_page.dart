import 'package:auto_route/auto_route.dart';
import 'package:construction_estimator/src/common/extension/datetime_x.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../generated/assets.gen.dart';
import '../../../../generated/colors.gen.dart';
import '../../../common/data/currency.dart';
import '../../../common/data/measurement.dart';
import '../../../common/extension/context_x.dart';
import '../../../common/extension/double_x.dart';
import '../../../common/extension/markdown_x.dart';
import '../../../common/extension/optional_x.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_circle_button.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_textfield.dart';
import '../../../common/widgets/app_cupertino_alert_dialog.dart';
import '../../../core/datasource/local/shared_prederences/storage.dart';
import '../../../common/utils/getit_utils.dart';
import '../../../core/datasource/local/hive/term_hive_repository.dart';
import '../../../core/app/app_router.dart';
import '../../estimate/domain/model/estimate.dart';
import '../cubit/invoice_cubit.dart';
import '../cubit/invoice_detail_cubit.dart';
import '../domain/model/invoice.dart';

part 'widgets/client_card.dart';
part 'widgets/company_card.dart';
part 'widgets/description_card.dart';
part 'widgets/invoice_app_bar.dart';
part 'widgets/invoice_tab_widget.dart';
part 'widgets/date_dropdown.dart';
part 'widgets/items_listview.dart';
part 'widgets/price_card.dart';
part 'widgets/payment_widget.dart';
part 'widgets/term_widget.dart';
part 'widgets/currency_textfield.dart';

part 'invoice_detail_client_tab.dart';
part 'invoice_detail_tab.dart';

@RoutePage()
class InvoiceDetailPage extends StatelessWidget {
  const InvoiceDetailPage({super.key, this.invoice});

  final Invoice? invoice;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InvoiceDetailCubit>(),
      child: InvoiceDetailBody(invoice: invoice),
    );
  }
}

class InvoiceDetailBody extends StatefulWidget {
  const InvoiceDetailBody({super.key, this.invoice});

  final Invoice? invoice;

  @override
  State<InvoiceDetailBody> createState() => _InvoiceDetailBodyState();
}

class _InvoiceDetailBodyState extends State<InvoiceDetailBody> {
  late TextEditingController _companyNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  late TextEditingController _noteController;
  late TextEditingController _titleController;

  late TextEditingController _discountController;
  late TextEditingController _taxController;
  late TextEditingController _currencyController;

  late QuillController _quillController;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<InvoiceDetailCubit>();
    if (widget.invoice != null) {
      cubit.transferInvoice(widget.invoice!);
    }
    final invoice = cubit.state.invoice;

    _quillController = QuillController.basic();

    _currencyController = TextEditingController(
      text: widget.invoice?.unit ?? '\$',
    );
    if (widget.invoice != null) {
      cubit.onChangeCurrency(_currencyController.text);
    }

    _companyNameController = TextEditingController(
      text: (widget.invoice.isNull)
          ? AppStorage.companyName
          : invoice?.companyName,
    );
    _titleController = TextEditingController(text: invoice?.title ?? '');
    _emailController = TextEditingController(
      text: (widget.invoice.isNull) ? AppStorage.email : invoice?.email,
    );
    _phoneController = TextEditingController(
      text: (widget.invoice.isNull) ? AppStorage.phone : invoice?.phone,
    );
    _addressController = TextEditingController(
      text: (widget.invoice.isNull) ? AppStorage.address : invoice?.address,
    );
    _noteController = TextEditingController(text: invoice?.note);

    if ((invoice?.description ?? '').isNotEmpty) {
      _quillController.document = (invoice?.description ?? '').toDelta();
    }

    _discountController = TextEditingController(
      text: (invoice?.discountPercent ?? invoice?.discountAmount ?? 0)
          .toString(),
    );
    _taxController = TextEditingController(
      text: invoice?.taxPercent?.toString() ?? '0',
    );

    _currencyController.addListener(() {
      cubit.onChangeCurrency(_currencyController.text);
    });
    _companyNameController.addListener(() {
      cubit.onChangeCompanyName(_companyNameController.text);
    });
    _titleController.addListener(() {
      cubit.onChangeTitle(_titleController.text);
    });
    _emailController.addListener(() {
      cubit.onChangeEmail(_emailController.text);
    });
    _phoneController.addListener(() {
      cubit.onChangePhoneNumber(_phoneController.text);
    });
    _addressController.addListener(() {
      cubit.onChangeAddress(_addressController.text);
    });
    _noteController.addListener(() {
      cubit.onChangeNote(_noteController.text);
    });
    _taxController.addListener(() {
      cubit.onChangeTax(_taxController.text);
    });

    _quillController.document.changes.listen((_) {
      cubit.onChangeDescription(_quillController.document.toMarkdown());
    });
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    _titleController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    _currencyController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _InvoiceAppBar(initialInvoice: widget.invoice),
      backgroundColor: Colors.white,
      body: BlocBuilder<InvoiceDetailCubit, InvoiceDetailState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              children: [
                _InvoiceTabHeader(
                  currentTab: state.tab,
                  onChangeTab: (tab) {
                    context.read<InvoiceDetailCubit>().onChangeTab(tab);
                  },
                ),
                Expanded(
                  child: IndexedStack(
                    index: state.tab == InvoiceTab.invoice ? 0 : 1,
                    children: [
                      SingleChildScrollView(child: _buildInvoiceTab(state)),
                      SingleChildScrollView(child: _buildClientTab(state)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
