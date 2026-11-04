// SgImageUpload (P133, refeito no P141 como composicao do SgFileUpload): paridade das regras de imagem com o React
// (image_upload_vectors) e comportamento do widget (uma imagem, varias, recusas por arquivo, dimensao, formulario).
import 'dart:convert';
import 'dart:io';
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

// PNG 1x1 valido.
final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

List<SgFile> png(List<String> names) => [
  for (final n in names) SgFile(name: n, bytes: _png),
];

SgFilePicker pickerOf(List<SgFile> files) =>
    (request) async => files;

void main() {
  final doc =
      jsonDecode(
            File(
              'test/widgets/image_upload_vectors/vectors.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  List<Map<String, dynamic>> list(String k) =>
      (doc[k] as List).cast<Map<String, dynamic>>();

  group('paridade com o React (vetores)', () {
    test('matchesAccept', () {
      for (final c in list('accept')) {
        expect(
          sgMatchesAccept(c['name'], c['type'], c['accept'] as String?),
          c['out'],
          reason: '$c',
        );
      }
    });
    test('validateImage', () {
      for (final c in list('validate')) {
        final f = c['file'] as Map<String, dynamic>;
        final r = c['rules'] as Map<String, dynamic>;
        final code = sgValidateImage(
          name: f['name'],
          type: f['type'],
          size: f['size'],
          width: f['width'],
          height: f['height'],
          accept: r['accept'],
          maxSizeBytes: r['maxSizeBytes'],
          minWidth: r['minWidth'],
          minHeight: r['minHeight'],
          aspect: r['aspect'],
          aspectTolerance: r['aspectTolerance'],
        );
        expect(code?.name, c['out'], reason: '$c');
      }
    });
    test('formatBytes e formatAspect', () {
      for (final c in list('bytes')) {
        expect(sgFormatBytes(c['bytes'], c['locale']), c['out'], reason: '$c');
      }
      for (final c in list('aspect')) {
        expect(sgFormatAspect(c['aspect']), c['out'], reason: '$c');
      }
    });
  });

  group('widget', () {
    setUp(
      () => setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR')),
    );
    tearDown(resetComponentsI18n);

    testWidgets('uma imagem: escolhe, mostra a miniatura e remove', (t) async {
      final calls = <List<String>>[];
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            label: 'Foto',
            picker: pickerOf(png(['foto.png'])),
            onChange: (f) => calls.add([for (final x in f) x.name]),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect(calls, [
        ['foto.png'],
      ]);
      expect(
        find.byKey(const ValueKey('sg-image-preview-up-foto.png')),
        findsOneWidget,
      );
      await t.tap(find.byKey(const ValueKey('sg-image-remove-up-0')));
      await t.pump();
      expect(calls.last, isEmpty);
      expect(find.byKey(const ValueKey('sg-image-open-up')), findsOneWidget);
    });

    testWidgets('com maxFiles 1, escolher outra substitui', (t) async {
      var next = png(['a.png']);
      List<SgFile>? last;
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            picker: (_) async => next,
            onChange: (f) => last = f,
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      next = png(['b.png']);
      await t.tap(find.byKey(const ValueKey('sg-image-change-up')));
      await t.pump();
      expect([for (final f in last!) f.name], ['b.png']);
    });

    testWidgets('varias imagens: grade, limite maxFiles e erro por arquivo', (
      t,
    ) async {
      final errors = <String>[];
      List<SgFile>? last;
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            maxFiles: 2,
            picker: pickerOf(png(['a.png', 'b.png', 'c.png'])),
            onChange: (f) => last = f,
            onError: (code, message, name) => errors.add('$name:${code.name}'),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect([for (final f in last!) f.name], ['a.png', 'b.png']);
      expect(errors, ['c.png:count']);
      expect(find.byKey(const ValueKey('sg-image-item-up-1')), findsOneWidget);
      expect(find.textContaining('c.png'), findsOneWidget);
      // cheio: a area de escolha some.
      expect(find.byKey(const ValueKey('sg-image-open-up')), findsNothing);
    });

    testWidgets('recusa tipo e tamanho por arquivo; os outros seguem', (
      t,
    ) async {
      final errors = <String>[];
      List<SgFile>? last;
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            maxFiles: 5,
            maxSizePerFile: '1KB',
            picker: pickerOf([
              SgFile(name: 'ok.png', bytes: _png),
              SgFile(
                name: 'doc.pdf',
                bytes: Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2d]),
                mimeType: 'application/pdf',
              ),
              SgFile(
                name: 'grande.png',
                bytes: Uint8List(2000)..setAll(0, _png),
                mimeType: 'image/png',
              ),
            ]),
            onChange: (f) => last = f,
            onError: (code, message, name) => errors.add('$name:${code.name}'),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect([for (final f in last!) f.name], ['ok.png']);
      expect(errors, ['doc.pdf:type', 'grande.png:size']);
      expect(find.textContaining('1,0 KB'), findsOneWidget);
    });

    testWidgets('imagem com extensao desconhecida vale pelo conteudo (.jfif)', (
      t,
    ) async {
      final errors = <String>[];
      List<SgFile>? last;
      final jpeg = Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0, 0, 0x10]);
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            picker: pickerOf([SgFile(name: '71cd3918.jfif', bytes: jpeg)]),
            onChange: (f) => last = f,
            onError: (code, message, name) => errors.add(name),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect(errors, isEmpty);
      expect(last!.single.name, '71cd3918.jfif');
    });

    testWidgets('accept restringe os formatos de imagem', (t) async {
      final errors = <String>[];
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            accept: '.jpg',
            picker: pickerOf(png(['a.png'])),
            onError: (code, message, name) => errors.add('$name:${code.name}'),
          ),
        ),
      );
      await t.runAsync(() async {
        await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await t.pump();
      expect(errors, ['a.png:type']);
    });

    testWidgets('valida dimensao minima lendo a imagem', (t) async {
      final errors = <String>[];
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            minWidth: 100,
            picker: pickerOf(png(['a.png'])),
            onError: (code, message, name) => errors.add('$name:${code.name}'),
          ),
        ),
      );
      await t.runAsync(() async {
        await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await t.pump();
      expect(errors, ['a.png:dimension']);
    });

    testWidgets('desabilitado nao abre o seletor e nao mostra remover', (
      t,
    ) async {
      var opened = false;
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            disabled: true,
            defaultValue: const [
              SgFile(name: 'a.png', url: 'https://x.test/a.png'),
            ],
            picker: (_) async {
              opened = true;
              return null;
            },
          ),
        ),
      );
      expect(opened, isFalse);
      expect(find.byKey(const ValueKey('sg-image-remove-up-0')), findsNothing);
      expect(find.byKey(const ValueKey('sg-image-change-up')), findsNothing);
    });

    testWidgets('formulario guarda a lista de imagens', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            name: 'foto',
            control: form,
            maxFiles: 3,
            picker: pickerOf(png(['a.png', 'b.png'])),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect(
        [for (final f in form.getValue('foto') as List) (f as SgFile).name],
        ['a.png', 'b.png'],
      );
    });
  });
}
