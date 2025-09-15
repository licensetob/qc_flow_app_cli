
# Qc_App_Flow Flutter 通用项目框架

## 🎯 项目概述

Qc_App_Flow 是一个功能完备、架构清晰的 Flutter 通用项目框架，旨在为开发者提供一套标准化、可复用的应用开发解决方案。该框架集成了现代 Flutter 开发的最佳实践，帮助开发者快速构建高性能、高质量的跨平台应用。

## ✨ 核心功能特性

### 🎨 **主题管理系统**
- 完善的亮色/暗色主题支持
- 主题状态持久化存储
- 一键切换主题模式
- 主题跟随系统设置
- 统一的颜色和样式管理

### 🚀 **路由管理**
- 基于 GetX 的高性能路由系统
- 声明式路由配置
- 页面与控制器的自动绑定
- 路由导航拦截器支持
- 命名路由统一管理

### 💾 **本地存储**
- 基于 Hive 的高效键值存储
- 数据加密支持
- 应用设置与用户数据分离存储
- 单例模式设计，全局唯一访问点

### 🌐 **网络请求**
- 基于 Dio 的网络请求封装
- 统一的请求/响应拦截器
- 请求重试机制
- 网络状态监听
- 网络错误处理与UI反馈

### 🌍 **国际化支持**
- 多语言资源管理
- 自动语言检测
- 运行时语言切换
- 支持RTL布局

### 🛡️ **异常处理**
- 全局异常捕获
- 崩溃日志记录
- 优雅的错误页面展示
- 网络错误重试机制

### 📐 **项目架构**
- 模块化设计，代码结构清晰
- 关注点分离原则
- 依赖注入机制
- 响应式状态管理

### 📦 **自定义插件**
- qc_app_flow_network: 网络请求插件
- qc_app_flow_utils: 通用工具插件
- qc_app_flow_base_animatablewidget: 动画组件插件

## 📁 项目结构

```
├── lib/
│   ├── core/                # 核心功能模块
│   │   ├── base/            # 基础类和接口
│   │   ├── config/          # 配置文件
│   │   ├── i18n/            # 国际化资源
│   │   ├── storage/         # 本地存储
│   │   ├── theme/           # 主题管理
│   │   └── utils/           # 工具类
│   ├── init/                # 应用初始化
│   ├── main.dart            # 应用入口
│   ├── modules/             # 业务模块
│   ├── pages/               # 独立页面
│   ├── routes/              # 路由配置
│   └── widgets/             # 通用组件
├── assets/                  # 静态资源
│   └── images/              # 图片资源
├── plugin/                  # 自定义插件
│   ├── qc_app_flow_network/     # 网络请求插件
│   ├── qc_app_flow_utils/       # 工具插件
│   └── qc_app_flow_base_animatablewidget/ # 动画组件插件
```

## 🚀 快速开始

### 环境要求
- Flutter 3.0+ 
- Dart 3.0+ 
- Android Studio / VS Code

### 安装步骤

```bash
# 克隆项目
git clone https://your-repository/qc_app_flow.git

# 进入项目目录
cd qc_app_flow

# 安装依赖
flutter pub get

# 运行项目 (默认调试模式)
flutter run

# 构建发布版本
flutter build appbundle  # Android
flutter build ipa        # iOS
```

## 🔧 核心模块详解

### 1. 主题管理 (ThemeController)

主题控制器提供了完整的主题切换和持久化功能，支持亮色、暗色和跟随系统三种模式。

```dart
// 切换主题
themeController.toggleTheme();

// 获取当前主题颜色
Color primaryColor = themeController.primaryColor;
```

### 2. 路由管理

路由系统采用 GetX 实现，支持声明式路由配置和页面控制器自动绑定。

```dart
// 页面跳转
Get.toNamed(AppRoutes.detail);

// 带参数跳转
Get.toNamed(AppRoutes.detail, arguments: {'id': '123'});

// 返回上一页
Get.back();
```

### 3. 本地存储 (HiveService)

基于 Hive 的存储服务提供了高效的数据读写功能，适用于应用设置和用户数据存储。

```dart
// 保存数据
await HiveService().setValue(HiveService.appBoxName, 'key', 'value');

// 读取数据
String value = HiveService().getValue(HiveService.appBoxName, 'key', defaultValue: 'default');
```

### 4. 网络请求

项目集成了自定义网络插件，提供统一的网络请求接口和错误处理机制。

### 5. 应用初始化流程

应用启动时通过 `AppInitializer` 进行全局配置初始化，包括主题、存储、网络等服务的初始化。

## 📝 开发指南

### 页面开发

创建新页面时，建议遵循以下结构：

1. 在 `modules` 目录下创建业务模块
2. 为每个页面创建对应的控制器
3. 在 `routes/app_routes.dart` 中注册路由
4. 在 `routes/routes_config.dart` 中配置页面和控制器的绑定

### 主题定制

如需自定义主题颜色和样式，可修改 `core/theme/themes.dart` 文件中的主题定义。

### 国际化开发

添加新语言支持：

1. 在 `core/i18n` 目录下创建语言资源文件
2. 在 `TranslationService` 中注册新语言

## 📊 技术栈

| 技术/依赖           | 用途                     | 版本要求     |
|-------------------|--------------------------|------------|
| Flutter           | 跨平台UI框架              | >=3.0.0    |
| GetX              | 状态管理、路由、依赖注入    | 最新版      |
| Hive              | 本地存储                  | 最新版      |
| Dio               | 网络请求                  | 最新版      |
| flutter_screenutil | 屏幕适配                  | 最新版      |
| bot_toast         | 全局弹窗                  | 最新版      |

## 🤝 贡献指南

我们欢迎社区贡献，如果您有任何建议或发现问题，请提交 Issue 或 Pull Request。

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 📞 联系我们

如有任何问题或建议，请联系项目维护者。

---

Qc_App_Flow - 让 Flutter 开发更高效、更优雅！ 💪✨
        