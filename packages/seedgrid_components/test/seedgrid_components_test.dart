// Conferencia do gerador de props: o que o Dart expoe bate com o que o compilador do TypeScript
// extraiu do React (tools/gen_props/props-spec.json) menos as props omitidas de proposito.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

void main() {
  final spec =
      jsonDecode(
            File('../../tools/gen_props/props-spec.json').readAsStringSync(),
          )
          as Map<String, dynamic>;
  final exc =
      jsonDecode(File('../../tools/gen_props/excecoes.json').readAsStringSync())
          as Map<String, dynamic>;
  final components = spec['components'] as Map<String, dynamic>;

  test('todo componente do React tem especificacao em Dart', () {
    expect(sgPropSpecs.keys.toSet(), components.keys.toSet());
    expect(components.length, 89);
  });

  test(
    'props por componente = props do React menos as omitidas (nada some em silencio)',
    () {
      final omitted = <String, int>{};
      for (final o in (exc['omitidas'] as List).cast<Map<String, dynamic>>()) {
        omitted.update(
          o['componente'] as String,
          (v) => v + 1,
          ifAbsent: () => 1,
        );
      }
      components.forEach((name, c) {
        final total = ((c as Map<String, dynamic>)['props'] as List).length;
        expect(
          sgPropSpecs[name]!.length,
          total - (omitted[name] ?? 0),
          reason: name,
        );
      });
    },
  );

  test(
    'SgButton: severity, appearance e size com os mesmos valores do React',
    () {
      final byName = {for (final p in sgPropSpecs['SgButton']!) p.name: p};
      expect(byName['severity']!.values, [
        'primary',
        'secondary',
        'success',
        'warning',
        'danger',
        'info',
        'help',
      ]);
      expect(byName['severity']!.defaultValue, 'primary');
      expect(byName['appearance']!.values, ['solid', 'outline', 'ghost']);
      expect(byName['size']!.values, ['sm', 'md', 'lg']);
      expect(SgSeverity.fromValue('danger'), SgSeverity.danger);
      expect(SgSeverity.danger.value, 'danger');
      expect(SgSeverity.fromValue('nao-existe'), isNull);
    },
  );

  test(
    'enabled vira disabled e children vira child, com o nome do React guardado',
    () {
      final input = {for (final p in sgPropSpecs['SgInputText']!) p.name: p};
      expect(input.containsKey('enabled'), isFalse);
      expect(input['disabled']!.reactName, 'enabled');
      expect(input['disabled']!.type, 'bool?');
      expect(input.containsKey('className'), isFalse);
      expect(input.containsKey('register'), isFalse);
    },
  );

  test(
    'tipos sem traducao exata estao marcados (exact: false) e listados em excecoes.json',
    () {
      final generic = (exc['tipoGenerico'] as List).length;
      final marked = sgPropSpecs.values
          .expand((l) => l)
          .where((p) => !p.exact)
          .length;
      expect(marked, generic);
      expect(generic, greaterThan(0));
    },
  );
}
