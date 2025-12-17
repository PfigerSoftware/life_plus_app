import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import '../models/models.dart';
import '../services/lifeplus_api_service.dart';
import '../services/database_service.dart';

// Providing the service globally
final lifePlusApiServiceProvider = Provider((ref) => LifePlusApiService());
final databaseServiceProvider = Provider((ref) => DatabaseService());

class LifePlusState {
  final bool isLoading;
  final String? error;
  final File? downloadedFile;
  final User? currentUser;
  final List<File> extractedFiles; // Kept for compatibility but unused
  final List<String> tables;
  final bool isDatabaseCreated;
  final bool isCreatingDatabase;
  final bool isExportingDatabase;

  LifePlusState({
    this.isLoading = false, 
    this.error, 
    this.downloadedFile,
    this.currentUser,
    this.extractedFiles = const [],
    this.tables = const [],
    this.isDatabaseCreated = false,
    this.isCreatingDatabase = false,
    this.isExportingDatabase = false,
  });

  LifePlusState copyWith({
    bool? isLoading, 
    String? error, 
    File? downloadedFile,
    User? currentUser,
    List<File>? extractedFiles,
    List<String>? tables,
    bool? isDatabaseCreated,
    bool? isCreatingDatabase,
    bool? isExportingDatabase,
  }) {
    return LifePlusState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      downloadedFile: downloadedFile ?? this.downloadedFile,
      currentUser: currentUser ?? this.currentUser,
      extractedFiles: extractedFiles ?? this.extractedFiles,
      tables: tables ?? this.tables,
      isDatabaseCreated: isDatabaseCreated ?? this.isDatabaseCreated,
      isCreatingDatabase: isCreatingDatabase ?? this.isCreatingDatabase,
      isExportingDatabase: isExportingDatabase ?? this.isExportingDatabase,
    );
  }
}

class LifePlusNotifier extends Notifier<LifePlusState> {
  @override
  LifePlusState build() {
    _checkDatabaseExists();
    return LifePlusState();
  }

  LifePlusApiService get _apiService => ref.read(lifePlusApiServiceProvider);
  DatabaseService get _dbService => ref.read(databaseServiceProvider);

  Future<void> _checkDatabaseExists() async {
    final exists = await _dbService.databaseExists();
    state = state.copyWith(isDatabaseCreated: exists);
  }

  Future<void> getMe() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _apiService.getMe();
      final user = User.fromJson(data);
      state = state.copyWith(isLoading: false, currentUser: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> downloadZipData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final file = await _apiService.downloadLifePlusData();
      
      // Close existing database connection before overwriting the file
      await _dbService.closeDatabase();
      
      await _apiService.unzipData(file);
      // await loadExtractedFiles(); // Old flow
      
      // Automatically create database after extraction
      // await createDatabase(); // Old flow
      
      // New flow: Just refresh table list
      await loadDatabaseTables();
      await _checkDatabaseExists();

      state = state.copyWith(isLoading: false, downloadedFile: file);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> loadDatabaseTables() async {
    try {
      final tables = await _dbService.getAllTables();
      state = state.copyWith(tables: tables);
    } catch (e) {
      print("Error loading tables: $e");
    }
  }

  Future<void> loadExtractedFiles() async {
    // For compatibility, we might still want to load files if needed, 
    // but the main view uses tables now.
    // In fact, we should probably call loadDatabaseTables here as well 
    // to ensure the UI is updated on init.
    await loadDatabaseTables();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final extractPath = '${directory.path}/lifeplus_data';
      final dir = Directory(extractPath);
      
      if (await dir.exists()) {
        final List<File> files = dir
            .listSync(recursive: true)
            .where((item) => item is File && item.path.endsWith('.CSV'))
            .map((item) => item as File)
            .toList();
            
        state = state.copyWith(extractedFiles: files);
      }
    } catch (e) {
      print("Error loading files: $e");
    }
  }

  Future<List<List<dynamic>>> readCsvFile(File file) async {
    try {
      final input = file.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      return fields;
    } catch (e) {
      throw 'Failed to read CSV: $e';
    }
  }

  // Future<void> createDatabase() async {
  //   state = state.copyWith(isCreatingDatabase: true, error: null);
  //   try {
  //     if (state.extractedFiles.isEmpty) {
  //       await loadExtractedFiles();
  //     }

  //     if (state.extractedFiles.isEmpty) {
  //       throw 'No CSV files found. Please download data first.';
  //     }

  //     await _dbService.createTablesFromCsvFiles(state.extractedFiles);
  //     state = state.copyWith(
  //       isCreatingDatabase: false, 
  //       isDatabaseCreated: true,
  //     );
  //   } catch (e) {
  //     state = state.copyWith(isCreatingDatabase: false, error: e.toString());
  //     rethrow;
  //   }
  // }

  Future<File> exportDatabase() async {
    state = state.copyWith(isExportingDatabase: true, error: null);
    try {
      final exportedFile = await _dbService.exportDatabaseToDownloads();
      state = state.copyWith(isExportingDatabase: false);
      return exportedFile;
    } catch (e) {
      state = state.copyWith(isExportingDatabase: false, error: e.toString());
      rethrow;
    }
  }
  Future<List<Map<String, dynamic>>> getNBRegisterData({
    DateTime? fromDate, 
    DateTime? toDate,
    String? agency,
  }) async {
    return await _dbService.getNBRegisterData(
      fromDate: fromDate, 
      toDate: toDate,
      agency: agency,
    );
  }

  Future<List<Map<String, dynamic>>> getSBDueData({
    DateTime? fromDate,
    DateTime? toDate,
    String? agency,
  }) async {
    return await _dbService.getSBDueData(
      fromDate: fromDate,
      toDate: toDate,
      agency: agency,
    );
  }

  Future<List<Map<String, dynamic>>> getMaturityData({
    DateTime? fromDate,
    DateTime? toDate,
    String? agency,
  }) async {
    return await _dbService.getMaturityData(
      fromDate: fromDate,
      toDate: toDate,
      agency: agency,
    );
  }

  Future<List<Map<String, dynamic>>> getBirthdayData({
    DateTime? fromDate,
    DateTime? toDate,
    String? agency,
  }) async {
    return await _dbService.getBirthdayData(
      fromDate: fromDate,
      toDate: toDate,
      agency: agency,
    );
  }

  Future<List<Map<String, dynamic>>> getWeddingData({
    DateTime? fromDate,
    DateTime? toDate,
    String? agency,
  }) async {
    return await _dbService.getWeddingData(
      fromDate: fromDate,
      toDate: toDate,
      agency: agency,
    );
  }

  Future<List<Map<String, dynamic>>> getAgencies() async {
    return await _dbService.getAgencies();
  }
}

final lifePlusProvider = NotifierProvider<LifePlusNotifier, LifePlusState>(() {
  return LifePlusNotifier();
});

