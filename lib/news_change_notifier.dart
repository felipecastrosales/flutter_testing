import 'package:flutter/material.dart';
import 'package:flutter_testing/article.dart';
import 'package:flutter_testing/news_service.dart';

class NewsChangeNotifier extends ChangeNotifier {
  final NewsService newsService;

  NewsChangeNotifier(this.newsService);

  final List<Article> _articles = [];

  List<Article> get articles => _articles;

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getArticles() async {}
}
