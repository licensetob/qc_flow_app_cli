// 文件名称：http_service.dart
// 文件描述：网络请求服务类，基于Dio库实现的HTTP请求管理。
// 提供GET、POST等请求方法，并支持请求缓存、错误处理和超时管理。
// 采用单例模式设计，确保全局只有一个实例。
// 作   者：license
// 创建日期：2025-08-16
// 版本号：1.0

// 修改导入部分，确保正确导入MemoryCacheStore
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/logger.dart';

class HttpService {
  // 保存单例实例的静态变量
  static HttpService? _instance;
  
  // 工厂构造函数
  factory HttpService() {
    _instance ??= HttpService._internal();
    return _instance!;
  }

  late Dio _dio;
  late CacheStore _cacheStore;
  
  // 内部构造函数 - 只是创建实例，不进行异步初始化
  HttpService._internal();

  // 公共的异步初始化方法
  Future<void> init() async {
    // 初始化缓存存储
    await _initCacheStore();
    
    // 初始化Dio
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.d('Request: ${options.path}');
          // 可以在这里添加token等认证信息
          return handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.d('Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          Logger.e('Error: ${e.message}');
          // 处理网络错误，显示全局错误页面
          _handleNetworkError(e);
          return handler.next(e);
        },
      ),
    );

    // 添加缓存拦截器
    _dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: _cacheStore,
          policy: CachePolicy.request,
          hitCacheOnErrorExcept: [401, 403],
          maxStale: const Duration(days: 7),
          priority: CachePriority.normal,
          keyBuilder: CacheOptions.defaultCacheKeyBuilder,
          allowPostMethod: true,
        ),
      ),
    );
  }

  // 初始化缓存存储
  Future<void> _initCacheStore() async {
    try {
      final dir = await getTemporaryDirectory();
      _cacheStore = HiveCacheStore(dir.path);
    } catch (e) {
      Logger.e('Failed to initialize cache store: $e');
      _cacheStore = MemCacheStore();
    }
  }

  // 处理网络错误
  // 处理网络错误
  void _handleNetworkError(DioException error) {
    // 这里可以根据错误类型显示不同的错误页面
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        debugPrint('连接超时');
        break;
      case DioExceptionType.badResponse:
        debugPrint('服务器错误: ${error.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        debugPrint('请求取消');
        break;
      case DioExceptionType.unknown:
        debugPrint('网络连接失败');
        break;
      default:
        debugPrint('未知错误');
    }
     //不暴露缺省页
    // 移除全局错误页面弹窗，让异常正常抛出，由页面自身处理错误状态
    // if (!Get.isDialogOpen!) {
    //   Get.dialog(
    //     NetworkErrorWidget(message: errorMessage, isGlobal: true),
    //     barrierDismissible: false,
    //   );
    // }
  }

  // GET请求
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showErrorPage = true,
  }) async {
    try {
      final response = await _dio.get(
        path, 
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      if (showErrorPage) {
        _handleNetworkError(e);
      }
      throw HttpException(e);
    }
  }

  // POST请求
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool showErrorPage = true,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (showErrorPage) {
        _handleNetworkError(e);
      }
      throw HttpException(e);
    }
  }
}

// 自定义异常
class HttpException implements Exception {
  final DioException dioError;
  HttpException(this.dioError);

  @override
  String toString() => 'HttpException: ${dioError.message}';
}

// 在HttpService类中添加一个公共的初始化方法
// 初始化HTTP服务（包括缓存存储）
