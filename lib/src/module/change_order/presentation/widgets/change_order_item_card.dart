part of '../change_order_page.dart';

class _ChangeOrderItemCard extends StatelessWidget {
  const _ChangeOrderItemCard({
    required this.item,
    this.onDelete,
    this.canEdit = true,
  });

  final ChangeOrderItem item;
  final VoidCallback? onDelete;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final isRemove = item.changeType == ChangeOrderType.remove;
    final accentColor = isRemove ? Colors.red : Colors.green;
    final qty = item.quantity ?? 0;
    final price = item.price ?? 0;
    final total = qty * price;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorName.whiteEE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: AppText(
                  isRemove
                      ? context.s.change_type_remove
                      : context.s.change_type_add,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  textColor: accentColor,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: AppText(
                  item.name ?? '',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  textColor: ColorName.black07,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                ),
              ),
              if (canEdit)
                PullDownButton(
                  itemBuilder: (_) => [
                    PullDownMenuItem(
                      onTap: onDelete,
                      title: context.s.delete,
                      isDestructive: true,
                      icon: CupertinoIcons.delete,
                    ),
                  ],
                  buttonBuilder: (_, showMenu) => GestureDetector(
                    onTap: showMenu,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 4.h,
                      ),
                      child: Icon(
                        Icons.more_vert_rounded,
                        size: 20.sp,
                        color: ColorName.gray55,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: AppText(
                  '$qty ${item.measurementUnit ?? ''} × ${price.formattedPrice} ${item.unit ?? ''}',
                  fontSize: 12,
                  textColor: ColorName.gray55,
                  textAlign: TextAlign.left,
                ),
              ),
              AppText(
                '${total.formattedPrice} ${item.unit ?? ''}',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                textColor: accentColor,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
