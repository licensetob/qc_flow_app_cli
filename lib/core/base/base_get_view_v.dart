// 文件名称：base_get_view_v.dart
// 文件描述：扩展的基础视图抽象类，继承自BaseGetView，增加了生命周期回调机制。
// 提供初始化前(onInitBefore)和初始化后(onInitAfter)的回调方法，便于页面生命周期管理。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'base_get_view.dart';
import 'base_controller.dart';

abstract class BaseGetViewV<T extends BaseController> extends BaseGetView<T> {
  BaseGetViewV({super.key});

  // 标记是否已初始化
  final RxBool _isInitialized = false.obs;

  @override
  Widget build(BuildContext context) {
    // 初始化前回调
    if (!_isInitialized.value) {
      onInitBefore();
    }

    final widget = super.build(context);

    // 初始化后回调（确保在build完成后调用）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized.value) {
        onInitAfter();
        _isInitialized.value = true;
      }
    });

    return widget;
  }

  // 页面初始化前回调（子类可重写）
  void onInitBefore();

  // 页面初始化后回调（子类可重写）
  void onInitAfter() ;

}
