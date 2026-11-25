import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('project list shows the empty state and supports refresh', (
    tester,
  ) async {
    var requests = 0;
    final client = ApiClient(
      baseUri: Uri.parse('http://localhost:8000'),
      client: MockClient((_) async {
        requests++;
        return http.Response(jsonEncode([]), 200);
      }),
    );
    addTearDown(client.close);

    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();
    expect(find.text('No projects found.'), findsOneWidget);
    expect(requests, 1);

    await tester.drag(find.text('No projects found.'), const Offset(0, 250));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(requests, 2);
  });

  testWidgets('project list shows an error and retry reloads the list', (
    tester,
  ) async {
    var requests = 0;
    final client = ApiClient(
      baseUri: Uri.parse('http://localhost:8000'),
      client: MockClient((_) async {
        requests++;
        if (requests == 1) {
          return http.Response(
            jsonEncode({'detail': 'Server unavailable.'}),
            503,
          );
        }
        return http.Response(jsonEncode([]), 200);
      }),
    );
    addTearDown(client.close);

    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();
    expect(find.text('Server unavailable.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(requests, 2);
    expect(find.text('No projects found.'), findsOneWidget);
  });
}

Widget _app(ApiClient client) => Provider<ApiClient>.value(
  value: client,
  child: const MaterialApp(home: ProjectListScreen()),
);
