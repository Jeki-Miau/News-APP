import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/compact_news_card.dart';
import 'package:news_app/widgets/empty_state_widget.dart';

/// Bookmarks view with staggered item entrance animation
/// and animated swipe-to-delete.
class BookmarksView extends GetView<BookmarkController> {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideX(begin: -0.05, end: 0),
        centerTitle: false,
        actions: [
          Obx(() {
            if (controller.bookmarkedArticles.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(
                  '${controller.bookmarkedArticles.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColors.accent,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ).animate().fadeIn(duration: 300.ms).scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                  ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.bookmarkedArticles.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.bookmark_border,
            title: 'No bookmarks yet',
            subtitle: 'Save articles you want to read later',
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                curve: Curves.easeOutCubic,
              );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: controller.bookmarkedArticles.length,
          itemBuilder: (context, index) {
            final article = controller.bookmarkedArticles[index];
            return Dismissible(
              key: ValueKey(article.url),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              onDismissed: (_) {
                controller.removeBookmark(article);
                Get.snackbar(
                  'Removed',
                  'Bookmark removed',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(12),
                  borderRadius: 12,
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.error),
                );
              },
              child: CompactNewsCard(
                article: article,
                onTap: () => _navigateToDetail(article),
              ),
            )
                .animate(delay: Duration(milliseconds: index * 60))
                .fadeIn(duration: 350.ms)
                .slideX(
                  begin: 0.06,
                  end: 0,
                  curve: Curves.easeOutCubic,
                );
          },
        );
      }),
    );
  }

  void _navigateToDetail(NewsArticle article) {
    Get.toNamed(Routes.NEWS_DETAIL, arguments: article);
  }
}
