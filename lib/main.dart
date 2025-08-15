

// 文件名称：main.dart
// 文件描述：主程序入口文件，负责初始化应用并运行 Flutter 应用。
// 使用 runZonedGuarded 启动应用，进行全局初始化配置并捕获全局错误。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:flutter/material.dart';
import 'package:qc_app_flow/init/application.dart';
import 'core/config/app_initializer.dart';
import 'dart:async';

void main() {
  runZonedGuarded(
    () async {
      // 使用全局初始化配置
      await AppInitializer.initializeApp();

      // 运行应用
      runApp(Application().getApplicationWidget());
    },
    (error, stackTrace) {
      // 全局错误捕获
      debugPrint('\n\n=== GLOBAL ERROR ===');
      debugPrint('Error: $error');
      debugPrint('Stack Trace: $stackTrace');
      debugPrint('====================\n\n');
    },
  );
}
