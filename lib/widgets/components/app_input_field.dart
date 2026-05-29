import 'package:flutter/material.dart';

import '../../constants/constants.dart';

/// Visual states for design-system input fields.
enum AppInputVisualState { normal, focused, error, disabled }

/// Design-system text input with validation and exact Figma-like states.
class AppInputField extends StatefulWidget {
  const AppInputField({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.enabled = true,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.validator,
    this.onChanged,
  });

  final String label;
  final String? hintText;
  final String? errorText;
  final bool enabled;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  final FocusNode _focusNode = FocusNode();
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = (widget.errorText?.isNotEmpty ?? false) || (_validationError != null);
    final AppInputVisualState state = !widget.enabled
        ? AppInputVisualState.disabled
        : hasError
            ? AppInputVisualState.error
            : (_focusNode.hasFocus ? AppInputVisualState.focused : AppInputVisualState.normal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: state == AppInputVisualState.focused ? const [AppShadows.focusRing] : null,
          ),
          child: TextField(
            enabled: widget.enabled,
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            onChanged: (value) {
              if (widget.validator != null) {
                setState(() => _validationError = widget.validator!(value));
              }
              widget.onChanged?.call(value);
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              errorText: null,
              fillColor: _fillColor(state),
              enabledBorder: _border(state),
              focusedBorder: _border(state),
              disabledBorder: _border(state),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText ?? _validationError!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _border(AppInputVisualState state) {
    final Color color = switch (state) {
      AppInputVisualState.normal => AppColors.outlineVariant,
      AppInputVisualState.focused => AppColors.primary,
      AppInputVisualState.error => AppColors.error,
      AppInputVisualState.disabled => AppColors.outlineVariant,
    };
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: color, width: state == AppInputVisualState.focused ? 1.5 : 1),
    );
  }

  Color _fillColor(AppInputVisualState state) {
    return state == AppInputVisualState.disabled
        ? AppColors.surfaceContainerHigh
        : AppColors.surfaceContainerLowest;
  }
}
