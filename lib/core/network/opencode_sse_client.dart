import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:simple_sse/simple_sse.dart';

class OpencodeSseClient {
  OpencodeSseClient(this._dio);

  final Dio _dio;

  Stream<SseEvent> connect(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async* {
    final requestCancelToken = cancelToken ?? CancelToken();

    try {
      final response = await _dio.get<ResponseBody>(
        path,
        queryParameters: queryParameters,
        cancelToken: requestCancelToken,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
            if (headers != null) ...headers,
          },
        ),
      );

      final responseBody = response.data;
      if (responseBody == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'SSE response body is empty.',
        );
      }

      yield* responseBody.stream
          .map((chunk) => chunk as List<int>)
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .transform(const SseEventTransformer());
    } finally {
      if (cancelToken == null && !requestCancelToken.isCancelled) {
        requestCancelToken.cancel('SSE stream closed');
      }
    }
  }
}
