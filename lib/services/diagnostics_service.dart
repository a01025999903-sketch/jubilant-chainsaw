class DiagnosticsService {
  DateTime? lastRequestTime;
  int? lastStatusCode;
  int? lastResponseTimeMs;
  String? lastRequest;
  String? lastResponse;
  String? lastError;

  void recordRequest(String request) {
    lastRequestTime = DateTime.now();
    lastRequest = request;
    lastError = null;
  }

  void recordResponse({
    required int statusCode,
    required int responseTimeMs,
    String? response,
  }) {
    lastStatusCode = statusCode;
    lastResponseTimeMs = responseTimeMs;
    lastResponse = response;
  }

  void recordError(String error) {
    lastError = error;
  }
}
