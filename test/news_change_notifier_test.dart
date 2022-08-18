import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/article.dart';
import 'package:flutter_testing/news_change_notifier.dart';
import 'package:flutter_testing/news_service.dart';
import 'package:mocktail/mocktail.dart';

///BAD
class BadMockNewsService implements NewsService {
  bool getArticleCalled = false;
  @override
  Future<List<Article>> getArticles() async {
    getArticleCalled = true;
    return [Article(title: 'Article 1', content: 'Content 1')];
  }
}

///GOOD
class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
    'initial values are correct',
    () {
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    },
  );

  group('getArticles', () {
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

    test(
      'gets articles using the News Service',
      () async {
        arrangeNewsServiceReturns3Articles();
        await sut.getArticles();
        verify(() => mockNewsService.getArticles()).called(1);
      },
    );

    test(
      '''indicates loading of data,
      sets articles to the ones from the service,
      indicates that data is not being loaded anymore''',
      () async {
        arrangeNewsServiceReturns3Articles();
        final future = sut.getArticles();
        expect(sut.isLoading, true);
        await future;
        expect(
          sut.articles,
          articlesFromService,
        );
        expect(sut.isLoading, false);
      },
    );
  });
}
