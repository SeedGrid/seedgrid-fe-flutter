// Regressao (P156): `required` dos multiselects bloqueia o envio do formulario com campo vazio, e o
// SgFileUpload usa a mensagem i18n padrao quando nao ha `requiredMessage` (antes a mensagem ia vazia).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

const _opts = [
  SgMultiSelectOption(label: 'Alpha', value: 'a'),
  SgMultiSelectOption(label: 'Beta', value: 'b'),
];

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(width: 400, child: child),
      ),
    ),
  ),
);

Future<bool> submit(SgFormController form) async {
  var ok = false;
  await form.handleSubmit((_) => ok = true);
  return ok;
}

void main() {
  setUp(resetComponentsI18n);

  group('SgMultiSelect required', () {
    testWidgets(
      'campo vazio bloqueia o envio com a mensagem padrao e libera ao escolher',
      (t) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(
            SgMultiSelect(
              id: 'm',
              name: 'tags',
              control: form,
              options: _opts,
              required: true,
            ),
          ),
        );
        expect(await submit(form), isFalse);
        await t.pump();
        expect(form.errorOf('tags')?.message, 'Required field.');
        form.setValue('tags', ['a']);
        await t.pump();
        expect(await submit(form), isTrue);
      },
    );

    testWidgets('requiredMessage vale sobre a mensagem padrao', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgMultiSelect(
            id: 'm',
            name: 'tags',
            control: form,
            options: _opts,
            required: true,
            requiredMessage: 'Escolha ao menos uma',
          ),
        ),
      );
      expect(await submit(form), isFalse);
      expect(form.errorOf('tags')?.message, 'Escolha ao menos uma');
    });

    testWidgets('sem required o campo vazio passa', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgMultiSelect(id: 'm', name: 'tags', control: form, options: _opts),
        ),
      );
      expect(await submit(form), isTrue);
    });
  });

  group('SgMultiSelectChips required', () {
    testWidgets('campo vazio bloqueia o envio e libera ao escolher', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgMultiSelectChips(
            id: 'c',
            name: 'tags',
            control: form,
            options: _opts,
            required: true,
          ),
        ),
      );
      expect(await submit(form), isFalse);
      await t.pump();
      expect(form.errorOf('tags')?.message, 'Required field.');
      form.setValue('tags', ['b']);
      await t.pump();
      expect(await submit(form), isTrue);
    });

    testWidgets('sem required o campo vazio passa', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgMultiSelectChips(
            id: 'c',
            name: 'tags',
            control: form,
            options: _opts,
          ),
        ),
      );
      expect(await submit(form), isTrue);
    });
  });

  group('SgFileUpload required', () {
    testWidgets('sem requiredMessage usa a mensagem i18n padrao (nao vazia)', (
      t,
    ) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgFileUpload(
            id: 'f',
            name: 'anexo',
            control: form,
            label: 'Anexo',
            required: true,
          ),
        ),
      );
      expect(await submit(form), isFalse);
      await t.pump();
      expect(form.errorOf('anexo')?.message, 'Required field.');
      expect(find.text('Required field.'), findsWidgets);
    });

    testWidgets('requiredMessage vale sobre a mensagem padrao', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgFileUpload(
            id: 'f',
            name: 'anexo',
            control: form,
            label: 'Anexo',
            required: true,
            requiredMessage: 'Anexe o arquivo',
          ),
        ),
      );
      expect(await submit(form), isFalse);
      expect(form.errorOf('anexo')?.message, 'Anexe o arquivo');
    });
  });
}
