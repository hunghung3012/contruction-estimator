part of '../estimate_detail_page.dart';

class CategoryCard extends StatelessWidget {
  final EstimateCategory category;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final bool isExpanded;
  final String unit;
  final bool canEdit;
  final Function(String id) onEditItem;
  final Function(String id) onDeleteItem;
  final Function(String id, String currentName) onEditCategoryName;
  final Function(String id) onDeleteCategory;
  const CategoryCard({
    super.key,
    required this.onTap,
    required this.category,
    required this.onEdit,
    required this.isExpanded,
    required this.unit,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.onEditCategoryName,
    required this.onDeleteCategory,
    this.canEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Category row ────────────────────────────────
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              children: [
                // Name + add icon
                Expanded(
                  child: Row(
                    children: [
                      if (canEdit)
                        InkWell(
                          onTap: onEdit,
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.add_circle_outline_rounded,
                              size: 20.sp,
                              color: ColorName.primary,
                            ),
                          ),
                        ),
                      Expanded(
                        child: AppText(
                          category.name ?? '',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          textColor: ColorName.black07,
                          textAlign: TextAlign.left,
                          maxLines: 5,
                          enableAutoResize: true,
                        ),
                      ),
                      SizedBox(width: 6),
                    ],
                  ),
                ),
                // Total price
                SizedBox(
                  width: 120.w,
                  child: AppText(
                    category.formattedTotalPrice,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    textColor: ColorName.black07,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    enableAutoResize: true,
                  ),
                ),
                SizedBox(width: 8.w),
                PullDownButton(
                  itemBuilder: (context) => [
                    PullDownMenuItem(
                      enabled: canEdit,
                      onTap: () => onEditCategoryName(
                        category.id ?? '',
                        category.name ?? '',
                      ),
                      title: context.s.edit,
                      icon: CupertinoIcons.pencil,
                    ),
                    PullDownMenuItem(
                      enabled: canEdit,
                      onTap: () => onDeleteCategory(category.id ?? ''),
                      title: context.s.delete,
                      isDestructive: true,
                      icon: CupertinoIcons.delete,
                    ),
                  ],
                  buttonBuilder: (context, showMenu) => GestureDetector(
                    onTap: showMenu,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 4.h,
                      ),
                      child: Icon(
                        Icons.more_vert_outlined,
                        size: 20.sp,
                        color: ColorName.gray55,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Expand / collapse chevron
                AnimatedRotation(
                  turns: isExpanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more_rounded,
                    size: 20.sp,
                    color: ColorName.gray55,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Items (expanded) ────────────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...(category.items ?? []).map(
                      (item) => ItemCard(
                        item: item,
                        unit: unit,
                        canEdit: canEdit,
                        onEdit: onEditItem,
                        onDelete: onDeleteItem,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                )
              : const SizedBox.shrink(),
        ),

        Divider(color: ColorName.whiteEE, height: 1),
      ],
    );
  }
}
