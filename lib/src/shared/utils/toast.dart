import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Toast {
  static void show(
    BuildContext context, {
    required String message,
    IconData icon = Icons.info_outline,
    Color? background,
    Color? textColor,
    Color? iconColor,
    FlushbarPosition position = FlushbarPosition.TOP,
    Duration duration = const Duration(seconds: 2),
  }) {
    Flushbar(
      messageText: Text(
        message,
        style: TextStyle(
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      backgroundColor:
          background ?? Theme.of(context).colorScheme.surface.withOpacity(0.98),
      flushbarPosition: position,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(2, 2),
        ),
      ],
      duration: duration,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ).show(context);
  }

  // ✅ Toasts prontos
  static void success(BuildContext context, String message) {
    show(
      context,
      message: message,
      background: Colors.green,
      textColor: Colors.white,
      icon: Icons.check_circle_outline,
    );
  }

  static void error(BuildContext context, String message) {
    show(
      context,
      message: message,
      background: Colors.red,
      textColor: Colors.white,
      icon: Icons.error_outline,
    );
  }
}
