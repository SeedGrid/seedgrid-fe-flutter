import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';

void main() {
  group('validateBirthDate (today injetado)', () {
    final today = DateTime(2026, 10, 23);
    // Datas com hora local evitam a diferenca de fuso do ISO "so data" (comportamento herdado do JS).
    test('sem minAge nem maxAge -> configMissing', () {
      expect(
        validateBirthDate(
          '2000-01-01T12:00:00',
          const BirthDatePolicy(),
          today: today,
        ).problem,
        BirthDateProblem.configMissing,
      );
    });
    test('minAge > maxAge -> configRange', () {
      expect(
        validateBirthDate(
          '2000-01-01T12:00:00',
          const BirthDatePolicy(minAge: 30, maxAge: 20),
          today: today,
        ).problem,
        BirthDateProblem.configRange,
      );
    });
    test('vazio e ok', () {
      expect(
        validateBirthDate(
          '',
          const BirthDatePolicy(minAge: 18),
          today: today,
        ).ok,
        isTrue,
      );
    });
    test('data invalida', () {
      expect(
        validateBirthDate(
          'lixo',
          const BirthDatePolicy(minAge: 18),
          today: today,
        ).problem,
        BirthDateProblem.invalidDate,
      );
    });
    test('maior de 18', () {
      expect(
        validateBirthDate(
          '2008-10-23T12:00:00',
          const BirthDatePolicy(minAge: 18),
          today: today,
        ).ok,
        isTrue,
      );
      final r = validateBirthDate(
        '2008-10-24T12:00:00',
        const BirthDatePolicy(minAge: 18),
        today: today,
      );
      expect(r.problem, BirthDateProblem.ageMin);
      expect(r.min, 18);
    });
    test('faixa e maximo', () {
      final between = validateBirthDate(
        '2020-01-01T12:00:00',
        const BirthDatePolicy(minAge: 18, maxAge: 60),
        today: today,
      );
      expect(between.problem, BirthDateProblem.ageBetween);
      expect(between.max, 60);
      final max = validateBirthDate(
        '1900-01-01T12:00:00',
        const BirthDatePolicy(maxAge: 120),
        today: today,
      );
      expect(max.problem, BirthDateProblem.ageMax);
    });
  });

  group('buscarCep', () {
    test('CEP com tamanho errado lanca antes de ir a rede', () {
      expect(
        () => buscarCep(
          '123',
          client: MockClient((_) async => fail('nao devia chamar')),
        ),
        throwsA(
          predicate((e) => e.toString().contains('CEP deve ter 8 dígitos.')),
        ),
      );
    });
    test('resposta ok', () async {
      Uri? visited;
      final client = MockClient((req) async {
        visited = req.url;
        return http.Response(
          jsonEncode({
            'cep': '01310-100',
            'logradouro': 'Av Paulista',
            'localidade': 'São Paulo',
            'uf': 'SP',
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final r = await buscarCep('01310-100', client: client);
      expect(visited.toString(), 'https://viacep.com.br/ws/01310100/json/');
      expect(r.uf, 'SP');
      expect(r.bairro, '');
    });
    test('erro true -> CEP não encontrado; http 500 -> falha', () async {
      expect(
        buscarCep(
          '01310100',
          client: MockClient((_) async => http.Response('{"erro":true}', 200)),
        ),
        throwsA(predicate((e) => e.toString().contains('CEP não encontrado.'))),
      );
      expect(
        buscarCep(
          '01310100',
          client: MockClient((_) async => http.Response('x', 500)),
        ),
        throwsA(
          predicate(
            (e) => e.toString().contains('Falha ao consultar CEP (500).'),
          ),
        ),
      );
    });
  });

  group('buscarCnpj', () {
    test(
      'tamanho errado lanca; falha de rede e nao-2xx devolvem null',
      () async {
        expect(
          () => buscarCnpj(
            '1',
            client: MockClient((_) async => http.Response('', 200)),
          ),
          throwsA(
            predicate(
              (e) => e.toString().contains('CNPJ deve ter 14 dígitos.'),
            ),
          ),
        );
        expect(
          await buscarCnpj(
            '11222333000181',
            client: MockClient((_) async => http.Response('', 404)),
          ),
          isNull,
        );
        expect(
          await buscarCnpj(
            '11222333000181',
            client: MockClient((_) async => throw Exception('rede')),
          ),
          isNull,
        );
      },
    );
    test('resposta ok', () async {
      final r = await buscarCnpj(
        '11.222.333/0001-81',
        client: MockClient((req) async {
          expect(
            req.url.toString(),
            'https://publica.cnpj.ws/cnpj/11222333000181',
          );
          return http.Response(
            jsonEncode({
              'razao_social': 'ACME',
              'estabelecimento': {'nome_fantasia': 'Acme Ltda'},
            }),
            200,
          );
        }),
      );
      expect(r!.razaoSocial, 'ACME');
      expect(r.nomeFantasia, 'Acme Ltda');
    });
  });

  group('SgHttpClient', () {
    test('Bearer, Content-Type e 204', () async {
      late http.BaseRequest seen;
      final c = SgHttpClient(
        HttpClientOptions(
          baseUrl: 'https://api.x',
          getAccessToken: () => 'tok',
        ),
        client: MockClient((req) async {
          seen = req;
          return http.Response('', 204);
        }),
      );
      expect(await c.request('/ping'), isNull);
      expect(seen.url.toString(), 'https://api.x/ping');
      expect(seen.headers['Authorization'], 'Bearer tok');
      expect(seen.headers['Content-Type'], 'application/json');
    });
    test('erro http lanca com status e corpo', () async {
      final c = SgHttpClient(
        const HttpClientOptions(baseUrl: 'https://api.x'),
        client: MockClient(
          (_) async => http.Response('nope', 403, reasonPhrase: 'Forbidden'),
        ),
      );
      expect(
        c.request('/x'),
        throwsA(predicate((e) => e.toString() == 'HTTP 403 Forbidden: nope')),
      );
    });
    test(
      '409 com problem+json lanca SgHttpException com status e corpo (sem tratar por status)',
      () async {
        const problema =
            '{"type":"about:blank","title":"Tenant Already Active","status":409}';
        final c = SgHttpClient(
          const HttpClientOptions(baseUrl: 'https://api.x'),
          client: MockClient(
            (_) async => http.Response(
              problema,
              409,
              reasonPhrase: 'Conflict',
              headers: {'content-type': 'application/problem+json'},
            ),
          ),
        );
        await expectLater(
          c.request('/tenants/validate', method: 'POST'),
          throwsA(
            isA<SgHttpException>()
                .having((e) => e.status, 'status', 409)
                .having((e) => e.body, 'body', problema),
          ),
        );
      },
    );
    test('JSON de resposta', () async {
      final c = SgHttpClient(
        const HttpClientOptions(baseUrl: 'https://api.x'),
        client: MockClient((_) async => http.Response('{"a":1}', 200)),
      );
      expect(await c.request('/x'), {'a': 1});
    });
  });
}
