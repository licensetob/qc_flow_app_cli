// 文件名称：application.dart
// 文件描述：应用入口类，负责初始化和配置GetMaterialApp。
// 包括主题设置、路由配置、国际化支持等应用的核心配置。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/i18n/translation_service.dart';
import '../core/theme/theme_controller.dart';
import '../core/theme/themes.dart';
import '../routes/app_routes.dart';
import '../routes/routes_config.dart';

class Application {
  Widget initGetMaterialApp({Widget Function(BuildContext, Widget?)? builder}) {
    return GetX<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          title: 'app_name'.tr,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeController.themeMode.value, // 使用控制器中的可观察主题模式
          initialRoute: AppRoutes.initial,
          getPages: RoutesConfig.getPages,
          debugShowCheckedModeBanner: false,
          translations: TranslationService(),
          locale: TranslationService.locale,
          fallbackLocale: TranslationService.fallbackLocale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: TranslationService.locales,
          builder: builder,
        );
      },
    );
  }

  Widget getApplicationWidget() {
    final bottoastinit = BotToastInit();
    Widget body = initGetMaterialApp(
      builder: (p0, p1) {
        final child = ScreenUtilInit(child: p1);
        return bottoastinit(p0, child);
      },
    );
    return body;
  }
}
