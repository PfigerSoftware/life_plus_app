import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'logger_service.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'lifeplus_database.db';
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        // Database will be created, tables added dynamically
      },
    );
  }

  String _sanitizeTableName(String filename) {
    // Remove .csv extension and sanitize for SQL
    String tableName = filename.replaceAll('.csv', '');
    // Replace invalid characters with underscore
    tableName = tableName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    // Ensure it doesn't start with a number
    if (RegExp(r'^[0-9]').hasMatch(tableName)) {
      tableName = 'table_$tableName';
    }
    return tableName.toLowerCase();
  }

  String _sanitizeColumnName(String columnName) {
    // Sanitize column names for SQL
    String sanitized = columnName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    if (RegExp(r'^[0-9]').hasMatch(sanitized)) {
      sanitized = 'col_$sanitized';
    }
    return sanitized.toLowerCase();
  }

  Future<void> createTablesFromCsvFiles(List<File> csvFiles) async {
    final db = await database;
    Logger.database('Starting database creation from ${csvFiles.length} CSV files');

    for (final file in csvFiles) {
      final filename = file.path.split(Platform.pathSeparator).last;
      final tableName = _sanitizeTableName(filename);

      try {
        Logger.fileOperation('Reading file: $filename');

        // Read CSV file with encoding fallback
        String fileContent;
        try {
          fileContent = await file.readAsString(encoding: utf8);
          Logger.fileOperation('✓ Read with UTF-8 encoding: $filename');
        } catch (e) {
          // Fallback to latin1 for files with non-UTF-8 characters
          Logger.fileOperation('UTF-8 failed, trying latin1 encoding: $filename');
          fileContent = await file.readAsString(encoding: latin1);
          Logger.fileOperation('✓ Read with latin1 encoding: $filename');
        }

        final fields = const CsvToListConverter().convert(fileContent);

        if (fields.isEmpty) {
          Logger.fileOperation('Skipping empty file: $filename', isError: true);
          continue;
        }

        // Get headers (first row)
        final headers = fields.first.map((e) => _sanitizeColumnName(e.toString())).toList();
        Logger.database('Table: $tableName | Columns: ${headers.length} | Headers: ${headers.join(", ")}');

        // Check if table exists
        final tableExists = await _tableExists(db, tableName);

        if (!tableExists) {
          // Create new table with all columns as TEXT (flexible for CSV data)
          // Use backticks to escape table and column names (handles reserved keywords)
          final columnDefinitions = headers.map((col) => '`$col` TEXT').join(', ');
          final createTableSQL = '''
            CREATE TABLE `$tableName` (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnDefinitions
            )
          ''';

          Logger.database('Creating table: $tableName');
          await db.execute(createTableSQL);
          Logger.database('✓ Created table: $tableName', isError: false);
        } else {
          // Table exists - clear old data
          Logger.database('Clearing old data from: $tableName');
          await db.delete(tableName);
          Logger.database('✓ Cleared old data from: $tableName');
        }

        // Insert new data in batches for performance
        final dataRows = fields.skip(1).toList();
        Logger.database('Inserting ${dataRows.length} rows into: $tableName');
        await _insertDataInBatches(db, tableName, headers, dataRows);

        Logger.database('✓ Successfully loaded table: $tableName with ${dataRows.length} rows');
      } catch (e, stackTrace) {
        Logger.error('DATABASE', 'Failed to process file: $filename (table: $tableName)', e, stackTrace);
        // Continue with next file
      }
    }

    Logger.database('Database creation completed');
  }

  Future<bool> _tableExists(Database db, String tableName) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  Future<void> _insertDataInBatches(
      Database db,
      String tableName,
      List<String> headers,
      List<List<dynamic>> rows,
      ) async {
    const batchSize = 500;
    final batches = <List<List<dynamic>>>[];

    for (var i = 0; i < rows.length; i += batchSize) {
      final end = (i + batchSize < rows.length) ? i + batchSize : rows.length;
      batches.add(rows.sublist(i, end));
    }

    for (final batch in batches) {
      await db.transaction((txn) async {
        for (final row in batch) {
          final values = <String, dynamic>{};
          for (var i = 0; i < headers.length && i < row.length; i++) {
            values[headers[i]] = row[i]?.toString() ?? '';
          }
          await txn.insert(tableName, values);
        }
      });
    }
  }

  Future<String> getDatabasePath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, _databaseName);
  }

  Future<File> exportDatabaseToDownloads() async {
    Logger.export('Starting database export');

    final dbPath = await getDatabasePath();
    final dbFile = File(dbPath);

    if (!await dbFile.exists()) {
      Logger.export('Database file does not exist at: $dbPath', isError: true);
      throw 'Database file does not exist';
    }

    Logger.export('Database file found at: $dbPath');

    // Get downloads directory
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
      if (!await downloadsDir.exists()) {
        // Fallback to external storage
        final externalDir = await getExternalStorageDirectory();
        downloadsDir = Directory('${externalDir?.path}/Download');
        await downloadsDir.create(recursive: true);
      }
    } else if (Platform.isIOS) {
      // iOS doesn't have a public Downloads folder, use Documents
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    if (downloadsDir == null) {
      Logger.export('Could not access downloads directory', isError: true);
      throw 'Could not access downloads directory';
    }

    final exportPath = join(downloadsDir.path, _databaseName);
    Logger.export('Exporting to: $exportPath');

    final exportFile = await dbFile.copy(exportPath);
    Logger.export('✓ Database exported successfully to: $exportPath');

    return exportFile;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<bool> databaseExists() async {
    final dbPath = await getDatabasePath();
    return await File(dbPath).exists();
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasePath();
    final file = File(dbPath);
    if (await file.exists()) {
      await file.delete();
    }
    _database = null;
  }
}
