import 'qc_annotations.dart';

/// 高级提取与分割操作抽象接口
abstract class QcTextExtractionOperations {
  /// 取出中间文本
  @QcMethod(name: "文本_取出中间文本")
  String getTextBetween(
    String text,
    String leftMark,
    String rightMark, {
    int startIndex = 0,
    bool caseSensitive = true,
  });

  /// 文本分割
  @QcMethod(name: "文本_分割")
  List<String> split(
    String text,
    List<String> separators, {
    bool ignoreEmpty = false,
  });

  /// 取行
  @QcMethod(name: "文本_取行")
  String getLine(String text, int lineNumber);

  /// 取所有行
  @QcMethod(name: "文本_取所有行")
  List<String> getAllLines(String text);

  /// 取词
  @QcMethod(name: "文本_取词")
  List<String> getWords(String text);

  /// 提取数字
  @QcMethod(name: "文本_提取数字")
  List<String> extractNumbers(String text);

  /// 提取字母
  @QcMethod(name: "文本_提取字母")
  List<String> extractLetters(String text);

  /// 提取中文
  @QcMethod(name: "文本_提取中文")
  List<String> extractChinese(String text);

  /// 取匹配项
  @QcMethod(name: "文本_取匹配项")
  List<String> getMatches(String text, String pattern);
}

/// 高级提取与分割操作实现类
class QcTextExtractionOperationsImpl implements QcTextExtractionOperations {
  @override
  String getTextBetween(
    String text,
    String leftMark,
    String rightMark, {
    int startIndex = 0,
    bool caseSensitive = true,
  }) {
    if (text.isEmpty || leftMark.isEmpty || rightMark.isEmpty) {
      return "";
    }

    String processedText = text;
    String processedLeftMark = leftMark;
    String processedRightMark = rightMark;

    if (!caseSensitive) {
      processedText = text.toLowerCase();
      processedLeftMark = leftMark.toLowerCase();
      processedRightMark = rightMark.toLowerCase();
    }

    int leftPos = processedText.indexOf(processedLeftMark, startIndex);
    if (leftPos == -1) {
      return "";
    }

    int leftEnd = leftPos + leftMark.length;
    int rightPos = processedText.indexOf(processedRightMark, leftEnd);
    if (rightPos == -1) {
      return "";
    }

    // 计算原始文本中的实际位置
    return text.substring(leftEnd, rightPos);
  }

  @override
  List<String> split(
    String text,
    List<String> separators, {
    bool ignoreEmpty = false,
  }) {
    if (separators.isEmpty) {
      return [text];
    }

    List<String> result = [text];
    for (String separator in separators) {
      List<String> temp = [];
      for (String item in result) {
        temp.addAll(item.split(separator));
      }
      result = temp;
    }

    if (ignoreEmpty) {
      result.removeWhere((item) => item.isEmpty);
    }

    return result;
  }

  @override
  String getLine(String text, int lineNumber) {
    List<String> lines = getAllLines(text);
    if (lineNumber < 1 || lineNumber > lines.length) {
      return "";
    }
    return lines[lineNumber - 1];
  }

  @override
  List<String> getAllLines(String text) {
    return text.split(RegExp(r'[\r\n]+'));
  }

  List<String> getWords(String text) {
    if (text.isEmpty) return [];

    // 改进的分词正则，支持更多标点符号，并保留单词中的特殊字符
    // 同时处理中英文标点
    List<String> words = text.split(
      RegExp(r'''[\s,.!?;:"\'()\[\]{}，。！？；：“”‘’（）【】{}]+'''),
    );

    // 移除空字符串，并处理单词前后可能残留的标点
    return words
        .where((word) => word.isNotEmpty)
        .map((word) => _trimPunctuation(word))
        .toList();
  }

  // 移除单词前后的标点符号
  String _trimPunctuation(String word) {
    if (word.isEmpty) return word;

    // 定义需要移除的标点集合
    const punctuation = ',.!?;:"\'()[]{}，。！？；：“”‘’（）【】{}';

    int start = 0;
    int end = word.length - 1;

    // 找到第一个不是标点的位置
    while (start <= end && punctuation.contains(word[start])) {
      start++;
    }

    // 找到最后一个不是标点的位置
    while (end >= start && punctuation.contains(word[end])) {
      end--;
    }

    return start > end ? '' : word.substring(start, end + 1);
  }

  @override
  List<String> extractNumbers(String text) {
    RegExp regExp = RegExp(r'\d+(\.\d+)?');
    Iterable<Match> matches = regExp.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  @override
  List<String> extractLetters(String text) {
    RegExp regExp = RegExp(r'[a-zA-Z]+');
    Iterable<Match> matches = regExp.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  @override
  List<String> extractChinese(String text) {
    RegExp regExp = RegExp(r'[\u4e00-\u9fa5]+');
    Iterable<Match> matches = regExp.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  @override
  List<String> getMatches(String text, String pattern) {
    try {
      RegExp regExp = RegExp(pattern);
      Iterable<Match> matches = regExp.allMatches(text);
      return matches.map((match) => match.group(0)!).toList();
    } catch (e) {
      return [];
    }
  }
}
