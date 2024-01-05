import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// 统一日志信息管理，提供静态的日志方法调用，隐藏内部的logger包的实现逻辑
/// 如果是非web平台，同时支持记录日志到文件并定时清理
class LoggerUtils {
  static Logger _logger = Logger(
    output: ConsoleOutput(),
  );

  static Logger get logger => _logger;

  static Future<String> get _root async => path.join(
      (await (Platform.isAndroid
              ? getExternalStorageDirectory()
              : getApplicationSupportDirectory()))!
          .path,
      'logs');

  /*
  (() async {
    print(await getApplicationDocumentsDirectory());// /data/user/0/com.ldwdz.oa/app_flutter
    print(await getApplicationSupportDirectory());// /data/user/0/com.ldwdz.oa/files
    print(await getExternalCacheDirectories());// ["/storage/emulated/0/Android/data/com.ldwdz.oa/cache"]
    print(await getExternalStorageDirectories());// ["/storage/emulated/0/Android/data/com.ldwdz.oa/files"]
    print(await getExternalStorageDirectory());// /storage/emulated/0/Android/data/com.ldwdz.oa/files
    print(await getTemporaryDirectory());// /data/user/0/com.ldwdz.oa/cache
    // print(await getLibraryDirectory()); // 仅ios和mac支持
    // print(await getDownloadsDirectory());// android不支持
  })();
   */

  /// 初始化
  static init([LoggerOption opts = const LoggerOption()]) async {
    var root = "";
    if (!kIsWeb) {
      if (opts.root != null) {
        root = opts.root!;
      } else {
        root = await _root;
      }
      await Directory(root).create(recursive: true);
    }
    _logger = Logger(
      level: kDebugMode ? Level.trace : Level.error,
      filter: ProductionFilter(),
      printer: HybridPrinter(
        SimplePrinter(
          printTime: true,
          colors: false,
        ),
        error: PrettyPrinter(
          printTime: true,
          colors: false,
          errorMethodCount: 99,
          noBoxingByDefault: true,
        ),
      ),
      output: MultiOutput(
        [
          ConsoleOutput(),
          if (!kIsWeb)
            FileOutput(
              root: root,
              maxDay: opts.maxDay < 0 ? 30 : opts.maxDay,
            ),
        ],
      ),
    );
  }

  /// Log a message at level [Level.trace].
  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.trace, message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.debug].
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.debug, message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.info].
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.info, message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.warning].
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.warning, message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.error].
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.error, message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.fatal].
  static void f(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.log(Level.fatal, message, error: error, stackTrace: stackTrace);
  }
}

/// 输出日志到文件，按照 filename-yyyy-MM-dd.log 格式保存，可以设置要保留的天数。
/// 默认全部保留，只在首次初始化的时候清理一次。
class FileOutput extends LogOutput {
  late File _file;
  final bool overrideExisting;
  final Encoding encoding;
  final String root;
  final String filename;
  final String fileExtension;
  final int? maxDay;
  IOSink? _sink;

  DateTime get now => DateTime.now();
  late DateTime _currentDate;
  bool isClearing = false;

  FileOutput({
    required this.root,
    this.filename = 'info',
    this.fileExtension = 'log',
    this.overrideExisting = false,
    this.encoding = utf8,
    this.maxDay,
  }) {
    clear();
  }

  @override
  Future<void> init() async {
    _currentDate = now;
    _file = File(path.join(root, getFilename(_currentDate)));
    _sink = _file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  String getFilename(DateTime d) {
    var dateStr = getDateStr(d);
    return '$filename-$dateStr.$fileExtension';
  }

  String getDateStr(DateTime d) {
    return d.toIso8601String().substring(0, 10);
  }

  @override
  void output(OutputEvent event) {
    if (now.day != _currentDate.day) {
      if (kDebugMode) {
        print('Log File Output into a new Date');
      }
      init();
    }
    _sink?.writeAll(event.lines, '\n');
    _sink?.writeln();
  }

  @override
  Future<void> destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }

  clear() async {
    if (isClearing) return;
    isClearing = true;
    if (maxDay != null) {
      // 要保留的文件列表，不在这个列表里的将被删除
      Set<String> remainFile = {};
      var date = now;
      for (var i = 0; i < maxDay!; i++) {
        remainFile.add(
            path.join(root, getFilename(date.subtract(Duration(days: i)))));
      }
      // 遍历logs目录下的文件
      Directory(root).list().listen(
        (entity) {
          if (!remainFile.contains(entity.path)) {
            if (kDebugMode) {
              print('todelete log file:$entity');
            }
            entity.delete();
          }
        },
        onDone: () {
          isClearing = false;
        },
      );
    }
  }
}

class LoggerOption {
  final String? root;
  final int maxDay;

  const LoggerOption({
    this.root,
    this.maxDay = 30,
  });
}

/// 记录debug日志
debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
  LoggerUtils.d(message, error, stackTrace);
}

/// 记录error日志
error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
  LoggerUtils.e(message, error, stackTrace);
}

/// 记录info日志
info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
  LoggerUtils.i(message, error, stackTrace);
}

/// 记录debug日志
trace(dynamic message, [dynamic error, StackTrace? stackTrace]) {
  LoggerUtils.v(message, error, stackTrace);
}
