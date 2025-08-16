import 'package:qc_app_flow_base_animatablewidget/export.dart';
import '../qc_flow_base_top_layer/qc_flow_base_animation_abs.dart';
import '../qc_flow_base_top_layer/qc_flow_base_anmaiton_controller.dart';

abstract class AbstractQcFlowTextButton extends QcFlowAnimatableWidget {
  void setText(String text);
  void setBackgroundColor(Color color);
  void setButtonShape(double radius);
  void setTextColor(Color color);
  void setTextSize(double size);
  void setSplashShow(bool show);
  void onClick(VoidCallback? callback);
}

class QcFlowTextButtonController extends QcFlowBaseAnimatableController {
  final RxString _text = "按钮".obs;
  final Rx<Color> _backgroundColor = Colors.blue.obs;
  final RxDouble _borderRadius = 4.0.obs;
  final Rx<Color> _textColor = Colors.white.obs;
  final RxDouble _textSize = 16.0.obs;
  final RxBool _enableSplash = true.obs;
  final Rxn<VoidCallback> _onPressed = Rxn<VoidCallback>();

  // Getter
  String get text => _text.value;
  Color get backgroundColor => _backgroundColor.value;
  double get borderRadius => _borderRadius.value;
  Color get textColor => _textColor.value;
  double get textSize => _textSize.value;
  bool get enableSplash => _enableSplash.value;
  VoidCallback? get onPressed => _onPressed.value;

  // Setter方法
  void setText(String text) => _text.value = text;
  void setBackgroundColor(Color color) => _backgroundColor.value = color;
  void setButtonShape(double radius) => _borderRadius.value = radius;
  void setTextColor(Color color) => _textColor.value = color;
  void setTextSize(double size) => _textSize.value = size;
  void setSplashShow(bool show) => _enableSplash.value = show;
  void setOnPressed(VoidCallback? callback) => _onPressed.value = callback;
}

class QcFlowTextButton extends QcFlowBaseAnimatableWidget
    implements AbstractQcFlowTextButton {
  final QcFlowTextButtonController _controller;

  QcFlowTextButton({
    QcFlowTextButtonController? controller,
    super.usePositioned = true,
    double? initialWidth = 50,
    double? initialHeight = 50,
    int initialAnimationType = 1,
    String initialText = "按钮",
    Color initialBgColor = Colors.blue,
    double initialRadius = 4.0,
    Color initialTextColor = Colors.white,
    double initialTextSize = 16.0,
    bool initialSplash = true,
  }) : _controller = controller ?? QcFlowTextButtonController(),
       super(
         controller: controller ?? QcFlowTextButtonController(),
         initialWidth: initialWidth!,
         initialHeight: initialHeight!,
         initialAnimationType: QcFlowAnimationType.values[initialAnimationType],
       ) {
    // 初始化逻辑移到构造函数体中
    _controller.setText(initialText);
    _controller.setBackgroundColor(initialBgColor);
    _controller.setButtonShape(initialRadius);
    _controller.setTextColor(initialTextColor);
    _controller.setTextSize(initialTextSize);
    _controller.setSplashShow(initialSplash);
  }

  @override
  Widget buildChild(BuildContext context) {
    return Obx(() {
      print("是否被刷新");
      return TextButton(
        onPressed: _controller.onPressed,
        style: TextButton.styleFrom(
          backgroundColor: _controller.backgroundColor,
          foregroundColor: _controller.textColor,
          textStyle: TextStyle(
            fontSize: _controller.textSize,
            color: _controller.textColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_controller.borderRadius),
          ),
          splashFactory: _controller.enableSplash
              ? InkSplash.splashFactory
              : NoSplash.splashFactory,
        ),
        child: Text(
          _controller.text,
          style: TextStyle(
            fontSize: _controller.textSize,
            color: _controller.textColor,
          ),
        ),
      );
    });
  }

  // 实现文本按钮特有方法
  @override
  void setText(String text) => _controller.setText(text);

  @override
  void setBackgroundColor(Color color) => _controller.setBackgroundColor(color);

  @override
  void setButtonShape(double radius) => _controller.setButtonShape(radius);

  @override
  void setTextColor(Color color) => _controller.setTextColor(color);

  @override
  void setTextSize(double size) => _controller.setTextSize(size);

  @override
  void setSplashShow(bool show) => _controller.setSplashShow(show);

  @override
  void onClick(VoidCallback? callback) => _controller.setOnPressed(callback);
}
