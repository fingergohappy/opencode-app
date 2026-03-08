import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/server_config.dart';

class ServerStore {
  static const _key = 'list';

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

  Future<void> save(ServerConfig server) async {
    final list = await getAll();
    final idx = list.indexWhere((e) => e.id == server.id);
    if (idx >= 0) {
      list[idx] = server;
    } else {
      list.add(server);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  Future<ServerConfig?> getById(String id) async {
    final list = await getAll();
    try {
      return list.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> delete(String id) async {
    final list = await getAll();
    final filtered = list.where((e) => e.id != id).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(filtered.map((e) => e.toJson()).toList()));
  }

  Future<void> ensureDefault() async {
    final list = await getAll();
    if (list.isEmpty) {
      await save(ServerConfig(
        id: 'default',
        name: 'Local Server',
        host: '192.168.50.119',
        port: 4096,
      ));
    }
  }
}
