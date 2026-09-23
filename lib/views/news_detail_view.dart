import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/controllers/settings_controller.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/app_text_styles.dart';
import 'package:news_app/widgets/compact_news_card.dart';
import 'package:news_app/widgets/reading_progress_bar.dart';
import 'package:news_app/widgets/section_header.dart';

/// Redesigned detail screen with flutter_animate content stagger,
/// Hero animation, reading progress, font controls, and bottom action bar.
class NewsDetailView extends StatefulWidget {
  const NewsDetailView({super.key});

  @override
  State<NewsDetailView> createState() => _NewsDetailViewState();
}

class _NewsDetailViewState extends State<NewsDetailView> {
  final NewsArticle article = Get.arguments as NewsArticle;
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  bool _showFontControls = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent > 0) {
      final newProgress = _scrollController.offset /
          _scrollController.position.maxScrollExtent;
      setState(() {
        _scrollProgress = newProgress;
        // Hide font controls when scrolled past header
        _showFontControls = _scrollController.offset < 350;
      });
    }
  }

  int _estimateReadingTime() {
    final text = '${article.content ?? ''} ${article.description ?? ''}';
    final wordCount =
        text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkCtrl = Get.find<BookmarkController>();
    final settingsCtrl = Get.find<SettingsController>();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // Collapsing AppBar with parallax image
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Hero(
                    tag: 'article-image-${article.url}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        article.urlToImage != null
                            ? CachedNetworkImage(
                                imageUrl: article.urlToImage!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.divider,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Container(
                                  color: AppColors.divider,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.divider,
                                child: const Icon(
                                  Icons.newspaper,
                                  size: 50,
                                  color: AppColors.textHint,
                                ),
                              ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.1),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.6),
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Article content with stagger animations
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source + Date + Reading time — animate first
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (article.source?.name != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                article.source!.name!,
                                style: AppTextStyles.caption(
                                  color: AppColors.accent,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          if (article.publishedAt != null)
                            Text(
                              timeago.format(
                                DateTime.parse(article.publishedAt!),
                              ),
                              style: AppTextStyles.caption(),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.schedule,
                                    size: 12, color: AppColors.success),
                                const SizedBox(width: 4),
                                Text(
                                  '~${_estimateReadingTime()} min read',
                                  style: AppTextStyles.caption(
                                    color: AppColors.success,
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
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

                      const SizedBox(height: 20),

                      // Title — animate with delay
                      if (article.title != null)
                        Obx(() => Text(
                              article.title!,
                              style: AppTextStyles.headline1(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ).copyWith(
                                fontSize: settingsCtrl.fontSize + 8,
                                height: 1.3,
                              ),
                            ))
                            .animate(delay: 100.ms)
                            .fadeIn(duration: 500.ms)
                            .slideY(
                              begin: 0.06,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),

                      const SizedBox(height: 24),

                      // Description — animate with more delay
                      if (article.description != null) ...[
                        Obx(() => Text(
                              article.description!,
                              style: AppTextStyles.bodyLarge(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              ).copyWith(
                                fontSize: settingsCtrl.fontSize,
                                height: 1.7,
                              ),
                            ))
                            .animate(delay: 200.ms)
                            .fadeIn(duration: 500.ms)
                            .slideY(
                              begin: 0.06,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),
                        const SizedBox(height: 24),

                        // Divider
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        )
                            .animate(delay: 300.ms)
                            .fadeIn(duration: 400.ms)
                            .scaleX(
                              begin: 0,
                              end: 1,
                              alignment: Alignment.centerLeft,
                              curve: Curves.easeOutCubic,
                            ),
                        const SizedBox(height: 24),
                      ],

                      // Content — animate with more delay
                      if (article.content != null) ...[
                        Text(
                          'Full Story',
                          style: AppTextStyles.headline3(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color,
                          ),
                        )
                            .animate(delay: 350.ms)
                            .fadeIn(duration: 400.ms),
                        const SizedBox(height: 12),
                        Obx(() => Text(
                              article.content!.replaceAll(RegExp(r'\[\+\d+\s+chars\]'), '...'),
                              style: AppTextStyles.bodyLarge(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ).copyWith(
                                fontSize: settingsCtrl.fontSize,
                                height: 1.8,
                              ),
                            ))
                            .animate(delay: 400.ms)
                            .fadeIn(duration: 500.ms)
                            .slideY(
                              begin: 0.04,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),
                        const SizedBox(height: 28),
                      ],

                      // Read Full Article button — animate in
                      if (article.url != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _openInBrowser,
                            icon:
                                const Icon(Icons.open_in_new, size: 18),
                            label: const Text('Read Full Article'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                            ),
                          ),
                        )
                            .animate(delay: 500.ms)
                            .fadeIn(duration: 400.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),

                      const SizedBox(height: 36),

                      // Related Articles — animate in
                      _buildRelatedArticles()
                          .animate(delay: 600.ms)
                          .fadeIn(duration: 500.ms),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Reading progress bar at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: ReadingProgressBar(progress: _scrollProgress),
            ),
          ),
        ],
      ),

      // Font size FABs — animated visibility based on scroll
      floatingActionButton: AnimatedOpacity(
        opacity: _showFontControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: AnimatedSlide(
          offset: _showFontControls ? Offset.zero : const Offset(1.5, 0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                heroTag: 'font_increase',
                onPressed: () => settingsCtrl.increaseFontSize(),
                child: const Text(
                  'A+',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'font_decrease',
                onPressed: () => settingsCtrl.decreaseFontSize(),
                child: const Text(
                  'A−',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom action bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Bookmark toggle — animated icon
                Obx(() {
                  final isBookmarked =
                      bookmarkCtrl.isBookmarked(article);
                  return _buildActionButton(
                    icon: isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    label: isBookmarked ? 'Saved' : 'Save',
                    color: isBookmarked ? AppColors.accent : null,
                    onTap: () =>
                        bookmarkCtrl.toggleBookmark(article),
                    animated: true,
                    isActive: isBookmarked,
                  );
                }),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: _shareArticle,
                ),
                _buildActionButton(
                  icon: Icons.open_in_browser,
                  label: 'Browser',
                  onTap: _openInBrowser,
                ),
                _buildActionButton(
                  icon: Icons.link,
                  label: 'Copy',
                  onTap: _copyLink,
                ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(delay: 300.ms, duration: 400.ms)
          .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
    bool animated = false,
    bool isActive = false,
  }) {
    final iconWidget = animated
        ? AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              icon,
              key: ValueKey(isActive),
              size: 22,
              color: color ?? Theme.of(context).iconTheme.color,
            ),
          )
        : Icon(
            icon,
            size: 22,
            color: color ?? Theme.of(context).iconTheme.color,
          );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption(
                color: color ??
                    Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedArticles() {
    try {
      final newsCtrl = Get.find<NewsController>();
      final related = newsCtrl.articles
          .where((a) => a.url != article.url)
          .take(5)
          .toList();

      if (related.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Related Articles'),
          ...related.asMap().entries.map(
                (entry) => CompactNewsCard(
                  article: entry.value,
                  onTap: () => Get.toNamed(Routes.NEWS_DETAIL,
                      arguments: entry.value),
                )
                    .animate(
                        delay: Duration(milliseconds: entry.key * 60))
                    .fadeIn(duration: 300.ms)
                    .slideY(
                      begin: 0.08,
                      end: 0,
                      curve: Curves.easeOutCubic,
                    ),
              ),
        ],
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }

  void _shareArticle() {
    if (article.url != null) {
      SharePlus.instance.share(
        ShareParams(
          text:
              '${article.title ?? 'Check out this news'}\n\n${article.url!}',
          subject: article.title,
        ),
      );
    }
  }

  void _copyLink() {
    if (article.url != null) {
      Clipboard.setData(ClipboardData(text: article.url!));
      Get.snackbar(
        'Copied!',
        'Link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle, color: AppColors.success),
      );
    }
  }

  void _openInBrowser() async {
    if (article.url != null) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open the link',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );
      }
    }
  }
}