import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/lifeplus_api_service.dart';
import 'lifeplus_provider.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkAuth();
    return AuthState();
  }

  LifePlusApiService get _apiService => ref.read(lifePlusApiServiceProvider);

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
       try {
          final data = await _apiService.getMe();
          final user = User.fromJson(data);
          state = state.copyWith(user: user);
       } catch (e) {
          // Token might be invalid or network issue. 
          // Could clear token or just leave state as guest.
       }
    }
  }

  Future<void> login(String mobile, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.login(mobile, password);
      // response: {access_token, refresh_token, user: UserProfile}
      if (response['user'] != null) {
          final user = User.fromJson(response['user']);
          state = state.copyWith(user: user, isLoading: false);
      } else {
          state = state.copyWith(isLoading: false, error: 'Invalid response from server');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<int> register({
    required String name, 
    required String email, 
    required String mobile, 
    required String password, 
    required int productId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.register(
          name: name, email: email, mobile: mobile, password: password, productId: productId);
      state = state.copyWith(isLoading: false);
      
      if (response['user_id'] is int) {
          return response['user_id'];
      } else {
          throw 'User ID missing in response';
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> verifyOtp(int userId, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiService.verifyOtp(userId, otp);
      if (response['user'] != null) {
          final user = User.fromJson(response['user']);
          state = state.copyWith(user: user, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    state = AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
