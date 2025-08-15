import 'package:qc_app_flow_base_animatablewidget/export.dart';
import 'qc_flow_base_anmaiton_controller.dart';

abstract class QcFlowAnimatableWidget {
  void playAnimation({bool reverse = false});
  void stopAnimation();
  void setAnimationType(QcFlowAnimationType type);
  void setWidth(double width);
  void setHeight(double height);
  void setPosition({double? left, double? top, double? right, double? bottom});

  Widget build(BuildContext context);
}

abstract class QcFlowBaseAnimatableWidget extends QcFlowAnimatableWidget {
  final QcFlowBaseAnimatableController controller;
  final bool usePositioned;

  QcFlowBaseAnimatableWidget({
    QcFlowBaseAnimatableController? controller,
    this.usePositioned = true,
    double initialWidth = 0,
    double initialHeight = 0,
    QcFlowAnimationType initialAnimationType = QcFlowAnimationType.fadeIn,
  }) : controller = controller ?? Get.put(QcFlowBaseAnimatableController()) {
    setWidth(initialWidth);
    setHeight(initialHeight);
    setAnimationType(initialAnimationType);
  }

  // 子类实现具体内容
  Widget buildChild(BuildContext context);

  // 应用动画效果
  Widget _applyAnimation(Widget child) {
    switch (controller.animationType) {
      case QcFlowAnimationType.fadeIn:
        return Opacity(opacity: controller.animation.value, child: child);
      case QcFlowAnimationType.scale:
        return Transform.scale(scale: controller.animation.value, child: child);
      // 其他动画实现...
      default:
        return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Widget child = AnimatedBuilder(
        animation: controller.animController,
        builder: (context, child) => _applyAnimation(child!),
        child: buildChild(context),
      );

      // 应用尺寸约束
      if (controller.width > 0 || controller.height > 0) {
        child = SizedBox(
          width: controller.width,
          height: controller.height,
          child: child,
        );
      }

      // 应用定位
      if (usePositioned) {
        child = Positioned(
          left: controller.left,
          top: controller.top,
          right: controller.right,
          bottom: controller.bottom,
          child: child,
        );
      }

      return child;
    });
  }

  // 实现接口方法
  @override
  void playAnimation({bool reverse = false}) => 
      controller.playAnimation(reverse: reverse);

  @override
  void stopAnimation() => controller.stopAnimation();

  @override
  void setAnimationType(QcFlowAnimationType type) => 
      controller.setAnimationType(type);

  @override
  void setWidth(double width) => controller.setWidth(width);

  @override
  void setHeight(double height) => controller.setHeight(height);

  @override
  void setPosition({double? left, double? top, double? right, double? bottom}) =>
      controller.setPosition(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      );
  double? getWidth() => controller.width;
  double? getHeight() => controller.height;
  double? getLeft() => controller.left;
  double? getTop() => controller.top;
  double? getRight() => controller.right;
  double? getBottom() => controller.bottom;
}