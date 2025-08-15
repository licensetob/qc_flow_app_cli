import 'package:qc_app_flow_base_animatablewidget/export.dart';
// fadeIn 淡入
// scale 缩放
// slideFromLeft 从左滑动
// slideFromRight 从右滑动
// slideFromTop 从上滑动
// slideFromBottom 从下滑动
// rotate 旋转
// flip 翻转
// sizeChange 尺寸变化
// colorFade 颜色变化
enum QcFlowAnimationType {
  fadeIn,
  scale,
  slideFromLeft,
  slideFromRight,
  slideFromTop,
  slideFromBottom,
  rotate,
  flip,
  sizeChange,
  colorFade,
}

class QcFlowBaseAnimatableController extends GetxController 
    with GetSingleTickerProviderStateMixin {
  // 尺寸状态
  final RxDouble _width = 0.0.obs;
  final RxDouble _height = 0.0.obs;
  
  // 定位状态
  final Rx<double?> _left = Rx<double?>(null);
  final Rx<double?> _top = Rx<double?>(null);
  final Rx<double?> _right = Rx<double?>(null);
  final Rx<double?> _bottom = Rx<double?>(null);

  // 动画核心
  late AnimationController animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  final Rx<QcFlowAnimationType> _animationType = QcFlowAnimationType.fadeIn.obs;
  final RxBool _isAnimating = false.obs;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  // 对外暴露的getter
  double get width => _width.value;
  double get height => _height.value;
  double? get left => _left.value;
  double? get top => _top.value;
  double? get right => _right.value;
  double? get bottom => _bottom.value;
  QcFlowAnimationType get animationType => _animationType.value;
  bool get isAnimating => _isAnimating.value;
  Animation<double> get animation => _animation;
  Animation<Color?> get colorAnimation => _colorAnimation;

  @override
  void onInit() {
    super.onInit();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    animController.addStatusListener((status) {
      _isAnimating.value = status != AnimationStatus.completed && 
                          status != AnimationStatus.dismissed;
    });
    _initAnimation();
  }

  // 尺寸控制方法
  void setWidth(double value) => _width.value = value;
  void setHeight(double value) => _height.value = value;
  
  // 定位控制方法
  void setPosition({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (left != null) _left.value = left;
    if (top != null) _top.value = top;
    if (right != null) _right.value = right;
    if (bottom != null) _bottom.value = bottom;
  }

  // 动画类型设置
  void setAnimationType(QcFlowAnimationType type) {
    _animationType.value = type;
    _initAnimation();
  }

  // 动画初始化
  void _initAnimation() {
    animController.reset();
    switch (_animationType.value) {
      case QcFlowAnimationType.fadeIn:
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeIn),
        );
        break;
      case QcFlowAnimationType.scale:
        _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOut),
        );
        break;
      case QcFlowAnimationType.slideFromLeft:
        _animation = Tween<double>(begin: -100.0, end: 0.0).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOut),
        );
        break;
      case QcFlowAnimationType.slideFromRight:
        _animation = Tween<double>(begin: 100.0, end: 0.0).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOut),
        );
        break;
      case QcFlowAnimationType.slideFromTop:
        _animation = Tween<double>(begin: -100.0, end: 0.0).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOut),
        );
        break;
      case QcFlowAnimationType.slideFromBottom:
        _animation = Tween<double>(begin: 100.0, end: 0.0).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOut),
        );
        break;
      case QcFlowAnimationType.rotate:
        _animation = Tween<double>(begin: 0.0, end: 360.0).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOut),
        );
        break;
      case QcFlowAnimationType.flip:
        _animation = Tween<double>(begin: 0.0, end: 180.0).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOut),
        );
        break;
      case QcFlowAnimationType.sizeChange:
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOut),
        );
        break;
      case QcFlowAnimationType.colorFade:
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOut),
        );
        break;
        //其他动画
     
    }
  }

  // 动画控制
  void playAnimation({bool reverse = false}) {
    if (reverse) {
      animController.reverse();
    } else {
      animController.forward();
    }
  }

  void stopAnimation() => animController.stop();

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }
}