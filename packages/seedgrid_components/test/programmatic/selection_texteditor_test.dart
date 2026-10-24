// Valor programatico de SgTextEditor (valueHtml / defaultValueHtml / name+control). O React usa
// `editor.commands.setContent(html, false)` ao mudar valueHtml (nao emite onChangeHtml). Ver
// docs/VALOR_PROGRAMATICO_SELECAO.md.
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'support/vector_runner.dart';

QuillController _ctrl(WidgetTester t) =>
    t.widget<QuillEditor>(find.byType(QuillEditor)).controller;
String _html(WidgetTester t) =>
    SgTextEditorHtml.fromDelta(_ctrl(t).document.toDelta());

Future<void> _mount(WidgetTester t, Widget w) async {
  t.view.physicalSize = const Size(1000, 1200);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
  await t.pumpWidget(vectorHost(w, width: 900));
  await frames(t);
}

void _type(WidgetTester t, String text) {
  final c = _ctrl(t);
  final end = c.document.length - 1;
  c.replaceText(
    end,
    0,
    text,
    TextSelection.collapsed(offset: end + text.length),
  );
}

void main() {
  const empty = '<p></p>';

  testWidgets('a: defaultValueHtml e valueHtml iniciais', (t) async {
    await _mount(
      t,
      const SgTextEditor(id: 'e', defaultValueHtml: '<p>padrao</p>'),
    );
    expect(_html(t), '<p>padrao</p>');
    await _mount(t, const SgTextEditor(id: 'o', valueHtml: '<h1>titulo</h1>'));
    expect(_html(t), '<h1>titulo</h1>');
    await _mount(t, const SgTextEditor(id: 'v'));
    expect(_html(t), empty);
  });

  testWidgets(
    'b: valueHtml muda por fora: outro, vazio, mesmo, nulo (limpa) sem emitir',
    (t) async {
      final got = <String>[];
      Future<void> set(String? v) =>
          _mount(t, SgTextEditor(id: 'e', valueHtml: v, onChangeHtml: got.add));
      await set('<p>um</p>');
      expect(_html(t), '<p>um</p>');
      await set('<p>dois</p>');
      expect(_html(t), '<p>dois</p>');
      await set('<p>dois</p>');
      expect(_html(t), '<p>dois</p>');
      await set('');
      expect(_html(t), empty);
      await set('<ul><li><p>a</p></li></ul>');
      expect(_html(t), '<ul><li><p>a</p></li></ul>');
      await set(null);
      expect(
        _html(t),
        empty,
        reason: 'pai limpou: o texto antigo nao pode ficar',
      );
      expect(got, isEmpty, reason: 'mudar por fora nao emite');
    },
  );

  testWidgets(
    'b: texto digitado e depois valueHtml por fora sobrescreve; editar emite o HTML',
    (t) async {
      final got = <String>[];
      await _mount(
        t,
        SgTextEditor(id: 'e', valueHtml: '<p>a</p>', onChangeHtml: got.add),
      );
      _type(t, 'b');
      await frames(t);
      expect(got.last, '<p>ab</p>');
      await _mount(
        t,
        SgTextEditor(id: 'e', valueHtml: '<p>novo</p>', onChangeHtml: got.add),
      );
      expect(_html(t), '<p>novo</p>');
      expect(got, ['<p>ab</p>']);
    },
  );

  testWidgets(
    'c: name+control: default, setValue, vazio, nulo, reset, getValue',
    (t) async {
      final form = SgFormController(defaultValues: {'f': '<p>inicial</p>'});
      await _mount(t, SgTextEditor(id: 'e', name: 'f', control: form));
      expect(_html(t), '<p>inicial</p>');
      await form.setValue('f', '<h2>setado</h2>');
      await frames(t);
      expect(_html(t), '<h2>setado</h2>');
      await form.setValue('f', '');
      await frames(t);
      expect(_html(t), empty);
      await form.setValue('f', '<p>de novo</p>');
      await frames(t);
      await form.setValue('f', null);
      await frames(t);
      expect(_html(t), empty, reason: 'setValue(null) limpa');
      _type(t, 'x');
      await frames(t);
      expect(form.getValue('f'), '<p>x</p>');
      form.reset();
      await frames(t);
      expect(_html(t), '<p>inicial</p>');
      form.reset({'f': '<p>outro</p>'});
      await frames(t);
      expect(_html(t), '<p>outro</p>');
    },
  );

  testWidgets('c: sem default, reset depois de digitar limpa o editor', (
    t,
  ) async {
    final form = SgFormController();
    await _mount(t, SgTextEditor(id: 'e', name: 'f', control: form));
    expect(_html(t), empty);
    _type(t, 'abc');
    await frames(t);
    expect(form.getValue('f'), '<p>abc</p>');
    form.reset();
    await frames(t);
    expect(_html(t), empty);
    expect(form.getValue('f'), isNull);
  });

  testWidgets(
    'c: sem default e com defaultValueHtml, o editor mostra o padrao e nao grava sozinho',
    (t) async {
      final form = SgFormController();
      await _mount(
        t,
        SgTextEditor(
          id: 'e',
          name: 'f',
          control: form,
          defaultValueHtml: '<p>padrao</p>',
        ),
      );
      expect(_html(t), '<p>padrao</p>');
      expect(form.getValue('f'), isNull);
    },
  );

  testWidgets('d: HTML invalido ou so texto nao quebra', (t) async {
    final form = SgFormController();
    await _mount(t, SgTextEditor(id: 'e', name: 'f', control: form));
    await form.setValue('f', 'texto sem tag');
    await frames(t);
    expect(_html(t), contains('texto sem tag'));
    await form.setValue('f', '<p>aberto');
    await frames(t);
    expect(_html(t), contains('aberto'));
    await form.setValue('f', 42);
    await frames(t);
    expect(_html(t), empty, reason: 'valor que nao e texto conta como vazio');
  });

  testWidgets(
    'f: required: erro no envio e some ao setValue validando; volta ao esvaziar',
    (t) async {
      final form = SgFormController();
      await _mount(
        t,
        SgTextEditor(
          id: 'e',
          name: 'f',
          control: form,
          rules: const SgRules(required: 'Informe'),
        ),
      );
      await form.handleSubmit((_) {});
      await frames(t);
      expect(find.text('Informe'), findsOneWidget);
      await form.setValue('f', '<p>ok</p>', shouldValidate: true);
      await frames(t);
      expect(find.text('Informe'), findsNothing);
      await form.setValue('f', '', shouldValidate: true);
      await frames(t);
      expect(find.text('Informe'), findsOneWidget);
      form.reset();
      await frames(t);
      expect(find.text('Informe'), findsNothing);
    },
  );

  testWidgets('g: setValue com o editor focado e depois digita no texto novo', (
    t,
  ) async {
    final form = SgFormController();
    await _mount(t, SgTextEditor(id: 'e', name: 'f', control: form));
    await t.tap(find.byType(QuillEditor));
    await frames(t);
    await form.setValue('f', '<p>carregado</p>');
    await frames(t);
    expect(_html(t), '<p>carregado</p>');
    _type(t, '!');
    await frames(t);
    expect(form.getValue('f'), '<p>carregado!</p>');
  });

  testWidgets('h: disabled mostra o valor, que continua mudando por fora', (
    t,
  ) async {
    await _mount(
      t,
      const SgTextEditor(id: 'e', disabled: true, valueHtml: '<p>fixo</p>'),
    );
    expect(_html(t), '<p>fixo</p>');
    expect(_ctrl(t).readOnly, isTrue);
    await _mount(
      t,
      const SgTextEditor(id: 'e', disabled: true, valueHtml: '<p>outro</p>'),
    );
    expect(_html(t), '<p>outro</p>');
  });
}
