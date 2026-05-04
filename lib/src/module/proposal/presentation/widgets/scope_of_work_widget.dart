part of '../proposal_detail_page.dart';

class ScopeOfWorkWidget extends StatelessWidget {
  final List<ScopeOfWork>? scopes;

  const ScopeOfWorkWidget({super.key, this.scopes});

  @override
  Widget build(BuildContext context) {
    if (scopes == null || scopes?.isEmpty == true) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...scopes!.map((scope) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (scope.name != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: AppText(
                    scope.name!,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    textColor: ColorName.primary,
                  ),
                ),
              ...?scope.works?.map((work) => _ProposalWorkItem(work: work)),

              // Total price summary
              if (scope.price != null)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.h),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: ColorName.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: ColorName.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        'Tổng cộng:',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      AppText(
                        '${scope.price!.toDouble().formattedPrice} ${scope.currencyUnit ?? 'VNĐ'}',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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

class _ProposalWorkItem extends StatefulWidget {
  final ProposalWork work;

  const _ProposalWorkItem({required this.work});

  @override
  State<_ProposalWorkItem> createState() => _ProposalWorkItemState();
}

class _ProposalWorkItemState extends State<_ProposalWorkItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final totalWorkPrice =
        widget.work.items?.fold<double>(
          0,
          (prev, element) =>
              prev + ((element.price ?? 0) * (element.quantity ?? 0)),
        ) ??
        0;
    final itemsCount = widget.work.items?.length ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                  bottom: Radius.circular(_isExpanded ? 0 : 12.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          widget.work.name ?? '',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        AppText(
                          '$itemsCount items',
                          fontSize: 12,
                          textColor: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                  AppText(
                    totalWorkPrice.formattedPrice,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // Items list
          if (_isExpanded)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemsCount,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final item = widget.work.items![index];
                return Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              item.name ?? '',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            SizedBox(height: 4.h),
                            AppText(
                              '${item.quantity} x ${item.price?.toDouble().formattedPrice} / ${item.unit}',
                              fontSize: 12,
                              textColor: Colors.grey.shade500,
                            ),
                          ],
                        ),
                      ),
                      AppText(
                        ((item.price ?? 0) * (item.quantity ?? 0))
                            .toDouble()
                            .formattedPrice,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
