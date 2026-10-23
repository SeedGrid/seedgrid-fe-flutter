import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 420}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

Finder star(int n, {String id = 'rating'}) =>
    find.byKey(ValueKey('$id-star-$n'));
Finder cancel({String id = 'rating'}) => find.byKey(ValueKey('$id-cancel'));

/// Nota exibida: soma das fracoes preenchidas (cada estrela e um ClipRect com clipper de fracao).
double shown(WidgetTester t, {String id = 'rating'}) {
  var total = 0.0;
  for (var i = 1; i <= 10; i++) {
    final s = star(i, id: id);
    if (s.evaluate().isEmpty) break;
    final clip = t.widget<ClipRect>(
      find.descendant(of: s, matching: find.byType(ClipRect)),
    );
    final size = t.getSize(
      find.descendant(of: s, matching: find.byType(ClipRect)),
    );
    final rect = clip.clipper!.getClip(size);
    total += rect.width / size.width;
  }
  return total;
}

Future<void> tapStar(WidgetTester t, int n, {bool leftHalf = false}) async {
  final r = t.getRect(star(n));
  await t.tapAt(Offset(leftHalf ? r.left + 2 : r.right - 2, r.center.dy));
  await t.pump();
}

void main() {
  setUp(resetComponentsI18n);

  testWidgets('5 estrelas por padrao, nota inicial value (padrao 0)', (
    t,
  ) async {
    await t.pumpWidget(host(const SgRating()));
    expect(star(5), findsOneWidget);
    expect(star(6), findsNothing);
    expect(shown(t), 0);
    await t.pumpWidget(host(const SgRating(key: ValueKey('v'), value: 3)));
    expect(shown(t), 3);
  });

  testWidgets('stars define a quantidade', (t) async {
    await t.pumpWidget(host(const SgRating(stars: 3)));
    expect(star(3), findsOneWidget);
    expect(star(4), findsNothing);
  });

  testWidgets('clicar na estrela n da nota n e onChange recebe o numero', (
    t,
  ) async {
    final changes = <num>[];
    await t.pumpWidget(host(SgRating(onChange: changes.add)));
    await tapStar(t, 4);
    expect(changes, [4]);
    expect(shown(t), 4);
    await tapStar(t, 2);
    expect(changes, [4, 2]);
    expect(shown(t), 2);
  });

  testWidgets(
    'allowHalf: metade esquerda = n+0.5 (indice da estrela), metade direita = n+1; sem allowHalf so inteiro',
    (t) async {
      final changes = <num>[];
      await t.pumpWidget(
        host(SgRating(allowHalf: true, onChange: changes.add)),
      );
      await tapStar(t, 3, leftHalf: true);
      expect(changes.last, 2.5);
      expect(shown(t), closeTo(2.5, 0.001));
      await tapStar(t, 3);
      expect(changes.last, 3);
      await t.pumpWidget(
        host(SgRating(key: const ValueKey('n'), onChange: changes.add)),
      );
      await tapStar(t, 3, leftHalf: true);
      expect(
        changes.last,
        3,
        reason: 'sem allowHalf, metade esquerda tambem vale inteiro',
      );
    },
  );

  testWidgets('cancel zera a nota; cancel false esconde o botao', (t) async {
    final changes = <num>[];
    await t.pumpWidget(host(SgRating(value: 4, onChange: changes.add)));
    expect(cancel(), findsOneWidget);
    await t.tap(cancel());
    await t.pump();
    expect(changes, [0]);
    expect(shown(t), 0);
    await t.pumpWidget(
      host(const SgRating(key: ValueKey('nc'), cancel: false)),
    );
    expect(cancel(), findsNothing);
  });

  testWidgets('disabled e readOnly nao mudam a nota', (t) async {
    final changes = <num>[];
    await t.pumpWidget(
      host(SgRating(disabled: true, value: 2, onChange: changes.add)),
    );
    await tapStar(t, 5);
    await t.tap(cancel());
    expect(changes, isEmpty);
    expect(shown(t), 2);
    expect(
      t
          .widget<Opacity>(
            find.ancestor(of: star(1), matching: find.byType(Opacity)).first,
          )
          .opacity,
      0.5,
    );
    await t.pumpWidget(
      host(
        SgRating(
          key: const ValueKey('ro'),
          readOnly: true,
          value: 2,
          onChange: changes.add,
        ),
      ),
    );
    await tapStar(t, 5);
    expect(changes, isEmpty);
    expect(shown(t), 2);
  });

  testWidgets('value novo do pai atualiza a nota (efeito do React)', (t) async {
    await t.pumpWidget(host(const SgRating(value: 1)));
    await t.pumpWidget(host(const SgRating(value: 4)));
    expect(shown(t), 4);
  });

  testWidgets(
    'hover: onHover recebe a nota sob o ponteiro e null ao sair; mostra a nota provisoria',
    (t) async {
      final hovers = <num?>[];
      await t.pumpWidget(
        host(SgRating(allowHalf: true, value: 1, onHover: hovers.add)),
      );
      final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      final r = t.getRect(star(3));
      await mouse.moveTo(Offset(r.left + 2, r.center.dy));
      await t.pump();
      expect(hovers.last, 2.5);
      expect(
        shown(t),
        closeTo(2.5, 0.001),
        reason: 'mostra o hover no lugar do valor',
      );
      await mouse.moveTo(Offset(r.right - 2, r.center.dy));
      await t.pump();
      expect(hovers.last, 3);
      await mouse.moveTo(const Offset(5, 5));
      await t.pump();
      expect(hovers.last, isNull);
      expect(shown(t), 1);
    },
  );

  testWidgets(
    'showTooltip mostra a nota acima da estrela sob o ponteiro; sem showTooltip nao',
    (t) async {
      await t.pumpWidget(host(const SgRating(showTooltip: true)));
      final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(t.getCenter(star(2)));
      await t.pump();
      expect(find.byKey(const ValueKey('rating-tooltip')), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      await t.pumpWidget(host(const SgRating(key: ValueKey('nt'))));
      await mouse.moveTo(t.getCenter(star(2)));
      await t.pump();
      expect(find.byKey(const ValueKey('rating-tooltip')), findsNothing);
    },
  );

  testWidgets('size: sm 16, md 24, lg 32, xl 40', (t) async {
    for (final e in {
      SgRatingSize.sm: 16.0,
      SgRatingSize.md: 24.0,
      SgRatingSize.lg: 32.0,
      SgRatingSize.xl: 40.0,
    }.entries) {
      await t.pumpWidget(host(SgRating(key: ValueKey(e.key), size: e.key)));
      expect(t.getSize(star(1)), Size.square(e.value), reason: '${e.key}');
    }
  });

  testWidgets('label, asterisco de obrigatorio e error', (t) async {
    await t.pumpWidget(
      host(const SgRating(label: 'Nota', required: true, error: 'Avalie')),
    );
    expect(find.textContaining('Nota'), findsOneWidget);
    expect(find.textContaining('*'), findsOneWidget);
    expect(find.text('Avalie'), findsOneWidget);
  });

  testWidgets(
    'required: cancelar mostra a mensagem do i18n (ou a propria) e avaliar limpa',
    (t) async {
      await t.pumpWidget(host(const SgRating(required: true, value: 3)));
      await t.tap(cancel());
      await t.pump();
      expect(find.text('Please provide a rating'), findsOneWidget);
      await tapStar(t, 2);
      expect(find.text('Please provide a rating'), findsNothing);
      await t.pumpWidget(
        host(
          const SgRating(
            key: ValueKey('m'),
            required: true,
            requiredMessage: 'Avalie o produto',
            value: 3,
          ),
        ),
      );
      await t.tap(cancel());
      await t.pump();
      expect(find.text('Avalie o produto'), findsOneWidget);
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(const SgRating(key: ValueKey('pt'), required: true, value: 3)),
      );
      await t.tap(cancel());
      await t.pump();
      expect(find.textContaining('avalia'), findsOneWidget);
    },
  );

  testWidgets('onIcon, offIcon e cancelIcon proprios', (t) async {
    await t.pumpWidget(
      host(
        const SgRating(
          stars: 2,
          onIcon: Icon(Icons.favorite),
          offIcon: Icon(Icons.favorite_border),
          cancelIcon: Icon(Icons.clear),
          value: 1,
        ),
      ),
    );
    expect(
      find.byIcon(Icons.favorite),
      findsNWidgets(2),
      reason: 'a camada cheia existe em cada estrela (cortada pela fracao)',
    );
    expect(find.byIcon(Icons.favorite_border), findsNWidgets(2));
    expect(find.byIcon(Icons.clear), findsOneWidget);
    expect(shown(t), 1);
  });

  testWidgets(
    'color e emptyColor aceitam #hex, rgb() e hsl(var(--token)); valor invalido cai no padrao',
    (t) async {
      for (final c in [
        '#FF0000',
        'rgb(0 128 0)',
        'hsl(var(--primary))',
        'nao-e-cor',
      ]) {
        await t.pumpWidget(
          host(SgRating(key: ValueKey(c), color: c, emptyColor: c, value: 2)),
        );
        expect(shown(t), 2, reason: c);
      }
    },
  );

  testWidgets(
    'teclado (extra do Flutter): setas ajustam, Home zera, End vai ao maximo',
    (t) async {
      final changes = <num>[];
      await t.pumpWidget(
        host(SgRating(allowHalf: true, onChange: changes.add)),
      );
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      expect(changes, [0.5, 1.0]);
      await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      expect(changes.last, 0.5);
      await t.sendKeyEvent(LogicalKeyboardKey.end);
      expect(changes.last, 5);
      await t.sendKeyEvent(LogicalKeyboardKey.home);
      expect(changes.last, 0);
    },
  );

  group('ligado ao formulario', () {
    testWidgets('nota vem do formulario e a avaliacao volta para ele', (
      t,
    ) async {
      final form = SgFormController(defaultValues: {'nota': 2});
      final changes = <num>[];
      await t.pumpWidget(
        host(
          SgRating(
            id: 'rating',
            name: 'nota',
            control: form,
            onChange: changes.add,
          ),
        ),
      );
      expect(shown(t), 2);
      await tapStar(t, 5);
      expect(form.getValue('nota'), 5);
      expect(changes, [5], reason: 'onChange tambem dispara, como no React');
      await form.setValue('nota', 1);
      await t.pump();
      expect(shown(t), 1);
    });

    testWidgets('sem valor no formulario comeca em 0', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(SgRating(id: 'rating', name: 'nota', control: form)),
      );
      expect(shown(t), 0);
    });

    testWidgets(
      'required: envio sem nota mostra a mensagem do rating e avaliar corrige',
      (t) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(
            SgRating(id: 'rating', name: 'nota', control: form, required: true),
          ),
        );
        await form.handleSubmit((_) {});
        await t.pump();
        expect(find.text('Please provide a rating'), findsOneWidget);
        await tapStar(t, 3);
        await t.pumpAndSettle();
        expect(find.text('Please provide a rating'), findsNothing);
      },
    );

    testWidgets('SgForm mais proximo', (t) async {
      Map<String, Object?>? sent;
      await t.pumpWidget(
        host(
          SgForm(
            onValid: (v) => sent = v,
            child: const Column(
              children: [
                SgRating(id: 'rating', name: 'nota'),
                SgButton(label: Text('Enviar'), type: SgButtonType.submit),
              ],
            ),
          ),
        ),
      );
      await tapStar(t, 4);
      await t.tap(find.text('Enviar'));
      await t.pumpAndSettle();
      expect(sent, {'nota': 4});
    });
  });

  testWidgets('[golden] estados da avaliacao', (t) async {
    t.view.physicalSize = const Size(460, 520);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SgRating(id: 'g1', label: 'Padrao', value: 3),
            SizedBox(height: 12),
            SgRating(
              id: 'g2',
              label: 'Meia estrela',
              allowHalf: true,
              value: 2.5,
              cancel: false,
            ),
            SizedBox(height: 12),
            SgRating(
              id: 'g3',
              label: 'Tamanho xl',
              size: SgRatingSize.xl,
              value: 4,
              cancel: false,
            ),
            SizedBox(height: 12),
            SgRating(
              id: 'g4',
              label: 'Cores',
              color: '#E11D48',
              emptyColor: '#9CA3AF',
              value: 2,
              cancel: false,
            ),
            SizedBox(height: 12),
            SgRating(
              id: 'g5',
              label: 'Obrigatoria',
              required: true,
              error: 'Avalie',
              cancel: false,
            ),
            SizedBox(height: 12),
            SgRating(
              id: 'g6',
              label: 'Desabilitada',
              disabled: true,
              value: 3,
              cancel: false,
            ),
          ],
        ),
        width: 436,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_rating_estados.png'),
    );
  });
}
