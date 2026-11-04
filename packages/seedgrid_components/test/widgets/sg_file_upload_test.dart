// SgFileUpload (P141): comportamento do widget (um arquivo, varios, tipo pelo conteudo, limites por arquivo/total/
// quantidade, erro por arquivo, desabilitado, formulario). A logica pura tem os vetores em sg_file_logic_test.dart.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(width: 400, child: child),
        ),
      ),
    ),
  ),
);

final Uint8List _pdf = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31]);
final Uint8List _png = Uint8List.fromList([
  0x89,
  0x50,
  0x4e,
  0x47,
  0x0d,
  0x0a,
  0x1a,
  0x0a,
]);

SgFile pdf(String name, [int size = 6]) =>
    SgFile(name: name, bytes: Uint8List(size)..setAll(0, _pdf));

SgFilePicker pickerOf(List<SgFile> files) =>
    (request) async => files;

String names(List<SgFile>? files) =>
    [for (final f in files ?? const <SgFile>[]) f.name].join(',');

void main() {
  setUp(() => setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR')));
  tearDown(resetComponentsI18n);

  testWidgets('um arquivo: escolhe, mostra nome e tamanho, troca e remove', (
    t,
  ) async {
    var next = [pdf('a.pdf', 1536)];
    final calls = <String>[];
    await t.pumpWidget(
      host(
        SgFileUpload(
          id: 'f',
          label: 'Anexo',
          picker: (_) async => next,
          onChange: (files) => calls.add(names(files)),
        ),
      ),
    );
    await t.tap(find.byKey(const ValueKey('sg-file-open-f')));
    await t.pump();
    expect(calls, ['a.pdf']);
    expect(find.text('a.pdf'), findsOneWidget);
    expect(find.text('1,5 KB'), findsOneWidget);
    next = [pdf('b.pdf')];
    await t.tap(find.byKey(const ValueKey('sg-file-change-f')));
    await t.pump();
    expect(calls.last, 'b.pdf');
    await t.tap(find.byKey(const ValueKey('sg-file-remove-f-0')));
    await t.pump();
    expect(calls.last, '');
    expect(find.byKey(const ValueKey('sg-file-open-f')), findsOneWidget);
  });

  testWidgets('varios arquivos: soma, respeita maxFiles e vira lista', (
    t,
  ) async {
    var next = [pdf('a.pdf'), pdf('b.pdf')];
    List<SgFile>? last;
    final errors = <String>[];
    await t.pumpWidget(
      host(
        SgFileUpload(
          id: 'f',
          maxFiles: 3,
          picker: (_) async => next,
          onChange: (files) => last = files,
          onError: (code, message, name) => errors.add('$name:${code.name}'),
        ),
      ),
    );
    await t.tap(find.byKey(const ValueKey('sg-file-open-f')));
    await t.pump();
    expect(names(last), 'a.pdf,b.pdf');
    next = [pdf('c.pdf'), pdf('d.pdf')];
    await t.tap(find.byKey(const ValueKey('sg-file-open-f')));
    await t.pump();
    expect(names(last), 'a.pdf,b.pdf,c.pdf');
    expect(errors, ['d.pdf:count']);
    expect(find.byKey(const ValueKey('sg-file-open-f')), findsNothing);
    await t.tap(find.byKey(const ValueKey('sg-file-remove-f-1')));
    await t.pump();
    expect(names(last), 'a.pdf,c.pdf');
    expect(find.byKey(const ValueKey('sg-file-open-f')), findsOneWidget);
  });

  testWidgets('mediaType confere pelo conteudo, nao so pela extensao', (
    t,
  ) async {
    final errors = <String>[];
    List<SgFile>? last;
    await t.pumpWidget(
      host(
        SgFileUpload(
          id: 'f',
          maxFiles: 5,
          mediaType: const [SgMediaType.pdf],
          picker: pickerOf([
            pdf('certo.pdf'),
            // diz ser pdf, mas o conteudo e PNG
            SgFile(name: 'falso.pdf', bytes: _png),
            // sem extensao, conteudo e PDF
            pdf('sem-extensao'),
          ]),
          onChange: (files) => last = files,
          onError: (code, message, name) => errors.add('$name:${code.name}'),
        ),
      ),
    );
    await t.tap(find.byKey(const ValueKey('sg-file-open-f')));
    await t.pump();
    expect(names(last), 'certo.pdf,sem-extensao');
    expect(errors, ['falso.pdf:type']);
    expect(find.textContaining('Aceitos: pdf'), findsOneWidget);
  });

  testWidgets('maxSizePerFile e maxSizeTotal com unidade, erro por arquivo', (
    t,
  ) async {
    final errors = <String>[];
    List<SgFile>? last;
    await t.pumpWidget(
      host(
        SgFileUpload(
          id: 'f',
          maxFiles: 10,
          maxSizePerFile: '1KB',
          maxSizeTotal: '1.5KB',
          picker: pickerOf([
            pdf('a.pdf', 1000),
            pdf('grande.pdf', 2000),
            pdf('b.pdf', 600),
            pdf('c.pdf', 100),
          ]),
          onChange: (files) => last = files,
          onError: (code, message, name) => errors.add('$name:${code.name}'),
        ),
      ),
    );
    await t.tap(find.byKey(const ValueKey('sg-file-open-f')));
    await t.pump();
    expect(names(last), 'a.pdf,c.pdf');
    expect(errors, ['grande.pdf:size', 'b.pdf:total']);
    expect(
      find.textContaining('grande.pdf: O arquivo deve ter no máximo 1,0 KB'),
      findsOneWidget,
    );
  });

  testWidgets('desabilitado: nao abre o seletor nem mostra remover', (t) async {
    var opened = false;
    await t.pumpWidget(
      host(
        SgFileUpload(
          id: 'f',
          disabled: true,
          defaultValue: [pdf('a.pdf')],
          picker: (_) async {
            opened = true;
            return null;
          },
        ),
      ),
    );
    expect(opened, isFalse);
    expect(find.byKey(const ValueKey('sg-file-remove-f-0')), findsNothing);
  });

  testWidgets('formulario guarda a lista e obrigatorio acusa vazio', (t) async {
    final form = SgFormController();
    await t.pumpWidget(
      host(
        SgFileUpload(
          id: 'f',
          name: 'anexos',
          control: form,
          maxFiles: 3,
          required: true,
          requiredMessage: 'Anexe um arquivo',
          picker: pickerOf([pdf('a.pdf')]),
        ),
      ),
    );
    await t.tap(find.byKey(const ValueKey('sg-file-open-f')));
    await t.pump();
    expect(
      [for (final f in form.getValue('anexos') as List) (f as SgFile).name],
      ['a.pdf'],
    );
    await t.tap(find.byKey(const ValueKey('sg-file-remove-f-0')));
    await t.pump();
    expect(form.getValue('anexos'), isNull);
  });
}
