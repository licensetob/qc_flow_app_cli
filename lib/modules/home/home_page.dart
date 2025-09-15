// 文件名称：home_page.dart
// 文件描述：首页视图类，负责首页UI的构建和用户交互处理。
// 包括页面初始化、AppBar构建、页面内容构建等功能，继承自BaseGetViewV。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qc_app_flow/core/base/base_get_view_v.dart';
import 'package:qc_app_flow_base_animatablewidget/qc_app_flow_textbutton/textbutton.dart';
import 'package:qc_app_flow_utils/qc_app_flow_utils.dart';
import 'home_controller.dart';

// ignore: must_be_immutable
class HomePage extends BaseGetViewV<HomeController> {
  HomePage({super.key});

  QcFlowTextButton textButton = QcFlowTextButton();

  @override
  void onInitBefore() {
    textButton.onClick(() {
      print(QcTextUtils.extraction.getTextBetween("你好世界", "你", "界"));
      textButton.setHeight(100);
      textButton.setText("新的文本");
      textButton.setTextSize(20);
      textButton.setWidth(100);
    });
    controller.fetchData();
  }

  @override
  void onInitAfter() {}

  @override
  AppBar? buildAppBar() {
    return AppBar(
      title: Text('home'.tr),
      actions: [
        IconButton(
          icon: Icon(Icons.brightness_medium),
          onPressed: () {
            controller.toggleTheme();
          },
        ),
        IconButton(
          icon: Icon(Icons.language),
          onPressed: () {
            controller.toggleLanguage();
          },
        ),
      ],
    );
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Center(child: Stack(children: [textButton.build(context)]));
  }

  bool onClose() {
    return false;
  }
}
