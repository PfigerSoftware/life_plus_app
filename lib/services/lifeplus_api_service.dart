import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'logger_service.dart';

class LifePlusApiService {
  late Dio _dio;
  // Using localhost for Android emulator. 
  // If running on real device, change this to your PC's IP.
  static const String baseUrl = 'http://192.168.1.2:8001';

  LifePlusApiService() {
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
    required String email,
    required String mobile,
    required String password,
    required int productId,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'mobile': mobile,
        'password': password,
        'product_id': productId,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOtp(int userId, String otp) async {
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
      Logger.download('Starting download of LifePlus data');
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/lifeplus_data.zip';
      Logger.download('Download path: $filePath');
      
      // Download file to internal app storage
      await _dio.download('/life-plus/get-life-plus-data', filePath);
      
      Logger.download('✓ Download completed successfully');
      return File(filePath);
    } on DioException catch (e) {
      Logger.error('DOWNLOAD', 'Failed to download LifePlus data', e);
      throw _handleError(e);
    }
  }

  Future<void> unzipData(File zipFile) async {
    try {
      Logger.fileOperation('Starting unzip operation');
      final bytes = await zipFile.readAsBytes();
      Logger.fileOperation('ZIP file size: ${bytes.length} bytes');
      
      final archive = ZipDecoder().decodeBytes(bytes);
      Logger.fileOperation('Found ${archive.length} files in archive');

      final directory = await getApplicationDocumentsDirectory();
      // We still extract to lifeplus_data for reference/backup if needed, 
      // but primarily we look for the .db file
      final extractPath = '${directory.path}/lifeplus_data';
      Logger.fileOperation('Extraction path: $extractPath');
      
      await Directory(extractPath).create(recursive: true);

      int extractedCount = 0;
      bool dbFileFound = false;

      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
           final data = file.content as List<int>;
           
           // Check if it's the database file
           if (filename.toLowerCase().endsWith('.db')) {
             Logger.fileOperation('Found database file: $filename');
             final dbPath = '${directory.path}/lifeplus_database.db';
             final dbFile = File(dbPath);
             
             // If db exists, maybe backup or just overwrite. 
             // Requirement says "extract db file. execute it". 
             // So we overwrite the current DB with this new one.
             if (await dbFile.exists()) {
               Logger.fileOperation('Overwriting existing database file');
               await dbFile.delete();
             }
             
             await dbFile.writeAsBytes(data, flush: true);
             dbFileFound = true;
             Logger.fileOperation('✓ Database file imported successfully to: $dbPath');
           }

           // Also save to extract folder as before
           File('$extractPath/$filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
           extractedCount++;
           Logger.fileOperation('Extracted: $filename (${data.length} bytes)');
        } else {
           await Directory('$extractPath/$filename').create(recursive: true);
        }
      }
      
      if (!dbFileFound) {
        Logger.fileOperation('WARNING: No .db file found in the zip archive!', isError: true);
        // We might want to throw here, but for now just log it.
        // throw 'No .db file found in the archive.'; 
      }

      Logger.fileOperation('✓ Unzip completed: $extractedCount files extracted');
    } catch (e, stackTrace) {
      Logger.error('FILE', 'Failed to unzip data', e, stackTrace);
      throw 'Failed to unzip data: $e';
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
