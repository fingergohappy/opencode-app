import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenCodeClient {
  final String baseUrl;

  OpenCodeClient(String url) : baseUrl = url.replaceAll(RegExp(r'/$'), '');

  Future<T> get<T>(String path, {Map<String, dynamic>? query, T Function(dynamic)? fromJson}) async {
    final uri = _buildUri(path, query);
    print('[OpenCodeClient] GET $uri');
    final response = await http.get(uri);
    print('[OpenCodeClient] Response status: ${response.statusCode}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      print('[OpenCodeClient] Response data type: ${data.runtimeType}');
      return fromJson != null ? fromJson(data) : data as T;
    }
    print('[OpenCodeClient] Error response: ${response.body}');
    throw Exception('Failed to GET $path: ${response.statusCode}');
  }

  Future<T> post<T>(String path, {dynamic body, Map<String, dynamic>? query, T Function(dynamic)? fromJson}) async {
    final uri = _buildUri(path, query);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return fromJson != null ? fromJson(data) : data as T;
    }
    throw Exception('Failed to POST $path: ${response.statusCode}');
  }

  Future<T> patch<T>(String path, {dynamic body, Map<String, dynamic>? query, T Function(dynamic)? fromJson}) async {
    final uri = _buildUri(path, query);
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return fromJson != null ? fromJson(data) : data as T;
    }
    throw Exception('Failed to PATCH $path: ${response.statusCode}');
  }

  Future<bool> submit(String method, String path, {dynamic body, Map<String, dynamic>? query}) async {
    final uri = _buildUri(path, query);
    final request = http.Request(method, uri);
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }
    final response = await request.send();
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  Future<String> getText(String path, {Map<String, dynamic>? query}) async {
    final uri = _buildUri(path, query);
    final response = await http.get(uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    }
    throw Exception('Failed to GET text $path: ${response.statusCode}');
  }

  Uri _buildUri(String path, Map<String, dynamic>? query) {
    final normalizedPath = path.replaceAll(RegExp(r'^/'), '');
    final url = '$baseUrl/$normalizedPath';
    return Uri.parse(url).replace(queryParameters: query?.map((k, v) => MapEntry(k, v.toString())));
  }
}
