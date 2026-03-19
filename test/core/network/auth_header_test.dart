import 'package:flutter_test/flutter_test.dart';
import 'package:opencode_app/core/network/auth_header.dart';

void main() {
  group('buildBasicAuthorizationHeader', () {
    test('returns null when password is missing', () {
      expect(buildBasicAuthorizationHeader(username: 'alice'), isNull);
    });

    test('uses default username when username is empty', () {
      expect(
        buildBasicAuthorizationHeader(username: '', password: 'secret'),
        'Basic b3BlbmNvZGU6c2VjcmV0',
      );
    });

    test('builds header from username and password', () {
      expect(
        buildBasicAuthorizationHeader(username: 'alice', password: 'secret'),
        'Basic YWxpY2U6c2VjcmV0',
      );
    });
  });
}
