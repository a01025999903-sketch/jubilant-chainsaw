import '../models/models.dart';
import 'api_service.dart';
import 'search_engine_service.dart';

class SearchService {
  final ApiService apiService;
  final SearchEngineService searchEngine;

  SearchService({
    required this.apiService,
    SearchEngineService? searchEngine,
  }) : searchEngine = searchEngine ?? SearchEngineService();

  Future<SearchResponse> search({
    required String query,
    List<String> phrases = const [],
    String? location,
    String sort = 'recent',
    int page = 1,
    int limit = 30,
  }) async {
    final response = await apiService.search(
      SearchQuery(
        q: query,
        location: location,
        sort: sort,
        page: page,
        limit: limit,
      ),
    );

    final scored = response.results.map((result) {
      final score = searchEngine.calculateRelevance(
        text: result.text,
        phrases: phrases.isEmpty ? [query] : phrases,
        location: location,
      );

      return SearchResult(
        id: result.id,
        text: result.text,
        groupName: result.groupName,
        authorName: result.authorName,
        date: result.date,
        url: result.url,
        location: result.location,
        relevance: score,
      );
    }).toList();

    scored.sort((a, b) => b.relevance.compareTo(a.relevance));

    return SearchResponse(
      success: response.success,
      results: scored,
    );
  }
}
