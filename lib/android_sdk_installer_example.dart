import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'android_sdk_installer.dart';

class AndroidSdkInstallerExample extends StatefulWidget {
  const AndroidSdkInstallerExample({super.key});

  @override
  State<AndroidSdkInstallerExample> createState() => _AndroidSdkInstallerExampleState();
}

class _AndroidSdkInstallerExampleState extends State<AndroidSdkInstallerExample> {
  String _status = '准备安装Android SDK';
  double _progress = 0.0;
  final List<String> _logs = [];
  AndroidSdkInstaller? _installer;

  // SDK安装路径 (可以根据实际情况修改)
  final String _sdkRoot = path.join(
    Platform.environment['HOME'] ?? '',
    'E:\\SoftWare\\code\\Fluttercode\\qc_app_flow\\',
    'sdk',
    'android'
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Android SDK 自动安装'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('安装路径: $_sdkRoot'),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 8),
            Text('状态: $_status'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _installer == null ? _startInstallation : null,
              child: const Text('开始安装'),
            ),
            const SizedBox(height: 16),
            const Text('安装日志:'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _logs.map((log) => Text(log)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startInstallation() {
    setState(() {
      _logs.clear();
      _status = '开始初始化安装器';
    });

    _installer = AndroidSdkInstaller(
      sdkRoot: _sdkRoot,
      onProgress: (message, progress) {
        setState(() {
          _status = message;
          _progress = progress;
        });
      },
      onLog: (log) {
        setState(() {
          _logs.add(log);
          // 只保留最近的100条日志
          if (_logs.length > 100) {
            _logs.removeAt(0);
          }
        });
      },
      // 可以指定其他镜像源
      // mirrorUrl: 'https://mirrors.aliyun.com/android/repository/',
    );

    // 检查是否已安装
    if (_installer!.isInstalled()) {
      setState(() {
        _status = 'Android SDK已安装';
        _progress = 1.0;
      });
      return;
    }

    // 开始安装
    _installer!.install().then((_) {
      setState(() {
        _status = '安装完成';
        _installer = null;
      });
    }).catchError((error) {
      setState(() {
        _status = '安装失败: ${error.toString()}';
        _installer = null;
      });
    });
  }
}
