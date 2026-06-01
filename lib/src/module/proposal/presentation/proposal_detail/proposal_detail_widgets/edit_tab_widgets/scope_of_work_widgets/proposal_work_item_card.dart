part of '../../../proposal_detail_page.dart';

class ProposalWorkItemCard extends StatelessWidget {
  final String scopeId;
  final String workId;
  final EstimateItem item;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProposalWorkItemCard({
    super.key,
    required this.scopeId,
    required this.workId,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
      child: GestureDetector(
        onTap: canEdit ? onEdit : null,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.name ?? '',
                    fontWeight: FontWeight.w600,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                    fontSize: 12,
                    enableAutoResize: true,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    '${item.quantity} x ${item.price?.toDouble().formattedPrice} (${item.measurementUnit})',
                    fontSize: 12,
                    textColor: Colors.grey.shade500,
                    textAlign: TextAlign.left,
                    enableAutoResize: true,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            AppText(
              ((item.price ?? 0) * (item.quantity ?? 0))
                  .toDouble()
                  .formattedPrice,
              fontSize: 12,
            ),
            SizedBox(width: 16.w),
            if (canEdit)
              PullDownButton(
                itemBuilder: (context) => [
                  PullDownMenuItem(
                    enabled: canEdit,
                    onTap: onEdit,
                    title: context.s.edit,
                    icon: CupertinoIcons.pencil,
                  ),
                  PullDownMenuItem(
                    enabled: canEdit,
                    onTap: onDelete,
                    title: context.s.delete,
                    isDestructive: true,
                    icon: CupertinoIcons.delete,
                  ),
                ],
                buttonBuilder: (context, showMenu) => GestureDetector(
                  onTap: showMenu,
                  child: Icon(
                    Icons.more_vert_outlined,
                    size: 20.sp,
                    color: ColorName.gray55,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
