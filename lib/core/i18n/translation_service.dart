// 文件名称：translation_service.dart
// 文件描述：国际化翻译服务类，负责应用的多语言支持和翻译管理。
// 定义了支持的语言、区域设置以及对应的翻译键值对，支持自动切换语言。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'dart:ui';

import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class TranslationService extends Translations {
  static final locale = Get.deviceLocale ?? const Locale('zh', 'CN');
  static final fallbackLocale = const Locale('en', 'US');
  static final langs = ['中文', 'English'];
  static final locales = [const Locale('zh', 'CN'), const Locale('en', 'US')];

  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'app_name': 'Flutter框架',
          'home': '首页',
          'loading': '加载中...',
          'error': '发生错误',
          'network_error': '网络错误',
          'no_data': '暂无数据',
          'retry': '重试',
          'success': '成功',
          'cancel': '取消',
          'confirm': '确认',
        },
        'en_US': {
          'app_name': 'Flutter Framework',
          'home': 'Home',
          'loading': 'Loading...',
          'error': 'Error',
          'network_error': 'Network Error',
          'no_data': 'No Data',
          'retry': 'Retry',
          'success': 'Success',
          'cancel': 'Cancel',
          'confirm': 'Confirm',
        },
      };

  // 切换语言
  static void changeLocale(String lang) {
    final locale = langs.contains(lang) ? locales[langs.indexOf(lang)] : fallbackLocale;
    Get.updateLocale(locale);
  }

  // 格式化日期
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(format).format(date);
    } catch (e) {
      return '';
    }
  }

  // 格式化数字
  static String formatNumber(num number, {int? fractionDigits}) {
    try {
      final formatter = NumberFormat('#,##0.${fractionDigits != null ? '0' * fractionDigits : '##'}');
      return formatter.format(number);
    } catch (e) {
      return number.toString();
    }
  }
}