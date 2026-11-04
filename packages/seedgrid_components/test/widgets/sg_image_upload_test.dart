// SgImageUpload (P133): paridade da logica pura com o React (image_upload_vectors/vectors.json, gerado a partir de
// imageUploadLogic.ts) e comportamento do widget (escolher, recusar, remover, URL salva, desabilitado, formulario).
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

SgImagePicker pickerOf(SgImageFile? file) =>
    (accept) async => file;

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

    testWidgets('escolhe, mostra o nome e remove', (t) async {
      final calls = <String?>[];
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            label: 'Foto',
            picker: pickerOf(SgImageFile(name: 'foto.png', bytes: _png)),
            onChange: (f) => calls.add(f?.name),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect(calls, ['foto.png']);
      expect(find.byKey(const ValueKey('sg-image-preview-up')), findsOneWidget);
      expect(find.textContaining('foto.png'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('sg-image-remove-up')));
      await t.pump();
      expect(calls, ['foto.png', null]);
      expect(find.byKey(const ValueKey('sg-image-preview-up')), findsNothing);
    });

    testWidgets('sem tipo nem extensao conhecida, vale o conteudo do arquivo', (
      t,
    ) async {
      final calls = <String?>[];
      final errors = <SgImageError>[];
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            picker: pickerOf(SgImageFile(name: 'foto.xyz', bytes: _png)),
            onChange: (f) => calls.add(f?.name),
            onError: (code, message) => errors.add(code),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect(errors, isEmpty);
      expect(calls, ['foto.xyz']);
    });

    testWidgets('recusa tipo e tamanho com onError e mensagem', (t) async {
      final errors = <SgImageError>[];
      var file = SgImageFile(
        name: 'doc.pdf',
        bytes: _png,
        mimeType: 'application/pdf',
      );
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            accept: 'image/png',
            maxSizeBytes: 50,
            picker: (_) async => file,
            onError: (code, message) => errors.add(code),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect(errors, [SgImageError.type]);
      file = SgImageFile(
        name: 'grande.png',
        bytes: Uint8List(500),
        mimeType: 'image/png',
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect(errors.last, SgImageError.size);
      expect(find.textContaining('50 B'), findsOneWidget);
    });

    testWidgets('valida dimensao minima lendo a imagem', (t) async {
      SgImageError? last;
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            minWidth: 100,
            picker: pickerOf(SgImageFile(name: 'a.png', bytes: _png)),
            onError: (code, message) => last = code,
          ),
        ),
      );
      await t.runAsync(() async {
        await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await t.pump();
      expect(last, SgImageError.dimension);
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
            defaultValue: 'https://x.test/a.png',
            picker: (_) async {
              opened = true;
              return null;
            },
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect(opened, isFalse);
      expect(find.byKey(const ValueKey('sg-image-remove-up')), findsNothing);
    });

    testWidgets('formulario guarda a imagem escolhida', (t) async {
      final form = SgFormController();
      await t.pumpWidget(
        host(
          SgImageUpload(
            id: 'up',
            name: 'foto',
            control: form,
            picker: pickerOf(SgImageFile(name: 'foto.png', bytes: _png)),
          ),
        ),
      );
      await t.tap(find.byKey(const ValueKey('sg-image-open-up')));
      await t.pump();
      expect((form.getValue('foto') as SgImageFile).name, 'foto.png');
    });
  });
}
