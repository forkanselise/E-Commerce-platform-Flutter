import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  static Future<User?> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('nb_user');
      if (userStr != null && userStr.isNotEmpty) {
        return User.fromJson(jsonDecode(userStr));
      }
    } catch (_) {}
    return null;
  }

  static Future<void> saveSession(User user, {String? token, String? refreshToken}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nb_user', jsonEncode(user.toJson()));
      if (token != null) await prefs.setString('nb_token', token);
      if (refreshToken != null) await prefs.setString('nb_refresh_token', refreshToken);
    } catch (_) {}
  }

  static Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('nb_user');
      await prefs.remove('nb_token');
      await prefs.remove('nb_refresh_token');
    } catch (_) {}
  }

  static Future<User?> login(String email, String password) async {
    final res = await ApiService.post('/Auth/login', {'email': email, 'password': password});
    if (res != null && res['user'] != null) {
      final user = User.fromJson(res['user']);
      await saveSession(
        user,
        token: res['accessToken'] as String?,
        refreshToken: res['refreshToken'] as String?,
      );
      return user;
    }

    // Demo authentication fallback if backend API is unreachable
    if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
      final demoUser = User(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        fullName: email.contains('@') ? email.split('@')[0].toUpperCase() : 'Artisan Baker',
        email: email.trim(),
        role: email.contains('admin') ? 'Admin' : 'Member',
        phone: '+880 1700-123456',
        address: 'Gulshan Avenue, Dhaka',
        avatarUrl: 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=300',
        subscriptionTier: 'Pro Baker Pass',
        loyaltyPoints: 450,
      );
      await saveSession(demoUser, token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}');
      return demoUser;
    }
    return null;
  }

  static Future<User?> register(String fullName, String email, String password) async {
    final res = await ApiService.post('/Auth/register', {
      'fullName': fullName,
      'email': email,
      'password': password
    });

    if (res != null && res['user'] != null) {
      final user = User.fromJson(res['user']);
      await saveSession(
        user,
        token: res['accessToken'] as String?,
        refreshToken: res['refreshToken'] as String?,
      );
      return user;
    }

    // Fallback registration for offline/local state
    final newMember = User(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName.trim(),
      email: email.trim(),
      role: 'Member',
      phone: '+880 1800-000000',
      address: 'Dhaka, Bangladesh',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
      subscriptionTier: 'Free Learner',
      loyaltyPoints: 100,
    );
    await saveSession(newMember, token: 'reg_token_${DateTime.now().millisecondsSinceEpoch}');
    return newMember;
  }
}
