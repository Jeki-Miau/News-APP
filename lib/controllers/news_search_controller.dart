import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/services/news_service.dart';

/// Manages search state with debounced queries, recent searches, and trending topics.
class NewsSearchController extends GetxController {
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 10;

  final NewsService _newsService = NewsService();

  final RxString searchQuery = ''.obs;
  final RxList<NewsArticle> searchResults = <NewsArticle>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool hasSearched = false.obs;

  final List<String> trendingTopics = const [
    'Technology',
    'Artificial Intelligence',
    'Climate Change',
    'Economy',
    'Sports',
    'Health',
    'Politics',
    'Space',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
    // Debounce search: wait 400ms after user stops typing
    debounce(
      searchQuery,
      (_) => _performSearch(),
      time: const Duration(milliseconds: 400),
    );
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList(_recentSearchesKey) ?? [];
    recentSearches.assignAll(searches);
  }

  Future<void> _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchesKey, recentSearches.toList());
  }

  Future<void> _performSearch() async {
    final query = searchQuery.value.trim();
    if (query.isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      return;
    }

    isSearching.value = true;
    hasSearched.value = true;
    try {
      final response = await _newsService.searchNews(query: query);
      searchResults.assignAll(response.articles);
    } catch (e) {
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.trim().isNotEmpty) {
      addRecentSearch(query.trim());
    }
  }

  void addRecentSearch(String query) {
    recentSearches.remove(query);
    recentSearches.insert(0, query);
    if (recentSearches.length > _maxRecentSearches) {
      recentSearches.removeLast();
    }
    _saveRecentSearches();
  }

  void removeRecentSearch(String query) {
    recentSearches.remove(query);
    _saveRecentSearches();
  }

  void clearRecentSearches() {
    recentSearches.clear();
    _saveRecentSearches();
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    hasSearched.value = false;
  }
}
