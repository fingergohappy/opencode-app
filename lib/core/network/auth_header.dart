import 'dart:convert';

import 'package:opencode_app/core/network/network_config.dart';

String? buildBasicAuthorizationHeader({String? username, String? password}) {
  if (password == null || password.isEmpty) return null;

  final resolvedUsername = (username == null || username.isEmpty)
      ? 'opencode'
      : username;
  final credentials = base64Encode(utf8.encode('$resolvedUsername:$password'));

  return 'Basic $credentials';
}



Map<String, dynamic> buildHeaders(NetworkConfig config) {
  final headers = <String, dynamic>{...config.defaultHeaders};
  final authorizationHeader = buildBasicAuthorizationHeader(
    username: config.username,
    password: config.password,
  );

  if (authorizationHeader != null) {
    headers['Authorization'] = authorizationHeader;
  }

  return headers;
}
