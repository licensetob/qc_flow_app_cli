// 文件名称：app_initializer.dart
// 文件描述：应用初始化配置类，负责全局服务的初始化工作。
// 包括Flutter绑定初始化、存储服务初始化、Hive服务初始化、网络服务初始化等。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../storage/storage_service.dart';
import '../storage/hive_service.dart';
import '../network/http_service.dart';
import '../theme/theme_controller.dart';
import '../utils/logger.dart';

class AppInitializer {
  // 初始化应用的各个服务
  static Future<void> initializeApp() async {
    try {
      // 确保Flutter绑定已初始化
      WidgetsFlutterBinding.ensureInitialized();
      Logger.i('Flutter binding initialized');

      // 初始化路径提供者
      final storageService = StorageService();
      
      // 先初始化SharedPreferences
      await storageService.init();
      Logger.i('StorageService initialized');
      
      // 然后初始化Hive服务
      final hiveService = HiveService();
      await hiveService.init();
      Logger.i('HiveService initialized');
      
      // 初始化网络服务
      final httpService = HttpService();
      await httpService.init();
      Logger.i('HttpService initialized');

      // 先注入HiveService和StorageService
      Get.put(hiveService);
      Get.put(storageService);
      
      // 最后注入ThemeController，确保Hive已完全初始化
      Get.put(ThemeController());
      Logger.i('GetX services initialized');
    } catch (error, stackTrace) {
      Logger.e('Error during app initialization: $error');
      Logger.e('Stack trace: $stackTrace');
      // 在实际应用中，可能需要显示错误页面或进行其他错误处理
    }
  }
}