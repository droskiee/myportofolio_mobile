import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  test(
    'login stores the token and logout clears it when the API fails',
    () async {
      final client = ApiClient(
        baseUri: Uri.parse('http://localhost:8000'),
        client: MockClient((request) async {
          if (request.url.path.endsWith('/auth/token/')) {
            return http.Response(jsonEncode({'token': 'active-token'}), 200);
          }
          return http.Response(
            jsonEncode({'detail': 'Token has already been revoked.'}),
            401,
          );
        }),
      );
      addTearDown(client.close);
      final authState = AuthState(client);
      addTearDown(authState.dispose);

      var notifications = 0;
      authState.addListener(() => notifications++);

      await authState.login('owner', 'password');
      expect(authState.token, 'active-token');
      expect(authState.isLoggedIn, isTrue);

      await expectLater(authState.logout(), throwsA(isA<ApiException>()));
      expect(authState.token, isNull);
      expect(authState.isLoggedIn, isFalse);
      expect(notifications, 2);
    },
  );
}
