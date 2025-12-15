import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import '../models/models.dart';
import '../services/lifeplus_api_service.dart';
import '../services/database_service.dart';
import '../services/logger_service.dart';

// Providing the service globally
final lifePlusApiServiceProvider = Provider((ref) => ApiService());
final databaseServiceProvider = Provider((ref) => DatabaseService());

class LifePlusState {
  final bool isLoading;
  final String? error;
  final File? downloadedFile;
  final User? currentUser;
  final List<File> extractedFiles;
  final bool isDatabaseCreated;
  final bool isCreatingDatabase;
  final bool isExportingDatabase;

  LifePlusState({
    this.isLoading = false,
    this.error,
    this.downloadedFile,
    this.currentUser,
    this.extractedFiles = const [],
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

  ApiService get _apiService => ref.read(lifePlusApiServiceProvider);
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

  Future<void> unzipData(File zipFile) async {
    try {
      Logger.fileOperation('Starting unzip operation');
      final bytes = await zipFile.readAsBytes();
      Logger.fileOperation('ZIP file size: ${bytes.length} bytes');

      final archive = ZipDecoder().decodeBytes(bytes);
      Logger.fileOperation('Found ${archive.length} files in archive');

      // Extract to lifeplus_data subdirectory
      final directory = await getApplicationDocumentsDirectory();
      final extractPath = '${directory.path}/lifeplus_data';
      Logger.fileOperation('Extraction path: $extractPath');

      // Create directory if it doesn't exist
      await Directory(extractPath).create(recursive: true);

      int extractedCount = 0;
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File('$extractPath/$filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
          extractedCount++;
          Logger.fileOperation('Extracted: $filename (${data.length} bytes)');
        } else {
          await Directory('$extractPath/$filename').create(recursive: true);
        }
      }
      Logger.fileOperation('✓ Unzip completed: $extractedCount files extracted');
    } catch (e, stackTrace) {
      Logger.error('FILE', 'Failed to unzip data', e, stackTrace);
      throw 'Failed to unzip data: $e';
    }
  }

  Future<void> downloadZipData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final file = await _apiService.downloadLifePlusData();
      await unzipData(file);
      await loadExtractedFiles();

      // Automatically create database after extraction
      await createDatabase();

      state = state.copyWith(isLoading: false, downloadedFile: file);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> loadExtractedFiles() async {
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

  Future<void> createDatabase() async {
    state = state.copyWith(isCreatingDatabase: true, error: null);
    try {
      if (state.extractedFiles.isEmpty) {
        await loadExtractedFiles();
      }

      if (state.extractedFiles.isEmpty) {
        throw 'No CSV files found. Please download data first.';
      }

      await _dbService.createTablesFromCsvFiles(state.extractedFiles);
      state = state.copyWith(
        isCreatingDatabase: false,
        isDatabaseCreated: true,
      );
    } catch (e) {
      state = state.copyWith(isCreatingDatabase: false, error: e.toString());
      rethrow;
    }
  }

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
}

final lifePlusProvider = NotifierProvider<LifePlusNotifier, LifePlusState>(() {
  return LifePlusNotifier();
});

