// 文件名称：home_controller.dart
// 文件描述：首页控制器类，负责首页的数据管理和业务逻辑。
// 包括首页数据的加载、主题切换等功能，继承自BaseController。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:get/get.dart';
import '../../core/base/base_controller.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/i18n/translation_service.dart';

class HomeController extends BaseController {
  final items = <Map<String, dynamic>>[].obs;

  @override
  void initData() {
    super.initData();
    loadData();
  }

  @override
  Future<void> fetchData() async {
    // try {
    //   final response = await HttpService().get('/api/demo');
    //   final data = response.data['data'] as List;
    //   items.assignAll(data.cast<Map<String, dynamic>>());
    //   isEmpty.value = items.isEmpty;
    // } catch (e) {
    //   isEmpty.value = true;
    //   rethrow;
    // }
  }

  void toggleTheme() {
    // 切换主题
    Get.find<ThemeController>().toggleTheme();
  }

  void toggleLanguage() {
    // 切换语言
    final currentLocale = Get.locale;
    if (currentLocale?.languageCode == 'zh') {
      TranslationService.changeLocale('English');
    } else {
      TranslationService.changeLocale('中文');
    }
  }
}

// 绑定控制器
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
