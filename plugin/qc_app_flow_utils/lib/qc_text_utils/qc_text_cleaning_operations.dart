import 'qc_annotations.dart';

/// 文本清洗与格式化操作抽象接口
abstract class QcTextCleaningOperations {
  /// 文本删空格
  @QcMethod(name: "文本_删空格")
  String removeSpaces(String text, {bool all = false, bool merge = false});

  /// 文本过滤
  @QcMethod(name: "文本_过滤")
  String filter(String text, bool Function(String char) predicate);

  /// 文本trim
  @QcMethod(name: "文本_trim")
  String trim(String text);

  /// 换行转空格
  @QcMethod(name: "文本_换行转空格")
  String lineBreakToSpace(String text);

  /// 规范格式
  @QcMethod(name: "文本_规范格式")
  String normalizeFormat(String text, {int indent = 2});

  /// 文本去重
  @QcMethod(name: "文本_去重")
  String removeDuplicates(String text, {bool continuousOnly = true});
}

/// 文本清洗与格式化操作实现类
class QcTextCleaningOperationsImpl implements QcTextCleaningOperations {
  @override
  String removeSpaces(String text, {bool all = false, bool merge = false}) {
    if (all) {
      return text.replaceAll(RegExp(r'\s+'), '');
    } else if (merge) {
      return text.replaceAll(RegExp(r'\s+'), ' ');
    } else {
      return text;
    }
  }

  @override
  String filter(String text, bool Function(String char) predicate) {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (predicate(char)) {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  @override
  String trim(String text) {
    return text.trim();
  }

  @override
  String lineBreakToSpace(String text) {
    return text.replaceAll(RegExp(r'[\r\n]+'), ' ');
  }

  @override
  String normalizeFormat(String text, {int indent = 2}) {
    // 简单实现：将多个换行合并为一个，句尾加换行
    String result = text.replaceAll(RegExp(r'[\r\n]+'), '\n');
    result = result.replaceAll(RegExp(r'([。！？；,.!?;])'), r'$1\n');
    
    // 添加缩进
    if (indent > 0) {
      String indentStr = ' ' * indent;
      result = result.replaceAll(RegExp(r'\n(.)'), '\n' + indentStr + r'$1');
    }
    
    return result;
  }

  @override
  String removeDuplicates(String text, {bool continuousOnly = true}) {
    if (text.isEmpty) return text;
    
    if (continuousOnly) {
      // 只去重连续重复的字符
      StringBuffer buffer = StringBuffer();
      String prevChar = text[0];
      buffer.write(prevChar);
      
      for (int i = 1; i < text.length; i++) {
        String currentChar = text[i];
        if (currentChar != prevChar) {
          buffer.write(currentChar);
          prevChar = currentChar;
        }
      }
      return buffer.toString();
    } else {
      // 去重所有重复的字符，保留第一次出现的
      StringBuffer buffer = StringBuffer();
      Set<String> seen = Set();
      
      for (int i = 0; i < text.length; i++) {
        String char = text[i];
        if (!seen.contains(char)) {
          buffer.write(char);
          seen.add(char);
        }
      }
      return buffer.toString();
    }
  }
}
