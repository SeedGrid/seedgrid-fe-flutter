import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_components/src/inputs/editor/sg_text_editor_toolbar.dart';
import 'package:seedgrid_components/src/inputs/editor_inputs.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child, {double width = 900}) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  ),
);

Finder tb(String id, String name) =>
    find.byKey(ValueKey('texteditor-$id-tb-$name'));
QuillController ctrl(WidgetTester t) =>
    t.widget<QuillEditor>(find.byType(QuillEditor)).controller;
String htmlOf(WidgetTester t) =>
    SgTextEditorHtml.fromDelta(ctrl(t).document.toDelta());

void select(WidgetTester t, int from, int to) => ctrl(t).updateSelection(
  TextSelection(baseOffset: from, extentOffset: to),
  ChangeSource.local,
);

Future<void> pickMenu(
  WidgetTester t,
  String id,
  String menu,
  String value,
) async {
  await t.ensureVisible(tb(id, menu));
  await t.tap(tb(id, menu));
  await t.pumpAndSettle();
  await t.tap(tb(id, '$menu-$value'));
  await t.pumpAndSettle();
}

Future<void> tapTb(WidgetTester t, String id, String name) async {
  await t.ensureVisible(tb(id, name));
  await t.tap(tb(id, name));
  await t.pumpAndSettle();
}

void main() {
  setUp(resetComponentsI18n);

  testWidgets('padrao: altura 320, placeholder, barra com os botoes do React', (
    t,
  ) async {
    await t.pumpWidget(host(const SgTextEditor(id: 'e')));
    expect(
      t.getSize(find.byKey(const ValueKey('texteditor-box-e'))).height,
      320,
    );
    expect(
      find.textContaining('Type here...', findRichText: true),
      findsOneWidget,
    );
    for (final n in [
      'heading',
      'font',
      'size',
      'bold',
      'italic',
      'underline',
      'strike',
      'textColor',
      'highlightColor', //
      'subscript',
      'superscript',
      'bullets',
      'numbered',
      'outdent',
      'indent',
      'alignLeft',
      'alignCenter',
      'alignRight', 'justify', 'link', 'image', 'clear', 'save', 'loadHtml',
    ]) {
      expect(tb('e', n), findsOneWidget, reason: n);
    }
    expect(find.bySemanticsLabel('Bold'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Load HTML'), findsOneWidget);
    expect(htmlOf(t), '<p></p>');
  });

  testWidgets('height e placeholder', (t) async {
    await t.pumpWidget(
      host(const SgTextEditor(id: 'e', height: 200, placeholder: 'Escreva')),
    );
    expect(
      t.getSize(find.byKey(const ValueKey('texteditor-box-e'))).height,
      200,
    );
    expect(find.textContaining('Escreva', findRichText: true), findsOneWidget);
  });

  testWidgets('defaultValueHtml e valueHtml (controlado)', (t) async {
    await t.pumpWidget(
      host(
        const SgTextEditor(
          id: 'e',
          defaultValueHtml: '<h1>Oi</h1><p>mundo</p>',
        ),
      ),
    );
    expect(htmlOf(t), '<h1>Oi</h1><p>mundo</p>');
    expect(find.textContaining('Oi', findRichText: true), findsOneWidget);
    await t.pumpWidget(
      host(const SgTextEditor(id: 'e', valueHtml: '<p>um</p>')),
    );
    expect(htmlOf(t), '<p>um</p>');
    await t.pumpWidget(
      host(const SgTextEditor(id: 'e', valueHtml: '<p>dois</p>')),
    );
    expect(htmlOf(t), '<p>dois</p>');
  });

  testWidgets(
    'onChangeHtml so quando o usuario edita; valueHtml por fora nao dispara',
    (t) async {
      final got = <String>[];
      await t.pumpWidget(
        host(
          SgTextEditor(id: 'e', valueHtml: '<p>a</p>', onChangeHtml: got.add),
        ),
      );
      await t.pumpWidget(
        host(
          SgTextEditor(id: 'e', valueHtml: '<p>b</p>', onChangeHtml: got.add),
        ),
      );
      expect(got, isEmpty);
      ctrl(t).replaceText(1, 0, 'x', const TextSelection.collapsed(offset: 2));
      await t.pump();
      expect(got, ['<p>bx</p>']);
    },
  );

  testWidgets(
    'barra: negrito, titulo, lista, alinhamento, cor, destaque, limpar',
    (t) async {
      final got = <String>[];
      await t.pumpWidget(
        host(
          SgTextEditor(
            id: 'e',
            defaultValueHtml: '<p>Ola mundo</p>',
            onChangeHtml: got.add,
          ),
        ),
      );
      select(t, 0, 3);
      await tapTb(t, 'e', 'bold');
      expect(htmlOf(t), '<p><strong>Ola</strong> mundo</p>');
      expect(got.last, htmlOf(t));
      await tapTb(t, 'e', 'bold');
      expect(htmlOf(t), '<p>Ola mundo</p>');

      select(t, 0, 3);
      await tapTb(t, 'e', 'italic');
      await tapTb(t, 'e', 'underline');
      await tapTb(t, 'e', 'strike');
      await tapTb(t, 'e', 'subscript');
      expect(htmlOf(t), '<p><em><s><u><sub>Ola</sub></u></s></em> mundo</p>');
      await tapTb(t, 'e', 'clear');
      expect(htmlOf(t), '<p>Ola mundo</p>');

      await tapTb(t, 'e', 'bullets');
      expect(htmlOf(t), '<ul><li><p>Ola mundo</p></li></ul>');
      await tapTb(t, 'e', 'numbered');
      expect(htmlOf(t), '<ol><li><p>Ola mundo</p></li></ol>');
      await tapTb(t, 'e', 'numbered');
      expect(htmlOf(t), '<p>Ola mundo</p>');

      await tapTb(t, 'e', 'alignCenter');
      expect(htmlOf(t), '<p style="text-align: center">Ola mundo</p>');
      await tapTb(t, 'e', 'justify');
      expect(htmlOf(t), '<p style="text-align: justify">Ola mundo</p>');

      await pickMenu(t, 'e', 'heading', 'h2');
      expect(htmlOf(t), '<h2 style="text-align: justify">Ola mundo</h2>');
    },
  );

  testWidgets('digitar no editor (teclado) chama onChangeHtml com o HTML', (
    t,
  ) async {
    final got = <String>[];
    await t.pumpWidget(host(SgTextEditor(id: 'e', onChangeHtml: got.add)));
    await t.ensureVisible(find.byKey(const ValueKey('texteditor-e')));
    await t.tapAt(
      t.getTopLeft(find.byKey(const ValueKey('texteditor-e'))) +
          const Offset(20, 20),
    );
    await t.pumpAndSettle();
    expect(t.testTextInput.isRegistered, isTrue);
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: 'oi\n',
        selection: TextSelection.collapsed(offset: 2),
      ),
    );
    await t.pumpAndSettle();
    expect(got.last, '<p>oi</p>');
    expect(htmlOf(t), '<p>oi</p>');
  });

  testWidgets('fonte e tamanho pelos menus', (t) async {
    await t.pumpWidget(
      host(const SgTextEditor(id: 'e', defaultValueHtml: '<p>Ola</p>')),
    );
    select(t, 0, 3);
    await pickMenu(t, 'e', 'font', 'Georgia');
    await pickMenu(t, 'e', 'size', '24px');
    expect(
      htmlOf(t),
      '<p><span style="font-family: Georgia; font-size: 24px">Ola</span></p>',
    );
    expect(find.text('Georgia'), findsWidgets);
  });

  testWidgets('cor do texto e destaque pelo seletor de cor', (t) async {
    await t.pumpWidget(
      host(const SgTextEditor(id: 'e', defaultValueHtml: '<p>Ola</p>')),
    );
    select(t, 0, 3);
    await tapTb(t, 'e', 'textColor');
    await t.tap(find.byKey(const ValueKey('texteditor-e-swatch-ff0000')));
    await t.pumpAndSettle();
    expect(htmlOf(t), '<p><span style="color: #ff0000">Ola</span></p>');
    select(t, 0, 3);
    await tapTb(t, 'e', 'highlightColor');
    await t.tap(find.byKey(const ValueKey('texteditor-e-swatch-ffff00')));
    await t.pumpAndSettle();
    expect(
      htmlOf(t),
      '<p><span style="color: #ff0000"><mark data-color="#ffff00" style="background-color: #ffff00; color: inherit">Ola</mark></span></p>',
    );
    // mesma cor de novo remove o destaque (toggleHighlight)
    select(t, 0, 3);
    await tapTb(t, 'e', 'highlightColor');
    await t.tap(find.byKey(const ValueKey('texteditor-e-swatch-ffff00')));
    await t.pumpAndSettle();
    expect(htmlOf(t), '<p><span style="color: #ff0000">Ola</span></p>');
  });

  testWidgets('link e imagem pedem a URL; cancelar nao muda nada', (t) async {
    await t.pumpWidget(
      host(const SgTextEditor(id: 'e', defaultValueHtml: '<p>Ola</p>')),
    );
    select(t, 0, 3);
    await tapTb(t, 'e', 'link');
    expect(find.text('URL'), findsWidgets);
    await t.tap(find.byKey(const ValueKey('texteditor-e-prompt-cancel')));
    await t.pumpAndSettle();
    expect(htmlOf(t), '<p>Ola</p>');

    await tapTb(t, 'e', 'link');
    await t.enterText(
      find.byKey(const ValueKey('input-texteditor-e-prompt')),
      'https://exemplo.com',
    );
    await t.tap(find.byKey(const ValueKey('texteditor-e-prompt-ok')));
    await t.pumpAndSettle();
    expect(
      htmlOf(t),
      '<p><a target="_blank" rel="noopener noreferrer nofollow" href="https://exemplo.com">Ola</a></p>',
    );

    // URL vazia remove o link; protocolo proibido nao cria link
    select(t, 0, 3);
    await tapTb(t, 'e', 'link');
    await t.enterText(
      find.byKey(const ValueKey('input-texteditor-e-prompt')),
      '',
    );
    await t.tap(find.byKey(const ValueKey('texteditor-e-prompt-ok')));
    await t.pumpAndSettle();
    expect(htmlOf(t), '<p>Ola</p>');
    select(t, 0, 3);
    await tapTb(t, 'e', 'link');
    await t.enterText(
      find.byKey(const ValueKey('input-texteditor-e-prompt')),
      'javascript:alert(1)',
    );
    await t.tap(find.byKey(const ValueKey('texteditor-e-prompt-ok')));
    await t.pumpAndSettle();
    expect(htmlOf(t), '<p>Ola</p>');

    select(t, 3, 3);
    await tapTb(t, 'e', 'image');
    await t.enterText(
      find.byKey(const ValueKey('input-texteditor-e-prompt')),
      'https://exemplo.com/a.png',
    );
    await t.tap(find.byKey(const ValueKey('texteditor-e-prompt-ok')));
    await t.pumpAndSettle();
    expect(htmlOf(t), '<p>Ola</p><img src="https://exemplo.com/a.png">');
  });

  testWidgets('disabled: barra e editor travados', (t) async {
    final got = <String>[];
    await t.pumpWidget(
      host(
        SgTextEditor(
          id: 'e',
          defaultValueHtml: '<p>Ola</p>',
          disabled: true,
          onChangeHtml: got.add,
        ),
      ),
    );
    expect(ctrl(t).readOnly, isTrue);
    select(t, 0, 3);
    await t.tap(tb('e', 'bold'), warnIfMissed: false);
    await t.pump();
    expect(htmlOf(t), '<p>Ola</p>');
    expect(got, isEmpty);
    expect(t.widget<SgButton>(tb('e', 'save')).disabled, isTrue);
    await t.pumpWidget(
      host(
        SgTextEditor(
          id: 'e',
          defaultValueHtml: '<p>Ola</p>',
          onChangeHtml: got.add,
        ),
      ),
    );
    expect(ctrl(t).readOnly, isFalse);
  });

  testWidgets('error aparece em vermelho abaixo do editor', (t) async {
    await t.pumpWidget(host(const SgTextEditor(id: 'e', error: 'Obrigatorio')));
    expect(find.text('Obrigatorio'), findsOneWidget);
  });

  testWidgets('borderRadius: numero e texto px/rem', (t) async {
    BorderRadius top() =>
        (t
                        .widget<Container>(
                          find
                              .descendant(
                                of: find.byType(SgTextEditorToolbar),
                                matching: find.byType(Container),
                              )
                              .first,
                        )
                        .decoration!
                    as BoxDecoration)
                .borderRadius!
            as BorderRadius;
    await t.pumpWidget(host(const SgTextEditor(id: 'e')));
    expect(top().topLeft.x, 8);
    await t.pumpWidget(host(const SgTextEditor(id: 'e', borderRadius: 20)));
    expect(top().topLeft.x, 20);
    await t.pumpWidget(host(const SgTextEditor(id: 'e', borderRadius: '1rem')));
    expect(top().topLeft.x, 16);
    await t.pumpWidget(host(const SgTextEditor(id: 'e', borderRadius: '4px')));
    expect(top().topLeft.x, 4);
  });

  testWidgets(
    'Salvar: arquivo <id>.html ou fileName, documento completo com o CSS',
    (t) async {
      SgTextEditorFile? file;
      SgTextEditorSaveMeta? meta;
      await t.pumpWidget(
        host(
          SgTextEditor(
            id: 'e',
            defaultValueHtml: '<p>Ola</p>',
            cssText: 'p{color:red}',
            onSave: (f, m) {
              file = f;
              meta = m;
            },
          ),
        ),
      );
      await tapTb(t, 'e', 'save');
      expect(file!.name, 'e.html');
      expect(file!.mimeType, 'text/html;charset=utf-8');
      expect(meta!.contentHtml, '<p>Ola</p>');
      expect(meta!.cssText, 'p{color:red}');
      expect(
        meta!.htmlDocument,
        startsWith('<!doctype html>\n<html lang="en-US">'),
      );
      expect(meta!.htmlDocument, contains('<style>\np{color:red}\n</style>'));
      expect(meta!.htmlDocument, contains('<body>\n<p>Ola</p>\n</body>'));
      expect(file!.text, meta!.htmlDocument);
      await t.pumpWidget(
        host(
          SgTextEditor(
            id: 'e',
            fileName: 'nota.html',
            onSave: (f, m) => file = f,
          ),
        ),
      );
      await tapTb(t, 'e', 'save');
      expect(file!.name, 'nota.html');
    },
  );

  testWidgets(
    'Carregar HTML: corpo no editor, CSS para onCssTextChange, onLoad, sem onChangeHtml',
    (t) async {
      final changes = <String>[];
      final css = <String>[];
      SgTextEditorSaveMeta? loaded;
      const doc =
          '<!doctype html><html><head><style>h1{x:y}</style></head><body><h1>Titulo</h1></body></html>';
      await t.pumpWidget(
        host(
          SgTextEditor(
            id: 'e',
            onChangeHtml: changes.add,
            onCssTextChange: css.add,
            onLoad: (m) => loaded = m,
            htmlFilePicker: () async => SgTextEditorFile(
              name: 'a.html',
              mimeType: 'text/html',
              bytes: Uint8List.fromList(utf8.encode(doc)),
            ),
          ),
        ),
      );
      await tapTb(t, 'e', 'loadHtml');
      await t.pumpAndSettle();
      expect(htmlOf(t), '<h1>Titulo</h1>');
      expect(css, ['h1{x:y}']);
      expect(changes, isEmpty);
      expect(loaded!.contentHtml, '<h1>Titulo</h1>');
      expect(loaded!.cssText, 'h1{x:y}');
      expect(loaded!.htmlDocument, doc);
    },
  );

  testWidgets('showCssEditor: rotulo, ajuda e onCssTextChange', (t) async {
    final css = <String>[];
    await t.pumpWidget(
      host(SgTextEditor(id: 'e', cssText: 'a{}', onCssTextChange: css.add)),
    );
    expect(find.text('Embedded CSS'), findsNothing);
    await t.pumpWidget(
      host(
        SgTextEditor(
          id: 'e',
          showCssEditor: true,
          cssEditorLabel: 'Estilos',
          cssText: 'a{}',
          onCssTextChange: css.add,
        ),
      ),
    );
    expect(find.text('Estilos'), findsOneWidget);
    expect(find.textContaining('a{}', findRichText: true), findsOneWidget);
    await t.enterText(find.byKey(const ValueKey('texteditor-css-e')), 'b{}');
    expect(css, ['b{}']);
    await t.pumpWidget(host(const SgTextEditor(id: 'e', showCssEditor: true)));
    expect(find.text('Embedded CSS'), findsOneWidget);
  });

  group('formulario', () {
    testWidgets(
      'name+control: edicao grava o HTML; valor do formulario aparece no editor',
      (t) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(SgTextEditor(id: 'e', name: 'texto', control: form)),
        );
        ctrl(
          t,
        ).replaceText(0, 0, 'oi', const TextSelection.collapsed(offset: 2));
        await t.pump();
        expect(form.getValue('texto'), '<p>oi</p>');
        form.setValue('texto', '<h1>Novo</h1>');
        await t.pump();
        expect(htmlOf(t), '<h1>Novo</h1>');
      },
    );

    testWidgets('rules required: erro no envio, some depois de digitar', (
      t,
    ) async {
      final form = SgFormController();
      var ok = 0;
      await t.pumpWidget(
        host(
          SgTextEditor(
            id: 'e',
            name: 'texto',
            control: form,
            rules: const SgRules(required: 'Informe o texto'),
          ),
        ),
      );
      await form.handleSubmit((_) => ok++);
      await t.pump();
      expect(ok, 0);
      expect(find.text('Informe o texto'), findsOneWidget);
      ctrl(t).replaceText(0, 0, 'oi', const TextSelection.collapsed(offset: 2));
      await t.pump();
      await t.pump();
      expect(find.text('Informe o texto'), findsNothing);
      await form.handleSubmit((_) => ok++);
      expect(ok, 1);
    });

    testWidgets(
      'pegadinha do React: apagar tudo deixa <p></p> e o required passa',
      (t) async {
        final form = SgFormController();
        await t.pumpWidget(
          host(
            SgTextEditor(
              id: 'e',
              name: 'texto',
              control: form,
              rules: const SgRules(required: 'Informe'),
            ),
          ),
        );
        ctrl(
          t,
        ).replaceText(0, 0, 'oi', const TextSelection.collapsed(offset: 2));
        ctrl(t).replaceText(0, 2, '', const TextSelection.collapsed(offset: 0));
        await t.pump();
        expect(form.getValue('texto'), '<p></p>');
        expect(await form.trigger(['texto']), isTrue);
      },
    );
  });

  testWidgets(
    'mobile (360 px): barra quebra em linhas, botoes de 44 px, sem estouro',
    (t) async {
      t.view.physicalSize = const Size(360, 800);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(
        host(
          const SgTextEditor(id: 'e', defaultValueHtml: '<p>Ola</p>'),
          width: 340,
        ),
      );
      expect(t.takeException(), isNull);
      expect(t.getSize(tb('e', 'bold')).height, 44);
      final toolbar = t.getSize(find.byType(SgTextEditorToolbar));
      expect(toolbar.width, 340);
      expect(toolbar.height, greaterThan(100)); // varias linhas
      await tapTb(t, 'e', 'bullets');
      expect(htmlOf(t), '<ul><li><p>Ola</p></li></ul>');
    },
  );

  test('Flutter quebra a linha no U+2028 (<br> do HTML)', () {
    final one = TextPainter(
      text: const TextSpan(text: 'ab', style: TextStyle(fontSize: 16)),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 300);
    final two = TextPainter(
      text: const TextSpan(text: 'a b', style: TextStyle(fontSize: 16)),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 300);
    expect(two.height, greaterThan(one.height * 1.5));
  });
}
