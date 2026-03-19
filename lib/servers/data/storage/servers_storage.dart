import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../model.dart';

const _kServersKey = 'servers';

/// 负责服务器列表的本地持久化，不负责请求服务器
class ServersStorage {
  ServersStorage(this._prefs);

  final SharedPreferences _prefs;

  /// 从本地读取服务器列表；解析失败时返回空列表，不抛异常
  List<Server> loadServers() {
    final raw = _prefs.getString(_kServersKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => Server.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // 数据损坏时降级为空列表，避免启动崩溃
      return [];
    }
  }

  /// 将服务器列表全量写入本地
  Future<void> saveServers(List<Server> servers) async {
    await _prefs.setString(
      _kServersKey,
      jsonEncode(servers.map((s) => s.toJson()).toList()),
    );
  }

  /// 将指定 url 的服务器设为默认，其余清除默认标记
  ///
  /// 内部执行：load → 清除旧 default → 设置新 default → save
  /// 默认服务器唯一性由 controller 保证，storage 只负责读写
  Future<void> updateDefault(String url) async {
    final servers = loadServers();
    final updated = servers
        .map((s) => s.copyWith(isDefault: s.url == url))
        .toList();
    await saveServers(updated);
  }
}
