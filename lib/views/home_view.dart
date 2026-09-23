import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_text_styles.dart';
import 'package:news_app/widgets/breaking_news_ticker.dart';
import 'package:news_app/widgets/category_chip.dart';
import 'package:news_app/widgets/compact_news_card.dart';
import 'package:news_app/widgets/error_state_widget.dart';
import 'package:news_app/widgets/featured_news_card.dart';
import 'package:news_app/widgets/loading_shimmer.dart';
import 'package:news_app/widgets/section_header.dart';

/// Home view with auto-scrolling carousel, time-based greeting,
/// flutter_animate staggered entrance animations on all sections.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  final NewsController controller = Get.find<NewsController>();
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final featured = controller.featuredArticles;
      if (featured.isEmpty) return;

      int nextPage = (_pageController.page?.round() ?? 0) + 1;
      if (nextPage >= featured.length) nextPage = 0;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  String _getGreetingText() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny;
    if (hour < 17) return Icons.wb_cloudy;
    return Icons.nights_stay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading && controller.articles.isEmpty) {
          return const LoadingShimmer();
        }

        if (controller.error.isNotEmpty && controller.articles.isEmpty) {
          return ErrorStateWidget(onRetry: controller.refreshNews);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNews,
          color: AppColors.accent,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollUpdateNotification && scrollInfo.metrics.hasContentDimensions) {
                if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.fetchMoreNews();
                  });
                }
              }
              return false;
            },
            child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // Custom SliverAppBar with greeting
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0,
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.75),
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                toolbarHeight: 72,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _getGreetingText(),
                          style: AppTextStyles.caption().copyWith(
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _getGreetingIcon(),
                          size: 14,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent
                                    .withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'N',
                              style: AppTextStyles.label(
                                      color: Colors.white)
                                  .copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'News App',
                          style: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle,
                        ),
                      ],
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideX(
                      begin: -0.05,
                      end: 0,
                      curve: Curves.easeOutCubic,
                    ),
                centerTitle: false,
              ),

              // Featured Carousel with auto-scroll
              if (controller.featuredArticles.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildFeaturedCarousel(context)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 100.ms)
                      .slideY(
                        begin: 0.06,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ),

              // Breaking News Ticker
              if (controller.articles.isNotEmpty)
                SliverToBoxAdapter(
                  child: BreakingNewsTicker(
                    headlines: controller.articles
                        .take(10)
                        .where((a) => a.title != null)
                        .map((a) => a.title!)
                        .toList(),
                  )
                      .animate(delay: 250.ms)
                      .fadeIn(duration: 400.ms)
                      .slideX(
                        begin: 0.03,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      ),
                ),

              // Category Pills
              SliverPersistentHeader(
                pinned: true,
                delegate: _CategoryHeaderDelegate(
                  child: _buildCategoryPills()
                      .animate(delay: 350.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(
                        begin: 0.08,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      ),
                ),
              ),

              // Section header
              SliverToBoxAdapter(
                child: const SectionHeader(title: 'Latest News')
                    .animate(delay: 450.ms)
                    .fadeIn(duration: 400.ms),
              ),

              // News List — mixed layout with staggered animation
              if (controller.regularArticles.isEmpty &&
                  controller.featuredArticles.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No articles available',
                      style: AppTextStyles.bodyMedium(),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final articles = controller.regularArticles;
                      if (index >= articles.length) return null;
                      final article = articles[index];

                      Widget card;
                      if (index == 0) {
                        card = FeaturedNewsCard(
                          article: article,
                          onTap: () => _navigateToDetail(article),
                        );
                      } else {
                        card = CompactNewsCard(
                          article: article,
                          onTap: () => _navigateToDetail(article),
                        );
                      }

                      return card
                          .animate(
                              delay: Duration(
                                  milliseconds: 500 + index * 60))
                          .fadeIn(duration: 400.ms)
                          .slideY(
                            begin: 0.08,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          );
                    },
                    childCount: controller.regularArticles.length,
                  ),
                ),

              // Pagination loading indicator
              if (controller.isLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              if (!controller.isLoadingMore && controller.hasReachedMax)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No more articles',
                        style: AppTextStyles.caption(),
                      ),
                    ),
                  ),
                ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
            ],
          ),
          ),
        );
      }),
    );
  }

  Widget _buildFeaturedCarousel(BuildContext context) {
    final featured = controller.featuredArticles;

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _pageController,
            itemCount: featured.length,
            itemBuilder: (context, index) {
              final article = featured[index];
              // Parallax scale effect based on page position
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = (_pageController.page ?? 0) - index;
                    value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
                  }
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: FeaturedNewsCard(
                  article: article,
                  onTap: () => _navigateToDetail(article),
                  height: 240,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: featured.length,
          effect: ExpandingDotsEffect(
            activeDotColor: AppColors.accent,
            dotColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.dividerDark
                : AppColors.divider,
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 4,
            spacing: 6,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildCategoryPills() {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return Obx(
            () => CategoryChip(
              label: category,
              isSelected: controller.selectedCategory == category,
              onTap: () => controller.selectCategory(category),
            ),
          );
        },
      ),
    );
  }

  void _navigateToDetail(NewsArticle article) {
    Get.toNamed(Routes.NEWS_DETAIL, arguments: article);
  }
}

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CategoryHeaderDelegate({required this.child});

  @override
  double get minExtent => 72.0;
  @override
  double get maxExtent => 72.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 72.0,
          alignment: Alignment.center,
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.75),
          child: child,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_CategoryHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}