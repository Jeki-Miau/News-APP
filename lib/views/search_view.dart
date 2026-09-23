import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_search_controller.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_text_styles.dart';
import 'package:news_app/widgets/compact_news_card.dart';
import 'package:news_app/widgets/empty_state_widget.dart';
import 'package:news_app/widgets/loading_shimmer.dart';

/// Search view with animated search bar, staggered search results,
/// animated trending chips, and smooth transitions.
class SearchView extends GetView<NewsSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideX(begin: -0.05, end: 0),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Animated search bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: textController,
              onChanged: (value) =>
                  controller.searchQuery.value = value,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.search(value.trim());
                }
              },
              decoration: InputDecoration(
                hintText: 'Search for news...',
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textHint),
                suffixIcon: Obx(() {
                  if (controller.searchQuery.value.isNotEmpty) {
                    return IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        textController.clear();
                        controller.clearSearch();
                      },
                    ).animate().fadeIn(duration: 200.ms).scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                        );
                  }
                  return const SizedBox.shrink();
                }),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideY(begin: -0.05, end: 0, curve: Curves.easeOutCubic),

          // Content area
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return const LoadingShimmer();
              }

              if (controller.hasSearched.value) {
                if (controller.searchResults.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.search_off,
                    title: 'No results found',
                    subtitle: 'Try a different search term',
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      );
                }

                // Staggered search results
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final article = controller.searchResults[index];
                    return CompactNewsCard(
                      article: article,
                      onTap: () => _navigateToDetail(article),
                    )
                        .animate(
                            delay:
                                Duration(milliseconds: index * 60))
                        .fadeIn(duration: 300.ms)
                        .slideX(
                          begin: 0.05,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        );
                  },
                );
              }

              return _buildDefaultContent(context, textController);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent(
    BuildContext context,
    TextEditingController textController,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Recent searches
        Obx(() {
          if (controller.recentSearches.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Searches',
                    style: AppTextStyles.label(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.clearRecentSearches,
                    child: Text(
                      'Clear All',
                      style: AppTextStyles.caption(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 200.ms),
              ...controller.recentSearches.asMap().entries.map(
                    (entry) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.history,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      title: Text(
                        entry.value,
                        style: AppTextStyles.bodyMedium(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.textHint,
                        ),
                        onPressed: () => controller
                            .removeRecentSearch(entry.value),
                      ),
                      onTap: () {
                        textController.text = entry.value;
                        controller.search(entry.value);
                      },
                    )
                        .animate(
                            delay: Duration(
                                milliseconds: 250 + entry.key * 50))
                        .fadeIn(duration: 300.ms)
                        .slideX(
                          begin: -0.05,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        ),
                  ),
              const Divider(),
            ],
          );
        }),

        // Trending topics with staggered chip animation
        const SizedBox(height: 16),
        Text(
          'Trending Topics',
          style: AppTextStyles.label(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        )
            .animate(delay: 300.ms)
            .fadeIn(duration: 300.ms),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.trendingTopics
              .asMap()
              .entries
              .map((entry) {
            return ActionChip(
              label: Text(entry.value),
              avatar: const Icon(
                Icons.trending_up,
                size: 18,
                color: AppColors.accent,
              ),
              onPressed: () {
                textController.text = entry.value;
                controller.search(entry.value);
              },
            )
                .animate(
                    delay:
                        Duration(milliseconds: 350 + entry.key * 50))
                .fadeIn(duration: 300.ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                );
          }).toList(),
        ),
      ],
    );
  }

  void _navigateToDetail(NewsArticle article) {
    Get.toNamed(Routes.NEWS_DETAIL, arguments: article);
  }
}
