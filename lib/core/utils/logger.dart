// 文件名称：logger.dart
// 文件描述：日志工具类，提供不同级别的日志记录功能。
// 支持调试、信息、警告和错误级别的日志输出，方便开发和调试。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'dart:developer';

class Logger {
  static void d(String message) {
    log('DEBUG: $message');
  }

  static void i(String message) {
    log('INFO: $message');
  }

  static void w(String message) {
    log('WARNING: $message');
  }

  static void e(String message) {
    log('ERROR: $message');
  }
}