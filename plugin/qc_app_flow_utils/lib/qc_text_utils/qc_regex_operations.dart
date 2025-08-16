import 'qc_annotations.dart';

/// 正则表达式操作抽象接口
abstract class QcRegexOperations {
  /// 正则创建
  @QcMethod(name: "正则_创建")
  RegExp? create(String pattern, {bool caseSensitive = true, bool multiLine = false});

  /// 正则匹配
  @QcMethod(name: "正则_匹配")
  bool match(String text, RegExp regex);

  /// 取匹配文本
  @QcMethod(name: "正则_取匹配文本")
  List<String> getMatchTexts(String text, RegExp regex);

  /// 正则替换
  @QcMethod(name: "正则_替换")
  String replace(String text, RegExp regex, String replacement);

  /// 正则分割
  @QcMethod(name: "正则_分割")
  List<String> split(String text, RegExp regex);

  /// 取分组
  @QcMethod(name: "正则_取分组")
  List<String> getGroups(String text, RegExp regex, {int groupIndex = 1});
}

/// 正则表达式操作实现类
class QcRegexOperationsImpl implements QcRegexOperations {
  @override
  RegExp? create(String pattern, {bool caseSensitive = true, bool multiLine = false}) {
    try {
      return RegExp(
        pattern,
        caseSensitive: caseSensitive,
        multiLine: multiLine,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  bool match(String text, RegExp regex) {
    return regex.hasMatch(text);
  }

  @override
  List<String> getMatchTexts(String text, RegExp regex) {
    Iterable<Match> matches = regex.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  @override
  String replace(String text, RegExp regex, String replacement) {
    return text.replaceAll(regex, replacement);
  }

  @override
  List<String> split(String text, RegExp regex) {
    return text.split(regex);
  }

  @override
  List<String> getGroups(String text, RegExp regex, {int groupIndex = 1}) {
    List<String> groups = [];
    Iterable<Match> matches = regex.allMatches(text);
    
    for (Match match in matches) {
      if (groupIndex < match.groupCount) {
        String? group = match.group(groupIndex);
        if (group != null) {
          groups.add(group);
        }
      }
    }
    
    return groups;
  }
}
