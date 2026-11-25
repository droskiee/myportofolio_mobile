import 'package:flutter/foundation.dart';

const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);

Uri get apiBaseUri {
  final configuredUri = Uri.parse(apiBaseUrl);
  if (kIsWeb && configuredUri.host == '10.0.2.2') {
    return configuredUri.replace(host: 'localhost');
  }
  return configuredUri;
}
