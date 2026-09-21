import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Light Theme Colors ──
  static const Color primary = Color(0xFF1A1A2E);
  static const Color accent = Color(0xFF4361EE);
  static const Color redAccent = Color(0xFFE63946);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0D0D0D);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color cardShadow = Color(0x1A000000);
  static const Color error = Color(0xFFF44336);
  static const Color success = Color(0xFF10B981);

  // ── Dark Theme Colors ──
  static const Color backgroundDark = Color(0xFF0F0F17);
  static const Color cardDark = Color(0xFF1C1C2E);
  static const Color textDark = Color(0xFFEAEAEA);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color dividerDark = Color(0xFF2D2D3F);

  // Legacy alias for backward compatibility
  static const Color background = backgroundLight;
}
