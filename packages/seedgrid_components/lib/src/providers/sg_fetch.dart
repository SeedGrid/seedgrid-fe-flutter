// Abstracao minima de HTTP para os providers (persistencia por API e token do realtime).
// No React o ponto de injecao e o `fetcher` (assinatura do `fetch`); aqui e [SgFetcher]. O padrao
// usa o SgHttpClient de seedgrid_commons, entao nao ha dependencia nova.
import 'dart:convert';

import 'package:seedgrid_commons/seedgrid_commons.dart';

/// Pedido HTTP (equivale aos argumentos `input` + `init` do `fetch`).
class SgFetchRequest {
  const SgFetchRequest({
    required this.method,
    required this.url,
    this.headers = const <String, String>{},
    this.body,
  });

  final String method;

  /// URL absoluta.
  final String url;
  final Map<String, String> headers;
  final String? body;
}

/// Resposta HTTP (equivale ao `Response`: `ok`, `status` e `json()`).
class SgFetchResponse {
  const SgFetchResponse(
    this.status, [
    this.body = '',
    this.headers = const <String, String>{},
  ]);

  final int status;
  final String body;

  /// Cabecalhos da resposta com as chaves em minusculas (`etag`, `cache-control`...); vazio se o fetcher nao os traz.
  final Map<String, String> headers;

  bool get ok => status >= 200 && status < 300;

  /// `await res.json()`.
  Object? json() => jsonDecode(body);
}

/// Equivale ao `fetch` injetavel do React.
typedef SgFetcher = Future<SgFetchResponse> Function(SgFetchRequest request);

/// Fetcher padrao: [SgHttpClient] de seedgrid_commons. Respostas nao-2xx viram [SgFetchResponse] com o
/// status (nao lancam), como o `fetch` do navegador.
Future<SgFetchResponse> sgDefaultFetcher(SgFetchRequest request) async {
  final client = SgHttpClient(const HttpClientOptions(baseUrl: ''));
  try {
    final res = await client.send(
      request.url,
      method: request.method,
      headers: request.headers.isEmpty ? null : request.headers,
      body: request.body,
    );
    return SgFetchResponse(res.status, res.body, res.headers);
  } finally {
    client.close();
  }
}
