import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'app_colors.dart';

class AppTheme {
  static ShadThemeData get lightTheme {
    return ShadThemeData(
      brightness: Brightness.light,
      colorScheme: const ShadSlateColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        destructive: AppColors.error,
        background: AppColors.background,
        card: AppColors.surface,
        popover: AppColors.surface,
        border: AppColors.border,
        input: AppColors.border,
        ring: AppColors.primary,
      ),
    );
  }

  static ShadThemeData get darkTheme {
    return ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: const ShadSlateColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        destructive: AppColors.error,
        background: AppColors.darkBackground,
        card: AppColors.darkSurface,
        popover: AppColors.darkSurface,
        border: AppColors.darkBorder,
        input: AppColors.darkBorder,
        ring: AppColors.secondary,
      ),
    );
  }
}
