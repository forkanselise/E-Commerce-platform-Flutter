import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({User? user, bool? isLoading, String? error, bool clearUser = false}) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    initAuth();
  }

  Future<void> initAuth() async {
    state = state.copyWith(isLoading: true);
    final savedUser = await AuthService.getSavedUser();
    if (savedUser != null) {
      state = state.copyWith(user: savedUser, isLoading: false);
      // Background sync profile if token exists
      AuthService.fetchProfile().then((fresh) {
        if (fresh != null && mounted) {
          state = state.copyWith(user: fresh);
        }
      });
    } else {
      state = state.copyWith(isLoading: false, clearUser: true);
    }
  }

  Future<bool> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(error: 'Please fill in both email and password.');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    final user = await AuthService.login(email, password);
    if (user != null) {
      state = state.copyWith(user: user, isLoading: false, error: null);
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: 'Login failed. Please check your credentials.');
      return false;
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    if (fullName.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(error: 'Please fill in all required fields.');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    final user = await AuthService.register(fullName, email, password);
    if (user != null) {
      state = state.copyWith(user: user, isLoading: false, error: null);
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: 'Registration failed.');
      return false;
    }
  }

  Future<bool> updateProfile({required String fullName, required String phone, required String avatarUrl}) async {
    final current = state.user;
    if (current == null) return false;

    state = state.copyWith(isLoading: true);
    final updated = await AuthService.updateProfile(
      current,
      fullName: fullName,
      phone: phone,
      avatarUrl: avatarUrl,
    );

    if (updated != null) {
      state = state.copyWith(user: updated, isLoading: false, error: null);
      return true;
    }
    state = state.copyWith(isLoading: false);
    return false;
  }

  Future<void> logout() async {
    await AuthService.clearSession();
    state = state.copyWith(clearUser: true, error: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

