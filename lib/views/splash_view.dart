import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_text_styles.dart';

/// Animated splash screen with multi-phase flutter_animate sequence:
/// logo scales in with elastic curve, then title + tagline slide up.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) Get.offAllNamed(Routes.MAIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App logo — elastic scale + fade + shimmer
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.5),
                    blurRadius: 40,
                    spreadRadius: 4,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'N',
                  style: AppTextStyles.headline1(color: Colors.white)
                      .copyWith(fontSize: 52),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(
                  begin: const Offset(0.3, 0.3),
                  end: const Offset(1.0, 1.0),
                  duration: 900.ms,
                  curve: Curves.elasticOut,
                )
                .then(delay: 300.ms)
                .shimmer(
                  duration: 1200.ms,
                  color: Colors.white30,
                ),

            const SizedBox(height: 28),

            // App name — slide up + fade in
            Text(
              'News App',
              style: AppTextStyles.headline1(color: Colors.white)
                  .copyWith(fontSize: 32, letterSpacing: 1.0),
            )
                .animate(delay: 500.ms)
                .fadeIn(duration: 500.ms)
                .slideY(
                  begin: 0.5,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOutCubic,
                ),

            const SizedBox(height: 10),

            // Tagline — slide up + fade in (slightly later)
            Text(
              'Stay Informed',
              style: AppTextStyles.bodyMedium(color: Colors.white60)
                  .copyWith(letterSpacing: 2.0, fontSize: 14),
            )
                .animate(delay: 750.ms)
                .fadeIn(duration: 500.ms)
                .slideY(
                  begin: 0.5,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOutCubic,
                ),

            const SizedBox(height: 48),

            // Loading indicator — appears last
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white38,
              ),
            )
                .animate(delay: 1200.ms)
                .fadeIn(duration: 400.ms)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                ),
          ],
        ),
      ),
    );
  }
}
