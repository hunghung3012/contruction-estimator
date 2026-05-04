import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/ui_const.dart';
import '../extension/context_x.dart';
import '../extension/string_x.dart';
import '../../../generated/colors.gen.dart';
import 'app_text.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.maxLines = 1,
    this.readOnly = false,
    this.minLines,
    this.maxLength,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.keyboardAppearance,
    this.textInputAction,
    this.textCapitalization,
    this.onChanged,
    this.onTap,
    this.hintMaxLines,
    this.onSubmit,
    this.filled = true,
    this.contentPadding,
    this.isCollapsed,
    this.suffix,
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.isError = false,
    this.fillColor,
    this.isVisibleBorder = true,
    this.borderColor,
    this.hintText,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.hintTextColor,
    this.focusedBorderColor,
    this.focusNode,
    this.autofocus = false,
    this.keyboardType,
    this.obscureText = false,
    this.cursorColor,
    this.textAlignVertical,
    this.prefixIcon,
    this.isDense,
    this.textCase = TextCaseType.none,
    this.onSuffixPressed,
    this.errorText,
    this.onEditingComplete,
    this.expands = false,
    this.prefixSpacing = 0,
    this.focusedBorder,
    this.enabledBorder,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.enableInteractiveSelection,
    this.height,
    this.width,
    this.textSuffix,
  });

  final TextEditingController? controller;
  final int? maxLines;
  final bool readOnly;
  final int? minLines;
  final int? maxLength;
  final EdgeInsets scrollPadding;
  final Brightness? keyboardAppearance;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final int? hintMaxLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmit;
  final bool? filled;
  final bool? isCollapsed;
  final Widget? suffix;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final bool isVisibleBorder;
  final BorderRadius borderRadius;
  final bool isError;
  final String? hintText;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? focusedBorderColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextAlignVertical? textAlignVertical;
  final Color? cursorColor;
  final Widget? prefixIcon;
  final bool? isDense;
  final TextCaseType textCase;
  final VoidCallback? onSuffixPressed;
  final VoidCallback? onEditingComplete;
  final String? errorText;
  final double prefixSpacing;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final bool expands;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enableInteractiveSelection;
  final double? height;
  final double? width;
  final Widget? textSuffix;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //widget.focusNode?.dispose();
    // this is a buggy, the controller pass from parent widget will be destroyed
    // should move the handler to the one who create this controller
    // widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextField(
        enableInteractiveSelection: widget.enableInteractiveSelection,
        inputFormatters: widget.inputFormatters,
        textAlign: widget.textAlign,
        obscuringCharacter: '*',
        expands: widget.expands,
        onEditingComplete: widget.onEditingComplete,
        textAlignVertical: widget.textAlignVertical,
        cursorColor: widget.cursorColor,
        obscureText: widget.obscureText,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        controller: widget.controller,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        scrollPadding: widget.scrollPadding,
        keyboardAppearance: widget.keyboardAppearance,
        textInputAction: widget.textInputAction,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        onSubmitted: (value) {
          if (widget.onSubmit != null) {
            widget.onSubmit!(value);
          }
        },
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        style: context.textTheme.regular.copyWith(
          color: widget.textColor ?? ColorName.black07,
          fontWeight: widget.fontWeight ?? FontWeight.w400,
          fontSize: widget.fontSize?.sp ?? 14.sp,
        ),
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          counterText: '',
          error: widget.errorText == null || widget.errorText!.isEmpty
              ? null
              : AppText(
                  widget.errorText!,
                  textAlign: TextAlign.right,
                  enableAutoResize: true,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  textColor: Colors.red,
                ),
          errorBorder: widget.errorText != null && widget.errorText!.isNotEmpty
              ? OutlineInputBorder(
                  borderRadius: widget.borderRadius,
                  borderSide: BorderSide(color: Colors.red),
                )
              : InputBorder.none,
          focusedErrorBorder:
              widget.errorText != null && widget.errorText!.isNotEmpty
              ? OutlineInputBorder(
                  borderRadius: widget.borderRadius,
                  borderSide: BorderSide(color: Colors.red),
                )
              : InputBorder.none,
          isDense: widget.isDense,
          prefixIcon: widget.prefixIcon,
          prefixIconConstraints: const BoxConstraints.tightForFinite(),
          hintMaxLines: widget.hintMaxLines,
          filled: widget.filled,
          isCollapsed: widget.isCollapsed,
          suffix: widget.textSuffix,
          suffixIcon: widget.suffix == null
              ? null
              : GestureDetector(
                  onTap: widget.onSuffixPressed,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [widget.suffix!],
                  ),
                ),
          contentPadding:
              widget.contentPadding ??
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          prefix: SizedBox(width: widget.prefixSpacing.w),
          fillColor: widget.fillColor ?? Colors.transparent,
          focusedBorder: widget.isVisibleBorder
              ? widget.focusedBorder ??
                    OutlineInputBorder(
                      borderRadius: widget.borderRadius,
                      borderSide: BorderSide(
                        color:
                            (widget.isError ||
                                (widget.errorText != null &&
                                    widget.errorText!.isNotEmpty))
                            ? Colors.red
                            : widget.borderColor ?? ColorName.primary,
                      ),
                    )
              : InputBorder.none,
          enabledBorder: widget.isVisibleBorder
              ? widget.enabledBorder ??
                    OutlineInputBorder(
                      borderRadius: widget.borderRadius,
                      borderSide: BorderSide(
                        color:
                            (widget.isError ||
                                (widget.errorText != null &&
                                    widget.errorText!.isNotEmpty))
                            ? Colors.red
                            : widget.borderColor ?? ColorName.whiteEE,
                      ),
                    )
              : InputBorder.none,
          hintStyle: context.textTheme.regular.copyWith(
            color: widget.hintTextColor ?? ColorName.gray55,
            fontSize: widget.fontSize?.sp ?? UIConst.defaultFontSize.sp,
            fontWeight: widget.fontWeight ?? FontWeight.w400,
          ),
          hintText: widget.hintText?.getTextByCasing(widget.textCase),
        ),
      ),
    );
  }
}
