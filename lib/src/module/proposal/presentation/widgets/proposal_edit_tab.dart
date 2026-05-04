part of '../proposal_detail_page.dart';

extension _ProposalEditTabExtension on _ProposalDetailBodyState {
  Widget _buildEditTab(ProposalDetailState state) {
    final s = context.s;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),

        // Company & Client Info
        _CompanyCard(
          companyNameController: _companyNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          addressController: _addressController,
        ),
        SizedBox(height: 20.h),
        const _ClientCard(),
        SizedBox(height: 20.h),

        // Title
        AppTextField(
          controller: _titleController,
          hintText: s.untitled_template,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          textColor: Colors.grey.shade600,
          hintTextColor: Colors.grey.shade400,
          filled: false,
        ),
        SizedBox(height: 20.h),

        // Intro
        _buildSectionTitle(s.introduction),
        _buildRichTextEditor(_introQuillController, s.enter_introduction),
        SizedBox(height: 20.h),

        // Overview
        _buildSectionTitle(s.overview),
        _buildRichTextEditor(_overviewQuillController, s.enter_overview),
        SizedBox(height: 20.h),

        // Scope of Work
        _buildSectionTitle('Phạm vi công việc (Scope of Work)'),
        ScopeOfWorkWidget(scopes: state.proposal?.scopeOfWork),
        SizedBox(height: 20.h),

        // Dates
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                label: s.start_date,
                date: state.proposal?.startDate,
                onChanged: (date) =>
                    context.read<ProposalDetailCubit>().onChangeStartDate(date),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildDatePicker(
                label: s.end_date,
                date: state.proposal?.endDate,
                onChanged: (date) =>
                    context.read<ProposalDetailCubit>().onChangeEndDate(date),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // Client Message
        _buildSectionTitle(s.client_message),
        AppTextField(
          controller: _clientMessageController,
          hintText: s.enter_client_message,
          maxLines: 3,
          borderRadius: BorderRadius.circular(8.r),
        ),
        SizedBox(height: 20.h),

        // Warranty & Exclusion
        _buildSectionTitle(s.warranty),
        AppTextField(
          controller: _warrantyController,
          hintText: s.enter_warranty,
          maxLines: 2,
          borderRadius: BorderRadius.circular(8.r),
        ),
        SizedBox(height: 20.h),

        _buildSectionTitle(s.exclusion),
        AppTextField(
          controller: _exclusionController,
          hintText: s.enter_exclusion,
          maxLines: 2,
          borderRadius: BorderRadius.circular(8.r),
        ),
        SizedBox(height: 20.h),

        // Payment
        _buildSectionTitle(s.payment_term),
        AppTextField(
          controller: _paymentTermController,
          hintText: s.enter_payment_term,
          maxLines: 2,
          borderRadius: BorderRadius.circular(8.r),
        ),
        SizedBox(height: 20.h),

        _buildSectionTitle(s.payment_info),
        AppTextField(
          controller: _paymentInfoController,
          hintText: s.enter_payment_info,
          maxLines: 2,
          borderRadius: BorderRadius.circular(8.r),
        ),
        SizedBox(height: 20.h),

        // Note
        _buildSectionTitle(s.note),
        AppTextField(
          controller: _noteController,
          hintText: s.note,
          maxLines: 2,
          borderRadius: BorderRadius.circular(8.r),
        ),
        SizedBox(height: 20.h),

        // Financial Summary
        _ProposalPriceCard(
          subtotal: state.proposal?.subtotal ?? 0,
          currencyUnit: state.proposal?.currencyUnit ?? '\$',
          discountController: _discountController,
          taxController: _taxController,
        ),

        SizedBox(height: 30.h),

        // Actions
        AppButton(
          title: s.save,
          isButtonDisabled: !state.isEditing,
          isLoading: state.isLoading,
          onPressed: () => context.read<ProposalDetailCubit>().saveProposal(),
        ),
        SizedBox(height: 16.h),
        AppButton(
          title: s.send,
          buttonType: ButtonType.outline,
          onPressed: () {
            // TODO: Send proposal action
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: AppText(
        title,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        textColor: ColorName.primary,
      ),
    );
  }

  Widget _buildRichTextEditor(QuillController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorName.whiteEE),
      ),
      child: Column(
        children: [
          QuillSimpleToolbar(
            controller: controller,
            config: const QuillSimpleToolbarConfig(
              showBoldButton: true,
              showItalicButton: true,
              showListBullets: true,
              showListNumbers: true,
              multiRowsDisplay: false,
              showFontFamily: false,
              showFontSize: false,
              showSmallButton: false,
              showUnderLineButton: false,
              showLineHeightButton: false,
              showStrikeThrough: false,
              showInlineCode: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showClearFormat: false,
              showAlignmentButtons: false,
              showRedo: false,
              showUndo: false,
              showSearchButton: false,
              showCodeBlock: false,
              showQuote: false,
              showLink: false,
              showDividers: false,
              showHeaderStyle: false,
              showListCheck: false,
              showDirection: false,
              showIndent: false,
            ),
          ),
          Container(
            height: 120.h,
            padding: EdgeInsets.all(12.r),
            child: QuillEditor.basic(controller: controller),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required Function(DateTime) onChanged,
  }) {
    final displayText = date != null ? date.localized : context.s.select_date;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: ColorName.whiteEE),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    displayText,
                    fontSize: 14,
                    textColor: date != null ? Colors.black87 : ColorName.gray99,
                    maxLines: 1,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black54,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 12.w,
          top: -8.h,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: AppText(label, fontSize: 12, textColor: ColorName.gray99),
          ),
        ),
      ],
    );
  }
}

class _ProposalPriceCard extends StatefulWidget {
  final String currencyUnit;
  final double subtotal;
  final TextEditingController discountController;
  final TextEditingController taxController;

  const _ProposalPriceCard({
    required this.currencyUnit,
    required this.subtotal,
    required this.discountController,
    required this.taxController,
  });

  @override
  State<_ProposalPriceCard> createState() => _ProposalPriceCardState();
}

class _ProposalPriceCardState extends State<_ProposalPriceCard> {
  bool _isDiscountPercentage = true;

  void _updateDiscount() {
    final text = widget.discountController.text;
    final cubit = context.read<ProposalDetailCubit>();
    if (_isDiscountPercentage) {
      cubit.onChangeDiscountPercent(text);
    } else {
      cubit.onChangeDiscountAmount(text);
    }
  }

  double get _discountValue {
    final val = double.tryParse(widget.discountController.text) ?? 0.0;
    if (_isDiscountPercentage) {
      return widget.subtotal * (val / 100);
    }
    return val;
  }

  double get _taxValue {
    final val = double.tryParse(widget.taxController.text) ?? 0.0;
    return widget.subtotal * (val / 100);
  }

  double get _total {
    double total = widget.subtotal - _discountValue + _taxValue;
    return total < 0 ? 0 : total;
  }

  Widget _buildVerticalSwitcher() {
    return Container(
      width: 60.w,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: ColorName.whiteEE,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() => _isDiscountPercentage = true);
              _updateDiscount();
            },
            child: Container(
              width: 28.w,
              height: 28.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _isDiscountPercentage
                    ? Colors.white
                    : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: _isDiscountPercentage
                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                    : null,
              ),
              child: const AppText(
                '%',
                fontSize: 13,
                textColor: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() => _isDiscountPercentage = false);
              _updateDiscount();
            },
            child: Container(
              width: 28.w,
              height: 28.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !_isDiscountPercentage
                    ? Colors.white
                    : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: !_isDiscountPercentage
                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                    : null,
              ),
              child: AppText(
                widget.currencyUnit,
                fontSize: 13,
                textColor: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorName.whiteEE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(s.subtotal, fontSize: 15, textColor: Colors.black87),
              AppText(
                '${widget.subtotal.formattedPrice} ${widget.currencyUnit}',
                fontSize: 15,
                textColor: Colors.black87,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(color: ColorName.whiteEE, height: 1),
          SizedBox(height: 12.h),

          // Discount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(s.discount, fontSize: 15, textColor: Colors.black87),
              Row(
                children: [
                  AppTextField(
                    width: 100.w,
                    controller: widget.discountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.right,
                    hintText: '0',
                    borderColor: ColorName.whiteEE,
                    borderRadius: BorderRadius.circular(12.r),
                    fillColor: Colors.white,
                    filled: true,
                    onChanged: (val) => _updateDiscount(),
                  ),
                  SizedBox(width: 8.w),
                  _buildVerticalSwitcher(),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Tax
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(s.tax, fontSize: 15, textColor: Colors.black87),
              Row(
                children: [
                  AppTextField(
                    width: 70.w,
                    controller: widget.taxController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.right,
                    hintText: '0',
                    borderColor: ColorName.whiteEE,
                    borderRadius: BorderRadius.circular(12.r),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  SizedBox(width: 8.w),
                  const AppText('%', fontSize: 14, textColor: Colors.black54),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(color: ColorName.whiteEE, height: 1),
          SizedBox(height: 12.h),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                s.total,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textColor: Colors.black,
              ),
              AppText(
                '${_total.formattedPrice} ${widget.currencyUnit}',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
