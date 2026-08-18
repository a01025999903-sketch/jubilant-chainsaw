import 'storage_service.dart';

class SavedPostService {
  final StorageService storage;

  SavedPostService({StorageService? storage})
      : storage = storage ?? StorageService();

  Future<List<Map<String, dynamic>>> getAll() => storage.getSavedPosts();

  Future<void> save(Map<String, dynamic> post) => storage.savePost(post);

  Future<void> delete(int index) => storage.deletePost(index);
}
