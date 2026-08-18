class SearchQuery {
  final String q;
  final String? location;
  final String? dateFrom;
  final String? dateTo;
  final String sort;
  final int page;
  final int limit;

  const SearchQuery({
    required this.q,
    this.location,
    this.dateFrom,
    this.dateTo,
    this.sort = 'recent',
    this.page = 1,
    this.limit = 30,
  });
}

class SearchResult {
  final String id;
  final String text;
  final String? groupName;
  final String? authorName;
  final DateTime? date;
  final String url;
  final String? location;
  final int relevance;

  const SearchResult({
    required this.id,
    required this.text,
    this.groupName,
    this.authorName,
    this.date,
    required this.url,
    this.location,
    this.relevance = 0,
  });
}

class SearchResponse {
  final bool success;
  final List<SearchResult> results;

  const SearchResponse({
    required this.success,
    required this.results,
  });
}

class SavedSearch {
  final String id;
  final String name;
  final List<String> keywords;
  final String? location;

  const SavedSearch({
    required this.id,
    required this.name,
    required this.keywords,
    this.location,
  });
}

class SavedPost {
  final String id;
  final String text;
  final String url;
  final String? groupName;
  final DateTime? date;
  final String searchQuery;

  const SavedPost({
    required this.id,
    required this.text,
    required this.url,
    this.groupName,
    this.date,
    required this.searchQuery,
  });
}

class AuthenticatedUser {
  final String id;
  final String name;
  final String? email;

  const AuthenticatedUser({
    required this.id,
    required this.name,
    this.email,
  });
}

class AppSettings {
  final int resultLimit;
  final String defaultSort;
  final bool notificationsEnabled;
  final String apiBaseUrl;

  const AppSettings({
    this.resultLimit = 30,
    this.defaultSort = 'recent',
    this.notificationsEnabled = false,
    this.apiBaseUrl = '',
  });
}

class Diagnostics {
  final bool apiOnline;
  final String? lastRequest;
  final String? lastResponse;
  final int? responseTimeMs;
  final int? httpStatus;
  final String? errorMessage;

  const Diagnostics({
    this.apiOnline = false,
    this.lastRequest,
    this.lastResponse,
    this.responseTimeMs,
    this.httpStatus,
    this.errorMessage,
  });
}

class Opportunity {
  final SearchResult post;
  final List<String> matchingPhrases;

  const Opportunity({
    required this.post,
    this.matchingPhrases = const [],
  });
}

class Radar {
  final String id;
  final String name;
  final List<String> keywords;
  final String? location;
  final String frequency;

  const Radar({
    required this.id,
    required this.name,
    required this.keywords,
    this.location,
    this.frequency = 'daily',
  });
}

class Analytics {
  final int totalOpportunities;
  final int highRelevance;
  final int savedPosts;

  const Analytics({
    this.totalOpportunities = 0,
    this.highRelevance = 0,
    this.savedPosts = 0,
  });
}
