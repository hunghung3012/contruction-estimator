part of '../project_tab.dart';

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTapProjectStatus;

  const _ProjectCard({required this.project, required this.onTapProjectStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorName.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorName.primary.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                project.updatedAt?.localized ??
                    project.createdAt?.localized ??
                    '',
                fontSize: 12,
                textColor: ColorName.gray99,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              Icon(Icons.more_vert, size: 20.w, color: ColorName.black33),
            ],
          ),
          SizedBox(height: 10.h),
          AppText(
            project.name ?? '',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            textColor: ColorName.black33,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 12.h),
          AppText(
            '${project.estimate?.currencyUnit ?? ''} ${(project.estimate?.totalPrice ?? 0).formattedPrice}',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            textColor: ColorName.black07,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: [
              _InfoTag(
                icon: Icons.radio_button_unchecked,
                label: project.projectStatus?.name ?? '',
                onTap: onTapProjectStatus,
                iconColor: project.projectStatus?.color,
              ),
              _InfoTag(
                icon: Icons.person_outline_rounded,
                label: context.s.client,
              ),
              _InfoTag(
                icon: Icons.location_on_outlined,
                label: project.estimate?.location ?? context.s.location,
              ),
              _InfoTag(
                icon: Icons.person_off_outlined,
                label: context.s.no_assignee,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? iconColor;

  const _InfoTag({
    required this.icon,
    required this.label,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: ColorName.grayF0, width: 1.2),
          color: ColorName.whiteFE,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.w, color: iconColor ?? ColorName.gray77),
            SizedBox(width: 6.w),
            AppText(
              label,
              fontSize: 13,
              textColor: ColorName.black33,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectShimmerLoadingCard extends StatelessWidget {
  const _ProjectShimmerLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorName.whiteFE,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorName.grayE8, width: 1),
      ),
      child: Shimmer.fromColors(
        baseColor: ColorName.grayF3,
        highlightColor: ColorName.grayE8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerPlaceholder(height: 14.h, width: 80.w),
                _ShimmerPlaceholder(height: 18.h, width: 18.w, isCircle: true),
              ],
            ),
            SizedBox(height: 10.h),
            _ShimmerPlaceholder(height: 22.h, width: 220.w),
            SizedBox(height: 12.h),
            _ShimmerPlaceholder(height: 28.h, width: 140.w),
            SizedBox(height: 20.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 10.h,
              children: [
                _ShimmerInfoTag(width: 60.w),
                _ShimmerInfoTag(width: 80.w),
                _ShimmerInfoTag(width: 140.w),
                _ShimmerInfoTag(width: 90.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerInfoTag extends StatelessWidget {
  final double width;

  const _ShimmerInfoTag({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: ColorName.grayE8, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ShimmerPlaceholder(height: 16.w, width: 16.w, isCircle: true),
          SizedBox(width: 6.w),
          _ShimmerPlaceholder(height: 13.h, width: width),
        ],
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final bool isCircle;

  const _ShimmerPlaceholder({
    required this.height,
    required this.width,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(30.r),
      ),
    );
  }
}
