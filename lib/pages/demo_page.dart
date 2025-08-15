// 文件名称：demo_page.dart
// 文件描述：示例页面，展示了应用的基本UI结构和组件使用方法。
// 包含简单的页面布局、组件集成和交互示例。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:flutter/material.dart';
import 'package:qc_app_flow_base_animatablewidget/qc_app_flow_textbutton/textbutton.dart';
import 'package:qc_app_flow_base_animatablewidget/qc_flow_base_top_layer/qc_flow_base_anmaiton_controller.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  QcFlowTextButton button = QcFlowTextButton();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 500,
              height: 500,
              child: Stack(
                children: [
                  Positioned.fill(child: Container(color: Colors.red)),
                  button.build(context),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: () => button.setWidth(200),
              child: const Text('设置大小'),
            ),
            ElevatedButton(
              onPressed: () {
                button.setAnimationType(QcFlowAnimationType.scale);
                button.playAnimation(reverse:false );
              },
              child: const Text('设置动画'),
            ),
            ElevatedButton(
              onPressed: () =>
                  button.setPosition(top: 100.0),
              child: const Text('设置位置'),
            ),
            ElevatedButton(
              onPressed: () => button.setTextColor(Colors.black),
              child: const Text('设置颜色'),
            ),
            ElevatedButton(
              onPressed: () => debugPrint(button.getTop().toString()),
              child: const Text('获取参数'),
            ),
          ],
        ),
      ),
    );
  }
}
