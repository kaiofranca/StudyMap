import 'package:flutter/material.dart';

class ThemeUtils {
  static BoxDecoration glassDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    );
  }

  static BoxDecoration bentoDecoration(BuildContext context) {
    return BoxDecoration(
      color: const Color(0xFF1E2023),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
    );
  }

  static TextStyle headlineStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ) ??
        const TextStyle();
  }
}
