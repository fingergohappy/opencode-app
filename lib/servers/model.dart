import '../core/network/opencode_http_client.dart';
import '../core/network/opencode_sse_client.dart';

/// 一个 opencode 服务器的连接配置，可持久化
class Server {
  const Server({
    required this.url,
    this.name,
    this.username,
    this.password,
    this.isDefault = false,
  });

  factory Server.fromJson(Map<String, dynamic> json) => Server(
        url: json['url'] as String,
        name: json['name'] as String?,
        username: json['username'] as String?,
        password: json['password'] as String?,
        isDefault: json['isDefault'] as bool? ?? false,
      );

  final String url;
  final String? name;
  final String? username;
  final String? password;

  /// 是否为默认服务器；同一时刻列表中最多一个为 true
  final bool isDefault;

  Server copyWith({
    String? url,
    String? name,
    Object? username = _sentinel,
    Object? password = _sentinel,
    bool? isDefault,
  }) {
    return Server(
      url: url ?? this.url,
      name: name ?? this.name,
      // 用哨兵值区分"未传入"与"显式传 null"
      username: username == _sentinel ? this.username : username as String?,
      password: password == _sentinel ? this.password : password as String?,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        if (name != null) 'name': name,
        if (username != null) 'username': username,
        if (password != null) 'password': password,
        'isDefault': isDefault,
      };
}

// 哨兵对象，用于 copyWith 中区分"未传入"与"传入 null"
const _sentinel = Object();

/// controller 管理的聚合状态；client 字段为运行时对象，不持久化
class ServersState {
  const ServersState({
    this.servers = const [],
    this.selectedServer,
    this.httpClient,
    this.sseClient,
  });

  final List<Server> servers;
  final Server? selectedServer;

  /// 当前选中服务器的 HTTP 客户端；selectedServer 为 null 时必须为 null
  final OpencodeHttpClient? httpClient;

  /// 当前选中服务器的 SSE 客户端；selectedServer 为 null 时必须为 null
  final OpencodeSseClient? sseClient;

  ServersState copyWith({
    List<Server>? servers,
    Server? selectedServer,
    bool clearSelected = false,
    OpencodeHttpClient? httpClient,
    bool clearHttpClient = false,
    OpencodeSseClient? sseClient,
    bool clearSseClient = false,
  }) {
    return ServersState(
      servers: servers ?? this.servers,
      selectedServer:
          clearSelected ? null : (selectedServer ?? this.selectedServer),
      httpClient:
          clearHttpClient ? null : (httpClient ?? this.httpClient),
      sseClient: clearSseClient ? null : (sseClient ?? this.sseClient),
    );
  }
}

/// 服务器健康检测结果；运行时状态，不持久化
class ServerHealthStatus {
  const ServerHealthStatus({
    required this.serverUrl,
    required this.healthy,
    this.version,
    this.error,
    required this.checkedAt,
  });

  final String serverUrl;
  final bool healthy;

  /// 健康时有值，来自 /global/health 响应的 version 字段
  final String? version;

  /// 不健康时有值，描述失败原因
  final String? error;

  /// 最近一次检测时间
  final DateTime checkedAt;
}
