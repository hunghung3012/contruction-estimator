part of '../../../proposal_detail_page.dart';

class ProposalWorkCard extends StatefulWidget {
  final String scopeId;
  final ProposalWork work;
  final bool canEdit;

  const ProposalWorkCard({
    super.key,
    required this.work,
    required this.scopeId,
    this.canEdit = true,
  });

  @override
  State<ProposalWorkCard> createState() => _ProposalWorkCardState();
}

class _ProposalWorkCardState extends State<ProposalWorkCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                  bottom: Radius.circular(_isExpanded ? 0 : 12.r),
                ),
              ),
              child: Row(
                children: [
                  if (widget.canEdit)
                    InkWell(
                      onTap: () => _showProposalAddItemBottomSheet(
                        context,
                        scopeId: widget.scopeId,
                        workId: widget.work.id ?? '',
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Icon(
                          Icons.add_circle_outline_rounded,
                          size: 20.sp,
                          color: ColorName.primary,
                        ),
                      ),
                    ),
                  Expanded(
                    child: AppText(
                      widget.work.name ?? '',
                      fontWeight: FontWeight.bold,
                      maxLines: 3,
                      enableAutoResize: true,
                      textAlign: TextAlign.left,
                      fontSize: 12,
                    ),
                  ),
                  AppText(
                    widget.work.price.formattedPrice,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  SizedBox(width: 8.w),
                  if (widget.canEdit)
                    PullDownButton(
                      itemBuilder: (context) => [
                        PullDownMenuItem(
                          enabled: widget.canEdit,
                          onTap: () => _showProposalAddWorkBottomSheet(
                            context,
                            scopeId: widget.scopeId,
                            work: widget.work,
                          ),
                          title: context.s.edit,
                          icon: CupertinoIcons.pencil,
                        ),
                        PullDownMenuItem(
                          enabled: widget.canEdit,
                          onTap: () => context
                              .read<ProposalDetailCubit>()
                              .removeProposalWork(
                                widget.scopeId,
                                widget.work.id ?? '',
                              ),
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
              itemCount: widget.work.itemCount,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final item = widget.work.items![index];
                return ProposalWorkItemCard(
                  scopeId: widget.scopeId,
                  workId: widget.work.id ?? '',
                  item: item,
                  canEdit: widget.canEdit,
                  onEdit: () => _showProposalAddItemBottomSheet(
                    context,
                    scopeId: widget.scopeId,
                    workId: widget.work.id ?? '',
                    item: item,
                  ),
                  onDelete: () =>
                      context.read<ProposalDetailCubit>().removeEstimateItem(
                        widget.scopeId,
                        widget.work.id ?? '',
                        item.id ?? '',
                      ),
                );
              },
            ),
        ],
      ),
    );
  }
}
