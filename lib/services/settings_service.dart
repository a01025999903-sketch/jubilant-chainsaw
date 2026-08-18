import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _apiUrlKey = 'api_base_url';
  static const _notificationsKey = 'notifications_enabled';

  Future<String> getApiBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiUrlKey) ?? '';
  }

  Future<void> setApiBaseUrl(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiUrlKey, value.trim());
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? false;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
  }
}
