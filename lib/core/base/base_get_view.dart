// 文件名称：base_get_view.dart
// 文件描述：基础视图抽象类，继承自GetView，提供页面通用的构建方法和生命周期管理。
// 包含AppBar构建、页面内容构建、占位页处理等基础功能。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/screen_util.dart';
import 'base_controller.dart';

abstract class BaseGetView<T extends BaseController> extends GetView<T> {
  const BaseGetView({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    // 初始化屏幕适配
    ScreenUtil.init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: buildContent(context),
    );
  }

  // 构建AppBar
  AppBar? buildAppBar() {
    return null;
  }

  // 构建页面主体内容（子类实现）
  Widget buildPageContent(BuildContext context);

  // 统一处理占位页逻辑
  Widget buildContent(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? buildLoadingWidget()
          : controller.hasError.value
          ? buildErrorWidget(
              controller.errorMessage.value,
              onTap: controller.refreshData,
            )
          : controller.isEmpty.value
          ? buildEmptyWidget(onTap: controller.refreshData)
          : buildPageContent(context),
    );
  }

  // 显示加载提示
  Widget buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  // 显示错误提示
  Widget buildErrorWidget(String message, {Function()? onTap}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
          ),
          ElevatedButton(onPressed: onTap, child: const Text('重试')),
        ],
      ),
    );
  }

  // 显示空数据提示
  Widget buildEmptyWidget({Function()? onTap}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '暂无数据',
          ),
          ElevatedButton(onPressed: onTap, child: const Text('刷新')),
        ],
      ),
    );
  }

  // 显示加载对话框
  void showLoading([String? message]) {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  // 隐藏加载提示
  void hideLoading() {
    Get.back();
  }

  // 显示提示信息
  void showToast(String message) {
    Get.snackbar('提示', message);
  }

  // GetX生命周期方法 - 页面关闭时调用
}
