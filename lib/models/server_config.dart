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

  String get baseUrl {
    final h = host.trimRight().replaceAll(RegExp(r'/$'), '');
    final protocol = h.startsWith('http') ? '' : 'http://';
    return '$protocol$h:$port';
  }

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

    // Handle old format where host contains port (e.g., "192.168.1.1:8080")
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
