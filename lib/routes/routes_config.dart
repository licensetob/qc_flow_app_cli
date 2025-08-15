// 文件名称：routes_config.dart
// 文件描述：应用路由配置类，定义了应用的页面路由映射。
// 负责将路由名称与对应的页面组件和控制器绑定进行关联，实现页面间的导航功能。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:get/get.dart';
import '../modules/home/home_controller.dart';
import '../modules/home/home_page.dart';
import '../widgets/network_error_widget.dart';
import 'app_routes.dart';

class RoutesConfig {
  static List<GetPage> getPages = [
    GetPage(
      name: AppRoutes.initial,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.networkError,
      page: () => const NetworkErrorWidget(isGlobal: true),
    ),
    // 更多页面路由...
  ];
}