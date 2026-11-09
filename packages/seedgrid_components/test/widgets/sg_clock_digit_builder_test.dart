// `digitBuilder` do SgClock: desenho proprio do digital, sem registro global, quando `digitalStyle` e `custom`.
// Mesmo contrato do React (`digitBuilder(parts)` em tests/clock-digit-builder-dom.test.mjs).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: child,
      ),
    ),
  ),
);

void main() {
  testWidgets('custom + digitBuilder desenha os digitos recebidos', (t) async {
    final received = <SgClockDigitalParts>[];
    await t.pumpWidget(
      host(
        SgClock(
          digitalStyle: SgClockDigitalStyle.custom,
          initialServerTime: '2026-06-15T15:41:07Z',
          timezone: 'UTC',
          locale: 'en-US',
          digitBuilder: (context, parts) {
            received.add(parts);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [for (final ch in parts.text.split('')) Text(ch)],
            );
          },
        ),
      ),
    );
    await t.pump();
    await t.pump();

    final parts = received.first;
    expect(parts.hour, '15');
    expect(parts.minute, '41');
    expect(parts.second, '07');
    expect(parts.text, '15:41:07');
    expect(parts.is12h, false);
    expect(parts.dayPeriod, isNull);
    expect(parts.showSeconds, true);
    expect(parts.size, 'md');
    expect(parts.sizePx, 16);
    expect(find.text('4'), findsOneWidget);
    expect(find.text(':'), findsNWidgets(2));
  });

  testWidgets('12h sem segundos entrega periodo e segundos vazios', (t) async {
    SgClockDigitalParts? got;
    await t.pumpWidget(
      host(
        SgClock(
          digitalStyle: SgClockDigitalStyle.custom,
          format: SgClockFormat.v12h,
          showSeconds: false,
          size: 'lg',
          initialServerTime: '2026-06-15T15:41:07Z',
          timezone: 'UTC',
          locale: 'en-US',
          digitBuilder: (context, parts) {
            got = parts;
            return Text(parts.textWithPeriod, key: const ValueKey('c'));
          },
        ),
      ),
    );
    await t.pump();
    await t.pump();

    expect(got, isNotNull);
    expect(got!.is12h, true);
    expect(got!.showSeconds, false);
    expect(got!.second, '');
    expect(got!.text, '03:41');
    expect(got!.dayPeriod?.toUpperCase(), 'PM');
    expect(got!.sizePx, 28);
    expect(t.widget<Text>(find.byKey(const ValueKey('c'))).data, '03:41 PM');
  });

  testWidgets(
    'custom sem digitBuilder cai no default; builder e ignorado em outros estilos',
    (t) async {
      await t.pumpWidget(
        host(
          const SgClock(
            digitalStyle: SgClockDigitalStyle.custom,
            initialServerTime: '2026-06-15T15:41:07Z',
            timezone: 'UTC',
          ),
        ),
      );
      await t.pump();
      await t.pump();
      expect(find.text('15:41:07'), findsOneWidget);

      var called = false;
      await t.pumpWidget(
        host(
          SgClock(
            initialServerTime: '2026-06-15T15:41:07Z',
            timezone: 'UTC',
            digitBuilder: (context, parts) {
              called = true;
              return const SizedBox();
            },
          ),
        ),
      );
      await t.pump();
      await t.pump();
      expect(called, false);
      expect(find.text('15:41:07'), findsOneWidget);
    },
  );
}
