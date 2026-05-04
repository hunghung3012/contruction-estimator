part of 'invoice_detail_page.dart';

extension _InvoiceDetailClientTabExtension on _InvoiceDetailBodyState {
  Widget _buildClientTab(InvoiceDetailState state) {
    final invoice = state.invoice;

    double summerRowWidth = 200.w;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: ColorName.primary,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    context.watch<InvoiceDetailCubit>().state.logoFile != null
                        ? ClipOval(
                            child: Image.file(
                              context
                                  .watch<InvoiceDetailCubit>()
                                  .state
                                  .logoFile!,
                              width: 80.w,
                              height: 80.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            (invoice?.companyName?.isNullOrEmpty ?? true)
                                ? context.s.company_name
                                : invoice!.companyName!,
                            textColor: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.right,
                            padding: EdgeInsets.only(bottom: 16.h),
                          ),
                          AppText(
                            (invoice?.address?.isNullOrEmpty ?? true)
                                ? context.s.address
                                : invoice?.address,
                            textColor: Colors.white,
                            fontSize: 12,
                            textAlign: TextAlign.right,
                            padding: EdgeInsets.only(bottom: 4.h),
                          ),
                          AppText(
                            (invoice?.phone?.isNullOrEmpty ?? true)
                                ? context.s.phone_number
                                : invoice?.phone,
                            textColor: Colors.white,
                            fontSize: 12,
                            textAlign: TextAlign.right,
                            padding: EdgeInsets.only(bottom: 4.h),
                          ),
                          AppText(
                            (invoice?.email?.isNullOrEmpty ?? true)
                                ? context.s.email
                                : invoice!.email!,
                            textColor: Colors.white,
                            fontSize: 12,
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Info Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppText(
                        (invoice?.title ?? context.s.invoice).toUpperCase(),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        maxLines: 2,
                        enableAutoResize: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _buildInfoRow(
                  context.s.invoice_no,
                  invoice?.number ?? context.s.enter_invoice_no,
                ),
                _buildInfoRow(
                  context.s.date,
                  invoice?.dueDate != null ? invoice!.dueDate!.localized : '',
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(context.s.bill_to, fontWeight: FontWeight.bold),
                      SizedBox(height: 4.h),
                      AppText(context.s.client, fontSize: 12),
                      AppText(context.s.address, fontSize: 12),
                      AppText(context.s.phone_number, fontSize: 12),
                      AppText(context.s.email, fontSize: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Table Header
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade400, width: 1.5),
                bottom: BorderSide(color: Colors.grey.shade400, width: 1.5),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AppText(
                    context.s.item,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AppText(
                    context.s.description,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AppText(
                    context.s.quantity,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: AppText(
                    context.s.unit,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AppText(
                    context.s.unit_price,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AppText(
                    context.s.total_price,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Table Body
          if (invoice?.items != null)
            ...invoice!.items!.asMap().entries.map((e) {
              final index = e.key + 1;
              final item = e.value;
              final isEven = e.key % 2 == 0;
              return Container(
                color: isEven ? Colors.grey.shade200 : Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AppText(
                        '$index',
                        fontSize: 12,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: AppText(
                        item.name ?? '',
                        fontSize: 12,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: AppText(
                        '${item.quantity ?? 0}',
                        fontSize: 12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: AppText(
                        item.measurementUnit ?? '',
                        fontSize: 12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: AppText(
                        '${state.currencyUnit}${(item.price ?? 0).toStringAsFixed(2)}',
                        fontSize: 12,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: AppText(
                        '${state.currencyUnit}${((item.quantity ?? 0) * (item.price ?? 0)).toStringAsFixed(2)}',
                        fontSize: 12,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),

          if (invoice?.items == null || invoice!.items!.isEmpty)
            ...List.generate(4, (index) {
              final isEven = index % 2 == 0;
              return Container(
                height: 30.h,
                color: isEven ? Colors.grey.shade200 : Colors.white,
              );
            }),

          // Summary Section
          Padding(
            padding: EdgeInsets.only(top: 24.h, right: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSummaryRow(
                      context.s.subtotal,
                      '${state.currencyUnit}${invoice?.subtotal}',
                      summerRowWidth,
                    ),
                    if ((invoice?.discountPercent ?? 0) > 0)
                      _buildSummaryRow(
                        context.s.discount,
                        '${invoice?.discountPercent}%',
                        summerRowWidth,
                      ),
                    if ((invoice?.discountAmount ?? 0) > 0)
                      _buildSummaryRow(
                        context.s.discount,
                        '${state.currencyUnit}${invoice?.discountAmount}',
                        summerRowWidth,
                      ),

                    if ((invoice?.discountValue ?? 0) > 0 &&
                        (invoice?.discountPercent ?? 0) > 0)
                      _buildSummaryRow(
                        context.s.total_discount,
                        '${state.currencyUnit}${invoice?.discountValue}',
                        summerRowWidth,
                      ),

                    if ((invoice?.taxPercent ?? 0) > 0)
                      _buildSummaryRow(
                        context.s.tax_rate,
                        '${invoice?.taxPercent}%',
                        summerRowWidth,
                      ),
                    if ((invoice?.taxAmount ?? 0) > 0)
                      _buildSummaryRow(
                        context.s.total_tax,
                        '${state.currencyUnit}${invoice?.taxAmount}',
                        summerRowWidth,
                      ),
                    SizedBox(
                      width: summerRowWidth,
                      child: Divider(color: ColorName.grayAA, thickness: 0.5),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: SizedBox(
                        width: summerRowWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppText(
                              context.s.total,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(width: 24.w),
                            Expanded(
                              child: Container(
                                color: ColorName.primary.withValues(alpha: 0.2),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 4.h,
                                ),
                                child: AppText(
                                  '${state.currencyUnit}${invoice?.total}',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  textAlign: TextAlign.right,
                                  enableAutoResize: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //Term
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((invoice?.description ?? '').isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Divider(color: ColorName.grayAA, thickness: 0.5),
                  SizedBox(height: 12.h),
                  AppText(
                    context.s.description,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4.h),
                  MarkdownBody(
                    data: invoice?.description ?? '',
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontSize: 12.sp),
                    ),
                  ),

                  SizedBox(height: 16.h),
                ],

                if (state.currentTerm != null &&
                    (state.currentTerm?.markdownContent ?? '').isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  Divider(color: ColorName.grayAA, thickness: 0.5),
                  SizedBox(height: 12.h),
                  AppText(
                    context.s.terms_and_conditions,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4.h),
                  MarkdownBody(
                    data: state.currentTerm?.markdownContent ?? '',
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ] else if ((invoice?.termsAndConditions ?? '')
                    .isNotNullOrEmpty) ...[
                  SizedBox(height: 24.h),
                  AppText(
                    context.s.terms_and_conditions,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    invoice?.termsAndConditions ?? '',
                    fontSize: 12,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16.h),
                ],

                if ((invoice?.note ?? '').isNotEmpty) ...[
                  Divider(color: ColorName.grayAA, thickness: 0.5),
                  SizedBox(height: 12.h),
                  AppText(
                    context.s.notes,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    invoice?.note ?? '',
                    fontSize: 12,
                    textAlign: TextAlign.left,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: AppText(
              title,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: AppText(
              value,
              fontSize: 12,
              textColor: Colors.grey[800],
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: AppText(
                title,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                textAlign: TextAlign.left,
                enableAutoResize: true,
              ),
            ),
            SizedBox(
              width: 80.w,
              child: AppText(
                value,
                fontSize: 12,
                textAlign: TextAlign.right,
                enableAutoResize: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
