import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_settings/providers.dart' show sharedPreferencesProvider;
import '../core/network/client_factory.dart';
import '../core/network/network_config.dart';
import '../core/network/opencode_http_client.dart';
import '../core/network/opencode_sse_client.dart';
import 'data/storage/servers_storage.dart';
import 'model.dart';

/// ServersStorage 的 provider，供 controller 和外部测试注入
final serversStorageProvider = Provider<ServersStorage>((ref) {
  return ServersStorage(ref.watch(sharedPreferencesProvider));
});

/// servers feature 的核心业务逻辑
///
/// 管理服务器列表增删改、默认服务器、选中服务器及对应 client
/// 不负责健康检测定时器，定时器由 healthStatusProvider 管理
class ServersController extends Notifier<ServersState> {
  late final ServersStorage _storage;

  @override
  ServersState build() {
    _storage = ref.read(serversStorageProvider);

    var servers = _storage.loadServers();

    // 若存在多个 default，按列表顺序保留第一个并纠正持久化
    final defaultCount = servers.where((s) => s.isDefault).length;
    if (defaultCount > 1) {
      var kept = false;
      servers = servers.map((s) {
        if (s.isDefault && !kept) {
          kept = true;
          return s;
        }
        return s.copyWith(isDefault: false);
      }).toList();
      // 异步持久化纠正结果，不阻塞 build
      _storage.saveServers(servers);
    }

    // 启动时自动选中默认服务器
    final defaultServer = servers.where((s) => s.isDefault).firstOrNull;
    if (defaultServer == null) {
      return ServersState(servers: servers);
    }

    final (http, sse) = _buildClients(defaultServer);
    return ServersState(
      servers: servers,
      selectedServer: defaultServer,
      httpClient: http,
      sseClient: sse,
    );
  }

  // ── 公开方法 ──────────────────────────────────────────────────────────────

  /// 新增服务器并持久化
  ///
  /// url 为空抛 [ArgumentError]；url 已存在抛 [StateError]
  /// 若新项为 default 且当前无选中，自动选中并创建 client
  Future<void> addServer(Server server) async {
    final url = _normalizeUrl(server.url);
    if (url.isEmpty) throw ArgumentError('url 不能为空');

    final servers = state.servers;
    if (servers.any((s) => _normalizeUrl(s.url) == url)) {
      throw StateError('已存在相同 url 的服务器：$url');
    }

    final normalized = server.copyWith(url: url);

    List<Server> updated;
    if (normalized.isDefault) {
      // 清除旧 default，再插入新项
      updated = [
        ...servers.map((s) => s.copyWith(isDefault: false)),
        normalized,
      ];
    } else {
      updated = [...servers, normalized];
    }

    await _storage.saveServers(updated);

    // 若当前无选中且新项为 default，自动选中
    if (state.selectedServer == null && normalized.isDefault) {
      final (http, sse) = _buildClients(normalized);
      state = state.copyWith(
        servers: updated,
        selectedServer: normalized,
        httpClient: http,
        sseClient: sse,
      );
    } else {
      state = state.copyWith(servers: updated);
    }
  }

  /// 更新服务器并持久化，支持修改 url / name / 认证信息
  ///
  /// originalUrl 不存在抛 [StateError]；新 url 与其他项冲突抛 [StateError]
  Future<void> updateServer(String originalUrl, Server next) async {
    final normOriginal = _normalizeUrl(originalUrl);
    final normNext = _normalizeUrl(next.url);

    final servers = state.servers;
    final index = servers.indexWhere(
      (s) => _normalizeUrl(s.url) == normOriginal,
    );
    if (index == -1) throw StateError('服务器不存在：$originalUrl');

    // 检查新 url 是否与其他项冲突（排除自身）
    final conflict = servers.any(
      (s) =>
          _normalizeUrl(s.url) == normNext &&
          _normalizeUrl(s.url) != normOriginal,
    );
    if (conflict) throw StateError('已存在相同 url 的服务器：$normNext');

    final normalized = next.copyWith(url: normNext);

    // 保持 default 唯一性
    List<Server> updated;
    if (normalized.isDefault) {
      updated = servers.asMap().entries.map((e) {
        if (e.key == index) return normalized;
        return e.value.copyWith(isDefault: false);
      }).toList();
    } else {
      updated = List.of(servers)..[index] = normalized;
    }

    await _storage.saveServers(updated);

    // 若被编辑的是当前选中项，更新选中并重建 client
    final wasSelected =
        state.selectedServer != null &&
        _normalizeUrl(state.selectedServer!.url) == normOriginal;

    if (wasSelected) {
      final (http, sse) = _buildClients(normalized);
      state = state.copyWith(
        servers: updated,
        selectedServer: normalized,
        httpClient: http,
        sseClient: sse,
      );
    } else {
      state = state.copyWith(servers: updated);
    }
  }

  /// 删除服务器并持久化；目标不存在时幂等返回
  ///
  /// 若删除的是当前选中项，自动清空选中和 client
  Future<void> removeServer(String url) async {
    final norm = _normalizeUrl(url);
    final servers = state.servers;
    final index = servers.indexWhere((s) => _normalizeUrl(s.url) == norm);
    if (index == -1) return; // 幂等

    final updated = List.of(servers)..removeAt(index);
    await _storage.saveServers(updated);

    final wasSelected =
        state.selectedServer != null &&
        _normalizeUrl(state.selectedServer!.url) == norm;

    if (wasSelected) {
      state = state.copyWith(
        servers: updated,
        clearSelected: true,
        clearHttpClient: true,
        clearSseClient: true,
      );
    } else {
      state = state.copyWith(servers: updated);
    }
  }

  /// 将目标设为默认服务器并持久化
  ///
  /// 目标不存在抛 [StateError]
  Future<void> setDefault(String url) async {
    final norm = _normalizeUrl(url);
    final servers = state.servers;
    if (!servers.any((s) => _normalizeUrl(s.url) == norm)) {
      throw StateError('服务器不存在：$url');
    }

    final updated = servers
        .map((s) => s.copyWith(isDefault: _normalizeUrl(s.url) == norm))
        .toList();

    await _storage.saveServers(updated);
    state = state.copyWith(servers: updated);
  }

  /// 切换当前选中服务器并重建 client
  ///
  /// 目标不存在抛 [StateError]；已是当前选中时幂等返回
  void selectServer(String url) {
    final norm = _normalizeUrl(url);
    final target = state.servers
        .where((s) => _normalizeUrl(s.url) == norm)
        .firstOrNull;
    if (target == null) throw StateError('服务器不存在：$url');

    // 已是当前选中，幂等返回
    if (state.selectedServer != null &&
        _normalizeUrl(state.selectedServer!.url) == norm) {
      return;
    }

    // 一次性更新 selectedServer + client，避免中间态
    final (http, sse) = _buildClients(target);
    state = state.copyWith(
      selectedServer: target,
      httpClient: http,
      sseClient: sse,
    );
  }

  /// 取消选中并清理 client；不影响已保存列表和默认服务器
  void clearSelection() {
    state = state.copyWith(
      clearSelected: true,
      clearHttpClient: true,
      clearSseClient: true,
    );
  }

  // ── 私有辅助 ──────────────────────────────────────────────────────────────

  /// 统一 url 格式：trim + 去末尾斜杠 + 转小写，用于比较去重
  String _normalizeUrl(String url) {
    return url.trim().toLowerCase().replaceAll(RegExp(r'/+$'), '');
  }

  /// 根据 server 构造 NetworkConfig 并创建 http / sse client
  (OpencodeHttpClient, OpencodeSseClient) _buildClients(Server server) {
    final config = NetworkConfig(
      baseUrl: server.url,
      username: server.username,
      password: server.password,
    );
    return (createHttpClient(config), createSseClient(config));
  }
}
