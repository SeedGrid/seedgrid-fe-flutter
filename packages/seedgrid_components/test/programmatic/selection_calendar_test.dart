// Valor programatico de SgCalendar (vias a, b, d, e, h). O calendario nao liga a formulario (sem name/control),
// entao as vias c e f nao se aplicam. A semantica de `value` controlado ja tem vetores do React em
// test/widgets/calendar_vectors; aqui se cobre o que muda por fora. Ver docs/VALOR_PROGRAMATICO_SELECAO.md.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support/vector_runner.dart';

final _today = DateTime(2026, 3, 15);

Future<void> _mount(WidgetTester t, SgCalendar c, {bool fresh = false}) async {
  if (fresh) await t.pumpWidget(const SizedBox());
  t.view.physicalSize = const Size(1000, 1100);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
  await t.pumpWidget(vectorHost(c, width: 900));
  await frames(t);
}

SgCalendar _cal({
  Object? value,
  Object? defaultValue,
  Object? viewDate,
  Object? minDate,
  Object? maxDate,
  ValueChanged<DateTime>? onValueChange,
}) => SgCalendar(
  today: _today,
  value: value,
  defaultValue: defaultValue,
  viewDate: viewDate,
  minDate: minDate,
  maxDate: maxDate,
  onValueChange: onValueChange,
);

String _selectedText(WidgetTester t) =>
    (t.widget(find.byKey(const ValueKey('calendario-selecionada'))) as Text)
        .data!;

bool _month(int y, int m) =>
    find.byKey(ValueKey('mes-$y-$m')).evaluate().isNotEmpty;

void main() {
  testWidgets(
    'a: sem valor mostra hoje; defaultValue e value mostram a data e o mes dela',
    (t) async {
      await _mount(t, _cal());
      final hoje = _selectedText(t);
      expect(_month(2026, 3), isTrue);
      await _mount(t, _cal(defaultValue: DateTime(2025, 12, 25)), fresh: true);
      expect(_selectedText(t), isNot(hoje));
      expect(_month(2025, 12), isTrue);
      await _mount(t, _cal(value: '2024-02-29'), fresh: true);
      expect(_month(2024, 2), isTrue);
      expect(find.byKey(const ValueKey('dia-2024-02-29')), findsOneWidget);
    },
  );

  testWidgets(
    'b: value muda por fora: outra data (acompanha o mes), mesma, texto invalido e nulo',
    (t) async {
      var n = 0;
      Future<void> set(Object? v) =>
          _mount(t, _cal(value: v, onValueChange: (_) => n++));
      await set(DateTime(2025, 1, 10));
      final jan = _selectedText(t);
      expect(_month(2025, 1), isTrue);
      await set(DateTime(2025, 7, 4));
      expect(_selectedText(t), isNot(jan));
      expect(
        _month(2025, 7),
        isTrue,
        reason: 'o mes visivel acompanha o value',
      );
      await set(DateTime(2025, 7, 4));
      expect(_month(2025, 7), isTrue);
      await set('lixo');
      expect(
        _selectedText(t),
        isNotEmpty,
        reason: 'texto invalido: nao quebra',
      );
      await set(null);
      expect(_selectedText(t), isNotEmpty);
      expect(n, 0, reason: 'mudar por fora nao emite');
    },
  );

  testWidgets('b: value como texto ISO e como DateTime dao o mesmo resultado', (
    t,
  ) async {
    await _mount(t, _cal(value: '2025-05-20'));
    final a = _selectedText(t);
    await _mount(t, _cal(value: DateTime(2025, 5, 20)));
    expect(_selectedText(t), a);
  });

  testWidgets(
    'b: controlado, clicar emite mas a selecao so muda se o pai acompanhar',
    (t) async {
      final got = <DateTime>[];
      await _mount(
        t,
        _cal(value: DateTime(2026, 3, 10), onValueChange: got.add),
      );
      final antes = _selectedText(t);
      await t.tap(find.byKey(const ValueKey('dia-2026-03-20')));
      await frames(t);
      expect(got.single, DateTime(2026, 3, 20));
      expect(_selectedText(t), antes);
    },
  );

  testWidgets(
    'd: minDate/maxDate novos desabilitam a data e clicar nela nao emite',
    (t) async {
      final got = <DateTime>[];
      await _mount(
        t,
        _cal(value: DateTime(2026, 3, 10), onValueChange: got.add),
      );
      await _mount(
        t,
        _cal(
          value: DateTime(2026, 3, 10),
          minDate: DateTime(2026, 3, 12),
          onValueChange: got.add,
        ),
      );
      await t.tap(find.byKey(const ValueKey('dia-2026-03-11')));
      await frames(t);
      expect(got, isEmpty);
      await t.tap(find.byKey(const ValueKey('dia-2026-03-12')));
      await frames(t);
      expect(got.single, DateTime(2026, 3, 12));
    },
  );

  testWidgets(
    'e/g: nao controlado guarda a escolha e value por fora a sobrescreve',
    (t) async {
      final got = <DateTime>[];
      await _mount(
        t,
        _cal(defaultValue: DateTime(2026, 3, 1), onValueChange: got.add),
      );
      await t.tap(find.byKey(const ValueKey('dia-2026-03-09')));
      await frames(t);
      expect(got.single, DateTime(2026, 3, 9));
      final escolhida = _selectedText(t);
      await _mount(
        t,
        _cal(value: DateTime(2026, 3, 22), onValueChange: got.add),
      );
      expect(_selectedText(t), isNot(escolhida));
    },
  );

  testWidgets('b: viewDate por fora muda o mes sem mudar a selecao', (t) async {
    await _mount(t, _cal(value: DateTime(2026, 3, 10)));
    final sel = _selectedText(t);
    await _mount(
      t,
      _cal(value: DateTime(2026, 3, 10), viewDate: DateTime(2027, 8, 1)),
    );
    expect(_month(2027, 8), isTrue);
    expect(_selectedText(t), sel);
  });

  testWidgets(
    'h: sem disabled proprio; datas desabilitadas por isDateDisabled mostram o valor e nao emitem',
    (t) async {
      final got = <DateTime>[];
      await _mount(
        t,
        SgCalendar(
          today: _today,
          value: DateTime(2026, 3, 10),
          isDateDisabled: (d) => d.day == 11,
          onValueChange: got.add,
        ),
      );
      await t.tap(find.byKey(const ValueKey('dia-2026-03-11')));
      await frames(t);
      expect(got, isEmpty);
    },
  );
}
