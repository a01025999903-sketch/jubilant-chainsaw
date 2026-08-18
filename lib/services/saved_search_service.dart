import 'storage_service.dart';

class SavedSearchService {
  final StorageService storage;

  SavedSearchService({StorageService? storage})
      : storage = storage ?? StorageService();

  Future<List<Map<String, dynamic>>> getAll() => storage.getSavedSearches();

  Future<void> save(Map<String, dynamic> search) => storage.saveSearch(search);

  Future<void> delete(int index) => storage.deleteSearch(index);
}
