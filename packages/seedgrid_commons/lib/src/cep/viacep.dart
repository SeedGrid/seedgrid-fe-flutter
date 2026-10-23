// Porte de @seedgrid/fe-commons src/cep/viacep.ts (buscarCep).

import 'dart:convert';

import 'package:http/http.dart' as http;

class ViaCepResponse {
  const ViaCepResponse({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ibge,
    required this.gia,
    required this.ddd,
    required this.siafi,
  });

  factory ViaCepResponse.fromJson(Map<String, dynamic> j) => ViaCepResponse(
    cep: (j['cep'] ?? '') as String,
    logradouro: (j['logradouro'] ?? '') as String,
    complemento: (j['complemento'] ?? '') as String,
    bairro: (j['bairro'] ?? '') as String,
    localidade: (j['localidade'] ?? '') as String,
    uf: (j['uf'] ?? '') as String,
    ibge: (j['ibge'] ?? '') as String,
    gia: (j['gia'] ?? '') as String,
    ddd: (j['ddd'] ?? '') as String,
    siafi: (j['siafi'] ?? '') as String,
  );

  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String ibge;
  final String gia;
  final String ddd;
  final String siafi;
}

/// `client` e injetavel (testes sem rede). Mensagens de erro iguais as do React.
Future<ViaCepResponse> buscarCep(String cep, {http.Client? client}) async {
  final normalized = cep.replaceAll(RegExp(r'\D'), '');
  if (normalized.length != 8) {
    throw Exception('CEP deve ter 8 dígitos.');
  }
  final c = client ?? http.Client();
  try {
    final res = await c.get(
      Uri.parse('https://viacep.com.br/ws/$normalized/json/'),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Falha ao consultar CEP (${res.statusCode}).');
    }
    final data = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    if (data['erro'] == true) {
      throw Exception('CEP não encontrado.');
    }
    return ViaCepResponse.fromJson(data);
  } finally {
    if (client == null) c.close();
  }
}
