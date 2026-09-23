import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_text_styles.dart';

/// Redesigned category pill with emoji icon and polished styling.
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  /// Map category names to icons.
  static const Map<String, IconData> categoryIcons = {
    'General': Icons.language,
    'Business': Icons.business_center,
    'Technology': Icons.computer,
    'Health': Icons.favorite,
    'Science': Icons.science,
    'Sports': Icons.sports_soccer,
    'Entertainment': Icons.movie,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconData = categoryIcons[label] ?? Icons.article;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: isSelected
              ? AppColors.accent
              : isDark
                  ? AppColors.cardDark
                  : Colors.white,
          borderRadius: BorderRadius.circular(24),
          elevation: isSelected ? 2 : 0,
          shadowColor: AppColors.accent.withValues(alpha: 0.3),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accent
                      : isDark
                          ? AppColors.dividerDark
                          : AppColors.divider,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    iconData,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : isDark
                            ? AppColors.textDark
                            : AppColors.textPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: AppTextStyles.label(
                      color: isSelected
                          ? Colors.white
                          : isDark
                              ? AppColors.textDark
                              : AppColors.textPrimary,
                    ).copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}