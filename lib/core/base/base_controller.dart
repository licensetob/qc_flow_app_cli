// 文件名称：base_controller.dart
// 文件描述：基础控制器抽象类，定义了页面通用的状态管理和数据加载逻辑。
// 包含加载状态、错误状态、空数据状态的管理，以及数据加载和获取的基础方法。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  // 页面状态
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isEmpty = false.obs;


  // 初始化数据
  void initData() {
    // 子类实现数据初始化逻辑
  }  
  // 加载数据
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      await fetchData();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // 获取数据（子类实现）
  Future<void> fetchData() async {
    // 子类实现数据获取逻辑
  }

  // 刷新数据
  void refreshData() {
    loadData();
  }
}