// 文件名称：hive_service.dart
// 文件描述：Hive数据库服务类，负责本地数据存储和管理。
// 提供数据的读写、删除等操作，支持应用设置和用户数据的持久化存储。
// 采用单例模式设计，确保全局只有一个实例。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/logger.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  
  late Box _appBox;
  late Box _userBox;
  
  // 定义存储键常量
  static const String appBoxName = 'app_settings';
  static const String userBoxName = 'user_data';

  
  // 主题相关键
  static const String themeMode = 'theme_mode';
  
  // 用户相关键
  static const String userToken = 'user_token';
  static const String userInfo = 'user_info';
  
  HiveService._internal();
  
  // 初始化Hive（简化版本）
  Future<void> init() async {
    try {
      // 获取应用文档目录
      final appDocumentDir = await getApplicationDocumentsDirectory();
      
      // 只使用Hive核心库的初始化方法
      Hive.init(appDocumentDir.path);
      
      // 打开必要的box
      _appBox = await Hive.openBox(appBoxName);
      _userBox = await Hive.openBox(userBoxName);
      
      Logger.i('Hive initialized successfully');
    } catch (e) {
      Logger.e('Failed to initialize Hive: $e');
      rethrow;
    }
  }
  
  // 应用设置相关操作
  Box get appBox => _appBox;
  
  // 用户数据相关操作
  Box get userBox => _userBox;
  
  // 通用设置方法
  Future<void> setValue(String boxName, String key, dynamic value) async {
    try {
      if (boxName == appBoxName) {

        await _appBox.put(key, value);
      } else if (boxName == userBoxName) {

        await _userBox.put(key, value);
      }
    } catch (e) {
      Logger.e('Failed to set value for key $key in box $boxName: $e');
      rethrow;
    }
  }
  
  // 通用获取方法
  dynamic getValue(String boxName, String key, {dynamic defaultValue}) {
    try {
      if (boxName == appBoxName) {
        return _appBox.get(key, defaultValue: defaultValue);
      } else if (boxName == userBoxName) {
        return _userBox.get(key, defaultValue: defaultValue);
      }
      return defaultValue;
    } catch (e) {
      Logger.e('Failed to get value for key $key in box $boxName: $e');
      return defaultValue;
    }
  }
  
  // 删除键值对
  Future<void> deleteValue(String boxName, String key) async {
    try {
      if (boxName == appBoxName) {
        await _appBox.delete(key);
      } else if (boxName == userBoxName) {
        await _userBox.delete(key);
      }
    } catch (e) {
      Logger.e('Failed to delete value for key $key in box $boxName: $e');
      rethrow;
    }
  }
  
  // 关闭所有box
  Future<void> close() async {
    await Hive.close();
  }
}