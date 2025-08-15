// 文件名称：storage_service.dart
// 文件描述：存储服务类，基于SharedPreferences实现本地数据持久化。
// 提供字符串、整数、布尔值等类型的读写操作，用于存储应用配置和用户偏好设置。
// 采用单例模式设计，确保全局只有一个实例。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  
  late SharedPreferences _prefs;
  
  StorageService._internal();
  
  // 初始化
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      Logger.i('SharedPreferences initialized');
    } catch (e) {
      Logger.e('Failed to initialize SharedPreferences: $e');
      rethrow;
    }
  }
  
  // 存储字符串
  Future<bool> setString(String key, String value) {
    try {
      return _prefs.setString(key, value);
    } catch (e) {
      Logger.e('Failed to set string for key $key: $e');
      rethrow;
    }
  }
  
  // 获取字符串
  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      Logger.e('Failed to get string for key $key: $e');
      return null;
    }
  }
  
  // 存储布尔值
  Future<bool> setBool(String key, bool value) {
    try {
      return _prefs.setBool(key, value);
    } catch (e) {
      Logger.e('Failed to set bool for key $key: $e');
      rethrow;
    }
  }
  
  // 获取布尔值
  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      Logger.e('Failed to get bool for key $key: $e');
      return null;
    }
  }
  
  // 存储整数
  Future<bool> setInt(String key, int value) {
    try {
      return _prefs.setInt(key, value);
    } catch (e) {
      Logger.e('Failed to set int for key $key: $e');
      rethrow;
    }
  }
  
  // 获取整数
  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      Logger.e('Failed to get int for key $key: $e');
      return null;
    }
  }
  
  // 删除键值对
  Future<bool> remove(String key) {
    try {
      return _prefs.remove(key);
    } catch (e) {
      Logger.e('Failed to remove key $key: $e');
      rethrow;
    }
  }
  
  // 清除所有数据
  Future<bool> clear() {
    try {
      return _prefs.clear();
    } catch (e) {
      Logger.e('Failed to clear all data: $e');
      rethrow;
    }
  }
}