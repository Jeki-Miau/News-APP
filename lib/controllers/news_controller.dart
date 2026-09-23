import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/services/news_service.dart';

class NewsController extends GetxController {
  final NewsService _newsService = NewsService();

  final RxList<NewsArticle> _articles = <NewsArticle>[].obs;
  List<NewsArticle> get articles => _articles;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _error = ''.obs;
  String get error => _error.value;

  final List<String> categories = [
    'General',
    'Business',
    'Technology',
    'Health',
    'Science',
    'Sports',
    'Entertainment',
  ];

  final RxString _selectedCategory = 'General'.obs;
  String get selectedCategory => _selectedCategory.value;

  /// Top 5 articles for the featured carousel banner.
  List<NewsArticle> get featuredArticles =>
      _articles.take(5).toList();

  /// Remaining articles for the list below the carousel.
  List<NewsArticle> get regularArticles =>
      _articles.length > 5 ? _articles.skip(5).toList() : [];

  final RxBool _isLoadingMore = false.obs;
  bool get isLoadingMore => _isLoadingMore.value;

  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool get hasReachedMax => _hasReachedMax;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    _isLoading.value = true;
    _error.value = '';
    _currentPage = 1;
    _hasReachedMax = false;
    try {
      final response = await _newsService.getTopHeadlines(
        category: _selectedCategory.value == 'General' ? null : _selectedCategory.value.toLowerCase(),
        page: _currentPage,
      );
      _articles.assignAll(response.articles);
      if (_articles.length >= (response.totalResults ?? 0) || response.articles.isEmpty) {
        _hasReachedMax = true;
      }
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> fetchMoreNews() async {
    if (_isLoadingMore.value || _hasReachedMax || _isLoading.value) return;
    
    _isLoadingMore.value = true;
    _currentPage++;
    try {
      final response = await _newsService.getTopHeadlines(
        category: _selectedCategory.value == 'General' ? null : _selectedCategory.value.toLowerCase(),
        page: _currentPage,
      );
      if (response.articles.isEmpty) {
        _hasReachedMax = true;
      } else {
        _articles.addAll(response.articles);
        if (_articles.length >= (response.totalResults ?? 0)) {
          _hasReachedMax = true;
        }
      }
    } catch (e) {
      if (e.toString().contains('426') || e.toString().contains('Upgrade') || e.toString().contains('maximumResultsReached')) {
        _hasReachedMax = true;
      }
      // Revert page if error
      _currentPage--;
    } finally {
      _isLoadingMore.value = false;
    }
  }

  void selectCategory(String category) {
    if (_selectedCategory.value == category) return;
    _selectedCategory.value = category;
    fetchNews();
  }

  Future<void> refreshNews() async {
    await fetchNews();
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      fetchNews();
      return;
    }
    _isLoading.value = true;
    _error.value = '';
    try {
      final response = await _newsService.searchNews(query: query);
      _articles.assignAll(response.articles);
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }
}