part of '../project_page.dart';

class _StatusBottomSheet extends StatelessWidget {
  final Project project;
  final List<ProjectStatus> statuses;
  final Function(ProjectStatus) onStatusSelected;
  final VoidCallback onAddStatus;
  final Function(ProjectStatus) onUpdateStatus;
  final Function(ProjectStatus) onDeleteStatus;

  const _StatusBottomSheet({
    required this.project,
    required this.statuses,
    required this.onStatusSelected,
    required this.onAddStatus,
    required this.onUpdateStatus,
    required this.onDeleteStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: ColorName.whiteEE,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                AppCircleButton(
                  icon: Icon(Icons.close, size: 18.sp, color: ColorName.gray55),
                  onTap: () => Navigator.pop(context),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  padding: 9.w,
                ),
                Expanded(
                  child: Center(
                    child: AppText(
                      context.s.status,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AppCircleButton(
                  icon: Icon(Icons.add, size: 18.sp, color: ColorName.gray55),
                  onTap: onAddStatus,
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  padding: 9.w,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: ColorName.grayF0),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: statuses.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: ColorName.grayF3, indent: 56.w),
              itemBuilder: (context, index) {
                final status = statuses[index];
                final isSelected = project.projectStatus?.id == status.id;

                return InkWell(
                  onTap: () {
                    onStatusSelected(status);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.radio_button_unchecked,
                          color: status.color,
                          size: 24.w,
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: AppText(
                            status.name ?? '',
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            textColor: isSelected
                                ? ColorName.black33
                                : ColorName.gray77,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check, color: Colors.green, size: 20.w),
                        SizedBox(width: 8.w),
                        AppCircleButton(
                          icon: Icon(
                            CupertinoIcons.pencil,
                            size: 16.sp,
                            color: ColorName.black,
                          ),
                          onTap: () => onUpdateStatus(status),
                          margin: EdgeInsets.zero,
                          padding: 5.w,
                        ),
                        if ((status.count ?? 0) == 0)
                          AppCircleButton(
                            icon: Icon(
                              CupertinoIcons.trash,
                              size: 16.sp,
                              color: Colors.red,
                            ),
                            onTap: () => onDeleteStatus(status),
                            margin: EdgeInsets.only(left: 4.w),
                            padding: 5.w,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
        ],
      ),
    );
  }
}
