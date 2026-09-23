import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/models/news_article.dart';

/// Manages bookmarked articles with local persistence via SharedPreferences.
class BookmarkController extends GetxController {
  static const String _bookmarksKey = 'bookmarked_articles';

  final RxList<NewsArticle> bookmarkedArticles = <NewsArticle>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_bookmarksKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      bookmarkedArticles.assignAll(
        jsonList.map((e) => NewsArticle.fromJson(e as Map<String, dynamic>)).toList(),
      );
    }
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(
      bookmarkedArticles.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_bookmarksKey, jsonString);
  }

  bool isBookmarked(NewsArticle article) {
    return bookmarkedArticles.any((a) => a.url == article.url);
  }

  Future<void> toggleBookmark(NewsArticle article) async {
    if (isBookmarked(article)) {
      bookmarkedArticles.removeWhere((a) => a.url == article.url);
    } else {
      bookmarkedArticles.add(article);
    }
    await _saveBookmarks();
  }

  Future<void> removeBookmark(NewsArticle article) async {
    bookmarkedArticles.removeWhere((a) => a.url == article.url);
    await _saveBookmarks();
  }
}
