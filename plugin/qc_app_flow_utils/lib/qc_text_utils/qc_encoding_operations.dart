import 'dart:convert';
import 'qc_annotations.dart';

/// 编码转换与处理操作抽象接口
abstract class QcEncodingOperations {
  /// UTF8到GBK (注意：Dart原生不直接支持GBK，实际使用可能需要第三方库)
  @QcMethod(name: "编码_UTF8到GBK")
  List<int> utf8ToGbk(String text);

  /// GBK到UTF8 (注意：Dart原生不直接支持GBK，实际使用可能需要第三方库)
  @QcMethod(name: "编码_GBK到UTF8")
  String gbkToUtf8(List<int> gbkBytes);

  /// Base64编码
  @QcMethod(name: "编码_BASE64编码")
  String base64Encode(String text, {bool urlSafe = false});

  /// Base64解码
  @QcMethod(name: "编码_BASE64解码")
  String base64Decode(String base64Str, {bool urlSafe = false});

  /// URL编码
  @QcMethod(name: "编码_URL编码")
  String urlEncode(String text);

  /// URL解码
  @QcMethod(name: "编码_URL解码")
  String urlDecode(String encodedText);

  /// Unicode编码
  @QcMethod(name: "编码_Unicode编码")
  String unicodeEncode(String text);

  /// Unicode解码
  @QcMethod(name: "编码_Unicode解码")
  String unicodeDecode(String unicodeStr);

  /// HTML编码
  @QcMethod(name: "编码_HTML编码")
  String htmlEncode(String text);

  /// HTML解码
  @QcMethod(name: "编码_HTML解码")
  String htmlDecode(String htmlStr);
}

/// 编码转换与处理操作实现类
class QcEncodingOperationsImpl implements QcEncodingOperations {
  @override
  List<int> utf8ToGbk(String text) {
    // Dart原生不直接支持GBK编码，这里返回UTF8字节作为替代
    // 实际使用中建议使用第三方库如"charset_converter"
    return utf8.encode(text);
  }

  @override
  String gbkToUtf8(List<int> gbkBytes) {
    // Dart原生不直接支持GBK编码，这里假设输入是UTF8字节
    // 实际使用中建议使用第三方库如"charset_converter"
    return utf8.decode(gbkBytes, allowMalformed: true);
  }

  @override
  String base64Encode(String text, {bool urlSafe = false}) {
    List<int> bytes = utf8.encode(text);
    String encoded = base64.encode(bytes);
    
    if (urlSafe) {
      return encoded.replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');
    }
    
    return encoded;
  }

  @override
  String base64Decode(String base64Str, {bool urlSafe = false}) {
    String processed = base64Str;
    
    if (urlSafe) {
      processed = processed.replaceAll('-', '+').replaceAll('_', '/');
      // 补充缺失的填充字符
      int paddingLength = 4 - (processed.length % 4);
      if (paddingLength < 4) {
        processed += '=' * paddingLength;
      }
    }
    
    try {
      List<int> bytes = base64.decode(processed);
      return utf8.decode(bytes);
    } catch (e) {
      return "";
    }
  }

  @override
  String urlEncode(String text) {
    return Uri.encodeComponent(text);
  }

  @override
  String urlDecode(String encodedText) {
    return Uri.decodeComponent(encodedText);
  }

  @override
  String unicodeEncode(String text) {
    StringBuffer buffer = StringBuffer();
    for (int rune in text.runes) {
      buffer.write('\\u${rune.toRadixString(16).padLeft(4, '0')}');
    }
    return buffer.toString();
  }

  @override
  String unicodeDecode(String unicodeStr) {
    return unicodeStr.replaceAllMapped(
      RegExp(r'\\u([0-9a-fA-F]{4})'),
      (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
    );
  }

  @override
  String htmlEncode(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  @override
  String htmlDecode(String htmlStr) {
    return htmlStr
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
  }
}
