part of '../estimate_detail_page.dart';

class _InputSmallField extends StatelessWidget {
  const _InputSmallField({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    this.keyboardType,
    this.prefix,
    this.textFieldWidth,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextInputType? keyboardType;
  final String? prefix;
  final double? textFieldWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          AppText(
            "$label ${prefix != null ? '($prefix)' : ''}:",
            fontSize: 14,
            textColor: ColorName.gray55,
            maxLines: 1,
            enableAutoResize: true,
            padding: EdgeInsets.only(right: 8),
          ),

          textFieldWidth != null
              ? SizedBox(
                  width: textFieldWidth ?? double.infinity,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    keyboardType: keyboardType,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      color: ColorName.black07,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    keyboardType: keyboardType,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      color: ColorName.black07,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
