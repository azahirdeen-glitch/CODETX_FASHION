import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/constants.dart';

/// Design-system icon wrapper supporting both IconData and SVG.
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    this.icon,
    this.svgAsset,
    this.svgString,
    this.size = AppSizes.iconMd,
    this.color = AppColors.onSurfaceVariant,
  }) : assert(
         icon != null || svgAsset != null || svgString != null,
         'icon, svgAsset, or svgString must be provided.',
       );

  final IconData? icon;
  final String? svgAsset;
  final String? svgString;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return Icon(icon, size: size, color: color);
    }
    if (svgAsset != null) {
      return SvgPicture.asset(
        svgAsset!,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }
    return SvgPicture.string(
      svgString!,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

/// Circular avatar/icon surface aligned with Figma rounded tokens.
class AppCircularIcon extends StatelessWidget {
  const AppCircularIcon({
    super.key,
    required this.child,
    this.size = AppSizes.avatarMd,
    this.background = AppColors.surfaceContainerHigh,
  });

  final Widget child;
  final double size;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: background,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
