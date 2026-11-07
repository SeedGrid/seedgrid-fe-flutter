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
  final ValueNotifier<String> _imediato = ValueNotifier('');
  final ValueNotifier<String> _busca = ValueNotifier('');
  final ValueNotifier<String> _imediato2 = ValueNotifier('');
  final ValueNotifier<String> _busca2 = ValueNotifier('');
  final ValueNotifier<String> _crua = ValueNotifier('');
  final ValueNotifier<int> _disparos = ValueNotifier(0);

  @override
  void dispose() {
    _imediato.dispose();
    _busca.dispose();
    _imediato2.dispose();
    _busca2.dispose();
    _crua.dispose();
    _disparos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (minChars 3, debounce 350ms)',
        description:
            'Digite e observe: o valor imediato muda a cada tecla, o termo de busca só atualiza após parar de digitar e com 3+ caracteres.',
        preview:
            // #region sg-input-text-search-basico
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputTextSearch(
                    id: 'search-basic',
                    labelText: context.tx('Busca'),
                    placeholder: context.tx('Digite para buscar'),
                    onChange: (valor) => _imediato.value = valor,
                    onSearchChange: (valor) => _busca.value = valor,
                  ),
                  const SizedBox(height: 8),
                  ListenableBuilder(
                    listenable: Listenable.merge([_imediato, _busca]),
                    builder: (context, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.tx('Valor imediato (onChange)')}: ${_imediato.value.isEmpty ? context.tx('(vazio)') : _imediato.value}',
                        ),
                        Text(
                          '${context.tx('Termo de busca (onSearchChange)')}: ${_busca.value.isEmpty ? context.tx('(vazio)') : _busca.value}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextSearchPageSnippets.sgInputTextSearchBasico,
      ),
      ShowcaseExample(
        title: 'minChars 1 e debounce 800ms',
        description: 'Dispara com 1 caractere, mas com um debounce mais longo.',
        preview:
            // #region sg-input-text-search-ajuste
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputTextSearch(
                    id: 'search-tuned',
                    labelText: context.tx('Busca'),
                    placeholder: context.tx('Digite para buscar'),
                    minChars: 1,
                    debounceMs: 800,
                    onChange: (valor) => _imediato2.value = valor,
                    onSearchChange: (valor) => _busca2.value = valor,
                  ),
                  const SizedBox(height: 8),
                  ListenableBuilder(
                    listenable: Listenable.merge([_imediato2, _busca2]),
                    builder: (context, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.tx('Valor imediato (onChange)')}: ${_imediato2.value.isEmpty ? context.tx('(vazio)') : _imediato2.value}',
                        ),
                        Text(
                          '${context.tx('Termo de busca (onSearchChange)')}: ${_busca2.value.isEmpty ? context.tx('(vazio)') : _busca2.value}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextSearchPageSnippets.sgInputTextSearchAjuste,
      ),
      ShowcaseExample(
        title: 'onChange imediato x onSearchChange com debounce',
        description:
            'onChange recebe cada digitação com o valor cru; onSearchChange só o valor normalizado e sem repetição.',
        preview:
            // #region sg-input-text-search-eventos
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputTextSearch(
                    id: 'search-events',
                    labelText: context.tx('Digite e veja os eventos'),
                    onChange: (valor) => _crua.value = valor,
                    onSearchChange: (valor) => _disparos.value++,
                  ),
                  const SizedBox(height: 8),
                  ListenableBuilder(
                    listenable: Listenable.merge([_crua, _disparos]),
                    builder: (context, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${context.tx('onChange (cru)')}: "${_crua.value}"'),
                        Text(
                          '${context.tx('Buscas disparadas')}: ${_disparos.value}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextSearchPageSnippets.sgInputTextSearchEventos,
      ),
      ShowcaseExample(
        title: 'Rótulo, largura e botão de limpar',
        description:
            'Limpar o campo dispara a busca vazia (volta para a lista completa).',
        preview:
            // #region sg-input-text-search-aparencia
            SgInputTextSearch(
              id: 'search-appearance',
              labelText: context.tx('Cliente'),
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
                'enabled',
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
          enabled: v['enabled'] as bool?,
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
