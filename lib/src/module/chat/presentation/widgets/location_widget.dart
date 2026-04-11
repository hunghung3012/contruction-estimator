part of '../chatting_page.dart';

class _LocationWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String location;

  const _LocationWidget({required this.onTap, required this.location});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14.sp,
              color: ColorName.primary,
            ),
            SizedBox(width: 4.w),
            AppText(
              location,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              textColor: ColorName.gray55,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
