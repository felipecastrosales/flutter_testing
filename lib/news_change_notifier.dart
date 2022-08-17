import 'package:flutter/material.dart';
import 'package:flutter_testing/article.dart';
import 'package:flutter_testing/news_service.dart';

class NewsChangeNotifier extends ChangeNotifier {
  final NewsService newsService;

  NewsChangeNotifier(this.newsService);

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getArticles() async {
    _isLoading = true;
    notifyListeners();
    _articles = await newsService.getArticles();
    _isLoading = false;
    notifyListeners();
  }
}
