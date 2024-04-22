import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String _tokenKey = 'token';
  static const String _userNameKey = 'userName';

  static Future<SharedPreferences> _prefsInstance() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await _prefsInstance();
      final sessionToken = prefs.getString(_tokenKey);
      return sessionToken != null;
    } catch (e) {
      print('Error checking if user is logged in: $e');
      return false;
    }
  }

  static Future<String> getToken() async {
    try {
      final prefs = await _prefsInstance();
      return prefs.getString(_tokenKey) ?? '';
    } catch (e) {
      print('Error retrieving token: $e');
      return '';
    }
  }

  static Future<void> setToken(String token) async {
    try {
      final prefs = await _prefsInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error setting token: $e');
    }
  }

  static Future<String> getUserName() async {
    try {
      final prefs = await _prefsInstance();
      return prefs.getString(_userNameKey) ?? '';
    } catch (e) {
      print('Error retrieving user name: $e');
      return '';
    }
  }

  static Future<void> setUserName(String userName) async {
    try {
      final prefs = await _prefsInstance();
      await prefs.setString(_userNameKey, userName);
    } catch (e) {
      print('Error setting user name: $e');
    }
  }

  static Future<void> clearUserData() async {
    try {
      final prefs = await _prefsInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userNameKey);
    } catch (e) {
      print('Error clearing Data: $e');
    }
  }
}
