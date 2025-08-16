import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

/// Android SDK自动安装工具
class AndroidSdkInstaller {
  final String sdkRoot;
  final Function(String message, double progress) onProgress;
  final Function(String log) onLog;
  final String mirrorUrl;
  
  // 需要安装的Android组件
  final List<String> requiredComponents = [
    'platforms;android-33',
    'build-tools;33.0.1',
    'platform-tools',
  ];

  AndroidSdkInstaller({
    required this.sdkRoot,
    required this.onProgress,
    required this.onLog,
    this.mirrorUrl = 'https://mirrors.cloud.tencent.com/AndroidSDK/',
    //https://mirrors.cloud.tencent.com/AndroidSDK/commandlinetools-win-13114758_latest.zip
  });

  /// 检查Android SDK是否已安装
  bool isInstalled() {
    // 检查关键目录和文件是否存在
    final platformToolsDir = path.join(sdkRoot, 'platform-tools');
    final buildToolsDir = path.join(sdkRoot, 'build-tools', '33.0.1');
    final platformsDir = path.join(sdkRoot, 'platforms', 'android-33');
    
    return Directory(platformToolsDir).existsSync() &&
           Directory(buildToolsDir).existsSync() &&
           Directory(platformsDir).existsSync();
  }

  /// 开始安装Android SDK
  Future<void> install() async {
    try {
      // 1. 确保所有必要目录存在（自动创建）
      await _ensureDirectoriesExist();
      
      // 2. 下载并安装Command-line Tools
      await _downloadAndInstallCommandLineTools();
      
      // 3. 配置镜像源
      await _configureMirror();
      
      // 4. 安装所需组件
      await _installComponents();
      
      // 5. 接受所有许可证
      await _acceptLicenses();
      
      onProgress('安装完成', 1.0);
      onLog('Android SDK已成功安装到: $sdkRoot');
    } catch (e) {
      onLog('安装失败: ${e.toString()}');
      rethrow;
    }
  }

  /// 确保所有必要的目录存在，不存在则自动创建
  Future<void> _ensureDirectoriesExist() async {
    onProgress('准备安装目录', 0.1);
    
    // 创建SDK根目录
    final sdkDir = Directory(sdkRoot);
    if (!sdkDir.existsSync()) {
      onLog('创建SDK根目录: ${sdkDir.path}');
      await sdkDir.create(recursive: true);
    }
    
    // 创建cmdline-tools目录（Android要求的特殊结构）
    final cmdToolsDir = path.join(sdkRoot, 'cmdline-tools', 'latest');
    final cmdToolsParentDir = Directory(path.dirname(cmdToolsDir));
    if (!cmdToolsParentDir.existsSync()) {
      onLog('创建cmdline-tools目录: ${cmdToolsParentDir.path}');
      await cmdToolsParentDir.create(recursive: true);
    }
    
    // 创建缓存目录
    final cacheDir = Directory(path.join(sdkRoot, 'cache'));
    if (!cacheDir.existsSync()) {
      await cacheDir.create();
    }
    
    onLog('所有必要目录准备就绪');
  }

  /// 下载并安装Android Command-line Tools
  Future<void> _downloadAndInstallCommandLineTools() async {
    onProgress('下载Command-line Tools', 0.2);
    
    // 确定当前系统对应的工具版本
    String osType;
    if (Platform.isWindows) {
      osType = 'windows';
    } else if (Platform.isMacOS) {
      osType = 'mac';
    } else if (Platform.isLinux) {
      osType = 'linux';
    } else {
      throw UnsupportedError('不支持的操作系统');
    }
    
    // 最新的Command-line Tools版本
    const toolsVersion = '13114758';
    final toolsFileName = 'commandlinetools-win-${toolsVersion}_latest.zip';
    final downloadUrl = '$mirrorUrl$toolsFileName';
    
    // 直接使用目标目录作为解压路径
    final targetDir = Directory(path.join(sdkRoot, 'cmdline-tools', 'latest'));
    
    // 如果目标目录已存在，先删除
    if (await targetDir.exists()) {
      await targetDir.delete(recursive: true);
    }
    
    // 确保目标目录的父目录存在
    await targetDir.parent.create(recursive: true);
    
    // 下载文件到临时位置
    final tempFile = File(path.join(Directory.systemTemp.path, toolsFileName));
    
    try {
      // 下载工具
      onLog('开始下载: $downloadUrl');
      await _downloadFile(
        url: downloadUrl,
        savePath: tempFile.path,
        progressCallback: (progress) {
          onProgress('下载Command-line Tools', 0.2 + progress * 0.3);
        },
      );
      
      // 解压文件到目标目录
      onProgress('解压Command-line Tools', 0.5);
      onLog('直接解压到目标目录: ${targetDir.path}');
      
      final bytes = await tempFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      
      // 解压所有文件
      for (final file in archive) {
        // 移除可能的顶层目录
        final fileName = path.join(targetDir.path, file.name.split('/').skip(1).join('/'));
        if (file.isFile) {
          final data = file.content as List<int>;
          final outputFile = File(fileName);
          await outputFile.parent.create(recursive: true);
          await outputFile.writeAsBytes(data);
        } else {
          await Directory(fileName).create(recursive: true);
        }
      }
      
      onLog('Command-line Tools已安装到: ${targetDir.path}');
    } finally {
      await tempFile.exists();//退出不清理

      // 清理临时文件
      // if (await tempFile.exists()) {
      //   try {
      //     await tempFile.delete();
      //   } catch (e) {
      //     onLog('清理临时文件失败: ${e.toString()}');
      //   }
      // }
    }
  }

  /// 配置国内镜像源
  Future<void> _configureMirror() async {
    onProgress('配置镜像源', 0.6);
    
    // 创建repositories.cfg文件配置镜像
    final androidDir = path.join(Platform.environment['HOME'] ?? '', '.android');
    final reposConfigFile = File(path.join(androidDir, 'repositories.cfg'));
    
    // 确保目录存在
    if (!await Directory(androidDir).exists()) {
      await Directory(androidDir).create(recursive: true);
    }
    
    // 写入镜像配置
    await reposConfigFile.writeAsString('''
### 自动配置的Android镜像源
mirrorUrl=$mirrorUrl
''');
    
    onLog('已配置镜像源: $mirrorUrl');
  }

  /// 安装所需的Android组件
  Future<void> _installComponents() async {
    onProgress('安装Android组件', 0.7);
    
    // 获取sdkmanager路径
    final sdkManagerPath = Platform.isWindows 
        ? path.join(sdkRoot, 'cmdline-tools', 'latest', 'bin', 'sdkmanager.bat')
        : path.join(sdkRoot, 'cmdline-tools', 'latest', 'bin', 'sdkmanager');
    
    // 检查sdkmanager是否存在
    if (!await File(sdkManagerPath).exists()) {
      throw FileSystemException('未找到sdkmanager', sdkManagerPath);
    }
    
    // 为macOS/Linux添加可执行权限
    if (!Platform.isWindows) {
      await Process.run('chmod', ['+x', sdkManagerPath]);
    }
    
    // 安装组件
    onLog('开始安装组件: ${requiredComponents.join(', ')}');
    
    final process = await Process.start(
      sdkManagerPath,
      requiredComponents,
      environment: {
        ...Platform.environment,
        'ANDROID_HOME': sdkRoot,
      },
    );
    
    // 监听输出
    process.stdout.transform(utf8.decoder).listen((data) {
      onLog('sdkmanager: $data');
    });
    
    process.stderr.transform(utf8.decoder).listen((data) {
      onLog('sdkmanager错误: $data');
    });
    
    // 等待安装完成
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw Exception('组件安装失败，退出代码: $exitCode');
    }
    
    onProgress('Android组件安装完成', 0.9);
    onLog('所有必要组件已安装');
  }

  /// 自动接受所有许可证
  Future<void> _acceptLicenses() async {
    onProgress('处理许可证', 0.95);
    
    // 获取sdkmanager路径
    final sdkManagerPath = Platform.isWindows 
        ? path.join(sdkRoot, 'cmdline-tools', 'latest', 'bin', 'sdkmanager.bat')
        : path.join(sdkRoot, 'cmdline-tools', 'latest', 'bin', 'sdkmanager');
    
    // 执行接受许可证命令
    final process = await Process.start(
      sdkManagerPath,
      ['--licenses'],
      environment: {
        ...Platform.environment,
        'ANDROID_HOME': sdkRoot,
      },
    );
    
    // 自动输入'y'接受所有许可证
    process.stdin.writeln('y\n' * 20); // 发送足够多的'y'来接受所有许可证
    
    // 监听输出
    process.stdout.transform(utf8.decoder).listen((data) {
      onLog('许可证处理: $data');
    });
    
    // 等待完成
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      onLog('警告: 许可证处理可能未完全完成，但将继续安装流程');
    } else {
      onLog('所有许可证已接受');
    }
  }

  /// 下载文件并提供进度反馈 - 修复了StreamSink问题
  Future<void> _downloadFile({
    required String url,
    required String savePath,
    required Function(double progress) progressCallback,
  }) async {
    final client = http.Client();
    late http.Request request;
    late http.StreamedResponse response;
    late File file;
    late IOSink sink;
    bool isSinkClosed = false;
    
    try {
      request = http.Request('GET', Uri.parse(url));
      response = await client.send(request);
      
      final contentLength = response.contentLength;
      file = File(savePath);
      
      // 确保目录存在
      await file.parent.create(recursive: true);
      
      sink = file.openWrite();
      int downloaded = 0;
      
      // 监听数据事件
      final subscription = response.stream.listen(
        (chunk) {
          if (!isSinkClosed) {
            downloaded += chunk.length;
            if (contentLength != null) {
              final progress = downloaded / contentLength;
              progressCallback(progress);
            }
            sink.add(chunk);
          }
        },
        onDone: () async {
          if (!isSinkClosed) {
            isSinkClosed = true;
            await sink.flush();
            await sink.close();
          }
        },
        onError: (e) async {
          if (!isSinkClosed) {
            isSinkClosed = true;
            await sink.flush();
            await sink.close();
            onLog('下载错误: $e');
          }
        },
        cancelOnError: true,
      );
      
      // 等待下载完成
      await subscription.asFuture();
      
      // 验证文件大小
      if (contentLength != null) {
        final fileStat = await file.stat();
        if (fileStat.size != contentLength) {
          throw Exception('下载文件不完整，预期大小: $contentLength, 实际大小: ${fileStat.size}');
        }
      }
    } catch (e) {
      // 出现错误时确保资源被释放
      if (!isSinkClosed) {
        isSinkClosed = true;
        try {
          await sink.flush();
          await sink.close();
        } catch (_) {}
      }
      
      // 删除不完整的文件
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (_) {}
      }
      
      onLog('下载失败: $e');
      rethrow;
    } finally {
      client.close();
    }
  }

  /// 获取配置好的环境变量
  Map<String, String> getEnvironmentVariables() {
    final env = Map<String, String>.from(Platform.environment);
    env['ANDROID_HOME'] = sdkRoot;
    
    // 添加platform-tools到PATH
    final platformToolsPath = path.join(sdkRoot, 'platform-tools');
    env['PATH'] = '${env['PATH']}${Platform.pathSeparator}$platformToolsPath';
    
    return env;
  }
}
