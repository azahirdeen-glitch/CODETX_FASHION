import 'package:flutter/material.dart';

import '../../constants/constants.dart';

/// Supported button variants from the design system.
enum AppButtonVariant { primary, secondary, text }

/// A reusable button with exact ClosetX design tokens and interaction states.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = AppButtonVariant.primary,
    this.leading,
    this.trailing,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final bool fullWidth;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool disabled = widget.onTap == null;
    final _ButtonTokens tokens = _tokens(disabled: disabled);

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: 52,
      width: widget.fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        color: tokens.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: tokens.border,
        boxShadow: [
          if (!disabled && widget.variant == AppButtonVariant.primary && !_pressed)
            AppShadows.button,
        ],
      ),
      child: Row(
        mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.leading != null) ...[
            IconTheme(data: IconThemeData(color: tokens.foreground), child: widget.leading!),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Text(
              widget.label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: tokens.foreground,
                    fontWeight: AppTypography.semibold,
                  ),
            ),
          ),
          if (widget.trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            IconTheme(data: IconThemeData(color: tokens.foreground), child: widget.trailing!),
          ],
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
        onTapCancel: disabled ? null : () => setState(() => _pressed = false),
        onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: Opacity(
          opacity: disabled ? 0.5 : (_hovered ? 0.95 : 1),
          child: Transform.scale(
            scale: _pressed ? 0.985 : 1,
            child: child,
          ),
        ),
      ),
    );
  }

  _ButtonTokens _tokens({required bool disabled}) {
    if (disabled) {
      return const _ButtonTokens(
        background: AppColors.surfaceContainerHigh,
        foreground: AppColors.outline,
        border: null,
      );
    }
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return const _ButtonTokens(
          background: AppColors.primary,
          foreground: AppColors.onPrimary,
          border: null,
        );
      case AppButtonVariant.secondary:
        return const _ButtonTokens(
          background: AppColors.surfaceContainerLowest,
          foreground: AppColors.primary,
          border: Border.fromBorderSide(BorderSide(color: AppColors.primary, width: 1.5)),
        );
      case AppButtonVariant.text:
        return const _ButtonTokens(
          background: Colors.transparent,
          foreground: AppColors.primary,
          border: null,
        );
    }
  }
}

class _ButtonTokens {
  const _ButtonTokens({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final BoxBorder? border;
}
