part of '../chatting_page.dart';

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bot icon
          _BotAvatar(),
          SizedBox(height: 10.h),

          // Shimmer skeleton lines
          Shimmer.fromColors(
            baseColor: const Color(0xFFEEEEEE),
            highlightColor: const Color(0xFFFAFAFA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerLine(width: 0.65.sw),
                SizedBox(height: 8.h),
                _ShimmerLine(width: 0.50.sw),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _ShimmerLine(width: 0.28.sw),
                    SizedBox(width: 8.w),
                    _ShimmerLine(width: 0.20.sw),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  const _ShimmerLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 12.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}
