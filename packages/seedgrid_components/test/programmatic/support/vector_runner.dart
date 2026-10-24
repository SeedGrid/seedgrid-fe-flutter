// Executor dos cenarios de "valor programatico" (test/programmatic/react_vectors/vectors.json, gerado pelo React REAL).
// Cada componente tem um [VectorAdapter] (como montar, agir e ler o que o usuario ve) e o mesmo cenario JSON que o
// React executou roda aqui; cada instantaneo (`snap`) e comparado com o do React.
// Divergencias conscientes (defeito do React ou limite do Dart) entram em `overrides`, cada uma documentada em
// docs/VALOR_PROGRAMATICO_SELECAO.md.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget vectorHost(Widget child, {double width = 420, double height = 900}) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: SgTheme.fromInput(
        defaultSeedTheme,
        Brightness.light,
      ).toThemeData(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: width,
              child: SingleChildScrollView(child: child),
            ),
          ),
        ),
      ),
    );

/// Estado de um cenario em execucao.
class ScenarioState {
  ScenarioState(this.scenario)
    : props = Map<String, Object?>.of(
        (scenario['props'] as Map?)?.cast<String, Object?>() ?? const {},
      ),
      items = scenario['items'] == null
          ? null
          : jsonDecode(jsonEncode(scenario['items'])) as List<Object?>,
      form = scenario['form'] == null
          ? null
          : SgFormController(
              defaultValues: Map<String, Object?>.of(
                ((scenario['form'] as Map)['defaults'] as Map)
                    .cast<String, Object?>(),
              ),
            );

  final Map<String, Object?> scenario;
  final Map<String, Object?> props;
  List<Object?>? items;
  final SgFormController? form;
  final List<Object?> events = [];

  String get sourceKind => (scenario['sourceKind'] as String?) ?? 'list';
  int get delay => (scenario['delay'] as num?)?.toInt() ?? 0;

  /// Regra do formulario (`required: true` -> mensagem 'Obrigatorio', igual ao harness do React).
  SgRules? get rules {
    final r = (scenario['form'] as Map?)?['rules'] as Map?;
    if (r == null) return null;
    return SgRules(
      required: r['required'] == true ? 'Obrigatorio' : r['required'],
    );
  }

  /// Valor da prop do cenario (`{$unset: true}` vira nulo: o Dart nao distingue nulo de ausente).
  Object? prop(String key) {
    final v = props[key];
    if (v is Map && v['\$unset'] == true) return null;
    return v;
  }
}

abstract class VectorAdapter {
  /// Chave em vectors.json.
  String get component;

  Widget build(ScenarioState s);

  /// Passos de UI do componente (open, pick, toggle...). Ja com `pump` ao final fica a cargo do runner.
  Future<void> ui(WidgetTester t, Map<String, Object?> step, ScenarioState s);

  Map<String, Object?> snapshot(WidgetTester t, ScenarioState s);
}

/// Tres quadros (a lista e o texto do campo aparecem/acompanham o valor um quadro depois).
Future<void> frames(WidgetTester t, [int n = 4]) async {
  for (var i = 0; i < n; i++) {
    await t.pump();
  }
}

Object? _norm(Object? v) => v == null ? null : jsonDecode(jsonEncode(v));

bool _same(Object? a, Object? b) {
  if (a is num && b is num) return a == b;
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!_same(a[i], b[i])) return false;
    }
    return true;
  }
  if (a is Map && b is Map) {
    if (a.length != b.length) return false;
    for (final k in a.keys) {
      if (!b.containsKey(k) || !_same(a[k], b[k])) return false;
    }
    return true;
  }
  return a == b;
}

List<Map<String, Object?>> loadVectors(String component) {
  final all =
      jsonDecode(
            File(
              'test/programmatic/react_vectors/vectors.json',
            ).readAsStringSync(),
          )
          as Map<String, Object?>;
  return [
    for (final sc in (all[component] as List))
      (sc as Map).cast<String, Object?>(),
  ];
}

/// Registra um `testWidgets` por cenario.
///  - [overrides]: 'idDoCenario|rotuloDoSnap' -> campos que diferem do React (mesclados no esperado).
///  - [skip]: cenarios que nao se aplicam (id -> motivo).
///  - [skipEventsInForm]: no React o `Controller` troca o onChange/onValueChange do usuario pelo do formulario (o
///    callback do usuario nao e chamado com `name`+`control`); o Flutter chama os dois. Nao compara `events` com formulario.
void runVectors(
  VectorAdapter adapter, {
  Map<String, Map<String, Object?>> overrides = const {},
  Map<String, String> skip = const {},
  Size surface = const Size(800, 1000),
  bool skipEventsInForm = false,
}) {
  final scenarios = loadVectors(adapter.component);
  group('vetores do React: ${adapter.component}', () {
    setUp(resetComponentsI18n);
    for (final sc in scenarios) {
      final id = sc['id'] as String;
      testWidgets(id, (t) async {
        if (sc['error'] != null) {
          fail('o React falhou ao gerar o vetor: ${sc['error']}');
        }
        t.view.physicalSize = surface;
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.reset);
        final s = ScenarioState(sc);
        await t.pumpWidget(vectorHost(adapter.build(s)));
        await frames(t);
        final expected = (sc['expected'] as List).cast<Map>();
        var snapIndex = 0;
        final problems = <String>[];
        for (final raw in (sc['steps'] as List)) {
          final step = (raw as Map).cast<String, Object?>();
          switch (step['op']) {
            case 'props':
              for (final e in (step['set'] as Map).entries) {
                s.props[e.key as String] = e.value;
              }
              await t.pumpWidget(vectorHost(adapter.build(s)));
              await frames(t);
            case 'items':
              s.items = jsonDecode(jsonEncode(step['items'])) as List<Object?>;
              await t.pumpWidget(vectorHost(adapter.build(s)));
              await frames(t);
            case 'wait':
              await t.pump(Duration(milliseconds: (step['ms'] as num).toInt()));
              await frames(t);
            case 'form.setValue':
              await s.form!.setValue(
                'f',
                _norm(step['value']),
                shouldValidate: step['shouldValidate'] == true,
              );
              await frames(t);
            case 'form.reset':
              final v = step['values'] as Map?;
              s.form!.reset(v?.cast<String, Object?>());
              await frames(t);
            case 'form.trigger':
              await s.form!.trigger(['f']);
              await frames(t);
            case 'snap':
              await frames(t);
              final exp = Map<String, Object?>.of(
                expected[snapIndex].cast<String, Object?>(),
              );
              final label = exp['label'] as String?;
              final ov = overrides['$id|$label'];
              if (ov != null) exp.addAll(ov);
              snapIndex++;
              final act = <String, Object?>{
                'label': label,
                ...adapter.snapshot(t, s),
                'events': _norm(s.events),
              };
              if (s.form != null) {
                final err = s.form!.errorOf('f');
                act['form'] = {
                  'value': _norm(s.form!.getValue('f')),
                  'error': err?.message,
                };
              }
              for (final k in exp.keys) {
                if (k == 'events' && skipEventsInForm && s.form != null) {
                  continue;
                }
                if (!_same(_norm(act[k]), exp[k])) {
                  problems.add(
                    '[$label] $k: React=${jsonEncode(exp[k])} Flutter=${jsonEncode(_norm(act[k]))}',
                  );
                }
              }
            default:
              await adapter.ui(t, step, s);
              await frames(t);
          }
        }
        expect(problems, isEmpty, reason: '$id\n${problems.join('\n')}');
      }, skip: skip.containsKey(id));
    }
  });
}
