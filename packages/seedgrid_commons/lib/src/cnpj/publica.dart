// Porte de @seedgrid/fe-commons src/cnpj/publica.ts (buscarCnpj).
// Parcial: o TypeScript tipa a resposta inteira (socios, simples, estabelecimento...). Aqui a
// resposta e o JSON original (`json`, mesmos nomes snake_case da API) mais getters para os campos
// mais usados. Os demais campos continuam acessiveis por `json`.

import 'dart:convert';

import 'package:http/http.dart' as http;

class PublicaCnpjResponse {
  const PublicaCnpjResponse(this.json);

  /// Resposta crua de https://publica.cnpj.ws/cnpj/{cnpj}.
  final Map<String, dynamic> json;

  String get cnpjRaiz => (json['cnpj_raiz'] ?? '') as String;
  String get razaoSocial => (json['razao_social'] ?? '') as String;
  String get capitalSocial => (json['capital_social'] ?? '') as String;
  Map<String, dynamic> get estabelecimento =>
      (json['estabelecimento'] ?? const <String, dynamic>{})
          as Map<String, dynamic>;
  String get nomeFantasia => (estabelecimento['nome_fantasia'] ?? '') as String;
  String get situacaoCadastral =>
      (estabelecimento['situacao_cadastral'] ?? '') as String;
}

/// Devolve `null` em qualquer falha de rede ou resposta nao-2xx (igual ao React). So lanca para
/// CNPJ que nao tem 14 digitos.
Future<PublicaCnpjResponse?> buscarCnpj(
  String cnpj, {
  http.Client? client,
}) async {
  final normalized = cnpj.replaceAll(RegExp(r'\D'), '');
  if (normalized.length != 14) {
    throw Exception('CNPJ deve ter 14 dígitos.');
  }
  final c = client ?? http.Client();
  try {
    final res = await c.get(
      Uri.parse('https://publica.cnpj.ws/cnpj/$normalized'),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) return null;
    return PublicaCnpjResponse(
      jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>,
    );
  } catch (_) {
    return null;
  } finally {
    if (client == null) c.close();
  }
}
