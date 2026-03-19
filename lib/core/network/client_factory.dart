import 'package:dio/dio.dart';

import 'auth_header.dart';
import 'network_config.dart';
import 'opencode_http_client.dart';
import 'opencode_sse_client.dart';

/// 常规 HTTP 请求客户端，使用配置中的超时
OpencodeHttpClient createHttpClient(NetworkConfig config) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: buildHeaders(config),
    ),
  );
  return OpencodeHttpClient(dio);
}

/// SSE 长连接客户端，receiveTimeout 置零避免连接被截断
OpencodeSseClient createSseClient(NetworkConfig config) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: Duration.zero,
      sendTimeout: config.sendTimeout,
      headers: buildHeaders(config),
    ),
  );
  return OpencodeSseClient(dio);
}
