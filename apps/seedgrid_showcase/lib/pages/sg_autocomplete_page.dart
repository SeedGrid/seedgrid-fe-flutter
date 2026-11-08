// Showcase do SgAutocomplete. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_autocomplete_page.snippets.g.dart';

class SgAutocompletePage extends StatefulWidget {
  const SgAutocompletePage({super.key});

  @override
  State<SgAutocompletePage> createState() => _SgAutocompletePageState();
}

class _SgAutocompletePageState extends State<SgAutocompletePage> {
  final SgFormController _form = SgFormController();
  final ValueNotifier<String> _enviado = ValueNotifier('');

  @override
  void dispose() {
    _enviado.dispose();
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Digite e veja resultados conforme a busca.',
        preview:
            // #region sg-autocomplete-basico
            SgAutocomplete<String>(
              id: 'pais',
              labelText: context.tx('País'),
              placeholder: context.tx('Digite 2 letras'),
              source: (q) =>
                  const [
                        'Argentina',
                        'Bolívia',
                        'Brasil',
                        'Chile',
                        'Colômbia',
                        'Uruguai',
                      ]
                      .where((p) => p.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompleteBasico,
      ),
      ShowcaseExample(
        title: 'Conteúdo personalizado',
        description: 'Renderiza o item com o código do país.',
        preview:
            // #region sg-autocomplete-personalizado
            SgAutocomplete<SgAutocompleteItem>(
              id: 'pais-codigo',
              labelText: context.tx('País'),
              renderItem: (item, active) => Row(
                children: [
                  Text(
                    '${item.data}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(item.label),
                ],
              ),
              source: (q) =>
                  const [
                        SgAutocompleteItem(
                          id: 1,
                          label: 'Argentina',
                          data: 'AR',
                        ),
                        SgAutocompleteItem(id: 2, label: 'Brasil', data: 'BR'),
                        SgAutocompleteItem(id: 3, label: 'Chile', data: 'CL'),
                        SgAutocompleteItem(
                          id: 4,
                          label: 'Colômbia',
                          data: 'CO',
                        ),
                      ]
                      .where(
                        (i) => i.label.toLowerCase().contains(q.toLowerCase()),
                      )
                      .toList(),
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompletePersonalizado,
      ),
      ShowcaseExample(
        title: 'Agrupado',
        description: 'Agrupa pela primeira letra.',
        preview:
            // #region sg-autocomplete-agrupado
            SgAutocomplete<SgAutocompleteItem>(
              id: 'pais-agrupado',
              labelText: context.tx('País'),
              grouped: true,
              source: (q) =>
                  const [
                        SgAutocompleteItem(
                          id: 1,
                          label: 'Argentina',
                          group: 'A',
                        ),
                        SgAutocompleteItem(
                          id: 2,
                          label: 'Austrália',
                          group: 'A',
                        ),
                        SgAutocompleteItem(id: 3, label: 'Brasil', group: 'B'),
                        SgAutocompleteItem(id: 4, label: 'Bolívia', group: 'B'),
                        SgAutocompleteItem(id: 5, label: 'Chile', group: 'C'),
                      ]
                      .where(
                        (i) => i.label.toLowerCase().contains(q.toLowerCase()),
                      )
                      .toList(),
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompleteAgrupado,
      ),
      ShowcaseExample(
        title: 'Botão dropdown',
        description:
            'Botão para abrir/fechar a lista. Com um item selecionado, reabrir mostra a lista completa com o item destacado.',
        preview:
            // #region sg-autocomplete-botao
            SgAutocomplete<String>(
              id: 'cor',
              labelText: context.tx('Cor'),
              showDropDownButton: true,
              openOnFocus: true,
              minLengthForSearch: 0,
              source: (q) =>
                  const ['Azul', 'Amarelo', 'Verde', 'Vermelho', 'Roxo']
                      .where((c) => c.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompleteBotao,
      ),
      ShowcaseExample(
        title: 'Rodapé',
        description: 'Rodapé personalizado com ação.',
        preview:
            // #region sg-autocomplete-rodape
            SgAutocomplete<String>(
              id: 'pais-rodape',
              labelText: context.tx('País'),
              renderFooter: (q, has) => SgButton(
                label: Text(
                  has
                      ? context.txf('Adicionar "{consulta}"', {'consulta': q})
                      : context.tx('Adicionar novo'),
                ),
                onClick: () {},
              ),
              source: (q) =>
                  const ['Argentina', 'Bolívia', 'Brasil', 'Chile', 'Uruguai']
                      .where((p) => p.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompleteRodape,
      ),
      ShowcaseExample(
        title: 'Comprimento mínimo',
        description: 'Só busca a partir de 3 caracteres.',
        preview:
            // #region sg-autocomplete-minimo
            SgAutocomplete<String>(
              id: 'pais-minimo',
              labelText: context.tx('País'),
              minLengthForSearch: 3,
              source: (q) =>
                  const ['Argentina', 'Bolívia', 'Brasil', 'Chile', 'Uruguai']
                      .where((p) => p.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompleteMinimo,
      ),
      ShowcaseExample(
        title: 'Raio da borda',
        description: 'Aplica raio de borda ao campo e à lista de sugestões.',
        preview:
            // #region sg-autocomplete-raio
            SgAutocomplete<String>(
              id: 'pais-raio',
              labelText: context.tx('País'),
              minLengthForSearch: 1,
              showDropDownButton: true,
              openOnFocus: true,
              borderRadius: 14,
              source: (q) =>
                  const ['Argentina', 'Bolívia', 'Brasil', 'Chile', 'Uruguai']
                      .where((p) => p.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompleteRaio,
      ),
      ShowcaseExample(
        title: 'Fonte assíncrona',
        description:
            'A fonte devolve um Future; enquanto espera aparece o texto de carregamento. Respostas antigas são descartadas.',
        preview:
            // #region sg-autocomplete-assincrono
            SgAutocomplete<String>(
              id: 'cidade',
              labelText: context.tx('Cidade'),
              delay: 200,
              loadingText: context.tx('Buscando cidades...'),
              source: (q) async {
                await Future<void>.delayed(const Duration(milliseconds: 600));
                return const ['Curitiba', 'Cuiabá', 'Campinas', 'Cascavel']
                    .where((c) => c.toLowerCase().contains(q.toLowerCase()))
                    .toList();
              },
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompleteAssincrono,
      ),
      ShowcaseExample(
        title: 'Valor livre e limpar ao escolher',
        description:
            'allowCustomValue guarda o que foi digitado; clearOnSelect esvazia o campo depois de escolher (útil para adicionar itens).',
        preview:
            // #region sg-autocomplete-livre
            Column(
              children: [
                SgAutocomplete<String>(
                  id: 'livre',
                  labelText: context.tx('Aceita texto livre'),
                  allowCustomValue: true,
                  source: (q) => const ['Alpha', 'Beta', 'Gamma']
                      .where((c) => c.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
                ),
                const SizedBox(height: 12),
                SgAutocomplete<String>(
                  id: 'adicionar',
                  labelText: context.tx('Limpa ao escolher'),
                  clearOnSelect: true,
                  source: (q) => const ['Item A', 'Item B', 'Item C']
                      .where((c) => c.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
                ),
              ],
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompleteLivre,
      ),
      ShowcaseExample(
        title: 'Limite de resultados',
        description: 'maxResult limita quantos itens a lista mostra.',
        preview:
            // #region sg-autocomplete-limite
            SgAutocomplete<String>(
              id: 'limite',
              labelText: context.tx('Máximo de 2 resultados'),
              maxResult: 2,
              source: (q) =>
                  const ['Rio Branco', 'Rio Claro', 'Rio Grande', 'Rio Verde']
                      .where((p) => p.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompleteLimite,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'name + control + required, como no react-hook-form.',
        preview:
            // #region sg-autocomplete-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgAutocomplete<String>(
                  id: 'fruta',
                  name: 'fruta',
                  control: _form,
                  labelText: context.tx('Fruta'),
                  required: true,
                  requiredMessage: context.tx('Escolha uma fruta'),
                  source: (q) => const ['Banana', 'Laranja', 'Uva']
                      .where((c) => c.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => _enviado.value = '${values['fruta']}',
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _enviado,
                  builder: (context, enviado, _) => enviado.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          context.txf('Enviado: {valor}', {'valor': enviado}),
                        ),
                ),
              ],
            ),
        // #endregion
        code: SgAutocompletePageSnippets.sgAutocompleteFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgAutocomplete',
      description:
          'Campo de texto com sugestões vindas de uma fonte (lista ou assíncrona), com busca com atraso, cache, grupos e valor livre.',
      examples: examples,
      propSpecs: sgPropSpecs['SgAutocomplete']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgAutocomplete']!
            .where(
              (s) => const {
                'showDropDownButton',
                'openOnFocus',
                'clearOnSelect',
                'allowCustomValue',
                'cacheEnabled',
                'enabled',
                'readOnly',
                'required',
                'placeholder',
                'hintText',
                'labelPosition',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgAutocomplete<String>(
          id: 'pg',
          labelText: 'Fruta',
          minLengthForSearch: 0,
          showDropDownButton: (v['showDropDownButton'] as bool?) ?? false,
          openOnFocus: (v['openOnFocus'] as bool?) ?? false,
          clearOnSelect: (v['clearOnSelect'] as bool?) ?? false,
          allowCustomValue: (v['allowCustomValue'] as bool?) ?? false,
          cacheEnabled: (v['cacheEnabled'] as bool?) ?? true,
          enabled: v['enabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          required: v['required'] as bool?,
          placeholder: v['placeholder'] as String?,
          hintText: v['hintText'] as String?,
          labelPosition: SgAutocompleteLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          source: (q) => const [
            'Abacate',
            'Banana',
            'Laranja',
            'Uva',
          ].where((c) => c.toLowerCase().contains(q.toLowerCase())).toList(),
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            "labelText: 'Fruta'",
            'minLengthForSearch: 0',
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgAutocompleteLabelPosition.${SgAutocompleteLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          args.add('source: (q) => frutas.where(...).toList()');
          return 'SgAutocomplete<String>(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
