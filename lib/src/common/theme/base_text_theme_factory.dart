import 'package:flutter/material.dart';

// import '../../../generated/colors.gen.dart';
// import '../../../generated/fonts.gen.dart';
import 'text_theme_factory.dart';

abstract class BaseTextThemeFactory extends TextThemeFactory {
  @override
  TextTheme create() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,

      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,

      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,

      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,

      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }

  @override
  TextStyle get extraLight => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w200,
      // fontFamily: FontFamily.roboto,
      // color: ColorName.black07
      );

  @override
  TextStyle get light => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      // fontFamily: FontFamily.roboto,
      // color: ColorName.black07
      );

  @override
  TextStyle get regular => const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      // fontFamily: FontFamily.roboto,
      // color: ColorName.black07
      );

  @override
  TextStyle get semiBold => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      // fontFamily: FontFamily.roboto,
      // color: ColorName.whiteFE
      );

  @override
  TextStyle get bold => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      // fontFamily: FontFamily.roboto,
      // color: ColorName.black07
      );

  @override
  TextStyle get extraBold => const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      // fontFamily: FontFamily.roboto,
      // color: ColorName.black07
      );

  @override
  TextStyle get displayLarge => bold;
  @override
  TextStyle get displayMedium => semiBold.copyWith(fontSize: 14);
  @override
  TextStyle get displaySmall =>
      semiBold.copyWith(fontSize: 14, fontWeight: FontWeight.w400);

  @override
  TextStyle get headlineLarge => extraBold;
  @override
  TextStyle get headlineMedium => bold;
  @override
  TextStyle get headlineSmall => semiBold.copyWith(fontSize: 18);
  
  @override
  TextStyle get titleLarge => bold;
  @override
  TextStyle get titleMedium => bold;
  @override
  TextStyle get titleSmall => bold;

  @override
  TextStyle get bodyLarge => bold;
  @override
  TextStyle get bodyMedium => bold;
  @override
  TextStyle get bodySmall => semiBold.copyWith(fontSize: 18, 
  // color: ColorName.whiteFE
  );
  @override
  TextStyle get labelLarge => bold;
  @override
  TextStyle get labelMedium => semiBold.copyWith(fontSize: 18, 
  // color: ColorName.whiteFE
  );
  @override
  TextStyle get labelSmall => bold;
}
