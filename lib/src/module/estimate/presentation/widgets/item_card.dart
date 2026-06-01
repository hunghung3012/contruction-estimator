part of '../estimate_detail_page.dart';

class ItemCard extends StatelessWidget {
  final EstimateItem item;
  final String unit;
  final bool canEdit;
  final Function(String id) onEdit;
  final Function(String id) onDelete;

  const ItemCard({
    super.key,
    required this.item,
    required this.unit,
    required this.onEdit,
    required this.onDelete,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    final qty = item.quantity ?? 0;
    final price = item.price ?? 0;

    return Container(
      decoration: BoxDecoration(color: ColorName.whiteEE),
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.symmetric(vertical: 8.h).copyWith(left: 12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.name ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: ColorName.black07,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                ),
                SizedBox(height: 2.h),
                AppText(
                  '${qty.toStringAsFixed(0)} x $unit ${price.formattedPrice}',
                  fontSize: 12,
                  textColor: ColorName.gray55,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          AppText(
            '$unit ${(qty * price).formattedPrice}',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: ColorName.black07,
            textAlign: TextAlign.right,
          ),
          SizedBox(width: 8.w),
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                enabled: canEdit,
                onTap: () => onEdit(item.id ?? ''),
                title: context.s.edit,
                icon: CupertinoIcons.pencil,
              ),
              PullDownMenuItem(
                enabled: canEdit,
                onTap: () => onDelete(item.id ?? ''),
                title: context.s.delete,
                isDestructive: true,
                icon: CupertinoIcons.delete,
              ),
            ],
            buttonBuilder: (context, showMenu) => GestureDetector(
              onTap: showMenu,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                child: Icon(
                  Icons.more_vert_outlined,
                  size: 20.sp,
                  color: ColorName.gray55,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
