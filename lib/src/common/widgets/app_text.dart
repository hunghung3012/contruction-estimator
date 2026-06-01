import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/colors.gen.dart';
import '../constants/ui_const.dart';
import '../extension/context_x.dart';
import '../extension/string_x.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.onFinished,
    this.height,
    this.maxLines,
    this.overflow,
    this.textCase = TextCaseType.none,
    this.fontStyle,
    this.decoration,
    this.underlineColor,
    this.textAlign,
    this.prefix,
    this.mainAxisAlignment,
    this.spacing = 4,
    this.minFontSize = 6,
    this.enableAutoResize = false,
    this.behavior = HitTestBehavior.opaque,
    this.decorationStyle,
    this.showSuggestLoginDialog = false,
    this.ignorePointer = true,
    this.isLogin,
    this.letterSpacing = 0,
    this.style,
  });

  final String? text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFinished;
  final double? height;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextCaseType textCase;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final Color? underlineColor;
  final TextAlign? textAlign;
  final Widget? prefix;
  final MainAxisAlignment? mainAxisAlignment;
  final double? spacing;
  final bool enableAutoResize;
  final HitTestBehavior behavior;
  final TextDecorationStyle? decorationStyle;
  final double minFontSize;
  final double? letterSpacing;
  final bool showSuggestLoginDialog;
  final bool? isLogin;
  final bool ignorePointer;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignorePointer,
      child: GestureDetector(
        behavior: behavior,
        onTap: () => onTap?.call(),
        child: Container(
          padding: padding,
          child: prefix == null
              ? enableAutoResize
                    ? AutoSizeText(
                        text?.getTextByCasing(textCase) ?? '',
                        minFontSize: minFontSize,
                        overflow: overflow,
                        maxLines: maxLines,
                        textAlign: textAlign ?? TextAlign.center,
                        style:
                            style ??
                            context.textTheme.regular.copyWith(
                              color: textColor ?? ColorName.black07,
                              fontWeight: fontWeight ?? FontWeight.w400,
                              fontSize:
                                  fontSize?.sp ?? UIConst.defaultFontSize.sp,
                              height: height?.h ?? 1,
                              fontStyle: fontStyle,
                              decoration: decoration,
                              decorationColor: textColor,
                              letterSpacing: letterSpacing,
                            ),
                      )
                    : Text(
                        text?.getTextByCasing(textCase) ?? '',
                        overflow: overflow,
                        maxLines: maxLines,
                        textAlign: textAlign ?? TextAlign.center,
                        style:
                            style ??
                            context.textTheme.regular.copyWith(
                              color: textColor ?? ColorName.black07,
                              fontWeight: fontWeight ?? FontWeight.w400,
                              fontSize:
                                  fontSize?.sp ?? UIConst.defaultFontSize.sp,
                              height: height?.h ?? 1,
                              fontStyle: fontStyle,
                              decoration: decoration,
                              decorationColor: textColor,
                              letterSpacing: letterSpacing,
                            ),
                      )
              : Row(
                  mainAxisAlignment:
                      mainAxisAlignment ?? MainAxisAlignment.center,
                  children: [
                    prefix!,
                    SizedBox(width: spacing),
                    if (enableAutoResize)
                      AutoSizeText(
                        text?.getTextByCasing(textCase) ?? '',
                        overflow: overflow,
                        maxLines: maxLines,
                        minFontSize: minFontSize.sp,
                        textAlign: textAlign ?? TextAlign.center,
                        style:
                            style ??
                            context.textTheme.regular.copyWith(
                              color: textColor ?? ColorName.black07,
                              fontWeight: fontWeight ?? FontWeight.w400,
                              fontSize:
                                  fontSize?.sp ?? UIConst.defaultFontSize.sp,
                              height: height?.h ?? 1,
                              fontStyle: fontStyle,
                              decoration: decoration,
                              decorationColor: textColor,
                              letterSpacing: letterSpacing,
                            ),
                      )
                    else
                      Flexible(
                        child: Text(
                          text?.getTextByCasing(textCase) ?? '',
                          overflow: overflow,
                          maxLines: maxLines,
                          textAlign: textAlign ?? TextAlign.center,
                          style:
                              style ??
                              context.textTheme.regular.copyWith(
                                color: textColor ?? ColorName.black07,
                                fontWeight: fontWeight ?? FontWeight.w400,
                                fontSize:
                                    fontSize?.sp ?? UIConst.defaultFontSize.sp,
                                height: height?.h,
                                fontStyle: fontStyle,
                                decoration: decoration,
                                decorationColor: textColor,
                                letterSpacing: letterSpacing,
                              ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
