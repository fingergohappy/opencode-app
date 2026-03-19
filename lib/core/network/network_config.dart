class NetworkConfig {
  const NetworkConfig({
    required this.baseUrl,
    this.username,
    this.password,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.defaultHeaders = const {},
  });

  static const defaults = NetworkConfig(baseUrl: 'http://localhost:4096');

  final String baseUrl;
  final String? username;
  final String? password;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, String> defaultHeaders;

  bool get hasPassword => password != null && password!.isNotEmpty;

  NetworkConfig copyWith({
    String? baseUrl,
    String? username,
    String? password,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, String>? defaultHeaders,
  }) {
    return NetworkConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      username: username ?? this.username,
      password: password ?? this.password,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
    );
  }
}
