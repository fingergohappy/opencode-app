import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/server_config.dart';

/// 服务器配置仓库。
/// 当前实现比较轻量：把整份服务器列表编码成 JSON 存到 SharedPreferences。
class ServerStore {
  static const _key = 'list';

  /// 读取全部服务器；如果解析失败，返回空列表而不是直接抛异常。
  Future<List<ServerConfig>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => ServerConfig.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  /// save 同时承担“新增”和“更新”的职责，靠 id 判断覆盖还是追加。
  Future<void> save(ServerConfig server) async {
    final list = await getAll();
    final idx = list.indexWhere((e) => e.id == server.id);
    // 本地没有单条记录概念，所以这里总是先改内存列表，再整体写回 SharedPreferences。
    if (idx >= 0) {
      list[idx] = server;
    } else {
      list.add(server);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  /// 这里先拿全量再过滤，适合当前数据量较小的本地配置场景。
  Future<ServerConfig?> getById(String id) async {
    final list = await getAll();
    try {
      return list.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 删除后重新写回完整列表，保持存储结构简单一致。
  Future<void> delete(String id) async {
    final list = await getAll();
    final filtered = list.where((e) => e.id != id).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(filtered.map((e) => e.toJson()).toList()),
    );
  }

  /// 首次启动时自动提供一个默认服务器，方便开发阶段马上能看到可用项。
  Future<void> ensureDefault() async {
    final list = await getAll();
    if (list.isEmpty) {
      // 这一步相当于给新安装的应用准备“开箱即用”的连接配置。
      await save(
        ServerConfig(
          id: 'default',
          name: 'Local Server',
          host: '192.168.50.119',
          port: 4096,
        ),
      );
    }
  }
}
