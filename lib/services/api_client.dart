import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client, Uri? baseUri})
    : _client = client ?? http.Client(),
      _baseUri = baseUri ?? apiBaseUri;

  final http.Client _client;
  final Uri _baseUri;

  Uri _endpoint(String path) => _baseUri.resolve('/api/v1/$path');

  Future<List<Project>> getProjects() async {
    final response = await _send(
      () => _client.get(
        _endpoint('projects/'),
        headers: const {'Accept': 'application/json'},
      ),
    );
    if (response.statusCode != 200) {
      throw _responseException(response);
    }

    final decoded = _decodeJson(response);
    if (decoded is! List) {
      throw ApiException(
        response.statusCode,
        'The server returned an invalid project list.',
      );
    }
    return decoded
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw ApiException(
              response.statusCode,
              'The server returned an invalid project entry.',
            );
          }
          return Project.fromJson(item);
        })
        .toList(growable: false);
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    if (token.trim().isEmpty) {
      throw const ApiException(401, 'Log in before creating a project.');
    }
    final response = await _send(
      () => _client.post(
        _endpoint('projects/'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(project.toJson()),
      ),
    );
    if (response.statusCode != 201) {
      throw _responseException(response);
    }
    final decoded = _decodeJson(response);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException(
        response.statusCode,
        'The server returned an invalid project.',
      );
    }
    return Project.fromJson(decoded);
  }

  Future<String> obtainToken({
    required String username,
    required String password,
  }) async {
    final response = await _send(
      () => _client.post(
        _endpoint('auth/token/'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({'username': username, 'password': password}),
      ),
    );
    if (response.statusCode != 200) {
      throw _responseException(response);
    }
    final decoded = _decodeJson(response);
    if (decoded is! Map<String, dynamic> || decoded['token'] is! String) {
      throw ApiException(
        response.statusCode,
        'The server returned an invalid login response.',
      );
    }
    final token = decoded['token'] as String;
    if (token.isEmpty) {
      throw ApiException(
        response.statusCode,
        'The server returned an empty login token.',
      );
    }
    return token;
  }

  Future<void> logout({required String token}) async {
    if (token.trim().isEmpty) {
      throw const ApiException(401, 'There is no active login session.');
    }
    final response = await _send(
      () => _client.post(
        _endpoint('auth/logout/'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      ),
    );
    if (response.statusCode != 204) {
      throw _responseException(response);
    }
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request();
    } on http.ClientException {
      throw const ApiException(
        0,
        'Could not reach the portfolio server. Check the server address and connection.',
      );
    }
  }

  Object? _decodeJson(http.Response response) {
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw ApiException(
        response.statusCode,
        'The server returned an unreadable response.',
      );
    }
  }

  ApiException _responseException(http.Response response) {
    String message = 'Request failed with status ${response.statusCode}.';
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map) {
        final detail = decoded['detail'];
        if (detail is String && detail.isNotEmpty) {
          message = detail;
        } else {
          final errors = decoded.entries
              .map((entry) {
                final value = entry.value;
                if (value is List) return value.join(' ');
                return value.toString();
              })
              .where((value) => value.isNotEmpty)
              .join(' ');
          if (errors.isNotEmpty) message = errors;
        }
      }
    } on FormatException {
      // Keep the status-based message for non-JSON responses.
    }
    return ApiException(response.statusCode, message);
  }

  void close() => _client.close();
}
