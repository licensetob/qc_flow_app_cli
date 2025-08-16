import 'qc_annotations.dart';

/// 基础文本处理操作抽象接口
abstract class QcTextBasicOperations {
  /// 取文本长度
  @QcMethod(name: "文本_取长度")
  int getLength(String text);

  /// 取文本左边
  @QcMethod(name: "文本_取左边")
  String getLeft(String text, int length);

  /// 取文本右边
  @QcMethod(name: "文本_取右边")
  String getRight(String text, int length);

  /// 取文本中间
  @QcMethod(name: "文本_取中间")
  String getMiddle(String text, int start, int length);

  /// 文本倒序
  @QcMethod(name: "文本_倒序")
  String reverse(String text);

  /// 文本替换
  @QcMethod(name: "文本_替换")
  String replace(String text, String oldStr, String newStr, {bool replaceAll = true});

  /// 文本删除
  @QcMethod(name: "文本_删除")
  String delete(String text, int start, int length);

  /// 文本插入
  @QcMethod(name: "文本_插入")
  String insert(String text, int position, String insertStr);

  /// 文本重复
  @QcMethod(name: "文本_重复")
  String repeat(String text, int count);

  /// 文本比较
  @QcMethod(name: "文本_比较")
  int compare(String text1, String text2, {bool ignoreCase = false});

  /// 文本到大写
  @QcMethod(name: "文本_到大写")
  String toUpper(String text);

  /// 文本到小写
  @QcMethod(name: "文本_到小写")
  String toLower(String text);
}

/// 基础文本处理操作实现类
class QcTextBasicOperationsImpl implements QcTextBasicOperations {
  @override
  int getLength(String text) {
    return text.length;
  }

  @override
  String getLeft(String text, int length) {
    if (length <= 0) return "";
    if (length >= text.length) return text;
    return text.substring(0, length);
  }

  @override
  String getRight(String text, int length) {
    if (length <= 0) return "";
    if (length >= text.length) return text;
    return text.substring(text.length - length);
  }

  @override
  String getMiddle(String text, int start, int length) {
    if (start < 0 || start >= text.length) return "";
    if (length <= 0) return "";
    
    int end = start + length;
    if (end > text.length) {
      end = text.length;
    }
    return text.substring(start, end);
  }

  @override
  String reverse(String text) {
    return String.fromCharCodes(text.runes.toList().reversed);
  }

  @override
  String replace(String text, String oldStr, String newStr, {bool replaceAll = true}) {
    if (replaceAll) {
      return text.replaceAll(oldStr, newStr);
    } else {
      return text.replaceFirst(oldStr, newStr);
    }
  }

  @override
  String delete(String text, int start, int length) {
    if (start < 0 || start >= text.length) return text;
    if (length <= 0) return text;
    
    int end = start + length;
    if (end > text.length) {
      end = text.length;
    }
    
    return text.substring(0, start) + text.substring(end);
  }

  @override
  String insert(String text, int position, String insertStr) {
    if (position < 0 || position > text.length) return text;
    return text.substring(0, position) + insertStr + text.substring(position);
  }

  @override
  String repeat(String text, int count) {
    if (count <= 0) return "";
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < count; i++) {
      buffer.write(text);
    }
    return buffer.toString();
  }

  @override
  int compare(String text1, String text2, {bool ignoreCase = false}) {
    if (ignoreCase) {
      return text1.toLowerCase().compareTo(text2.toLowerCase());
    } else {
      return text1.compareTo(text2);
    }
  }

  @override
  String toUpper(String text) {
    return text.toUpperCase();
  }

  @override
  String toLower(String text) {
    return text.toLowerCase();
  }
}
