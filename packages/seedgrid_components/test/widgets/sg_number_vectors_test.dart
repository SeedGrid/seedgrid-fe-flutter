// Paridade com o React: cada cenario de number_vectors/vectors.json foi executado pelo componente
// REAL do React num jsdom (tecla por tecla). Aqui o mesmo cenario roda no widget Flutter e o campo
// (display), o valor emitido em onChange e os afixos precisam ser iguais.
// Regerar: node test/widgets/number_vectors/generate.mjs <pacote react>.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/number/numeric_field.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Center(child: SizedBox(width: 400, child: child)),
  ),
);

SgInputCurrencyCurrencyDisplay? _display(Object? v) =>
    v == null ? null : SgInputCurrencyCurrencyDisplay.fromValue(v as String);

Widget buildScenario(Map<String, dynamic> s, List<String> emitted) {
  final p = (s['props'] as Map<String, dynamic>);
  final initial = (p['inputProps'] as Map<String, dynamic>?)?['value'];
  if (s['component'] == 'number') {
    return SgInputNumber(
      id: 'x',
      decimals: p['decimals'] as int?,
      allowNegative: p['allowNegative'] as bool?,
      emptyValue: p['emptyValue'] == null
          ? null
          : SgInputNumberEmptyValue.fromValue(p['emptyValue'] as String),
      value: initial,
      onChange: emitted.add,
    );
  }
  return SgInputCurrency(
    id: 'x',
    currency: p['currency'] as String?,
    locale: p['locale'] as String?,
    currencyDisplay: _display(p['currencyDisplay']),
    currencySymbolPlacement: p['currencySymbolPlacement'] == null
        ? null
        : SgInputCurrencyCurrencySymbolPlacement.fromValue(
            p['currencySymbolPlacement'] as String,
          ),
    currencySymbolOverride: p['currencySymbolOverride'] as String?,
    showCurrencySymbol: p['showCurrencySymbol'] as bool?,
    useGrouping: p['useGrouping'] as bool?,
    decimals: p['decimals'] as int?,
    prefixText: p['prefixText'] as String?,
    suffixText: p['suffixText'] as String?,
    emptyValue: p['emptyValue'] == null
        ? null
        : SgInputCurrencyEmptyValue.fromValue(p['emptyValue'] as String),
    allowNegative: p['allowNegative'] as bool?,
    value: initial,
    onChange: emitted.add,
  );
}

void main() {
  final doc =
      jsonDecode(
            File('test/widgets/number_vectors/vectors.json').readAsStringSync(),
          )
          as Map<String, dynamic>;
  final scenarios = (doc['scenarios'] as List).cast<Map<String, dynamic>>();

  // Passos que o React trata por um caminho que o teclado do Flutter nao tem (documentado no relatorio):
  //  - {input: ''}: `handleChange` com texto vazio (programatico); no Flutter, apagar tudo e Backspace.
  //  - 'Enter' e outras teclas nao imprimiveis: nao produzem texto, logo nao chegam ao campo.
  bool comparable(Object? action) {
    if (action is Map && action['input'] == '') return false;
    if (action is Map &&
        action['key'] is String &&
        (action['key'] as String).length > 1 &&
        action['key'] != 'Backspace' &&
        action['key'] != 'Delete') {
      return false;
    }
    return true;
  }

  setUp(resetComponentsI18n);

  testWidgets(
    '${scenarios.length} cenarios do React (digitar, colar, apagar, limpar, locales, moedas) batem',
    (t) async {
      final failures = <String>[];
      var steps = 0;
      for (final s in scenarios) {
        setComponentsI18n(SgComponentsI18nInput(locale: s['locale'] as String));
        final emitted = <String>[];
        await t.pumpWidget(
          const SizedBox(),
        ); // desmonta o cenario anterior: o State nao pode vazar
        await t.pumpWidget(host(buildScenario(s, emitted)));
        final field = find.byKey(const ValueKey('input-x'));
        final recorded = (s['steps'] as List).cast<Map<String, dynamic>>();
        String shown() => t.widget<TextField>(field).controller!.text;
        String where(int i) => '${s['id']} passo $i';

        // inicial
        if (shown() != recorded[0]['display']) {
          failures.add(
            '${where(0)}: display "${shown()}" != "${recorded[0]['display']}"',
          );
        }
        final fieldState = t.state<NumericFieldState>(
          find.byType(NumericField),
        );
        if (fieldState.c.prefixText != recorded[0]['prefix']) {
          failures.add(
            '${where(0)}: prefixo "${fieldState.c.prefixText}" != "${recorded[0]['prefix']}"',
          );
        }
        if (fieldState.c.suffixText != recorded[0]['suffix']) {
          failures.add(
            '${where(0)}: sufixo "${fieldState.c.suffixText}" != "${recorded[0]['suffix']}"',
          );
        }

        await t.showKeyboard(field);
        final actions = (s['steps'] as List)
            .skip(1)
            .map((e) => (e as Map<String, dynamic>)['action'])
            .toList();
        for (var i = 0; i < actions.length; i++) {
          final a = actions[i] as Map<String, dynamic>;
          final rec = recorded[i + 1];
          if (!comparable(a)) continue;
          final before = emitted.length;
          if (a['key'] != null) {
            final k = a['key'] as String;
            final cur = shown();
            if (k == 'Backspace' || k == 'Delete') {
              if (cur.isEmpty) {
                // React com campo vazio: so troca para zero se emptyValue=zero (campo nunca fica vazio nesse caso)
              } else {
                await t.enterText(field, cur.substring(0, cur.length - 1));
              }
            } else {
              await t.enterText(field, cur + k);
            }
          } else if (a['input'] != null) {
            await t.enterText(field, a['input'] as String);
          } else if (a['paste'] != null) {
            await t.enterText(field, shown() + (a['paste'] as String));
          } else if (a['clear'] == true) {
            await t.tap(find.byKey(const ValueKey('clear-x')));
            await t.pump();
          }
          steps++;
          final gotEmitted = emitted.length > before ? emitted.last : null;
          if (shown() != rec['display']) {
            failures.add(
              '${where(i + 1)} ${jsonEncode(a)}: display "${shown()}" != "${rec['display']}"',
            );
          }
          if (gotEmitted != rec['emitted']) {
            failures.add(
              '${where(i + 1)} ${jsonEncode(a)}: emitido "$gotEmitted" != "${rec['emitted']}"',
            );
          }
        }
      }
      expect(
        steps,
        greaterThan(4000),
        reason: 'o teste precisa comparar milhares de passos de verdade',
      );
      expect(
        failures,
        isEmpty,
        reason:
            '${failures.length} divergencias em $steps passos; primeiras:\n${failures.take(25).join('\n')}',
      );
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
