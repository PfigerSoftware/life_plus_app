import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<bool> _tableExists(Database db, String tableName) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName.toUpperCase()],
    );
    return result.isNotEmpty;
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

  Future<List<String>> getAllTables() async {
    final db = await database;
    try {
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' AND name != 'android_metadata'"
      );
      return tables.map((e) => e['name'] as String).toList();
    } catch (e) {
      Logger.error('DATABASE', 'Failed to fetch tables', e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTableData(String tableName) async {
    final db = await database;
    try {
      return await db.query(tableName);
    } catch (e) {
      Logger.error('DATABASE', 'Failed to fetch data for table: $tableName', e);
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> getAgencies() async {
    final db = await database;
    try {
      // Check if table exists first to avoid crash
      if (!await _tableExists(db, 'AGENCY')) {
        return [];
      }
      return await db.query('AGENCY');
    } catch (e) {
      Logger.error('DATABASE', 'Failed to fetch agencies', e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getNBRegisterData({
    DateTime? fromDate,
    DateTime? toDate,
    String? agency,
  }) async {
    final db = await database;
    try {
      // Base query
      String sql = '''
        SELECT 
          pol.Pono, 
          pol.rdt, 
          pol.matdate, 
          party.name,
          party.bd, 
          pol.fupdate, 
          pol.mode, 
          pol.agno, 
          pol.branch 
        FROM pol 
        JOIN party ON party.pcode = pol.pcode1
      ''';
      
      // Execute query
      final results = await db.rawQuery(sql);

      var filteredResults = results;

      // Filter by Date in Dart
      if (fromDate != null && toDate != null) {
        final start = DateTime(fromDate.year, fromDate.month, fromDate.day);
        final end = DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59);

        filteredResults = filteredResults.where((row) {
          final rdtStr = row['rdt'] as String?;
          if (rdtStr == null) return false;
          
          try {
            DateTime? rdtDate;
            if (rdtStr.contains('/')) {
                final parts = rdtStr.split('/');
                if (parts.length == 3) {
                   rdtDate = DateTime(
                     int.parse(parts[2]), 
                     int.parse(parts[1]), 
                     int.parse(parts[0])
                   );
                }
            } else if (rdtStr.contains('-')) {
                rdtDate = DateTime.tryParse(rdtStr);
            }
            
            if (rdtDate != null) {
              return rdtDate.isAfter(start.subtract(const Duration(seconds: 1))) && 
                     rdtDate.isBefore(end.add(const Duration(seconds: 1)));
            }
            return false;
          } catch (e) {
            return false;
          }
        }).toList();
      }

      // Filter by Agency in Dart (safer than complex SQL joins for now)
      if (agency != null && agency.isNotEmpty) {
        filteredResults = filteredResults.where((row) {
          final rowAgency = row['agno']?.toString();
          return rowAgency == agency;
        }).toList();
      }

      return filteredResults;
    } catch (e) {
      Logger.error('DATABASE', 'Failed to fetch NB Register data', e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSBDueData({
    DateTime? fromDate,
    DateTime? toDate,
    String? agency,
  }) async {
    final db = await database;
    try {
      // Base query joining POL and SB_DUES
      String sql = '''
        SELECT 
          pol.Pono, 
          pol.rdt, 
          pol.prem, 
          pol.fupdate, 
          pol.mode, 
          pol.agno, 
          pol.branch,
          sb.amount, 
          sb.duedate
        FROM POL 
        JOIN SB_DUE sb ON sb.puniqid = pol.puniqid
      ''';
      
      final results = await db.rawQuery(sql);
      var filteredResults = results;

      // Filter by Date (duedate)
      if (fromDate != null && toDate != null) {
        final start = DateTime(fromDate.year, fromDate.month, fromDate.day);
        final end = DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59);

        filteredResults = filteredResults.where((row) {
          final dueStr = row['duedate'] as String?;
          if (dueStr == null) return false;
          
          try {
            DateTime? dueDate;
             if (dueStr.contains('/')) { // assume dd/MM/yyyy
                final parts = dueStr.split('/');
                if (parts.length == 3) {
                   dueDate = DateTime(
                     int.parse(parts[2]), 
                     int.parse(parts[1]), 
                     int.parse(parts[0])
                   );
                }
            } else if (dueStr.contains('-')) { // assume yyyy-MM-dd
                dueDate = DateTime.tryParse(dueStr);
            }
            
            if (dueDate != null) {
              return dueDate.isAfter(start.subtract(const Duration(seconds: 1))) && 
                     dueDate.isBefore(end.add(const Duration(seconds: 1)));
            }
            return false;
          } catch (e) {
            return false;
          }
        }).toList();
      }

      // Filter by Agency (pol.agno)
      if (agency != null && agency.isNotEmpty) {
        filteredResults = filteredResults.where((row) {
          final rowAgency = row['agno']?.toString();
          return rowAgency == agency;
        }).toList();
      }

      return filteredResults;

    } catch (e) {
      Logger.error('DATABASE', 'Failed to fetch SB Due data', e);
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> getMaturityData({
    DateTime? fromDate,
    DateTime? toDate,
    String? agency,
  }) async {
    final db = await database;
    try {
      // Base query on POL table
      String sql = '''
        SELECT 
          pol.Pono, 
          pol.rdt, 
          pol.matdate,
          pol.prem, 
          pol.fupdate, 
          pol.mode, 
          pol.agno, 
          pol.branch
        FROM pol 
      ''';
      
      final results = await db.rawQuery(sql);
      var filteredResults = results;

      // Filter by Date (rdt - Risk Date)
      if (fromDate != null && toDate != null) {
        final start = DateTime(fromDate.year, fromDate.month, fromDate.day);
        final end = DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59);

        filteredResults = filteredResults.where((row) {
          final rdtStr = row['rdt'] as String?;
          if (rdtStr == null) return false;
          
          try {
            DateTime? rdtDate;
             if (rdtStr.contains('/')) { // assume dd/MM/yyyy
                final parts = rdtStr.split('/');
                if (parts.length == 3) {
                   rdtDate = DateTime(
                     int.parse(parts[2]), 
                     int.parse(parts[1]), 
                     int.parse(parts[0])
                   );
                }
            } else if (rdtStr.contains('-')) { // assume yyyy-MM-dd
                rdtDate = DateTime.tryParse(rdtStr);
            }
            
            if (rdtDate != null) {
              return rdtDate.isAfter(start.subtract(const Duration(seconds: 1))) && 
                     rdtDate.isBefore(end.add(const Duration(seconds: 1)));
            }
            return false;
          } catch (e) {
            return false;
          }
        }).toList();
      }

      // Filter by Agency (pol.agno)
      if (agency != null && agency.isNotEmpty) {
        filteredResults = filteredResults.where((row) {
          final rowAgency = row['agno']?.toString();
          return rowAgency == agency;
        }).toList();
      }

      return filteredResults;

    } catch (e) {
      Logger.error('DATABASE', 'Failed to fetch Maturity data', e);
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> getBirthdayData({
     DateTime? fromDate,
     DateTime? toDate,
     String? agency,
   }) async {
     return _getEventData(
       fromDate: fromDate,
       toDate: toDate,
       agency: agency,
       dateColumn: 'bd',
       isWedding: false,
     );
   }

   Future<List<Map<String, dynamic>>> getWeddingData({
     DateTime? fromDate,
     DateTime? toDate,
     String? agency,
   }) async {
     return _getEventData(
       fromDate: fromDate,
       toDate: toDate,
       agency: agency,
       dateColumn: 'wdt',
       isWedding: true,
     );
   }

   Future<List<Map<String, dynamic>>> _getEventData({
     DateTime? fromDate,
     DateTime? toDate,
     String? agency,
     required String dateColumn,
     required bool isWedding,
   }) async {
     final db = await database;
     try {
       // Query to get distinct party details needed.
       // We join with POL to filter by agency if needed, 
       // but we group by party to avoid duplicates.
       String sql = '''
         SELECT DISTINCT
           party.name, 
           party.bd, 
           party.abd,
           party.wdt
         FROM PARTY 
         JOIN POL ON party.pcode = pol.pcode1
       ''';

       // Apply Agency Filter in SQL if possible, or fetch all and filter in Dart if complex.
       // Since we are joining, we can filter by pol.agno in SQL.
       List<dynamic> args = [];
       if (agency != null && agency.isNotEmpty) {
         sql += ' WHERE pol.agno = ?';
         args.add(agency);
       }
       
       // Ensure distinctness
       // sql += ' GROUP BY party.pcode'; // Might be needed if DISTINCT isn't enough with text blobs

       final results = await db.rawQuery(sql, args);
       List<Map<String, dynamic>> filteredList = [];

       if (fromDate != null && toDate != null) {
         final start = DateTime(fromDate.year, fromDate.month, fromDate.day);
         final end = DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59);
         
         final now = DateTime.now();

         for (var row in results) {
           final dateStr = row[dateColumn] as String?;
           if (dateStr == null || dateStr.trim().isEmpty || dateStr == '-') continue; // Skip empty
           
           DateTime? eventDate;
           try {
             if (dateStr.contains('/')) {
                final parts = dateStr.split('/');
                if (parts.length == 3) {
                   eventDate = DateTime(
                     int.parse(parts[2]), 
                     int.parse(parts[1]), 
                     int.parse(parts[0])
                   );
                }
             } else if (dateStr.contains('-')) {
                 eventDate = DateTime.tryParse(dateStr);
             }
           } catch (e) {
             continue;
           }

           if (eventDate == null) continue;

           // Check if anniversary falls in range
           bool inRange = false;
           // Iterate through years in the range
           for (int year = start.year; year <= end.year; year++) {
             try {
               final candidate = DateTime(year, eventDate.month, eventDate.day);
               if (candidate.isAfter(start.subtract(const Duration(seconds: 1))) && 
                   candidate.isBefore(end.add(const Duration(seconds: 1)))) {
                 inRange = true;
                 break;
               }
             } catch (e) {
               // Handle leap years (e.g. Feb 29 on non-leap year)
               if (eventDate.month == 2 && eventDate.day == 29) {
                  // Check Feb 28 or Mar 1? Usually ignored or mapped to 28.
                  final candidate = DateTime(year, 2, 28);
                   if (candidate.isAfter(start.subtract(const Duration(seconds: 1))) && 
                       candidate.isBefore(end.add(const Duration(seconds: 1)))) {
                     inRange = true;
                     break;
                   }
               }
             }
           }

           if (inRange) {
             // Calculate Years Completed
             // Logic: Age = difference in years.
             int yearsCompleted = now.year - eventDate.year;
             if (now.month < eventDate.month || (now.month == eventDate.month && now.day < eventDate.day)) {
               yearsCompleted--;
             }
             
             final newRow = Map<String, dynamic>.from(row);
             newRow['years_completed'] = yearsCompleted >= 0 ? yearsCompleted.toString() : '0';
             
             // Normalize columns for UI
             if (!isWedding) {
                // For birthday we might want to ensure 'bd' and 'abd' are present.
             }
             
             filteredList.add(newRow);
           }
         }
       } else {
          // If no date filter, optional? But usually required.
          // Or return none?
          filteredList = [];
       }

       return filteredList;
     } catch (e) {
       Logger.error('DATABASE', 'Failed to fetch ${isWedding ? "Wedding" : "Birthday"} data', e);
       return [];
     }
   }
}
