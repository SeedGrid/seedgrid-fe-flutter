// Porte de @seedgrid/fe-commons src/http/httpClient.ts (createHttpClient).

import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpClientOptions {
  const HttpClientOptions({required this.baseUrl, this.getAccessToken});

  final String baseUrl;
  final String? Function()? getAccessToken;
}

class SgHttpException implements Exception {
  SgHttpException(this.status, this.reason, this.body);
  final int status;
  final String? reason;
  final String body;

  @override
  String toString() => 'HTTP $status ${reason ?? ''}: $body';
}

/// Equivale a `createHttpClient(opts).request`. `client` e injetavel (testes sem rede).
class SgHttpClient {
  SgHttpClient(this.options, {http.Client? client})
    : _client = client ?? http.Client();

  final HttpClientOptions options;
  final http.Client _client;

  /// Devolve o JSON decodificado (ou `null` para 204).
  Future<dynamic> request(
    String path, {
    String method = 'GET',
    Map<String, String>? headers,
    Object? body,
  }) async {
    final h = <String, String>{...?headers};
    if (!h.keys.any((k) => k.toLowerCase() == 'content-type')) {
      h['Content-Type'] = 'application/json';
    }
    final token = options.getAccessToken?.call();
    if (token != null && token.isNotEmpty) h['Authorization'] = 'Bearer $token';

    final req = http.Request(method, Uri.parse('${options.baseUrl}$path'))
      ..headers.addAll(h);
    if (body != null) req.body = body is String ? body : jsonEncode(body);
    final res = await http.Response.fromStream(await _client.send(req));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw SgHttpException(res.statusCode, res.reasonPhrase, res.body);
    }
    if (res.statusCode == 204) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  void close() => _client.close();
}
