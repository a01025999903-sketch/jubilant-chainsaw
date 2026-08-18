import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/search_service.dart';

class HunterProvider extends ChangeNotifier {
  final SearchService searchService;

  HunterProvider({SearchService? searchService})
      : searchService = searchService ??
            SearchService(apiService: ApiService());

  bool isLoading = false;
  String? errorMessage;
  List<SearchResult> results = [];
  String lastQuery = '';

  Future<void> search({
    required String query,
    List<String> phrases = const [],
    String? location,
  }) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      errorMessage = 'اكتب الخدمة أو الطلب الأول';
      results = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    lastQuery = cleanQuery;
    notifyListeners();

    try {
      final response = await searchService.search(
        query: cleanQuery,
        phrases: phrases,
        location: location,
      );

      results = response.results;

      if (results.isEmpty) {
        errorMessage = 'ملقيناش نتائج مطابقة';
      }
    } catch (_) {
      errorMessage = 'حصل خطأ أثناء البحث';
      results = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    results = [];
    errorMessage = null;
    notifyListeners();
  }
}
