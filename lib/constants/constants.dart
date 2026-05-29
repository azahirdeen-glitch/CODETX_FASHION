import 'package:flutter/material.dart';

const double kSpacingXS = 4;
const double kSpacingS = 8;
const double kSpacingM = 12;
const double kSpacingL = 16;
const double kSpacingXL = 24;
const double kSpacing2XL = 32;
const double kSpacing3XL = 48;
const double kSpacing4XL = 64;

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF005AB4);
  static const Color primaryContainer = Color(0xFF0873DF);
  static const Color primaryFixed = Color(0xFFD6E3FF);
  static const Color primaryFixedDim = Color(0xFFAAC7FF);
  static const Color inversePrimary = Color(0xFFAAC7FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFEFCFF);
  static const Color onPrimaryFixed = Color(0xFF001B3E);
  static const Color onPrimaryFixedVariant = Color(0xFF00458D);

  static const Color secondary = Color(0xFF465F89);
  static const Color secondaryContainer = Color(0xFFB7CFFF);
  static const Color secondaryFixed = Color(0xFFD6E3FF);
  static const Color secondaryFixedDim = Color(0xFFAFC7F7);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF405882);
  static const Color onSecondaryFixed = Color(0xFF001B3E);
  static const Color onSecondaryFixedVariant = Color(0xFF2E4770);

  static const Color tertiary = Color(0xFF964400);
  static const Color tertiaryContainer = Color(0xFFBD5700);
  static const Color tertiaryFixed = Color(0xFFFFDBC9);
  static const Color tertiaryFixedDim = Color(0xFFFFB68C);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFFFFBFF);
  static const Color onTertiaryFixed = Color(0xFF321200);
  static const Color onTertiaryFixedVariant = Color(0xFF763400);

  static const Color background = Color(0xFFF9F9FF);
  static const Color onBackground = Color(0xFF181C22);
  static const Color surface = Color(0xFFF9F9FF);
  static const Color surfaceBright = Color(0xFFF9F9FF);
  static const Color surfaceDim = Color(0xFFD8DAE3);
  static const Color surfaceTint = Color(0xFF005DB8);
  static const Color surfaceVariant = Color(0xFFE0E2EC);
  static const Color onSurface = Color(0xFF181C22);
  static const Color onSurfaceVariant = Color(0xFF414753);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FD);
  static const Color surfaceContainer = Color(0xFFECEDF7);
  static const Color surfaceContainerHigh = Color(0xFFE6E8F1);
  static const Color surfaceContainerHighest = Color(0xFFE0E2EC);

  static const Color outline = Color(0xFF717785);
  static const Color outlineVariant = Color(0xFFC1C6D5);
  static const Color inverseSurface = Color(0xFF2D3038);
  static const Color inverseOnSurface = Color(0xFFEFF0FA);

  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);
}

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  static const double size8 = 8;
  static const double size10 = 10;
  static const double size12 = 12;
  static const double size14 = 14;
  static const double size16 = 16;
  static const double size18 = 18;
  static const double size20 = 20;
  static const double size24 = 24;
  static const double size30 = 30;
  static const double size36 = 36;

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  static const double trackingTighter = -0.5;
  static const double trackingTight = -0.25;
  static const double trackingNormal = 0;
  static const double trackingWide = 0.5;
  static const double trackingWider = 1.0;
  static const double trackingWidest = 1.5;

  static const double lineHeightNone = 1.0;
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.625;
}

class AppSpacing {
  AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double section = 48;
}

class AppRadius {
  AppRadius._();

  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double full = 9999;
}

class AppSizes {
  AppSizes._();

  static const double appBarHeight = 64;
  static const double bottomNavHeight = 76;
  static const double searchHeight = 52;
  static const double bannerHeight = 192;
  static const double cardHeight = 180;
  static const double avatarLg = 88;
  static const double avatarMd = 56;
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;
}

class AppShadows {
  AppShadows._();

  static const BoxShadow card = BoxShadow(
    color: Color(0x1A0B1A3D),
    blurRadius: 24,
    spreadRadius: 0,
    offset: Offset(0, 8),
  );

  static const BoxShadow button = BoxShadow(
    color: Color(0x33005AB4),
    blurRadius: 16,
    spreadRadius: 0,
    offset: Offset(0, 6),
  );

  static const BoxShadow focusRing = BoxShadow(
    color: Color(0x29005AB4),
    blurRadius: 0,
    spreadRadius: 3,
    offset: Offset(0, 0),
  );
}
