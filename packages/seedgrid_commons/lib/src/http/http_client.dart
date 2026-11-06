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

/// Resposta crua: status, corpo e cabecalhos (chaves em minusculas), sem lancar em nao-2xx.
class SgHttpResponse {
  const SgHttpResponse(
    this.status,
    this.reason,
    this.body, [
    this.headers = const <String, String>{},
  ]);
  final int status;
  final String? reason;
  final String body;
  final Map<String, String> headers;
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
    final res = await send(path, method: method, headers: headers, body: body);
    if (res.status < 200 || res.status >= 300) {
      throw SgHttpException(res.status, res.reason, res.body);
    }
    if (res.status == 204) return null;
    return jsonDecode(res.body);
  }

  /// Como [request], mas devolve a resposta crua (status, corpo e cabecalhos em minusculas) e nao lanca em nao-2xx:
  /// e o que um `fetch` entrega (precisa para 304 e ETag).
  Future<SgHttpResponse> send(
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
    return SgHttpResponse(res.statusCode, res.reasonPhrase, _text(res), {
      for (final e in res.headers.entries) e.key.toLowerCase(): e.value,
    });
  }

  static String _text(http.Response res) {
    final ok = res.statusCode >= 200 && res.statusCode < 300;
    // O JSON de sucesso e sempre UTF-8 (como antes); o corpo de erro segue o charset da resposta.
    return ok ? utf8.decode(res.bodyBytes) : res.body;
  }

  void close() => _client.close();
}
