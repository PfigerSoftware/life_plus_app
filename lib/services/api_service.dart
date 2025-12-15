// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/models.dart';
//
// class ApiService {
//   late Dio _dio;
//   static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator localhost
//
//   ApiService() {
//     _dio = Dio(BaseOptions(
//       baseUrl: baseUrl,
//       connectTimeout: const Duration(seconds: 5),
//       receiveTimeout: const Duration(seconds: 3),
//     ));
//
//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         final prefs = await SharedPreferences.getInstance();
//         final token = prefs.getString('token');
//         if (token != null) {
//           options.headers['auth'] = token;
//         }
//         return handler.next(options);
//       },
//       onError: (error, handler) {
//         return handler.next(error);
//       },
//     ));
//   }
//
//   // Auth
//   Future<Map<String, dynamic>> register(String username, String email, String password) async {
//     final response = await _dio.post('/auth/register', data: {
//       'username': username,
//       'email': email,
//       'password': password,
//     });
//     return response.data;
//   }
//
//   Future<Map<String, dynamic>> login(String email, String password) async {
//     final response = await _dio.post('/auth/login', data: {
//       'email': email,
//       'password': password,
//     });
//
//     if (response.data['token'] != null) {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', response.data['token']);
//     }
//
//     return response.data;
//   }
//
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//   }
//
//   // Categories
//   Future<List<Category>> getCategories() async {
//     final response = await _dio.get('/categories');
//     return (response.data as List).map((c) => Category.fromJson(c)).toList();
//   }
//
//   Future<void> createCategory(Category category) async {
//     await _dio.post('/categories', data: category.toJson());
//   }
//
//   Future<void> deleteCategory(int id) async {
//     await _dio.delete('/categories/$id');
//   }
//
//   // Transactions
//   Future<List<Transaction>> getTransactions({String? startDate, String? endDate, int? categoryId}) async {
//     final queryParams = <String, dynamic>{};
//     if (startDate != null) queryParams['startDate'] = startDate;
//     if (endDate != null) queryParams['endDate'] = endDate;
//     if (categoryId != null) queryParams['categoryId'] = categoryId;
//
//     final response = await _dio.get('/transactions', queryParameters: queryParams);
//     return (response.data as List).map((t) => Transaction.fromJson(t)).toList();
//   }
//
//   Future<void> createTransaction(double amount, DateTime date, String? note, int categoryId) async {
//     await _dio.post('/transactions', data: {
//       'amount': amount,
//       'date': date.toIso8601String(),
//       'note': note,
//       'categoryId': categoryId,
//     });
//   }
//
//   Future<void> deleteTransaction(int id) async {
//     await _dio.delete('/transactions/$id');
//   }
//
//   // Stats
//   Future<Stats> getStats() async {
//     final response = await _dio.get('/stats/summary');
//     return Stats.fromJson(response.data);
//   }
// }
