// 文件名称：theme_controller.dart
// 文件描述：主题控制器类，负责应用主题的管理和切换。
// 支持亮色模式和暗色模式的切换，以及主题设置的持久化存储。
// 采用单例模式设计，提供全局访问点。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../storage/hive_service.dart';
import 'themes.dart';

class ThemeController extends GetxController {
  // 单例模式
  static ThemeController get to => Get.find();

  // 当前主题模式
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  // 标记是否已初始化
  bool _initialized = false;

  @override
  void onInit() {
    super.onInit();
    // 尝试获取HiveService，如果已初始化则加载主题
    try {
      // 从Hive存储读取主题设置
      loadTheme();
    } catch (e) {
      // 如果Hive还未初始化，稍后再尝试
      debugPrint('Hive not initialized yet, will retry later');
      // 延迟100ms后再次尝试
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!_initialized) {
          loadTheme();
        }
      });
    }
  }

  // 加载主题设置
  void loadTheme() {
    try {
      // 获取Hive服务
      final HiveService hiveService = Get.find<HiveService>();

      final themeStr =
          hiveService.getValue(
                HiveService.appBoxName,

                HiveService.themeMode,
                defaultValue: 'light',
              )
              as String;

      if (themeStr == 'dark') {
        themeMode.value = ThemeMode.dark;
      } else if (themeStr == 'light') {
        themeMode.value = ThemeMode.light;
      } else {
        // 默认跟随系统
        themeMode.value = ThemeMode.system;
      }
      _initialized = true;
    } catch (e) {
      // 出错时使用默认主题
      themeMode.value = ThemeMode.light;
      debugPrint('Failed to load theme: $e');
    }
  }

  // 切换主题
  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
    // 保存主题设置到Hive存储
    saveTheme();
  }

  // 保存主题设置
  Future<void> saveTheme() async {
    final HiveService hiveService = Get.find<HiveService>();
    try {
      String themeStr;
      if (themeMode.value == ThemeMode.light) {
        themeStr = 'light';
      } else if (themeMode.value == ThemeMode.dark) {
        themeStr = 'dark';
      } else {
        themeStr = 'system';
      }
      await hiveService.setValue(
        HiveService.appBoxName,

        HiveService.themeMode,
        themeStr,
      );
    } catch (e) {
      // 保存失败时的错误处理
      debugPrint('Failed to save theme: $e');
    }
  }

  // 获取当前主题
  ThemeData get theme => Get.isDarkMode ? darkTheme : lightTheme;
  Color get backgroundColor => Get.isDarkMode
      ? darkTheme.scaffoldBackgroundColor
      : lightTheme.scaffoldBackgroundColor;
  Color get primaryColor =>
      Get.isDarkMode ? darkTheme.primaryColor : lightTheme.primaryColor;
  Color get textColor => Get.isDarkMode ? Colors.white : Colors.black87;
}
