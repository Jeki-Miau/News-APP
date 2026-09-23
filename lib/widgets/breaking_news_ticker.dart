import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_text_styles.dart';

/// Breaking news ticker with gradient edge fading, pulsing BREAKING label,
/// and smooth auto-scrolling headlines.
class BreakingNewsTicker extends StatefulWidget {
  final List<String> headlines;

  const BreakingNewsTicker({super.key, required this.headlines});

  @override
  State<BreakingNewsTicker> createState() => _BreakingNewsTickerState();
}

class _BreakingNewsTickerState extends State<BreakingNewsTicker> {
  late ScrollController _scrollController;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  @override
  void dispose() {
    _isScrolling = false;
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startScrolling() async {
    _isScrolling = true;
    while (_isScrolling && mounted) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted || !_scrollController.hasClients) continue;

      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll <= 0) continue;

      final currentScroll = _scrollController.offset;
      if (currentScroll >= maxScroll) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(currentScroll + 0.8);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.headlines.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 4),

          // Pulsing "BREAKING" label
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.redAccent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.redAccent.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'BREAKING',
              style: AppTextStyles.caption(color: Colors.white).copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 11,
              ),
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scaleXY(
                begin: 1.0,
                end: 1.04,
                duration: 900.ms,
                curve: Curves.easeInOut,
              ),

          const SizedBox(width: 10),

          // Scrolling headlines with gradient edge fade
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white,
                  Colors.white,
                  Colors.transparent,
                ],
                stops: [0.0, 0.03, 0.92, 1.0],
              ).createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  children: widget.headlines
                      .map(
                        (headline) => Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                headline,
                                style: AppTextStyles.bodyMedium(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ).copyWith(fontWeight: FontWeight.w500),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
