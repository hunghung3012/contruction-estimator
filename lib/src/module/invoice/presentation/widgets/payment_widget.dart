part of '../invoice_detail_page.dart';

class _PaymentWidget extends StatelessWidget {
  const _PaymentWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // TODO: Log manual payment
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: AppText(
            context.s.log_manual_payment,
            textColor: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}
