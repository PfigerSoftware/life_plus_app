import 'package:flutter/foundation.dart';

class Logger {
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';

  static void api(String message, {bool isError = false}) {
    _log('API', message, isError ? _red : _blue);
  }

  static void database(String message, {bool isError = false}) {
    _log('DATABASE', message, isError ? _red : _green);
  }

  static void fileOperation(String message, {bool isError = false}) {
    _log('FILE', message, isError ? _red : _cyan);
  }

  static void download(String message, {bool isError = false}) {
    _log('DOWNLOAD', message, isError ? _red : _magenta);
  }

  static void export(String message, {bool isError = false}) {
    _log('EXPORT', message, isError ? _red : _yellow);
  }

  static void error(String tag, String message, [dynamic error, StackTrace? stackTrace]) {
    final errorMsg = StringBuffer();
    errorMsg.writeln('❌ [$tag] ERROR: $message');
    if (error != null) {
      errorMsg.writeln('   Error Details: $error');
    }
    if (stackTrace != null) {
      errorMsg.writeln('   Stack Trace: ${stackTrace.toString().split('\n').take(5).join('\n   ')}');
    }
    debugPrint('$_red$errorMsg$_reset');
  }

  static void _log(String tag, String message, String color) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toString().substring(11, 19);
      debugPrint('$color[$timestamp] [$tag] $message$_reset');
    }
  }
}
