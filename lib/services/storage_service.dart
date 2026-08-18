import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _savedSearchesKey = 'saved_searches';
  static const _savedPostsKey = 'saved_posts';

  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  Future<List<Map<String, dynamic>>> getSavedSearches() async {
    final raw = (await _prefs).getStringList(_savedSearchesKey) ?? [];
    return raw
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  Future<void> saveSearch(Map<String, dynamic> search) async {
    final prefs = await _prefs;
    final items = prefs.getStringList(_savedSearchesKey) ?? [];
    items.add(jsonEncode(search));
    await prefs.setStringList(_savedSearchesKey, items);
  }

  Future<void> deleteSearch(int index) async {
    final prefs = await _prefs;
    final items = prefs.getStringList(_savedSearchesKey) ?? [];
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      await prefs.setStringList(_savedSearchesKey, items);
    }
  }

  Future<List<Map<String, dynamic>>> getSavedPosts() async {
    final raw = (await _prefs).getStringList(_savedPostsKey) ?? [];
    return raw
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  Future<void> savePost(Map<String, dynamic> post) async {
    final prefs = await _prefs;
    final items = prefs.getStringList(_savedPostsKey) ?? [];
    items.add(jsonEncode(post));
    await prefs.setStringList(_savedPostsKey, items);
  }

  Future<void> deletePost(int index) async {
    final prefs = await _prefs;
    final items = prefs.getStringList(_savedPostsKey) ?? [];
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      await prefs.setStringList(_savedPostsKey, items);
    }
  }
}
