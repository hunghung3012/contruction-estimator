import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extension/context_x.dart';
import '../extension/optional_x.dart';

import '../../../generated/colors.gen.dart';
import '../extension/string_x.dart';
import 'app_text.dart';

class AppCupertinoAlertDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Color? titleColor;
  final String? submitButtonTitle;
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final VoidCallback? onSubmitWithoutPop;
  const AppCupertinoAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.titleColor,
    this.onSubmit,
    this.submitButtonTitle,
    this.onCancel,
    this.onSubmitWithoutPop,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: AppText(
        title,
        textCase: TextCaseType.capitalized,
        textColor: titleColor ?? ColorName.primary,
        fontSize: 18,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      ),
      content: AppText(
        content,
        textColor: ColorName.black,
        fontWeight: FontWeight.w400,
        textAlign: TextAlign.start,
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop();
          },
          child: AppText(context.s.cancle, textColor: ColorName.black),
        ),
        CupertinoDialogAction(
          onPressed: onSubmitWithoutPop.isNotNull
              ? () => onSubmitWithoutPop?.call()
              : () {
                  Navigator.pop(context);
                  onSubmit?.call();
                },
          child: AppText(
            submitButtonTitle ?? context.s.confirm,
            textColor: titleColor ?? ColorName.primary,
          ),
        ),
      ],
    );
  }
}
