import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/utils/app_colors.dart';

/// Centralized typography using Google Fonts.
/// Headlines use Playfair Display for a bold editorial feel.
/// Body text uses Inter for clean readability.
class AppTextStyles {
  AppTextStyles._();

  // ── Headlines — Playfair Display ──

  static TextStyle headline1({Color? color}) => GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle headline2({Color? color}) => GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle headline3({Color? color}) => GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        height: 1.3,
      );

  // ── Body — Inter ──

  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        color: color ?? AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        color: color ?? AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        color: color ?? AppColors.textSecondary,
        height: 1.4,
      );

  // ── Labels & Buttons ──

  static TextStyle caption({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        color: color ?? AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle label({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle button({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
      );
}
