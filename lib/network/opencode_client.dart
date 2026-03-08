import 'dart:convert';
import 'package:dio/dio.dart';

import '../utils/app_logger.dart';

class OpenCodeClient {
  final String baseUrl;
  final Dio _dio;

  static const _logger = AppLogger('OpenCodeClient');

  OpenCodeClient(String url)
    : baseUrl = url.replaceAll(RegExp(r'/$'), ''),
      _dio = Dio(BaseOptions(baseUrl: url.replaceAll(RegExp(r'/$'), '')));

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic)? fromJson,
  }) async {
    final normalizedPath = _normalizePath(path);
    final requestUrl = _describeRequestUrl(normalizedPath, query);
    _logger.info('GET $requestUrl');
    final response = await _dio.get<dynamic>(
      normalizedPath,
      queryParameters: query,
      options: Options(validateStatus: (_) => true),
    );
    _logger.info('Response status: ${response.statusCode}');
    _ensureSuccess('GET', path, response.statusCode, response.data);
    final data = _decodeJsonData(response.data);
    _logger.info('Response data type: ${data.runtimeType}');
    return fromJson != null ? fromJson(data) : data as T;
  }

  Future<T> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    T Function(dynamic)? fromJson,
  }) async {
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

  Future<bool> submit(
    String method,
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
  }) async {
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

  String _normalizePath(String path) {
    return path.replaceAll(RegExp(r'^/'), '');
  }

  String _describeRequestUrl(String path, Map<String, dynamic>? query) {
    return Uri.parse('$baseUrl/$path')
        .replace(queryParameters: query?.map((k, v) => MapEntry(k, '$v')))
        .toString();
  }

  dynamic _decodeJsonData(dynamic data) {
    if (data is String) {
      return jsonDecode(data);
    }
    return data;
  }

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
