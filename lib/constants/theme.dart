import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class AppTheme {
  AppTheme._();

  static final TextTheme textTheme = TextTheme(
    displayLarge: _textStyle(
      size: AppTypography.size36,
      weight: AppTypography.extrabold,
      letterSpacing: AppTypography.trackingTight,
      height: AppTypography.lineHeightTight,
    ),
    displayMedium: _textStyle(
      size: AppTypography.size30,
      weight: AppTypography.bold,
      letterSpacing: AppTypography.trackingTight,
      height: AppTypography.lineHeightTight,
    ),
    headlineLarge: _textStyle(
      size: AppTypography.size24,
      weight: AppTypography.bold,
      letterSpacing: AppTypography.trackingTight,
      height: AppTypography.lineHeightTight,
    ),
    headlineMedium: _textStyle(
      size: AppTypography.size20,
      weight: AppTypography.bold,
      letterSpacing: AppTypography.trackingTight,
      height: AppTypography.lineHeightTight,
    ),
    titleLarge: _textStyle(
      size: AppTypography.size18,
      weight: AppTypography.bold,
      letterSpacing: AppTypography.trackingNormal,
      height: AppTypography.lineHeightTight,
    ),
    titleMedium: _textStyle(
      size: AppTypography.size16,
      weight: AppTypography.semibold,
      letterSpacing: AppTypography.trackingNormal,
      height: AppTypography.lineHeightNormal,
    ),
    bodyLarge: _textStyle(
      size: AppTypography.size16,
      weight: AppTypography.regular,
      letterSpacing: AppTypography.trackingNormal,
      height: AppTypography.lineHeightRelaxed,
    ),
    bodyMedium: _textStyle(
      size: AppTypography.size14,
      weight: AppTypography.medium,
      letterSpacing: AppTypography.trackingNormal,
      height: AppTypography.lineHeightNormal,
    ),
    bodySmall: _textStyle(
      size: AppTypography.size12,
      weight: AppTypography.regular,
      letterSpacing: AppTypography.trackingWide,
      height: AppTypography.lineHeightNormal,
    ),
    labelLarge: _textStyle(
      size: AppTypography.size14,
      weight: AppTypography.semibold,
      letterSpacing: AppTypography.trackingWide,
      height: AppTypography.lineHeightNormal,
    ),
    labelMedium: _textStyle(
      size: AppTypography.size12,
      weight: AppTypography.semibold,
      letterSpacing: AppTypography.trackingWider,
      height: AppTypography.lineHeightNormal,
    ),
    labelSmall: _textStyle(
      size: AppTypography.size10,
      weight: AppTypography.medium,
      letterSpacing: AppTypography.trackingWider,
      height: AppTypography.lineHeightNone,
    ),
  );

  static final ColorScheme colorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.inverseOnSurface,
    inversePrimary: AppColors.inversePrimary,
    surfaceTint: AppColors.surfaceTint,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme.apply(
        bodyColor: AppColors.onBackground,
        displayColor: AppColors.onBackground,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.surfaceContainerLowest,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLow,
        surfaceTintColor: AppColors.surfaceTint,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        side: BorderSide.none,
        selectedColor: AppColors.primaryFixed,
        backgroundColor: AppColors.surfaceContainerHigh,
        labelStyle: textTheme.labelMedium,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: AppSpacing.lg,
      ),
    );
  }

  static TextStyle _textStyle({
    required double size,
    required FontWeight weight,
    required double letterSpacing,
    required double height,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
