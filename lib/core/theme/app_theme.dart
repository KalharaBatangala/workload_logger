import 'package:flutter/material.dart';

import 'tokens.dart';

/// The app's single Material 3 light theme, built only from [tokens.dart].
abstract final class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.navy,
      onPrimary: AppColors.surface,
      secondary: AppColors.gold,
      onSecondary: AppColors.navyDeep,
      tertiary: AppColors.goldText,
      onTertiary: AppColors.surface,
      error: AppColors.error,
      onError: AppColors.surface,
      surface: AppColors.surface,
      onSurface: AppColors.navy,
      onSurfaceVariant: AppColors.textMuted,
      surfaceContainerHighest: AppColors.chip,
      outline: AppColors.borderStrong,
      outlineVariant: AppColors.border,
    );

    const textTheme = TextTheme(
      displayLarge: AppText.display,
      headlineMedium: AppText.screenTitle,
      headlineSmall: AppText.stepTitle,
      titleLarge: AppText.cardTitle,
      titleMedium: AppText.section,
      bodyLarge: AppText.body,
      bodyMedium: AppText.bodySmall,
      bodySmall: AppText.caption,
      labelLarge: AppText.body,
      labelMedium: AppText.caption,
      labelSmall: AppText.overline,
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.button),
    );
    const buttonMinSize = Size(
      AppSpacing.minTouchTarget,
      AppSpacing.minTouchTarget,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppText.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.ground,
      dividerColor: AppColors.divider,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ground,
        foregroundColor: AppColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppText.section,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.surface,
          minimumSize: buttonMinSize,
          shape: buttonShape,
          textStyle: AppText.body,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: buttonMinSize,
          shape: buttonShape,
          side: const BorderSide(color: AppColors.borderStrong),
          textStyle: AppText.body,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: buttonMinSize,
          textStyle: AppText.body,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.navy,
          minimumSize: buttonMinSize,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        labelStyle: AppText.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.surface),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.navy
              : AppColors.borderStrong,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.navy,
        contentTextStyle: TextStyle(
          fontFamily: AppText.fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.surface,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
