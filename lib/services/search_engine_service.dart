class SearchEngineService {
  int calculateRelevance({
    required String text,
    required List<String> phrases,
    String? location,
  }) {
    final normalized = text.toLowerCase();
    var score = 0;

    for (final phrase in phrases) {
      final p = phrase.trim().toLowerCase();
      if (p.isEmpty) continue;

      if (normalized.contains(p)) {
        score += 35;
      }

      final words = p.split(RegExp(r'\s+'));
      final matchedWords =
          words.where((word) => normalized.contains(word)).length;

      score += matchedWords * 8;
    }

    if (location != null &&
        location.trim().isNotEmpty &&
        normalized.contains(location.trim().toLowerCase())) {
      score += 10;
    }

    return score.clamp(0, 100);
  }
}
