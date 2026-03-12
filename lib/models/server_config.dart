/// 单个服务器连接配置。
class ServerConfig {
  final String id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;

  ServerConfig({
    String? id,
    required this.name,
    required this.host,
    this.port = 8080,
    this.username = '',
    this.password = '',
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
  // 如果调用方没传 id，就按创建时间生成一个足够稳定的本地唯一标识。

  /// 组装最终请求地址。
  /// 如果用户没有输入协议头，就默认补成 http://。
  String get baseUrl {
    final h = host.trimRight().replaceAll(RegExp(r'/$'), '');
    // host 允许用户输入裸域名/IP，这里统一补协议，调用网络层时就不用每次判断。
    final protocol = h.startsWith('http') ? '' : 'http://';
    return '$protocol$h:$port';
  }

  /// toJson / fromJson 让这个模型既能本地持久化，也能在页面间稳定传递配置对象。
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'host': host,
    'port': port,
    'username': username,
    'password': password,
  };

  factory ServerConfig.fromJson(Map<String, dynamic> json) {
    String host = json['host'] ?? '';
    int port = 8080;

    // 兼容旧数据：早期版本可能把 host 和 port 混在同一个字段里。
    if (json['port'] == null && host.contains(':')) {
      final parts = host.split(':');
      if (parts.length == 2) {
        host = parts[0];
        port = int.tryParse(parts[1]) ?? 8080;
      }
    } else {
      final portValue = json['port'];
      if (portValue is int) {
        port = portValue;
      } else if (portValue != null) {
        port = int.tryParse(portValue.toString()) ?? 8080;
      }
    }

    // 这里把旧版脏数据清洗成统一结构，后面的页面和网络层就可以只处理一种格式。
    return ServerConfig(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      host: host,
      port: port,
      username: json['username']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
    );
  }
}
