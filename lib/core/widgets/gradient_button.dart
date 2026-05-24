import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;
  final Widget? icon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B8EFF), Color(0xFF00EEFC)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B8EFF).withOpacity(0.45),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF002E69),
          minimumSize: Size(double.infinity, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF002E69),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
