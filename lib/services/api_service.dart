import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/models.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<SearchResponse> search(SearchQuery query) async {
    if (AppConfig.apiBaseUrl.isEmpty) {
      return const SearchResponse(success: true, results: []);
    }

    final uri = Uri.parse('${AppConfig.apiBaseUrl}/search').replace(
      queryParameters: {
        'q': query.q,
        if (query.location != null) 'location': query.location!,
        if (query.dateFrom != null) 'date_from': query.dateFrom!,
        if (query.dateTo != null) 'date_to': query.dateTo!,
        'sort': query.sort,
        'page': '${query.page}',
        'limit': '${query.limit}',
      },
    );

    final response = await _client.get(uri);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API Error: HTTP ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final rawResults = (data['results'] as List<dynamic>?) ?? [];

    final results = rawResults.map((item) {
      final map = item as Map<String, dynamic>;

      return SearchResult(
        id: '${map['id'] ?? ''}',
        text: '${map['text'] ?? ''}',
        groupName: map['group_name'] as String?,
        authorName: map['author_name'] as String?,
        date: DateTime.tryParse('${map['date'] ?? ''}'),
        url: '${map['url'] ?? ''}',
        location: map['location'] as String?,
        relevance: (map['relevance'] as num?)?.toInt() ?? 0,
      );
    }).toList();

    return SearchResponse(
      success: data['success'] == true,
      results: results,
    );
  }

  Future<bool> testConnection() async {
    if (AppConfig.apiBaseUrl.isEmpty) return false;

    final response = await _client.get(Uri.parse(AppConfig.apiBaseUrl));
    return response.statusCode >= 200 && response.statusCode < 500;
  }

  void dispose() {
    _client.close();
  }
}
