// 文件名称：screen_util.dart
// 文件描述：屏幕适配工具类，提供屏幕尺寸的获取和适配方法。
// 包括屏幕宽度、高度、像素密度等信息的获取，以及尺寸的适配转换。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

import 'package:flutter/material.dart';

class ScreenUtil {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double pixelRatio;
  static late double statusBarHeight;
  static late double bottomBarHeight;
  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    pixelRatio = _mediaQueryData.devicePixelRatio;
    statusBarHeight = _mediaQueryData.padding.top;
    bottomBarHeight = _mediaQueryData.padding.bottom;
    textScaleFactor = _mediaQueryData.textScaler.scale(1.0);
  }

  // 适配宽度
  static double setWidth(double width) {
    return width * screenWidth / 375.0;
  }

  // 适配高度
  static double setHeight(double height) {
    return height * screenHeight / 667.0;
  }

  // 适配字体
  static double setFontSize(double fontSize) {
    return fontSize * textScaleFactor;
  }
}