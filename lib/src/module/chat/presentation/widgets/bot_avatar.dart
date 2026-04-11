part of '../chatting_page.dart';

class _BotAvatar extends StatelessWidget {
  const _BotAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: ColorName.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.home_work_rounded,
        size: 16.sp,
        color: ColorName.primary,
      ),
    );
  }
}