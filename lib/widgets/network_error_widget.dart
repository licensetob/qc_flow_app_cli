// 文件名称：network_error_widget.dart
// 文件描述：网络错误页面组件，用于显示网络连接异常的提示信息。
// 提供错误图标、错误消息和重试按钮，支持全局和局部两种错误展示模式。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/base/base_controller.dart';

class NetworkErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool isGlobal;

  const NetworkErrorWidget({
    super.key,
    this.message = 'network_error',
    this.onRetry,
    this.isGlobal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 100,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 20),
            Text(
              message.tr,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry ?? _defaultRetryAction,
              child: Text('retry'.tr),
            ),
          ],
        ),
      ),
    );
  }

  void _defaultRetryAction() {
    if (isGlobal) {
      // 如果是全局错误页面，可以重新加载应用或当前页面
      Get.back();
    } else {
      // 重新请求数据
      final controller = Get.find<BaseController>();
      controller.refreshData();
    }
  }
}