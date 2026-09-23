import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_text_styles.dart';
import 'package:news_app/widgets/pressable_scale.dart';

/// Horizontal compact card with press scale animation, animated bookmark toggle,
/// and Hero animation on thumbnail.
class CompactNewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const CompactNewsCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkCtrl = Get.find<BookmarkController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PressableScale(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: isDark ? 2 : 1,
        shadowColor: isDark ? Colors.black26 : AppColors.cardShadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Text content (left side)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Source + time
                    Row(
                      children: [
                        if (article.source?.name != null) ...[
                          Flexible(
                            child: Text(
                              article.source!.name!,
                              style: AppTextStyles.caption(
                                color: AppColors.accent,
                              ).copyWith(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (article.publishedAt != null)
                          Text(
                            timeago.format(
                              DateTime.parse(article.publishedAt!),
                            ),
                            style: AppTextStyles.caption(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Title (max 2 lines)
                    if (article.title != null)
                      Text(
                        article.title!,
                        style: AppTextStyles.label(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),

                    // Animated bookmark toggle
                    Obx(() {
                      final isBookmarked =
                          bookmarkCtrl.isBookmarked(article);
                      return GestureDetector(
                        onTap: () => bookmarkCtrl.toggleBookmark(article),
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
                            size: 20,
                            color: isBookmarked
                                ? AppColors.accent
                                : AppColors.textHint,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Thumbnail (right side) with rounded corners
              Hero(
                tag: 'article-image-${article.url}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: article.urlToImage != null
                      ? CachedNetworkImage(
                          imageUrl: article.urlToImage!,
                          width: 85,
                          height: 85,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 85,
                            height: 85,
                            color: isDark
                                ? AppColors.cardDark
                                : AppColors.divider,
                          ),
                          errorWidget: (context, url, error) =>
                              Container(
                            width: 85,
                            height: 85,
                            color: isDark
                                ? AppColors.cardDark
                                : AppColors.divider,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 24,
                              color: AppColors.textHint,
                            ),
                          ),
                        )
                      : Container(
                          width: 85,
                          height: 85,
                          color: isDark
                              ? AppColors.cardDark
                              : AppColors.divider,
                          child: const Icon(
                            Icons.newspaper,
                            size: 24,
                            color: AppColors.textHint,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
