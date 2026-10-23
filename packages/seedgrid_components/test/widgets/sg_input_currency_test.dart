import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/number/numeric_field.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 400}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Center(
      child: SizedBox(width: width, child: child),
    ),
  ),
);

Finder field([String id = 'c']) => find.byKey(ValueKey('input-$id'));
String shown(WidgetTester t, [String id = 'c']) =>
    t.widget<TextField>(field(id)).controller!.text;
NumericFieldConfig cfg(WidgetTester t) =>
    t.state<NumericFieldState>(find.byType(NumericField)).c;

Future<void> type(WidgetTester t, String keys, [String id = 'c']) async {
  await t.showKeyboard(field(id));
  for (final k in keys.split('')) {
    await t.enterText(field(id), shown(t, id) + k);
  }
}

void main() {
  setUp(() {
    resetComponentsI18n();
    setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
  });

  group('moeda, simbolo e posicao', () {
    testWidgets('padrao: BRL em pt-BR = prefixo R\$, 2 casas, agrupamento', (
      t,
    ) async {
      await t.pumpWidget(
        host(const SgInputCurrency(id: 'c', labelText: 'Preco')),
      );
      expect(shown(t), '0,00');
      expect(cfg(t).prefixText, r'R$');
      expect(cfg(t).suffixText, isNull);
      await type(t, '1234567');
      expect(shown(t), '1.234.567,00');
    });

    testWidgets(
      'o idioma do provider decide posicao e separadores (en-US, pt-PT, es, fr)',
      (t) async {
        final expected = {
          'en-US': ('0.00', r'R$', null),
          'pt-PT': ('0,00', null, r'R$'),
          'es': ('0,00', null, 'BRL'),
          'fr': ('0,00', null, r'R$'),
        };
        for (final e in expected.entries) {
          setComponentsI18n(SgComponentsI18nInput(locale: e.key));
          await t.pumpWidget(const SizedBox());
          await t.pumpWidget(host(const SgInputCurrency(id: 'c')));
          expect(
            (shown(t), cfg(t).prefixText, cfg(t).suffixText),
            e.value,
            reason: e.key,
          );
        }
      },
    );

    testWidgets(
      'locale proprio da prop vence o idioma (de-DE: sufixo e separadores alemaes)',
      (t) async {
        await t.pumpWidget(
          host(
            const SgInputCurrency(
              id: 'c',
              locale: 'de-DE',
              currency: 'EUR',
              initialValue: '1234.5',
            ),
          ),
        );
        expect(shown(t), '1.234,50');
        expect(cfg(t).suffixText, '€');
      },
    );

    testWidgets('currency: USD, EUR, GBP, JPY (sem casas) e codigo minusculo', (
      t,
    ) async {
      for (final e in {
        'USD': 'US\$',
        'EUR': '€',
        'GBP': '£',
        'usd': 'US\$',
      }.entries) {
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(host(SgInputCurrency(id: 'c', currency: e.key)));
        expect(cfg(t).prefixText, e.value, reason: e.key);
      }
      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(host(const SgInputCurrency(id: 'c', currency: 'JPY')));
      expect(shown(t), '0', reason: 'JPY nao tem casas decimais');
      expect(cfg(t).decimals, 0);
    });

    testWidgets(
      'moeda mal formada cai no codigo em maiusculas e 2 casas (como o React)',
      (t) async {
        await t.pumpWidget(
          host(const SgInputCurrency(id: 'c', currency: 'XXXX')),
        );
        expect(cfg(t).prefixText, 'XXXX');
        expect(cfg(t).decimals, 2);
        expect(cfg(t).decimalSep, '.');
      },
    );

    testWidgets('currencyDisplay: symbol, narrowSymbol, code, name', (t) async {
      for (final e in {
        SgInputCurrencyCurrencyDisplay.symbol: r'R$',
        SgInputCurrencyCurrencyDisplay.narrowSymbol: r'R$',
        SgInputCurrencyCurrencyDisplay.code: 'BRL',
      }.entries) {
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(SgInputCurrency(id: 'c', currencyDisplay: e.key)),
        );
        expect(cfg(t).prefixText, e.value, reason: '${e.key}');
      }
      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(
        host(
          const SgInputCurrency(
            id: 'c',
            currencyDisplay: SgInputCurrencyCurrencyDisplay.name,
          ),
        ),
      );
      expect(
        cfg(t).suffixText,
        'Reais brasileiros',
        reason: 'em pt-BR o nome fica depois do numero',
      );
    });

    testWidgets(
      'currencySymbolPlacement prefix/suffix/auto e currencySymbolOverride',
      (t) async {
        await t.pumpWidget(
          host(
            const SgInputCurrency(
              id: 'c',
              currencySymbolPlacement:
                  SgInputCurrencyCurrencySymbolPlacement.suffix,
            ),
          ),
        );
        expect((cfg(t).prefixText, cfg(t).suffixText), (null, r'R$'));
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            const SgInputCurrency(
              id: 'c',
              currencySymbolOverride: 'pts',
              currencySymbolPlacement:
                  SgInputCurrencyCurrencySymbolPlacement.suffix,
            ),
          ),
        );
        expect(cfg(t).suffixText, 'pts');
      },
    );

    testWidgets(
      'showCurrencySymbol false esconde o simbolo; prefixText/suffixText extras combinam com ele',
      (t) async {
        await t.pumpWidget(
          host(const SgInputCurrency(id: 'c', showCurrencySymbol: false)),
        );
        expect(cfg(t).prefixText, isNull);
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            const SgInputCurrency(
              id: 'c',
              prefixText: 'Total',
              suffixText: '/mes',
            ),
          ),
        );
        expect(cfg(t).prefixText, r'R$ Total');
        expect(cfg(t).suffixText, '/mes');
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            const SgInputCurrency(
              id: 'c',
              locale: 'fr',
              prefixText: 'Total',
              suffixText: '/mois',
            ),
          ),
        );
        expect(cfg(t).prefixText, 'Total');
        expect(cfg(t).suffixText, r'/mois R$');
      },
    );

    testWidgets('useGrouping false tira os separadores de milhar', (t) async {
      await t.pumpWidget(
        host(const SgInputCurrency(id: 'c', useGrouping: false)),
      );
      await type(t, '1234567');
      expect(shown(t), '1234567,00');
    });

    testWidgets('decimals explicito vence as casas da moeda', (t) async {
      await t.pumpWidget(host(const SgInputCurrency(id: 'c', decimals: 4)));
      expect(shown(t), '0,0000');
      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(host(const SgInputCurrency(id: 'c', decimals: 0)));
      expect(shown(t), '0');
    });
  });

  group('valor e interacao', () {
    testWidgets(
      'onChange recebe o valor canonico com ponto; negativo e limpar',
      (t) async {
        final out = <String>[];
        var cleared = 0;
        await t.pumpWidget(
          host(
            SgInputCurrency(
              id: 'c',
              onChange: out.add,
              onClear: () => cleared++,
            ),
          ),
        );
        await type(t, '1234,56');
        expect(out.last, '1234.56');
        await type(t, '-');
        expect(out.last, '-1234.56');
        await t.tap(find.byKey(const ValueKey('clear-c')));
        await t.pump();
        expect(shown(t), '0,00');
        expect(out.last, '0.00');
        expect(cleared, 1);
      },
    );

    testWidgets(
      'allowNegative false, emptyValue nullValue, value e initialValue',
      (t) async {
        await t.pumpWidget(
          host(const SgInputCurrency(id: 'c', allowNegative: false)),
        );
        await type(t, '-3');
        expect(shown(t), '3,00');
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            const SgInputCurrency(
              id: 'c',
              emptyValue: SgInputCurrencyEmptyValue.nullValue,
            ),
          ),
        );
        expect(shown(t), '');
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(host(const SgInputCurrency(id: 'c', value: '99.9')));
        expect(shown(t), '99,90');
        await t.pumpWidget(host(const SgInputCurrency(id: 'c', value: 5)));
        expect(shown(t), '5,00');
      },
    );

    testWidgets(
      'desabilitado / somente leitura nao editam e escondem o botao limpar',
      (t) async {
        final out = <String>[];
        await t.pumpWidget(
          host(SgInputCurrency(id: 'c', disabled: true, onChange: out.add)),
        );
        expect(t.widget<TextField>(field()).enabled, isFalse);
        expect(find.byKey(const ValueKey('clear-c')), findsNothing);
        await t.pumpWidget(
          host(SgInputCurrency(id: 'c', readOnly: true, onChange: out.add)),
        );
        expect(t.widget<TextField>(field()).readOnly, isTrue);
        t
            .widget<TextField>(field())
            .inputFormatters!
            .single
            .formatEditUpdate(
              const TextEditingValue(text: '0,00'),
              const TextEditingValue(text: '0,001'),
            );
        expect(out, isEmpty);
      },
    );

    testWidgets('onEnter (foco) e onExit (blur)', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          Column(
            children: [
              SgInputCurrency(
                id: 'c',
                onEnter: () => log.add('enter'),
                onExit: () => log.add('exit'),
              ),
              const SgInputCurrency(id: 'z'),
            ],
          ),
        ),
      );
      await t.tap(field());
      await t.pump();
      await t.tap(field('z'));
      await t.pump();
      expect(log, ['enter', 'exit']);
    });

    testWidgets(
      'width, withBorder, borderRadius, filled, iconButtons, prefixIcon, hintText, placeholder',
      (t) async {
        final theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);
        await t.pumpWidget(
          host(
            const SgInputCurrency(
              id: 'c',
              width: 200,
              filled: true,
              withBorder: false,
              borderRadius: 12,
              prefixIcon: Icon(Icons.paid),
              iconButtons: [Icon(Icons.info, key: ValueKey('x'))],
            ),
          ),
        );
        expect(t.getSize(find.byType(InputDecorator).first).width, 200);
        final d = t
            .widget<InputDecorator>(find.byType(InputDecorator).first)
            .decoration;
        expect(d.fillColor, theme.mutedSurface);
        expect(
          (d.enabledBorder as OutlineInputBorder).borderSide,
          BorderSide.none,
        );
        expect(
          (d.enabledBorder as OutlineInputBorder).borderRadius,
          BorderRadius.circular(12),
        );
        expect(find.byIcon(Icons.paid), findsOneWidget);
        expect(find.byKey(const ValueKey('x')), findsOneWidget);
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            const SgInputCurrency(
              id: 'c',
              emptyValue: SgInputCurrencyEmptyValue.nullValue,
              hintText: 'dica',
              labelText: 'Preco',
            ),
          ),
        );
        // rotulo flutuante: o hint nao aparece no campo (como o placeholder transparente do React)
        expect(find.text('dica'), findsNothing);
        expect(find.text('Preco'), findsOneWidget);
      },
    );

    testWidgets('label e labelText; required com asterisco', (t) async {
      await t.pumpWidget(
        host(const SgInputCurrency(id: 'c', label: 'Valor', required: true)),
      );
      expect(find.text('Valor *'), findsOneWidget);
      await t.pumpWidget(
        host(const SgInputCurrency(id: 'c', label: 'A', labelText: 'B')),
      );
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('textInputType padrao decimal com sinal; numeric', (t) async {
      await t.pumpWidget(host(const SgInputCurrency(id: 'c')));
      expect(
        t.widget<TextField>(field()).keyboardType,
        const TextInputType.numberWithOptions(decimal: true, signed: true),
      );
      await t.pumpWidget(
        host(
          const SgInputCurrency(
            id: 'c',
            textInputType: SgInputCurrencyTextInputType.numeric,
            allowNegative: false,
          ),
        ),
      );
      expect(
        t.widget<TextField>(field()).keyboardType,
        const TextInputType.numberWithOptions(signed: false),
      );
    });
  });

  group('validacao', () {
    testWidgets(
      'required (zero = vazio), minValue, maxValue, validation, onValidation, mensagens',
      (t) async {
        final msgs = <String?>[];
        await t.pumpWidget(
          host(
            Column(
              children: [
                SgInputCurrency(
                  id: 'a',
                  required: true,
                  onValidation: msgs.add,
                ),
                const SgInputCurrency(
                  id: 'b',
                  minValue: 10,
                  minValueMessage: 'pouco',
                ),
                const SgInputCurrency(id: 'd', maxValue: 5),
                SgInputCurrency(
                  id: 'e',
                  validation: (v) => v == '1.00' ? null : 'so 1',
                  requiredMessage: 'x',
                ),
                const SgInputCurrency(id: 'z'),
              ],
            ),
          ),
        );
        await t.tap(field('a'));
        await t.pump();
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('Campo obrigatório.'), findsOneWidget);
        expect(msgs.last, 'Campo obrigatório.');
        await type(t, '3', 'b');
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('pouco'), findsOneWidget);
        await type(t, '9', 'd');
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('Valor deve ser no máximo 5.'), findsOneWidget);
        await type(t, '2', 'e');
        await t.tap(field('z'));
        await t.pump();
        expect(find.text('so 1'), findsOneWidget);
      },
    );

    testWidgets(
      'error vindo de fora; validateOnBlur false valida a cada tecla',
      (t) async {
        await t.pumpWidget(
          host(const SgInputCurrency(id: 'c', error: 'Cartao recusado')),
        );
        expect(find.text('Cartao recusado'), findsOneWidget);
        await t.pumpWidget(const SizedBox());
        await t.pumpWidget(
          host(
            const SgInputCurrency(id: 'c', maxValue: 3, validateOnBlur: false),
          ),
        );
        await type(t, '5');
        await t.pump();
        expect(find.text('Valor deve ser no máximo 3.'), findsOneWidget);
      },
    );
  });

  group('formulario (name + control + rules)', () {
    testWidgets(
      'valor canonico no formulario, setValue atualiza o campo, submit valida',
      (t) async {
        final form = SgFormController(defaultValues: {'preco': '12.5'});
        Map<String, Object?>? sent;
        Map<String, SgFieldError>? invalid;
        await t.pumpWidget(
          host(
            SgInputCurrency(
              id: 'c',
              name: 'preco',
              control: form,
              required: true,
              requiredMessage: 'Informe o preco',
              rules: SgRules(
                validate: (v) =>
                    (num.tryParse('$v') ?? 0) > 0 ? true : 'maior que zero',
              ),
            ),
          ),
        );
        expect(shown(t), '12,50');
        await type(t, '3');
        expect(
          form.getValue('preco'),
          '12.53',
          reason: 'o 3 entra nos decimais: 12,5 -> 12,53',
        );
        await form.setValue('preco', '0');
        await t.pump();
        expect(shown(t), '0,00');
        await form.handleSubmit((v) => sent = v, (e) => invalid = e);
        await t.pump();
        expect(sent, isNull);
        expect(invalid!['preco']!.message, 'maior que zero');
        expect(find.text('maior que zero'), findsOneWidget);
      },
    );
  });

  testWidgets('[golden] estados do SgInputCurrency', (t) async {
    t.view.physicalSize = const Size(480, 560);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      host(
        const Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SgInputCurrency(
                id: 'g1',
                labelText: 'Preco (BRL, pt-BR)',
                initialValue: '1234567.89',
              ),
              SizedBox(height: 12),
              SgInputCurrency(
                id: 'g2',
                labelText: 'Dolar',
                currency: 'USD',
                locale: 'en-US',
                initialValue: '1234.5',
              ),
              SizedBox(height: 12),
              SgInputCurrency(
                id: 'g3',
                labelText: 'Euro (fr)',
                currency: 'EUR',
                locale: 'fr',
                initialValue: '-1234.5',
              ),
              SizedBox(height: 12),
              SgInputCurrency(
                id: 'g4',
                labelText: 'Com erro',
                error: 'Acima do limite',
                initialValue: '99999',
              ),
              SizedBox(height: 12),
              SgInputCurrency(
                id: 'g5',
                labelText: 'Desabilitado',
                disabled: true,
                initialValue: '10',
              ),
            ],
          ),
        ),
        width: 456,
      ),
    );
    await expectLater(
      find.byType(Column).first,
      matchesGoldenFile('goldens/sg_input_currency_estados.png'),
    );
  });
}
