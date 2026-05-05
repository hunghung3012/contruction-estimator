import 'package:flutter/material.dart';

import '../../../generated/colors.gen.dart';

class AppCircleButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final double? padding;
  final Color? backgroundColor;
  final EdgeInsets? margin;
  final Color? borderColor;
  const AppCircleButton({
    super.key,
    required this.icon,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap?.call,
      child: Container(
        padding: EdgeInsets.all(padding ?? 12),
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor ?? ColorName.grayF0,
          shape: BoxShape.circle,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: icon,
      ),
    );
  }
}
