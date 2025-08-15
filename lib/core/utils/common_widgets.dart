// 文件名称：common_widgets.dart
// 文件描述：通用Widget组件库，定义了应用中常用的UI组件。
// 包括加载中组件、空数据组件等，方便在不同页面中复用，提高代码的可维护性。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 加载中组件
Widget buildLoadingWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        CircularProgressIndicator(),
        SizedBox(height: 10),
        Text('loading'.tr),
      ],
    ),
  );
}

// 空数据组件
Widget buildEmptyWidget({VoidCallback? onTap}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade300),
        SizedBox(height: 10),
        Text('no_data'.tr),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text('retry'.tr),
          ),
      ],
    ),
  );
}

// 错误组件
Widget buildErrorWidget(String message, {VoidCallback? onTap}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
        SizedBox(height: 10),
        Text(message),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text('retry'.tr),
          ),
      ],
    ),
  );
}