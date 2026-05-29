import 'package:flutter/widgets.dart';

class ResponsiveHelper {
  ResponsiveHelper._();

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopBreakpoint) return 56;
    if (width >= tabletBreakpoint) return 32;
    if (width >= mobileBreakpoint) return 24;
    return 16;
  }

  static double contentMaxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopBreakpoint) return 1240;
    if (width >= tabletBreakpoint) return 900;
    return width;
  }

  static double scaleFont(BuildContext context, double baseSize) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopBreakpoint) return baseSize * 1.08;
    if (width >= tabletBreakpoint) return baseSize * 1.04;
    return baseSize;
  }
}
