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
    'General', 'Business', 'Technology', 'Health', 'Science', 'Sports', 'Entertainment'
  ];
  
  final RxString _selectedCategory = 'General'.obs;
  String get selectedCategory => _selectedCategory.value;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    _isLoading.value = true;
    _error.value = '';
    try {
      final response = await _newsService.getTopHeadlines(
        category: _selectedCategory.value.toLowerCase(),
      );
      _articles.assignAll(response.articles);
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
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