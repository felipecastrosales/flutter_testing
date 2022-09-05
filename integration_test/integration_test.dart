import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/article.dart';
import 'package:flutter_testing/article_page.dart';
import 'package:flutter_testing/news_change_notifier.dart';
import 'package:flutter_testing/news_page.dart';
import 'package:flutter_testing/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  final articlesFromService = [
    Article(title: 'Article 1', content: 'Content 1'),
    Article(title: 'Article 2', content: 'Content 2'),
    Article(title: 'Article 3', content: 'Content 3'),
  ];

  void arrangeNewsServiceReturns3Articles() {
    when(() => mockNewsService.getArticles()).thenAnswer(
      (_) async => articlesFromService,
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    '''Tapping on the first article excerpt opens the article page 
      where the full article content is displayed''',
    (tester) async {
      arrangeNewsServiceReturns3Articles();
      await tester.pumpWidget(
        createWidgetUnderTest(),
      );
      await tester.pump();
      await tester.tap(find.text('Content 1'));
      await tester.pumpAndSettle();
      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(ArticlePage), findsOneWidget);
      expect(find.text('Article 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
    },
  );
}
