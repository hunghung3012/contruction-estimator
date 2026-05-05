import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../generated/colors.gen.dart';
import 'default_text_theme.dart';
import 'text_theme_factory.dart';

class AppTheme {
  final TextThemeFactory factory;

  AppTheme._(this.factory);

  factory AppTheme.create() {
    return AppTheme._(DefaultTextTheme());
  }

  ThemeData build() {
    final primary = ColorName.primary;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,

      // ========================
      // COLOR
      // ========================
      colorScheme: colorScheme,
      primaryColor: primary,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,

      // ========================
      // TEXT
      // ========================
      textTheme: factory.create().apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),

      // ========================
      // APP BAR
      // ========================
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      // ========================
      // BUTTON
      // ========================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),

      // ========================
      // INPUT
      // ========================
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        // fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),

      // ========================
      // SELECTION
      // ========================
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primary,
        selectionColor: primary.withValues(alpha: 0.4),
        selectionHandleColor: primary,
      ),

      // ========================
      // SWITCH / CHECKBOX / RADIO
      // ========================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(primary),
        trackColor: WidgetStatePropertyAll(primary.withValues(alpha: 0.4)),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStatePropertyAll(primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      radioTheme: RadioThemeData(fillColor: WidgetStatePropertyAll(primary)),

      // ========================
      // CARD
      // ========================
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ========================
      // DIVIDER
      // ========================
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),

      // ========================
      // SNACKBAR
      // ========================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // ========================
      // DIALOG
      // ========================
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ========================
      // BOTTOMSHEET
      // ========================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // ========================
      // LIST TILE
      // ========================
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),

      // ========================
      // ICON
      // ========================
      iconTheme: IconThemeData(color: primary),

      // ========================
      // FLOATING ACTION BUTTON
      // ========================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),

      // ========================
      // NAVIGATION BAR
      // ========================
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: primary.withValues(alpha: 0.2),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // ========================
      // BOTTOM APP BAR
      // ========================
      bottomAppBarTheme: BottomAppBarThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: const CircularNotchedRectangle(),
      ),

      // ========================
      // BOTTOM NAVIGATION BAR
      // ========================
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: colorScheme.primary.withValues(alpha: 0.6),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
