import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/opencode_http_client.dart';
import '../core/network/opencode_sse_client.dart';
import 'controller.dart';
import 'data/api/health_api.dart';
import 'model.dart';

export 'controller.dart' show serversStorageProvider;

/// controller 主 provider，管理服务器列表与选中状态
final serversControllerProvider =
    NotifierProvider<ServersController, ServersState>(ServersController.new);

/// 服务器列表（只读派生）
final serversProvider = Provider<List<Server>>((ref) {
  return ref.watch(serversControllerProvider).servers;
});

/// 当前选中服务器（只读派生）
final selectedServerProvider = Provider<Server?>((ref) {
  return ref.watch(serversControllerProvider).selectedServer;
});

/// 当前 HTTP 客户端；其他 feature 通过此 provider 获取
///
/// selectedServer 为 null 时返回 null
final httpClientProvider = Provider<OpencodeHttpClient?>((ref) {
  return ref.watch(serversControllerProvider).httpClient;
});

/// 当前 SSE 客户端；selectedServer 为 null 时返回 null
final sseClientProvider = Provider<OpencodeSseClient?>((ref) {
  return ref.watch(serversControllerProvider).sseClient;
});

/// 当前选中服务器的健康状态，定时轮询
///
/// - 选中服务器后立即执行一次健康检查
/// - 之后每 30 秒轮询一次
/// - 切换服务器时旧定时器通过 ref.onDispose 自动销毁，新定时器重新启动
/// - 取消选中时停止定时器并返回 null
final healthStatusProvider =
    NotifierProvider<_HealthStatusNotifier, ServerHealthStatus?>(
  _HealthStatusNotifier.new,
);

class _HealthStatusNotifier extends Notifier<ServerHealthStatus?> {
  @override
  ServerHealthStatus? build() {
    final server = ref.watch(selectedServerProvider);
    final httpClient = ref.watch(httpClientProvider);

    // 无选中服务器时停止轮询
    if (server == null || httpClient == null) return null;

    final api = HealthApi(httpClient);

    // 立即执行一次健康检查
    _runCheck(server.url, api);

    // 每 30 秒轮询；切换服务器时 provider 重建，旧 timer 由 onDispose 取消
    final timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _runCheck(server.url, api),
    );
    ref.onDispose(timer.cancel);

    // 初始状态为 null，等待第一次检查结果写入
    return null;
  }

  /// 执行一次健康检查并更新 state
  Future<void> _runCheck(String serverUrl, HealthApi api) async {
    try {
      final version = await api.check();
      state = ServerHealthStatus(
        serverUrl: serverUrl,
        healthy: true,
        version: version,
        checkedAt: DateTime.now(),
      );
    } catch (e) {
      state = ServerHealthStatus(
        serverUrl: serverUrl,
        healthy: false,
        error: e.toString(),
        checkedAt: DateTime.now(),
      );
    }
  }
}
