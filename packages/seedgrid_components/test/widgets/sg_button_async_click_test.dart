// SgButton: onClick pode devolver um Future; o botao fica em loading ate ele terminar ou falhar.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

Widget host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

final spinner = find.byType(CircularProgressIndicator);

void main() {
  testWidgets('Future do onClick liga loading, ignora cliques e volta ao normal', (
    t,
  ) async {
    final c = Completer<void>();
    var calls = 0;
    await t.pumpWidget(
      host(
        SgButton(
          label: const Text('Go'),
          onClick: () {
            calls++;
            return c.future;
          },
        ),
      ),
    );
    expect(spinner, findsNothing);

    await t.tap(find.text('Go'));
    await t.pump();
    expect(calls, 1);
    expect(spinner, findsOneWidget, reason: 'loading durante o Future');

    await t.tap(find.text('Go'));
    await t.pump();
    expect(calls, 1, reason: 'clique ignorado durante o loading');

    c.complete();
    await t.pump();
    await t.pump();
    expect(spinner, findsNothing);

    await t.tap(find.text('Go'));
    await t.pump();
    expect(calls, 2, reason: 'volta a aceitar cliques');
  });

  testWidgets('Future que falha sai do loading e o erro nao e engolido', (
    t,
  ) async {
    final errors = <Object>[];
    await runZonedGuarded(() async {
      final c = Completer<void>();
      await t.pumpWidget(
        host(SgButton(label: const Text('Go'), onClick: () => c.future)),
      );
      await t.tap(find.text('Go'));
      await t.pump();
      expect(spinner, findsOneWidget);

      c.completeError(StateError('boom'));
      await t.pump();
      await t.pump();
      expect(spinner, findsNothing, reason: 'saiu do loading apos falhar');
    }, (e, _) => errors.add(e));
    // O erro nao e engolido: segue como erro nao tratado da zona.
    expect(errors.single, isA<StateError>());
  });

  testWidgets('VoidCallback segue sem loading; loading manual vence; enabled false nao dispara', (
    t,
  ) async {
    var calls = 0;
    await t.pumpWidget(
      host(SgButton(label: const Text('Sync'), onClick: () => calls++)),
    );
    await t.tap(find.text('Sync'));
    await t.pump();
    expect(calls, 1);
    expect(spinner, findsNothing);

    var manual = 0;
    await t.pumpWidget(
      host(
        SgButton(
          label: const Text('Manual'),
          loading: true,
          onClick: () {
            manual++;
            return Completer<void>().future;
          },
        ),
      ),
    );
    expect(spinner, findsOneWidget);
    await t.tap(find.text('Manual'), warnIfMissed: false);
    await t.pump();
    expect(manual, 0);

    var off = 0;
    await t.pumpWidget(
      host(
        SgButton(label: const Text('Off'), enabled: false, onClick: () => off++),
      ),
    );
    await t.tap(find.text('Off'), warnIfMissed: false);
    await t.pump();
    expect(off, 0);
  });
}
