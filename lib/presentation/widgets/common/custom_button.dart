import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.elevatedButtonTheme.style ??
        ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        );
    final effectiveBackground = backgroundColor ?? theme.colorScheme.primary;
    final effectiveForeground = textColor ?? theme.colorScheme.onPrimary;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: baseStyle.copyWith(
          backgroundColor: WidgetStatePropertyAll(effectiveBackground),
          foregroundColor: WidgetStatePropertyAll(effectiveForeground),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    effectiveForeground,
                  ),
                ),
              )
            : icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: effectiveForeground,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        text,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: effectiveForeground,
                        ),
                      ),
                    ],
                  )
                : Text(
                    text,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: effectiveForeground,
                    ),
                  ),
      ),
    );
  }
}
