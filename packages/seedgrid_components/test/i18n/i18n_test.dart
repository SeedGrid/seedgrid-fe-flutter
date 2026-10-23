import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';
import 'package:seedgrid_components/src/i18n/i18n.dart';
import 'package:seedgrid_components/src/i18n/validator_messages.dart';

const _locales = ['pt-BR', 'pt-PT', 'en-US', 'es', 'fr'];

Map<String, Map<String, String>> get _builtins => {
  'pt-BR': componentsMessagesPtBr,
  'pt-PT': componentsMessagesPtPt,
  'en-US': componentsMessagesEnUs,
  'es': componentsMessagesEs,
  'fr': componentsMessagesFr,
};

void main() {
  final vec =
      jsonDecode(File('test/i18n/vectors.json').readAsStringSync())
          as Map<String, dynamic>;
  final byLocale = vec['locales'] as Map<String, dynamic>;

  tearDown(resetComponentsI18n);

  group('mapas gerados == TypeScript (React ${vec['versaoReact']})', () {
    for (final loc in _locales) {
      test(loc, () {
        final ts = ((byLocale[loc] as Map)['messages'] as Map)
            .cast<String, String>();
        expect(_builtins[loc], ts);
        expect(_builtins[loc]!.length, (vec['contagem'] as Map)[loc]);
      });
    }
  });

  test(
    'completude: todo idioma tem as mesmas chaves (falha com a lista do que falta)',
    () {
      final all = <String>{for (final m in _builtins.values) ...m.keys};
      final missing = <String, List<String>>{
        for (final e in _builtins.entries)
          e.key: all.where((k) => !e.value.containsKey(k)).toList()..sort(),
      }..removeWhere((_, v) => v.isEmpty);
      expect(missing, isEmpty, reason: 'chaves faltando por idioma: $missing');
    },
  );

  // Defeito que existiu no React (src/i18n/*.ts, corrigido em 2026-10-23): acento virou "?" dentro de palavra ou foi
  // duplamente codificado. O porte e fiel ao React; este teste impede a volta do defeito.
  test('sem "?" no lugar de acento dentro de palavra', () {
    // "?" no lugar de letra acentuada, ou acento duplamente codificado (U+00C3/U+00C2 + continuacao).
    final bad = RegExp('[A-Za-z]\\?[A-Za-z]|[\\u00C3\\u00C2][\\u0080-\\u00BF]');
    final found = <String, int>{
      for (final e in _builtins.entries)
        e.key: e.value.values.where(bad.hasMatch).length,
    }..removeWhere((_, v) => v == 0);
    expect(
      found,
      isEmpty,
      reason: 'mensagens com acento corrompido por idioma: $found',
    );
  });

  group('locale', () {
    test('normalizeComponentsLocale == TS', () {
      for (final c in (vec['normalize'] as List).cast<Map<String, dynamic>>()) {
        expect(
          normalizeComponentsLocale(c['in'] as String?),
          c['out'],
          reason: '${c['in']}',
        );
      }
    });
    test('locale desconhecido cai em en-US', () {
      expect(getBuiltInComponentsMessages('xx'), componentsMessagesEnUs);
      expect(getBuiltInComponentsMessages('pt'), componentsMessagesEnUs);
      expect(getBuiltInComponentsMessages('en'), componentsMessagesEnUs);
      expect(getBuiltInComponentsMessages(null), componentsMessagesEnUs);
    });
  });

  group('t / formatMessage (mesmas respostas do TS)', () {
    for (final loc in _locales) {
      test(loc, () {
        final i18n = resolveComponentsI18n(SgComponentsI18nInput(locale: loc));
        for (final c
            in ((byLocale[loc] as Map)['t'] as List)
                .cast<Map<String, dynamic>>()) {
          final params = (c['params'] as Map<String, dynamic>?);
          expect(
            t(i18n, c['key'] as String, params),
            c['out'],
            reason: '$loc ${c['key']} $params',
          );
        }
      });
    }
    test('parametro numerico e ausente', () {
      expect(formatMessage('de {a} a {b}', {'a': 1}), 'de 1 a {b}');
      expect(formatMessage('x {a}', null), 'x {a}');
      expect(formatMessage('x {a}', {'a': null}), 'x {a}');
    });
    test(
      'chave inexistente devolve a chave; mensagem propria vence a embutida',
      () {
        expect(t(null, 'nao.existe'), 'nao.existe');
        final custom = resolveComponentsI18n(
          const SgComponentsI18nInput(
            locale: 'pt-BR',
            messages: {'components.actions.clear': 'Apagar'},
          ),
        );
        expect(t(custom, 'components.actions.clear'), 'Apagar');
      },
    );
    test('mensagens por namespace {components: {...}}', () {
      final i = resolveComponentsI18n(
        const SgComponentsI18nInput(
          locale: 'en-US',
          messages: {
            'components': {'components.actions.clear': 'Wipe'},
          },
        ),
      );
      expect(t(i, 'components.actions.clear'), 'Wipe');
    });
  });

  group('estado global (setComponentsI18n/getComponentsI18n)', () {
    test('padrao e en-US', () => expect(getComponentsI18n().locale, 'en-US'));
    test(
      'troca de idioma preserva overrides do mesmo idioma e descarta ao mudar',
      () {
        setComponentsI18n(
          const SgComponentsI18nInput(locale: 'pt-BR', messages: {'k': 'v'}),
        );
        expect(getComponentsI18n().locale, 'pt-BR');
        expect(getComponentsI18n().messages['k'], 'v');
        setComponentsI18n(const SgComponentsI18nInput(messages: {'k2': 'v2'}));
        expect(
          getComponentsI18n().messages['k'],
          'v',
        ); // mesmo locale: preserva
        setComponentsI18n(const SgComponentsI18nInput(locale: 'fr'));
        expect(
          getComponentsI18n().messages.containsKey('k'),
          isFalse,
        ); // locale mudou: descarta
        expect(
          t(null, 'components.wizard.next'),
          componentsMessagesFr['components.wizard.next'],
        );
      },
    );
  });

  group('mensagens dos validadores == TS', () {
    for (final loc in _locales) {
      test('senha $loc', () {
        final i18n = resolveComponentsI18n(SgComponentsI18nInput(locale: loc));
        for (final c
            in ((byLocale[loc] as Map)['password'] as List)
                .cast<Map<String, dynamic>>()) {
          final p = c['policy'] as Map<String, dynamic>;
          final got = passwordValidationMessage(
            validatePassword(
              c['in'] as String,
              PasswordPolicy(
                minSize: p['minSize'] as int?,
                upper: p['upper'] as bool?,
                lower: p['lower'] as bool?,
                number: p['number'] as bool?,
                special: p['special'] as bool?,
                noRepeat: p['noRepeat'] as bool?,
              ),
            ),
            i18n,
          );
          expect(got, c['out'], reason: '$loc ${jsonEncode(c)}');
        }
      });
      test('data de nascimento $loc', () {
        final i18n = resolveComponentsI18n(SgComponentsI18nInput(locale: loc));
        for (final c
            in ((byLocale[loc] as Map)['birthdate'] as List)
                .cast<Map<String, dynamic>>()) {
          final p = c['policy'] as Map<String, dynamic>;
          final got = birthDateValidationMessage(
            validateBirthDate(
              c['value'] as String,
              BirthDatePolicy(
                minAge: p['minAge'] as int?,
                maxAge: p['maxAge'] as int?,
              ),
            ),
            i18n,
          );
          expect(got, c['out'], reason: '$loc ${jsonEncode(c)}');
        }
      });
    }
  });

  group('SgComponentsI18nProvider', () {
    Widget probe(void Function(SgComponentsI18n) onBuild) => Builder(
      builder: (ctx) {
        final i = useComponentsI18n(ctx);
        onBuild(i);
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Text(t(i, 'components.wizard.next')),
        );
      },
    );

    testWidgets('sem provider usa o global', (tester) async {
      await tester.pumpWidget(probe((_) {}));
      expect(
        find.text(componentsMessagesEnUs['components.wizard.next']!),
        findsOneWidget,
      );
    });

    testWidgets('trocar o locale em tempo de execucao reconstroi', (
      tester,
    ) async {
      final seen = <String>[];
      Widget app(String loc) => SgComponentsI18nProvider(
        locale: loc,
        child: probe((i) => seen.add(i.locale)),
      );
      await tester.pumpWidget(app('pt-BR'));
      expect(
        find.text(componentsMessagesPtBr['components.wizard.next']!),
        findsOneWidget,
      );
      await tester.pumpWidget(app('fr'));
      expect(
        find.text(componentsMessagesFr['components.wizard.next']!),
        findsOneWidget,
      );
      await tester.pumpWidget(app('en'));
      expect(
        find.text(componentsMessagesEnUs['components.wizard.next']!),
        findsOneWidget,
      );
      expect(seen, containsAllInOrder(['pt-BR', 'fr', 'en-US']));
    });

    testWidgets('messages proprias do provider sobrepoem as embutidas', (
      tester,
    ) async {
      await tester.pumpWidget(
        SgComponentsI18nProvider(
          locale: 'pt-BR',
          messages: const {'components.wizard.next': 'Avancar'},
          child: probe((_) {}),
        ),
      );
      expect(find.text('Avancar'), findsOneWidget);
    });

    testWidgets('extensao context.sgI18n', (tester) async {
      late SgComponentsI18n got;
      await tester.pumpWidget(
        SgComponentsI18nProvider(
          locale: 'es',
          child: Builder(
            builder: (c) {
              got = c.sgI18n;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(got.locale, 'es');
    });
  });
}
