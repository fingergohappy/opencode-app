import 'package:opencode_app/core/network/opencode_http_client.dart';

/// 负责 /global/health 健康检查请求，不负责本地保存
///
/// 本质上也是验证 Basic Auth 凭证是否正确：
/// 非 200 响应或网络异常均视为不健康，由调用方捕获异常并转换状态
class HealthApi {
  HealthApi(this._client);

  final OpencodeHttpClient _client;

  /// 检查服务器健康状态
  ///
  /// 成功时返回版本号字符串（来自响应的 version 字段）
  /// 失败时抛出异常，由 healthStatusProvider 转换为不健康状态
  Future<String> check() async {
    final response =
        await _client.get<Map<String, dynamic>>('/global/health');
    final data = response.data;
    if (data == null) throw Exception('健康检查响应体为空');
    final version = data['version'];
    if (version == null) throw Exception('响应缺少 version 字段');
    return version as String;
  }
}
