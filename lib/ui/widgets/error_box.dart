import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onRetry;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const ErrorBox({
    super.key,
    required this.message,
    this.icon,
    this.onRetry,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 8,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            color: theme.colorScheme.error,
          ),
          Expanded(child: Text(message)),
          if (onRetry != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRetry,
              tooltip: 'Réessayer',
            ),
        ],
      ),
    );
  }
}

