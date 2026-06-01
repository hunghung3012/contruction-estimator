import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extension/context_x.dart';
import '../extension/optional_x.dart';
import '../extension/string_x.dart';
import '../../../generated/colors.gen.dart';
import '../constants/ui_const.dart';
import 'app_text.dart';

enum ButtonType { normal, outline }

class AppButtonStyle {
  const AppButtonStyle({
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.leadingIcon,
    this.textStyle,
    this.fontWeight,
    this.radius,
    this.gradient,
    this.marginBottom = UIConst.zero,
    this.borderWidth = UIConst.defaultBorderWidth,
    this.fontSize,
    this.textCase,
  });

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final FontWeight? fontWeight;
  final Widget? leadingIcon;
  final double? radius;
  final LinearGradient? gradient;
  final double marginBottom;
  final double borderWidth;
  final double? fontSize;
  final TextCaseType? textCase;
}

final class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onPressed,
    this.style = const AppButtonStyle(),
    this.titleBuilder,
    this.title = '',
    this.prefixIcon,
    this.isLoading,
    this.loading,
    this.isButtonDisabled = false,
    this.buttonType = ButtonType.normal,
    this.margin = EdgeInsets.zero,
    this.height = 48,
    this.width,
    this.border,
    this.note,
    this.showSuggestLoginDialog = false,
    this.textCase = TextCaseType.capitalized,
    this.isLogin,
    this.titleAlignment = MainAxisAlignment.center,
    this.titlePadding = EdgeInsets.zero,
    this.spacing = 4,
    this.resultHandler,
  });

  final AppButtonStyle style;
  final VoidCallback? onPressed;
  final String title;
  final Widget Function(String title)? titleBuilder;
  final Widget? prefixIcon;
  final bool? isLoading;
  final Widget? loading;
  final bool isButtonDisabled;
  final double spacing;
  final ButtonType buttonType;
  final EdgeInsetsGeometry margin;
  final double? height;
  final double? width;
  final BoxBorder? border;
  final Widget? note;
  final bool showSuggestLoginDialog;
  final TextCaseType textCase;
  final bool? isLogin;
  final MainAxisAlignment titleAlignment;
  final EdgeInsetsGeometry titlePadding;
  final VoidCallback? resultHandler;

  bool get isOutLineButton => buttonType == ButtonType.outline;

  Widget _buildTitle(BuildContext context, Widget? prefixIcon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: height?.h ?? UIConst.defaultHeightButton.h,
          width: width?.w,
          margin: margin,
          decoration: BoxDecoration(
            color: isButtonDisabled
                ? Colors.grey
                : isOutLineButton
                ? style.backgroundColor ?? Colors.transparent
                : style.backgroundColor ?? ColorName.primary,
            gradient: style.gradient,
            borderRadius: BorderRadius.circular(
              style.radius ?? UIConst.defaultCornerRadiusButton,
            ),
            border:
                border ??
                Border.all(
                  width: isOutLineButton ? style.borderWidth.h : UIConst.zero,
                  color:
                      style.borderColor ??
                      (isOutLineButton
                          ? ColorName.primary
                          : Colors.transparent),
                ),
          ),
          child: Visibility(
            visible: isLoading ?? false,
            replacement:
                titleBuilder?.call(title) ??
                Padding(
                  padding: titlePadding,
                  child: Row(
                    mainAxisAlignment: titleAlignment,
                    children: [
                      prefixIcon ?? const SizedBox.shrink(),
                      SizedBox(width: prefixIcon == null ? 0 : spacing.w),
                      Flexible(
                        child: AppText(
                          title.getTextByCasing(style.textCase ?? textCase),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          enableAutoResize: true,
                          style:
                              style.textStyle ??
                              context.textTheme.semiBold.copyWith(
                                fontSize:
                                    style.fontSize?.sp ??
                                    UIConst.mediumFontSize.sp,
                                fontWeight: style.fontWeight ?? FontWeight.w500,
                                color:
                                    style.textColor ??
                                    (isOutLineButton
                                        ? ColorName.primary
                                        : ColorName.whiteFE),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
            child: Center(
              child: loading ?? CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),
        Visibility(
          visible: note.isNotNull,
          child: note ?? const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isButtonDisabled
          ? null
          : () {
              onPressed?.call();
            },
      minimumSize: Size(0, 0),
      child: _buildTitle(context, prefixIcon),
    );
  }
}
