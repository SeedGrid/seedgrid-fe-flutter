// Fluxo do CRUD de clientes (lista -> novo/editar -> lista, busca e exclusao), lendo o JSON de verdade.
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_showcase/pages/crud_clientes_page.dart';

import 'support/page_checks.dart';

/// Le os assets direto do disco, de forma sincrona: a leitura real de IO nao anda no relogio falso do teste.
class _BundleDeArquivos extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) => throw UnimplementedError(key);

  @override
  Future<String> loadString(String key, {bool cache = true}) =>
      SynchronousFuture(File(key).readAsStringSync());
}

String? _ns() => 'teste';

Future<void> _abre(WidgetTester t) async {
  setSize(t, const Size(1280, 1000));
  await t.pumpWidget(
    app(
      DefaultAssetBundle(
        bundle: _BundleDeArquivos(),
        child: const SingleChildScrollView(child: ClientesCrud()),
      ),
    ),
  );
  await settle(t);
}

void main() {
  testWidgets('carrega o JSON e lista os clientes', (t) async {
    await _abre(t);
    expect(find.text('Ana Lima'), findsOneWidget);
    expect(find.text('Bruno Souza'), findsOneWidget);
  });

  testWidgets('busca filtra a tabela', (t) async {
    await _abre(t);
    await t.enterText(find.byType(EditableText).first, 'Bruno');
    await t.pump(const Duration(seconds: 1));
    expect(find.text('Bruno Souza'), findsOneWidget);
    expect(find.text('Ana Lima'), findsNothing);
  });

  testWidgets('editar abre o formulario preenchido e salvar volta a lista', (
    t,
  ) async {
    await _abre(t);
    await t.tap(find.byIcon(Icons.edit).first);
    await settle(t);
    expect(find.text('EDITAR CLIENTE'), findsOneWidget);
    final nome = find.byType(EditableText).first;
    expect(
      (t.widget(nome) as EditableText).controller.text,
      'Ana Lima',
      reason: 'formulario preenchido',
    );
    await t.enterText(nome, 'Ana Souza');
    await t.pump();
    await t.tap(find.text('Salvar'));
    await settle(t);
    expect(find.text('EDITAR CLIENTE'), findsNothing);
    expect(find.text('Ana Souza'), findsOneWidget);
    expect(find.text('Ana Lima'), findsNothing);
  });

  testWidgets('novo valida os obrigatorios e cria o cliente', (t) async {
    await _abre(t);
    await t.tap(find.text('Novo'));
    await settle(t);
    expect(find.text('NOVO CLIENTE'), findsOneWidget);
    await t.tap(find.text('Salvar'));
    await settle(t);
    expect(
      find.text('NOVO CLIENTE'),
      findsOneWidget,
      reason: 'invalido nao salva',
    );
    final campos = find.byType(EditableText);
    await t.enterText(campos.at(0), 'Zélia Prado');
    await t.enterText(campos.at(1), 'zelia@exemplo.com');
    await t.pump();
    await t.tap(find.text('Salvar'));
    await settle(t);
    expect(find.text('NOVO CLIENTE'), findsNothing);
    await t.enterText(find.byType(EditableText).first, 'Zélia');
    await t.pump(const Duration(seconds: 1));
    expect(find.text('Zélia Prado'), findsOneWidget);
  });

  testWidgets('excluir pede confirmacao e remove a linha', (t) async {
    await _abre(t);
    await t.tap(find.byIcon(Icons.delete).first);
    await settle(t);
    expect(find.text('Excluir cliente?'), findsOneWidget);
    expect(find.text('Ana Lima'), findsOneWidget, reason: 'ainda nao excluiu');
    await t.tap(find.text('Confirm'));
    await settle(t);
    expect(find.text('Ana Lima'), findsNothing);
    expect(find.text('Bruno Souza'), findsOneWidget);
  });

  testWidgets(
    'a tabela restaura as colunas salvas pelo SgEnvironmentProvider',
    (t) async {
      setSize(t, const Size(1280, 1000));
      final salvos = <String, Object?>{};
      final estrategia = PersistenceStrategy.from(
        load: (k) =>
            salvos[k] ??
            {
              'version': 1,
              'columnOrder': [
                'field:nome',
                'field:email',
                'field:cidade',
                'field:plano',
                'field:limite',
                'field:ativo',
                'index:6',
              ],
              'hiddenColumnsMap': {'field:email': true},
            },
        save: (k, v) => salvos[k] = v,
        clear: salvos.remove,
      );
      await t.pumpWidget(
        app(
          SgEnvironmentProvider(
            value: SgEnvironmentPartial(
              namespaceProvider: const NamespaceProvider(_ns),
              persistenceStrategy: estrategia,
            ),
            child: DefaultAssetBundle(
              bundle: _BundleDeArquivos(),
              child: const SingleChildScrollView(child: ClientesCrud()),
            ),
          ),
        ),
      );
      await settle(t);
      expect(find.text('Nome'), findsWidgets);
      expect(
        find.text('E-mail'),
        findsNothing,
        reason: 'coluna oculta restaurada',
      );
    },
  );
}
