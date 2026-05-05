part of 'invoice_detail_page.dart';

extension _InvoiceDetailTabExtension on _InvoiceDetailBodyState {
  Widget _buildInvoiceTab(InvoiceDetailState state) {
    return Column(
      children: [
        SizedBox(height: 16.h),

        _CompanyCard(
          companyNameController: _companyNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          addressController: _addressController,
        ),
        SizedBox(height: 20.h),

        _ClientCard(),

        SizedBox(height: 20.h),
        // Title field
        AppTextField(
          controller: _titleController,
          hintText: context.s.untitled_template,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          textColor: Colors.grey.shade600,
          hintTextColor: Colors.grey.shade400,
          filled: false,
        ),

        SizedBox(height: 12.h),
        DateDropdown(
          initialDate: context
              .read<InvoiceDetailCubit>()
              .state
              .invoice
              ?.dueDate,
          onChanged: (date) {
            context.read<InvoiceDetailCubit>().onChangeDueDate(date);
          },
        ),
        SizedBox(height: 20.h),
        CurrencyTextField(
          controller: _currencyController,
          label: context.s.currency_unit,
        ),
        SizedBox(height: 20.h),
        _ItemsListView(
          items: state.invoice?.items ?? [],
          currencyUnit: state.currencyUnit,
        ),
        SizedBox(height: 20.h),
        _PriceCard(
          subtotal: state.invoice?.subtotal ?? 0,
          discountController: _discountController,
          taxController: _taxController,
          currencyUnit: state.currencyUnit,
        ),
        SizedBox(height: 20.h),
        const _PaymentWidget(),
        SizedBox(height: 20.h),
        _TermWidget(state.currentTerm),
        SizedBox(height: 20.h),
        _DescriptionCard(
          noteController: _noteController,
          quillController: _quillController,
        ),
        // SizedBox(height: 30.h),
        // AppButton(
        //   title: context.s.save,
        //   isButtonDisabled: !state.isEditting,
        //   isLoading: state.isLoading,
        //   onPressed: () async {
        //     if (widget.invoice.isNull) {
        //       await context.read<InvoiceDetailCubit>().createInvoice();
        //     } else {
        //       await context.read<InvoiceDetailCubit>().updateInvoice();
        //     }
        //   },
        // ),
        SizedBox(height: 24.h),
        AppButton(
          title: context.s.send,
          buttonType: ButtonType.outline,
          onPressed: () {
            //TODO: Send invoice Action
          },
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
