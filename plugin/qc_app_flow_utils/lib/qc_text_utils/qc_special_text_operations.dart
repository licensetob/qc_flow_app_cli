import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'qc_annotations.dart';

/// 特殊文本处理操作抽象接口
abstract class QcSpecialTextOperations {
  /// JSON解析
  @QcMethod(name: "JSON_解析")
  dynamic jsonParse(String jsonText);

  /// JSON生成
  @QcMethod(name: "JSON_生成")
  String jsonGenerate(dynamic data, {bool pretty = false});

  /// XML取节点值
  @QcMethod(name: "XML_取节点值")
  String xmlGetNodeValue(String xmlText, String nodeName);

  /// 文本加密MD5
  @QcMethod(name: "文本_加密_MD5")
  String encryptMd5(String text, {bool upperCase = false});

  /// 文本加密SHA1
  @QcMethod(name: "文本_加密_SHA1")
  String encryptSha1(String text, {bool upperCase = false});

  /// 文本异或加密
  @QcMethod(name: "文本_异或加密")
  String xorEncrypt(String text, String key);

  /// 生成随机字符串
  @QcMethod(name: "文本_生成随机字符串")
  String generateRandomString(int length, {String? charSet});
}

/// 特殊文本处理操作实现类
class QcSpecialTextOperationsImpl implements QcSpecialTextOperations {
  @override
  dynamic jsonParse(String jsonText) {
    try {
      return json.decode(jsonText);
    } catch (e) {
      return null;
    }
  }

  @override
  String jsonGenerate(dynamic data, {bool pretty = false}) {
    try {
      if (pretty) {
        return JsonEncoder.withIndent('  ').convert(data);
      } else {
        return json.encode(data);
      }
    } catch (e) {
      return "";
    }
  }

  @override
  String xmlGetNodeValue(String xmlText, String nodeName) {
    // 简单实现，实际使用中建议使用xml库
    RegExp regExp = RegExp(
      '<$nodeName[^>]*>(.*?)</$nodeName>',
      dotAll: true,
      caseSensitive: false,
    );
    
    Match? match = regExp.firstMatch(xmlText);
    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? "";
    }
    
    return "";
  }

  @override
  String encryptMd5(String text, {bool upperCase = false}) {
    Digest digest = md5.convert(utf8.encode(text));
    String result = digest.toString();
    return upperCase ? result.toUpperCase() : result;
  }

  @override
  String encryptSha1(String text, {bool upperCase = false}) {
    Digest digest = sha1.convert(utf8.encode(text));
    String result = digest.toString();
    return upperCase ? result.toUpperCase() : result;
  }

  @override
  String xorEncrypt(String text, String key) {
    if (key.isEmpty) return text;
    
    List<int> textBytes = utf8.encode(text);
    List<int> keyBytes = utf8.encode(key);
    List<int> resultBytes = [];
    
    for (int i = 0; i < textBytes.length; i++) {
      resultBytes.add(textBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return base64.encode(resultBytes);
  }

  @override
  String generateRandomString(int length, {String? charSet}) {
    if (length <= 0) return "";
    
    String defaultCharSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    String chars = charSet ?? defaultCharSet;
    
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      int randomIndex = DateTime.now().microsecond % chars.length;
      buffer.write(chars[randomIndex]);
      // 稍微延迟一下以确保随机性
      Future.delayed(Duration(microseconds: 1));
    }
    
    return buffer.toString();
  }
}
