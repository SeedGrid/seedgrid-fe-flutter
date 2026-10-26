// Configuracao por pais do SgInputPostalCode e as consultas padrao (ViaCEP e publica.cnpj.ws) dos
// inputs com mascara. As consultas sao injetaveis (`viaCepFetch`, `publicaCnpjFetch`): os testes
// nao usam rede.
import 'package:seedgrid_commons/seedgrid_commons.dart';

import '../../generated/enums.g.dart';

/// Resposta do ViaCEP (o `ViaCepResponse` do React, com `erro`). O `ViaCepResponse` de
/// seedgrid_commons lanca em vez de devolver `erro`, entao este tipo existe so para o input.
class SgViaCepResult {
  const SgViaCepResult({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.ibge,
    this.gia,
    this.ddd,
    this.siafi,
    this.erro = false,
  });

  final String? cep;
  final String? logradouro;
  final String? complemento;
  final String? bairro;
  final String? localidade;
  final String? uf;
  final String? ibge;
  final String? gia;
  final String? ddd;
  final String? siafi;
  final bool erro;
}

/// Consulta padrao: `buscarCep` de seedgrid_commons; "CEP nao encontrado" vira `erro: true`
/// (como o `{ erro: true }` do ViaCEP), qualquer outra falha propaga (vai para `onViaCepError`).
Future<SgViaCepResult> sgDefaultViaCepFetch(String cep) async {
  try {
    final r = await buscarCep(cep);
    return SgViaCepResult(
      cep: r.cep,
      logradouro: r.logradouro,
      complemento: r.complemento,
      bairro: r.bairro,
      localidade: r.localidade,
      uf: r.uf,
      ibge: r.ibge,
      gia: r.gia,
      ddd: r.ddd,
      siafi: r.siafi,
    );
  } on Exception catch (e) {
    if (e.toString().contains('CEP não encontrado.')) {
      return const SgViaCepResult(erro: true);
    }
    rethrow;
  }
}

/// Consulta padrao do CNPJ: GET https://publica.cnpj.ws/cnpj/<14 digitos>. Resposta 4xx (menos 429) vira
/// `null` ("nao achou"); falha de rede propaga (vai para `onPublicaCnpjError`).
Future<Object?> sgDefaultPublicaCnpjFetch(String cnpj) async {
  final client = SgHttpClient(
    const HttpClientOptions(baseUrl: 'https://publica.cnpj.ws'),
  );
  try {
    return await client.request('/cnpj/$cnpj');
  } on SgHttpException catch (e) {
    // 429 (limite de 3 consultas por minuto) e 5xx nao dizem que o CNPJ nao existe: propagam e vao para
    // onPublicaCnpjError (a validacao passa). Diverge do React, que trata toda resposta nao-2xx como "nao achou".
    if (e.status == 429 || e.status >= 500) rethrow;
    return null;
  } finally {
    client.close();
  }
}

enum SgPostalCountry {
  br,
  pt,
  us,
  es,
  uy,
  ar,
  py;

  static SgPostalCountry of(SgInputPostalCodeCountry? c) => switch (c) {
    null || SgInputPostalCodeCountry.br => br,
    SgInputPostalCodeCountry.pt => pt,
    SgInputPostalCodeCountry.us => us,
    SgInputPostalCodeCountry.es => es,
    SgInputPostalCodeCountry.uy => uy,
    SgInputPostalCodeCountry.ar => ar,
    SgInputPostalCodeCountry.py => py,
  };

  String get code => name.toUpperCase();
}

class SgPostalConfig {
  const SgPostalConfig({
    required this.mask,
    required this.rawLength,
    required this.maxLength,
    required this.numeric,
    required this.placeholder,
  });

  final String Function(String) mask;
  final int rawLength;
  final int maxLength;
  final bool numeric;
  final String placeholder;

  String lengthKeyFor(SgPostalCountry c) =>
      'components.inputs.postalCode.${c.code}.length';
  String invalidKeyFor(SgPostalCountry c) =>
      'components.inputs.postalCode.${c.code}.invalid';
}

SgPostalConfig sgPostalConfigOf(SgPostalCountry c) => switch (c) {
  SgPostalCountry.br => const SgPostalConfig(
    mask: maskPostalCodeBR,
    rawLength: 8,
    maxLength: 10,
    numeric: true,
    placeholder: '00000-000',
  ),
  SgPostalCountry.pt => const SgPostalConfig(
    mask: maskPostalCodePT,
    rawLength: 7,
    maxLength: 8,
    numeric: true,
    placeholder: '0000-000',
  ),
  SgPostalCountry.us => const SgPostalConfig(
    mask: maskPostalCodeUS,
    rawLength: 5,
    maxLength: 10,
    numeric: true,
    placeholder: '00000',
  ),
  SgPostalCountry.es => const SgPostalConfig(
    mask: maskPostalCodeES,
    rawLength: 5,
    maxLength: 5,
    numeric: true,
    placeholder: '00000',
  ),
  SgPostalCountry.uy => const SgPostalConfig(
    mask: maskPostalCodeUY,
    rawLength: 5,
    maxLength: 5,
    numeric: true,
    placeholder: '00000',
  ),
  SgPostalCountry.ar => const SgPostalConfig(
    mask: maskPostalCodeAR,
    rawLength: 4,
    maxLength: 8,
    numeric: false,
    placeholder: 'A0000AAA',
  ),
  SgPostalCountry.py => const SgPostalConfig(
    mask: maskPostalCodePY,
    rawLength: 6,
    maxLength: 6,
    numeric: true,
    placeholder: '000000',
  ),
};

/// Parte "crua" do valor (so digitos; no AR, letras e digitos em maiusculas).
String sgPostalRaw(String value, SgPostalCountry c) => c == SgPostalCountry.ar
    ? value.replaceAll(RegExp(r'[^0-9A-Za-z]'), '').toUpperCase()
    : value.replaceAll(RegExp(r'\D'), '');
