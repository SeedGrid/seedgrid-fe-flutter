// Showcase do SgInputTextSearch. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_input_text_search_page.snippets.g.dart';

class SgInputTextSearchPage extends StatefulWidget {
  const SgInputTextSearchPage({super.key});

  @override
  State<SgInputTextSearchPage> createState() => _SgInputTextSearchPageState();
}

class _SgInputTextSearchPageState extends State<SgInputTextSearchPage> {
  String _busca = '(nenhuma ainda)';
  String _crua = '';
  String _rapida = '(nenhuma ainda)';
  int _disparos = 0;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'onSearchChange dispara 350 ms depois da última digitação, com o texto sem espaços nas pontas e só com 3 ou mais caracteres (ou vazio).',
        preview:
            // #region sg-input-text-search-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputTextSearch(
                  id: 'busca',
                  labelText: 'Buscar produto',
                  prefixIcon: const Icon(Icons.search),
                  onSearchChange: (valor) => setState(() => _busca = valor),
                ),
                const SizedBox(height: 8),
                Text('Última busca: $_busca'),
              ],
            ),
        // #endregion
        code: SgInputTextSearchPageSnippets.sgInputTextSearchBasico,
      ),
      ShowcaseExample(
        title: 'onChange imediato x onSearchChange com debounce',
        description:
            'onChange recebe cada digitação com o valor cru; onSearchChange só o valor normalizado e sem repetição.',
        preview:
            // #region sg-input-text-search-eventos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputTextSearch(
                  id: 'eventos',
                  labelText: 'Digite e veja os eventos',
                  onChange: (valor) => setState(() => _crua = valor),
                  onSearchChange: (valor) => setState(() => _disparos++),
                ),
                const SizedBox(height: 8),
                Text('onChange (cru): "$_crua"'),
                Text('Buscas disparadas: $_disparos'),
              ],
            ),
        // #endregion
        code: SgInputTextSearchPageSnippets.sgInputTextSearchEventos,
      ),
      ShowcaseExample(
        title: 'minChars e debounceMs',
        description: 'Dispara a partir de 1 caractere e com 100 ms de espera.',
        preview:
            // #region sg-input-text-search-ajuste
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputTextSearch(
                  id: 'ajuste',
                  labelText: 'Resposta rápida',
                  minChars: 1,
                  debounceMs: 100,
                  onSearchChange: (valor) => setState(() => _rapida = valor),
                ),
                const SizedBox(height: 8),
                Text('Última busca: $_rapida'),
              ],
            ),
        // #endregion
        code: SgInputTextSearchPageSnippets.sgInputTextSearchAjuste,
      ),
      ShowcaseExample(
        title: 'Rótulo, largura e botão de limpar',
        description:
            'Limpar o campo dispara a busca vazia (volta para a lista completa).',
        preview:
            // #region sg-input-text-search-aparencia
            SgInputTextSearch(
              id: 'aparencia',
              labelText: 'Cliente',
              labelPosition: SgInputTextSearchLabelPosition.top,
              placeholder: context.tx('Nome ou CPF'),
              width: 320,
              filled: true,
              onSearchChange: (valor) {},
            ),
        // #endregion
        code: SgInputTextSearchPageSnippets.sgInputTextSearchAparencia,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputTextSearch',
      description:
          'Campo de busca com debounce, mínimo de caracteres e busca distinta, baseado no SgInputText.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputTextSearch']!,
        const SgPropSpec(
          name: 'initialValue',
          reactName: 'inputProps.defaultValue',
          type: 'String?',
          tsType: 'string',
          required: false,
          description:
              'Valor inicial quando não há control (no React vai em inputProps).',
        ),
        const SgPropSpec(
          name: 'inputFormatters',
          reactName: 'inputProps',
          type: 'List<TextInputFormatter>?',
          tsType: 'InputHTMLAttributes',
          required: false,
          description:
              'Lista fechada que substitui inputProps (ADR 50): formatadores de entrada.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'autofocus',
          reactName: 'inputProps.autoFocus',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
          description: 'Foca o campo ao montar.',
        ),
        const SgPropSpec(
          name: 'autofillHints',
          reactName: 'inputProps.autoComplete',
          type: 'Iterable<String>?',
          tsType: 'string',
          required: false,
          description: 'Dicas de preenchimento automático.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'textInputAction',
          reactName: 'inputProps.enterKeyHint',
          type: 'TextInputAction?',
          tsType: 'string',
          required: false,
          description: 'Ação do teclado.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'onSubmitted',
          reactName: 'inputProps.onKeyDown',
          type: 'ValueChanged<String>?',
          tsType: '(value: string) => void',
          required: false,
          description:
              'Tecla Enter / ação do teclado; recebe o valor completo.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'focusNode',
          reactName: 'inputProps.ref',
          type: 'FocusNode?',
          tsType: 'Ref<HTMLInputElement>',
          required: false,
          description: 'Foco externo.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputTextSearch']!
            .where(
              (s) => const {
                'labelPosition',
                'filled',
                'disabled',
                'readOnly',
                'clearButton',
                'placeholder',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputTextSearch(
          id: 'pg',
          labelText: 'Buscar',
          labelPosition: SgInputTextSearchLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          filled: v['filled'] as bool?,
          disabled: v['disabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          clearButton: v['clearButton'] as bool?,
          placeholder: v['placeholder'] as String?,
          onSearchChange: (valor) {},
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            "labelText: 'Buscar'",
            'onSearchChange: (valor) {}',
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputTextSearchLabelPosition.${SgInputTextSearchLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputTextSearch(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
