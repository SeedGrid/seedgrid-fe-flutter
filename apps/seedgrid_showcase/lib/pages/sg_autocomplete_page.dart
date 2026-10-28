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
  String _enviado = '';

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Digite ao menos 2 letras: a busca roda depois de 300 ms sem digitar. Em tela estreita a lista abre como painel de baixo.',
        preview:
            // #region sg-autocomplete-basico
            SgAutocomplete<String>(
              id: 'pais',
              labelText: 'País',
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
        title: 'Fonte assíncrona',
        description:
            'A fonte devolve um Future; enquanto espera aparece o texto de carregamento. Respostas antigas são descartadas.',
        preview:
            // #region sg-autocomplete-assincrono
            SgAutocomplete<String>(
              id: 'cidade',
              labelText: 'Cidade',
              delay: 200,
              loadingText: 'Buscando cidades...',
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
        title: 'Botão de lista e abrir ao focar',
        description:
            'Com showDropDownButton e openOnFocus a lista abre inteira (modo catálogo), sem digitar.',
        preview:
            // #region sg-autocomplete-botao
            SgAutocomplete<String>(
              id: 'cor',
              labelText: 'Cor',
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
        title: 'Agrupado, com item e rodapé próprios',
        preview:
            // #region sg-autocomplete-agrupado
            SgAutocomplete<SgAutocompleteItem>(
              id: 'produto',
              labelText: 'Produto',
              grouped: true,
              renderItem: (item, active) => Row(
                children: [
                  const Icon(Icons.label_outline, size: 16),
                  const SizedBox(width: 8),
                  Text(item.label),
                ],
              ),
              renderFooter: (q, has) =>
                  Text(has ? 'Resultados para "$q"' : 'Nada para "$q"'),
              source: (q) =>
                  [
                        SgAutocompleteItem(
                          id: 1,
                          label: context.tx('Maçã'),
                          group: 'Frutas',
                        ),
                        SgAutocompleteItem(
                          id: 2,
                          label: context.tx('Manga'),
                          group: 'Frutas',
                        ),
                        SgAutocompleteItem(
                          id: 3,
                          label: context.tx('Milho'),
                          group: 'Grãos',
                        ),
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
        title: 'Valor livre e limpar ao escolher',
        description:
            'allowCustomValue guarda o que foi digitado; clearOnSelect esvazia o campo depois de escolher (útil para adicionar itens).',
        preview:
            // #region sg-autocomplete-livre
            Column(
              children: [
                SgAutocomplete<String>(
                  id: 'livre',
                  labelText: 'Aceita texto livre',
                  allowCustomValue: true,
                  source: (q) => const ['Alpha', 'Beta', 'Gamma']
                      .where((c) => c.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
                ),
                const SizedBox(height: 12),
                SgAutocomplete<String>(
                  id: 'adicionar',
                  labelText: 'Limpa ao escolher',
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
        title: 'Limite de resultados e raio da borda',
        description:
            'maxResult limita quantos itens a lista mostra; borderRadius arredonda o campo.',
        preview:
            // #region sg-autocomplete-limite
            SgAutocomplete<String>(
              id: 'limite',
              labelText: 'Máximo de 2 resultados',
              maxResult: 2,
              borderRadius: 20,
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
                  labelText: 'Fruta',
                  required: true,
                  requiredMessage: 'Escolha uma fruta',
                  source: (q) => const ['Banana', 'Laranja', 'Uva']
                      .where((c) => c.toLowerCase().contains(q.toLowerCase()))
                      .toList(),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['fruta']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
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
                'disabled',
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
          disabled: v['disabled'] as bool?,
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
