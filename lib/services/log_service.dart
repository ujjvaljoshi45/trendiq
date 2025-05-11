import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LogService {
  static final LogService _instance = LogService._();
  LogService._();
  factory LogService() => _instance;
  String? loggerFilePath;
  Logger? fileLogger;
  Logger? consoleLogger;

  Future<void> init() async {
    await initFileLogger();
    initConsoleLogger();
  }

  Future<void> getPath() async {
    if (kIsWeb) {
      return;
    }
    String tempPath = (await getApplicationDocumentsDirectory()).path;
    tempPath += "/u_log.txt";
    loggerFilePath = tempPath;
  }

  Future<void> initFileLogger() async {
    if (kIsWeb) {
      return;
    }
    if (loggerFilePath == null) {
      await getPath();
    }
    fileLogger = Logger(
      output: FileOutput(file: File(loggerFilePath!), overrideExisting: true),
      filter: ProductionFilter(),
    );
  }

  void initConsoleLogger() {
    consoleLogger = Logger(output: ConsoleOutput());
  }

  void logMessage(String message) {
    fileLogger?.d(message, time: DateTime.now());
    consoleLogger?.d(message, time: DateTime.now());
  }

  void logError(String message, Object? error, StackTrace? stackTrace) {
    fileLogger?.e(
      message,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
    consoleLogger?.e(
      message,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
  }

  void shareLog() async {
    if (loggerFilePath == null) {

      return;
    }
    await Share.shareXFiles([XFile(loggerFilePath!)]);
  }
}
