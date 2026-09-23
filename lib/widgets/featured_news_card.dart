import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_text_styles.dart';
import 'package:news_app/widgets/pressable_scale.dart';

/// Large, image-dominant card with glassmorphism overlay, press animation,
/// and animated bookmark toggle.
class FeaturedNewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;
  final double height;

  const FeaturedNewsCard({
    super.key,
    required this.article,
    required this.onTap,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkCtrl = Get.find<BookmarkController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PressableScale(
      onTap: onTap,
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black38
                  : AppColors.accent.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image with Hero animation
              Hero(
                tag: 'article-image-${article.url}',
                child: article.urlToImage != null
                    ? CachedNetworkImage(
                        imageUrl: article.urlToImage!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDark
                              ? AppColors.cardDark
                              : AppColors.divider,
                          child: const Center(
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: isDark
                              ? AppColors.cardDark
                              : AppColors.divider,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: AppColors.textHint,
                          ),
                        ),
                      )
                    : Container(
                        color: isDark
                            ? AppColors.cardDark
                            : AppColors.divider,
                        child: const Icon(
                          Icons.newspaper,
                          size: 48,
                          color: AppColors.textHint,
                        ),
                      ),
              ),

              // Multi-stop gradient overlay for depth
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    stops: const [0.0, 0.25, 0.6, 1.0],
                  ),
                ),
              ),

              // Bookmark button (top-right) with animated toggle
              Positioned(
                top: 12,
                right: 12,
                child: Obx(() {
                  final isBookmarked = bookmarkCtrl.isBookmarked(article);
                  return GestureDetector(
                    onTap: () => bookmarkCtrl.toggleBookmark(article),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isBookmarked
                            ? AppColors.accent
                            : Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          key: ValueKey(isBookmarked),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              // Bottom content overlay
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Source badge + time
                    Row(
                      children: [
                        if (article.source?.name != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              article.source!.name!,
                              style: AppTextStyles.caption(
                                color: Colors.white,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (article.publishedAt != null)
                          Text(
                            timeago.format(
                              DateTime.parse(article.publishedAt!),
                            ),
                            style: AppTextStyles.caption(
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Title with text shadow for readability
                    if (article.title != null)
                      Text(
                        article.title!,
                        style: AppTextStyles.headline3(color: Colors.white)
                            .copyWith(
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
