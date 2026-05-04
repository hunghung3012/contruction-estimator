part of '../proposal_detail_page.dart';

extension _ProposalPreviewTabExtension on _ProposalDetailBodyState {
  Widget _buildPreviewTab(ProposalDetailState state) {
    final proposal = state.proposal;
    final s = context.s;

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
          // Header (Company info)
          _buildPreviewHeader(state),

          // Info Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  (proposal?.title?.isNotEmpty == true
                          ? proposal!.title!
                          : s.proposal)
                      .toUpperCase(),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20.h),
                _buildPreviewInfoRow(
                  s.date,
                  proposal?.startDate != null
                      ? proposal!.startDate!.localized
                      : '',
                ),
                if (proposal?.endDate != null)
                  _buildPreviewInfoRow(
                    s.end_date,
                    proposal!.endDate!.localized,
                  ),
                SizedBox(height: 12.h),
                _buildPreviewClientInfo(proposal),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 1),

          // Content sections
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (proposal?.introduction?.isNotEmpty == true) ...[
                  _buildPreviewSectionTitle(s.introduction),
                  _buildMarkdownBody(proposal!.introduction!),
                  SizedBox(height: 20.h),
                ],
                if (proposal?.overview?.isNotEmpty == true) ...[
                  _buildPreviewSectionTitle(s.overview),
                  _buildMarkdownBody(proposal!.overview!),
                  SizedBox(height: 20.h),
                ],
                if (proposal?.scopeOfWork != null &&
                    proposal!.scopeOfWork!.isNotEmpty) ...[
                  _buildPreviewSectionTitle(
                    'Phạm vi công việc (Scope of Work)',
                  ),
                  _buildPreviewScopeOfWork(proposal.scopeOfWork!),
                  SizedBox(height: 20.h),
                ],
                if (proposal?.clientMessage?.isNotEmpty == true) ...[
                  _buildPreviewSectionTitle(s.client_message),
                  AppText(
                    proposal!.clientMessage!,
                    fontSize: 13,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 20.h),
                ],
                if (proposal?.warranty?.isNotEmpty == true) ...[
                  _buildPreviewSectionTitle(s.warranty),
                  AppText(
                    proposal!.warranty!,
                    fontSize: 13,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 20.h),
                ],
                if (proposal?.exclusion?.isNotEmpty == true) ...[
                  _buildPreviewSectionTitle(s.exclusion),
                  AppText(
                    proposal!.exclusion!,
                    fontSize: 13,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 20.h),
                ],
                if (proposal?.paymentTerm?.isNotEmpty == true ||
                    proposal?.paymentInfor?.isNotEmpty == true) ...[
                  _buildPreviewSectionTitle(s.payment_term),
                  if (proposal?.paymentTerm?.isNotEmpty == true)
                    AppText(
                      proposal!.paymentTerm!,
                      fontSize: 13,
                      textAlign: TextAlign.left,
                    ),
                  if (proposal?.paymentInfor?.isNotEmpty == true)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: AppText(
                        proposal!.paymentInfor!,
                        fontSize: 13,
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  SizedBox(height: 20.h),
                ],
                if (proposal?.note?.isNotEmpty == true) ...[
                  _buildPreviewSectionTitle(s.note),
                  AppText(
                    proposal!.note!,
                    fontSize: 13,
                    textAlign: TextAlign.left,
                    fontStyle: FontStyle.italic,
                  ),
                  SizedBox(height: 20.h),
                ],
                _buildFinancialSummary(proposal),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary(Proposal? proposal) {
    if (proposal == null) return const SizedBox.shrink();

    final s = context.s;
    final currencyUnit = proposal.currencyUnit;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            s.subtotal,
            proposal.subtotal.formattedPrice,
            currencyUnit,
          ),
          if (proposal.discountValue > 0)
            _buildSummaryRow(
              s.discount,
              '-${proposal.discountValue.formattedPrice}',
              currencyUnit,
              textColor: Colors.red.shade700,
            ),
          if (proposal.taxValue > 0)
            _buildSummaryRow(
              '${s.tax} (${proposal.taxPercent}%)',
              proposal.taxValue.formattedPrice,
              currencyUnit,
            ),
          const Divider(),
          _buildSummaryRow(
            s.total,
            proposal.total.formattedPrice,
            currencyUnit,
            isBold: true,
            fontSize: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewHeader(ProposalDetailState state) {
    final proposal = state.proposal;
    final s = context.s;

    return Container(
      color: ColorName.primary,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (state.logoFile != null)
            ClipOval(
              child: Image.file(
                state.logoFile!,
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  proposal?.companyName?.isNotNullOrBlank == true
                      ? proposal!.companyName!
                      : s.company_name,
                  textColor: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                  padding: EdgeInsets.only(bottom: 16.h),
                ),
                AppText(
                  proposal?.address?.isNotNullOrBlank == true
                      ? proposal!.address!
                      : s.address,
                  textColor: Colors.white,
                  fontSize: 12,
                  textAlign: TextAlign.right,
                  padding: EdgeInsets.only(bottom: 4.h),
                ),
                AppText(
                  proposal?.phone?.isNotNullOrBlank == true
                      ? proposal!.phone!
                      : s.phone_number,
                  textColor: Colors.white,
                  fontSize: 12,
                  textAlign: TextAlign.right,
                  padding: EdgeInsets.only(bottom: 4.h),
                ),
                AppText(
                  proposal?.email?.isNotNullOrBlank == true
                      ? proposal!.email!
                      : s.email,
                  textColor: Colors.white,
                  fontSize: 12,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewClientInfo(Proposal? proposal) {
    final s = context.s;
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppText(s.bill_to, fontWeight: FontWeight.bold),
          SizedBox(height: 4.h),
          AppText(s.client, fontSize: 12),
          AppText(s.address, fontSize: 12),
          AppText(s.phone_number, fontSize: 12),
          AppText(s.email, fontSize: 12),
        ],
      ),
    );
  }

  Widget _buildPreviewInfoRow(String title, String value) {
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

  Widget _buildSummaryRow(
    String label,
    String value,
    String unit, {
    bool isBold = false,
    double fontSize = 14,
    Color? textColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            textColor: textColor ?? Colors.grey.shade700,
          ),
          AppText(
            '$value $unit',
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            textColor: textColor ?? Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, fontWeight: FontWeight.bold, fontSize: 14),
        Divider(color: Colors.grey.shade300, thickness: 0.5, height: 12.h),
      ],
    );
  }

  Widget _buildMarkdownBody(String data) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: MarkdownBody(
        data: data,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800),
          listBullet: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800),
        ),
      ),
    );
  }

  Widget _buildPreviewScopeOfWork(List<ScopeOfWork> scopes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...scopes.map((scope) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (scope.name != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: AppText(
                    scope.name!,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    textColor: ColorName.primary,
                    textAlign: TextAlign.left,
                  ),
                ),
              ...?scope.works?.map((work) {
                final totalWorkPrice =
                    work.items?.fold<double>(
                      0,
                      (prev, element) =>
                          prev +
                          ((element.price ?? 0) * (element.quantity ?? 0)),
                    ) ??
                    0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            work.name ?? '',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          AppText(
                            totalWorkPrice.formattedPrice,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Column(
                        children: [
                          ...?work.items?.map((item) {
                            final itemTotal =
                                (item.price ?? 0) * (item.quantity ?? 0);
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          item.name ?? '',
                                          fontSize: 12,
                                          textAlign: TextAlign.left,
                                        ),
                                        AppText(
                                          '${item.quantity} x ${item.price?.toDouble().formattedPrice} / ${item.unit}',
                                          fontSize: 11,
                                          textColor: Colors.grey.shade500,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  AppText(
                                    itemTotal.toDouble().formattedPrice,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Divider(
                      height: 16.h,
                      color: Colors.grey.shade100,
                      thickness: 1,
                    ),
                  ],
                );
              }),
              if (scope.price != null)
                Padding(
                  padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        'Tổng ${scope.name ?? ""}:',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      AppText(
                        '${scope.price!.toDouble().formattedPrice} ${scope.currencyUnit ?? 'VNĐ'}',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        textColor: ColorName.primary,
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
