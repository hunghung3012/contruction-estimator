part of '../chatting_page.dart';

class _SuggestionChip extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const _SuggestionChip({required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: 110.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: ColorName.grayCC),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AppText(
            title,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            enableAutoResize: true,
          ),
        ),
      ),
    );
  }
}
