import 'package:flutter/material.dart';
import 'package:news_app/utils/app_colors.dart';

/// Thin linear progress bar showing reading progress in the article detail view.
class ReadingProgressBar extends StatelessWidget {
  final double progress;

  const ReadingProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress.clamp(0.0, 1.0),
      minHeight: 3,
      backgroundColor: Colors.transparent,
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
    );
  }
}
