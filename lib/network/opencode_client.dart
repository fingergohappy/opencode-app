import 'dart:convert';
import 'package:dio/dio.dart';

import '../utils/app_logger.dart';

/// 对 Dio 的轻量封装。
/// 这一层统一处理路径规范化、状态码校验、JSON 解码和日志输出。
class OpenCodeClient {
  final String baseUrl;
  final Dio _dio;

  static const _logger = AppLogger('OpenCodeClient');

  OpenCodeClient(String url)
    : baseUrl = url.replaceAll(RegExp(r'/$'), ''),
      _dio = Dio(BaseOptions(baseUrl: url.replaceAll(RegExp(r'/$'), '')));

  /// 通用 GET：如果传了 fromJson，就把响应结果转换成目标模型。
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic)? fromJson,
  }) async {
    // baseUrl 已经保存好了域名部分，这里只保留相对路径。
    final normalizedPath = _normalizePath(path);
    final requestUrl = _describeRequestUrl(normalizedPath, query);
    _logger.info('GET $requestUrl');
    final response = await _dio.get<dynamic>(
      normalizedPath,
      queryParameters: query,
      // 先拿到原始响应，再由 _ensureSuccess 统一决定是否抛错，避免每种请求各写一套判断。
      options: Options(validateStatus: (_) => true),
    );
    _logger.info('Response status: ${response.statusCode}');
    _ensureSuccess('GET', path, response.statusCode, response.data);
    final data = _decodeJsonData(response.data);
    _logger.info('Response data type: ${data.runtimeType}');
    return fromJson != null ? fromJson(data) : data as T;
  }

  /// POST / PATCH 的结构和 GET 类似，只是额外带上请求体。
  Future<T> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    T Function(dynamic)? fromJson,
  }) async {
    // POST/PATCH 都沿用同一套“请求 -> 校验 -> 解码 -> 转模型”流水线。
    final response = await _dio.post<dynamic>(
      _normalizePath(path),
      queryParameters: query,
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        validateStatus: (_) => true,
      ),
    );
    _ensureSuccess('POST', path, response.statusCode, response.data);
    final data = _decodeJsonData(response.data);
    return fromJson != null ? fromJson(data) : data as T;
  }

  Future<T> patch<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    T Function(dynamic)? fromJson,
  }) async {
    final response = await _dio.patch<dynamic>(
      _normalizePath(path),
      queryParameters: query,
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        validateStatus: (_) => true,
      ),
    );
    _ensureSuccess('PATCH', path, response.statusCode, response.data);
    final data = _decodeJsonData(response.data);
    return fromJson != null ? fromJson(data) : data as T;
  }

  /// 只关心是否成功、不关心响应体时，用 submit 可以少写一层解析。
  Future<bool> submit(
    String method,
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
  }) async {
    // submit 适合“只关心成功失败”的动作接口，调用方不用再声明 fromJson。
    final response = await _dio.request<dynamic>(
      _normalizePath(path),
      data: body,
      queryParameters: query,
      options: Options(
        method: method,
        contentType: Headers.jsonContentType,
        validateStatus: (_) => true,
      ),
    );
    final statusCode = response.statusCode ?? 0;
    return statusCode >= 200 && statusCode < 300;
  }

  /// 某些接口返回的是纯文本，所以保留一个单独的 getText 入口。
  Future<String> getText(String path, {Map<String, dynamic>? query}) async {
    final response = await _dio.get<String>(
      _normalizePath(path),
      queryParameters: query,
      options: Options(
        responseType: ResponseType.plain,
        validateStatus: (_) => true,
      ),
    );
    _ensureSuccess('GET', path, response.statusCode, response.data);
    return response.data ?? '';
  }

  /// 统一去掉开头的 /，避免和 baseUrl 拼接后出现双斜杠。
  String _normalizePath(String path) {
    return path.replaceAll(RegExp(r'^/'), '');
  }

  /// 仅用于日志，方便调试时看到完整请求地址。
  String _describeRequestUrl(String path, Map<String, dynamic>? query) {
    return Uri.parse('$baseUrl/$path')
        .replace(queryParameters: query?.map((k, v) => MapEntry(k, '$v')))
        .toString();
  }

  /// Dio 可能返回 String，也可能已经完成 JSON 解码，这里统一兼容两种情况。
  dynamic _decodeJsonData(dynamic data) {
    if (data is String) {
      // 后端有时返回 JSON 字符串，有时 Dio 已经帮我们解成 Map/List，这里做兼容层。
      return jsonDecode(data);
    }
    return data;
  }

  /// 把“非 2xx 就视为失败”的规则集中起来，避免散落在调用方里。
  void _ensureSuccess(
    String method,
    String path,
    int? statusCode,
    dynamic data,
  ) {
    final code = statusCode ?? 0;
    if (code >= 200 && code < 300) {
      return;
    }
    _logger.error('Error response: $data');
    throw Exception('Failed to $method $path: $code');
  }
}
