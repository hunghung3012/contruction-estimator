import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../generated/colors.gen.dart';

class ClientShimmerCard extends StatelessWidget {
  const ClientShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: ColorName.grayF3,
        highlightColor: ColorName.grayE8,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar placeholder
            Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            // Info placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _ShimmerBox(height: 16.h, width: 120.w),
                      SizedBox(width: 8.w),
                      _ShimmerBox(height: 18.h, width: 45.w, radius: 10.r),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  _ShimmerBox(height: 14.h, width: 100.w),
                  SizedBox(height: 4.h),
                  _ShimmerBox(height: 12.h, width: 160.w),
                  SizedBox(height: 4.h),
                  _ShimmerBox(height: 12.h, width: 140.w),
                ],
              ),
            ),
            // More icon placeholder
            _ShimmerBox(height: 20.w, width: 20.w, isCircle: true),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final bool isCircle;
  final double? radius;

  const _ShimmerBox({
    required this.height,
    required this.width,
    this.isCircle = false,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius:
            isCircle ? null : BorderRadius.circular(radius ?? 30.r),
      ),
    );
  }
}
