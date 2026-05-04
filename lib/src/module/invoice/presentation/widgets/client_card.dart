part of '../invoice_detail_page.dart';

class _ClientCard extends StatelessWidget {
  const _ClientCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Add Client
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(8.r),
            color: ColorName.primary,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: ColorName.primary.withValues(
                alpha: 0.1,
              ), // Light green background
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: ColorName.primary, size: 20.w),
                SizedBox(width: 8.w),
                AppText(context.s.add_client, textColor: ColorName.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
