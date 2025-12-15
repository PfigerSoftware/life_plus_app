import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Make sure this is added to pubspec.yaml

class ApiService {
  late Dio _dio;
  // Using localhost for Android emulator.
  // If running on real device, change this to your PC's IP.
  static const String baseUrl = 'http://192.168.1.2:8000';

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Handle global errors if needed (e.g. 401 logout)
        return handler.next(error);
      },
    ));
  }

  // Helper for error handling
  String _handleError(DioException error) {
    if (error.response?.data != null && error.response?.data is Map) {
      final data = error.response!.data as Map;
      if (data.containsKey('detail')) {
        return data['detail'].toString();
      }
    }
    return error.message ?? 'An unexpected error occurred';
  }

  // Auth APIs

  Future<Map<String, dynamic>> register({
    required String name,
    String? email,
    required String mobile,
    required String password,
    int? productId,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'mobile': mobile,
        'password': password,
        'product_id': 1,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String userId, String otp) async {
    try {
      final response = await _dio.post('/auth/verify-otp', data: {
        'user_id': userId,
        'otp': otp,
      });
      await _saveTokens(response.data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> resendOtp(int userId) async {
    try {
      final response = await _dio.post('/auth/resend-otp', data: {
        'user_id': userId,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> login(String mobile, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'mobile': mobile,
        'password': password,
      });
      await _saveTokens(response.data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String mobile) async {
    try {
      final response = await _dio.post('/auth/forgot-password', data: {
        'mobile': mobile,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyForgotOtp(String mobile, String otp) async {
    try {
      final response = await _dio.post('/auth/verify-forgot-otp', data: {
        'mobile': mobile,
        'otp': otp,
      });
      // This usually returns a reset_token
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    try {
      final response = await _dio.post('/auth/reset-password', data: {
        'token': token,
        'new_password': newPassword,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      if (refreshToken == null) throw 'No refresh token available';

      final response = await _dio.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });

      if (response.data['access_token'] != null) {
        await prefs.setString('token', response.data['access_token']);
      }
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // LifePlus Data API

  Future<File> downloadLifePlusData() async {
    try {
      // if (Platform.isAndroid) {
      //   // Request storage permission
      //   if (await Permission.storage.request().isGranted ||
      //       await Permission.manageExternalStorage.request().isGranted) {
      //     directory = Directory('/storage/emulated/0/Download');
      //     if (!await directory.exists()) {
      //       directory = await getExternalStorageDirectory();
      //     }
      //   }
      // } else if (Platform.isIOS) {
      //   directory = await getApplicationDocumentsDirectory();
      // }
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/lifeplus_data.zip';


      // if (directory == null) {
      //   // Fallback or error
      //   // directory = await getExternalStorageDirectory();
      //   if (directory == null) throw 'Could not get download directory';
      // }


      // Since it's a GET request, we use download method
      await _dio.download('/life-plus/get-life-plus-data', filePath);

      return File(filePath);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data['access_token'] != null) {
      await prefs.setString('token', data['access_token']);
    }
    if (data['refresh_token'] != null) {
      await prefs.setString('refresh_token', data['refresh_token']);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh_token');
  }
}
