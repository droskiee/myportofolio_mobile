import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  final baseUri = Uri.parse('http://localhost:8000');

  test(
    'project JSON uses Django snake_case and omits the server ID on create',
    () {
      const project = Project(
        id: 'server-id',
        title: 'Portfolio',
        description: 'A sample project',
        techStack: 'Flutter, Django',
        projectUrl: 'https://example.com',
      );

      final json = project.toJson();
      expect(json['tech_stack'], 'Flutter, Django');
      expect(json['project_url'], 'https://example.com');
      expect(json.containsKey('id'), isFalse);
    },
  );

  test(
    'getProjects parses project records and ignores read-only fields',
    () async {
      final client = ApiClient(
        baseUri: baseUri,
        client: MockClient((request) async {
          expect(request.method, 'GET');
          expect(request.url.path, '/api/v1/projects/');
          return http.Response(
            jsonEncode([
              {
                'id': 'project-1',
                'title': 'Portfolio',
                'description': 'A sample project',
                'tech_stack': 'Flutter',
                'project_url': 'https://example.com',
                'project_image_url': '',
                'star_count': 2,
                'is_starred': false,
                'starred_by_names': '',
              },
            ]),
            200,
          );
        }),
      );
      addTearDown(client.close);

      final projects = await client.getProjects();
      expect(projects, hasLength(1));
      expect(projects.single.id, 'project-1');
      expect(projects.single.techStack, 'Flutter');
      expect(projects.single.projectImageUrl, '');
    },
  );

  test('createProject sends JSON with the token header', () async {
    final client = ApiClient(
      baseUri: baseUri,
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/projects/');
        expect(request.headers['authorization'], 'Token secret-token');
        expect(jsonDecode(request.body), {
          'title': 'Portfolio',
          'description': 'A sample project',
          'tech_stack': 'Flutter',
          'project_url': 'https://example.com',
          'project_image_url': '',
        });
        return http.Response(
          jsonEncode({
            'id': 'created-id',
            'title': 'Portfolio',
            'description': 'A sample project',
            'tech_stack': 'Flutter',
            'project_url': 'https://example.com',
            'project_image_url': '',
            'star_count': 0,
            'is_starred': false,
            'starred_by_names': '',
          }),
          201,
        );
      }),
    );
    addTearDown(client.close);

    final created = await client.createProject(
      const Project(
        title: 'Portfolio',
        description: 'A sample project',
        techStack: 'Flutter',
        projectUrl: 'https://example.com',
      ),
      token: 'secret-token',
    );
    expect(created.id, 'created-id');
  });

  test('obtainToken and logout use the authentication endpoints', () async {
    final requests = <http.Request>[];
    final client = ApiClient(
      baseUri: baseUri,
      client: MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/auth/token/')) {
          return http.Response(jsonEncode({'token': 'secret-token'}), 200);
        }
        return http.Response('', 204);
      }),
    );
    addTearDown(client.close);

    final token = await client.obtainToken(
      username: 'owner',
      password: 'password',
    );
    await client.logout(token: token);

    expect(token, 'secret-token');
    expect(jsonDecode(requests.first.body), {
      'username': 'owner',
      'password': 'password',
    });
    expect(requests.last.url.path, '/api/v1/auth/logout/');
    expect(requests.last.headers['authorization'], 'Token secret-token');
  });

  test('HTTP errors retain the status and server error message', () async {
    final client = ApiClient(
      baseUri: baseUri,
      client: MockClient(
        (_) async =>
            http.Response(jsonEncode({'detail': 'Permission denied.'}), 403),
      ),
    );
    addTearDown(client.close);

    await expectLater(
      client.getProjects(),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'statusCode', 403)
            .having((error) => error.message, 'message', 'Permission denied.'),
      ),
    );
  });
}
