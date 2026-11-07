// Showcase do SgInputTextArea. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import '../src/showcase_log_box.dart';
import 'sg_input_text_area_page.snippets.g.dart';

class SgInputTextAreaPage extends StatefulWidget {
  const SgInputTextAreaPage({super.key});

  @override
  State<SgInputTextAreaPage> createState() => _SgInputTextAreaPageState();
}

class _SgInputTextAreaPageState extends State<SgInputTextAreaPage> {
  final SgFormController _form = SgFormController(
    defaultValues: {'controlled': ''},
  );
  String _basico = '';
  String? _validationMsg;
  final List<String> _eventLog = [];

  void _log(String entry) => setState(() => _eventLog.insert(0, entry));

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
        description: 'Textarea com floating label e botão limpar (padrão).',
        preview:
            // #region sg-input-text-area-basico
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputTextArea(
                    id: 'demo-basic',
                    labelText: context.tx('Descrição'),
                    onChange: (v) => setState(() => _basico = v),
                  ),
                  const SizedBox(height: 8),
                  Text('${context.tx('Valor')}: $_basico'),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description:
            'Valida ao perder o foco (validateOnBlur=true por padrão).',
        preview:
            // #region sg-input-text-area-obrigatorio
            Column(
              children: [
                SizedBox(
                  width: 384,
                  child: SgInputTextArea(
                    id: 'demo-required',
                    labelText: context.tx('Campo obrigatório'),
                    required: true,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 384,
                  child: SgInputTextArea(
                    id: 'demo-required-custom',
                    labelText: context.tx('Mensagem customizada'),
                    required: true,
                    requiredMessage: context.tx('Preencha este campo!'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaObrigatorio,
      ),
      ShowcaseExample(
        title: 'Controlado',
        description:
            'Para controlar o valor de fora (setar, limpar, preencher via API), use o formulário: setValue atualiza o campo e o estado atual aparece em tempo real.',
        preview:
            // #region sg-input-text-area-controlado
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputTextArea(
                    id: 'demo-controlled',
                    labelText: context.tx('Observações'),
                    name: 'controlled',
                    control: _form,
                  ),
                  const SizedBox(height: 12),
                  ListenableBuilder(
                    listenable: _form,
                    builder: (context, _) => Text(
                      '${context.tx('Estado atual')}: "${_form.getValue('controlled') ?? ''}"',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SgButton(
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        label: Text(
                          context.tx('Simular preenchimento via API'),
                        ),
                        onClick: () => _form.setValue(
                          'controlled',
                          context.tx('Texto preenchido via API.'),
                        ),
                      ),
                      SgButton(
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        label: Text(context.tx('Setar outro valor')),
                        onClick: () => _form.setValue(
                          'controlled',
                          context.tx('Outro valor qualquer'),
                        ),
                      ),
                      SgButton(
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        severity: SgSeverity.danger,
                        label: Text(context.tx('Limpar campo')),
                        onClick: () => _form.setValue('controlled', ''),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaControlado,
      ),
      ShowcaseExample(
        title: 'Contador de caracteres',
        description:
            'Usa maxLength e showCharCounter para limitar e exibir contagem.',
        preview:
            // #region sg-input-text-area-contador
            SizedBox(
              width: 384,
              child: SgInputTextArea(
                id: 'demo-counter',
                labelText: context.tx('Máximo 100 caracteres'),
                maxLength: 100,
                showCharCounter: true,
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaContador,
      ),
      ShowcaseExample(
        title: 'Tamanho mínimo',
        description: 'Valida que o texto tem um tamanho mínimo ao perder foco.',
        preview:
            // #region sg-input-text-area-tamanho-minimo
            SizedBox(
              width: 384,
              child: SgInputTextArea(
                id: 'demo-minlength',
                labelText: context.tx('Mínimo 10 caracteres'),
                minLength: 10,
                showCharCounter: true,
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaTamanhoMinimo,
      ),
      ShowcaseExample(
        title: 'Mínimo de palavras',
        description: 'Valida quantidade mínima de palavras.',
        preview:
            // #region sg-input-text-area-palavras
            SizedBox(
              width: 384,
              child: SgInputTextArea(
                id: 'demo-words',
                labelText: context.tx('Mínimo 5 palavras'),
                minNumberOfWords: 5,
                minNumberOfWordsMessage: context.tx(
                  'Digite pelo menos 5 palavras.',
                ),
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaPalavras,
      ),
      ShowcaseExample(
        title: 'Mínimo de linhas',
        description:
            'Valida que o texto tem um número mínimo de linhas (quebras de linha). Exclusivo do TextArea.',
        preview:
            // #region sg-input-text-area-linhas-minimo
            SizedBox(
              width: 384,
              child: SgInputTextArea(
                id: 'demo-minlines',
                labelText: context.tx('Mínimo 3 linhas'),
                minLines: 3,
                minLinesMessage: context.tx('Escreva pelo menos 3 linhas.'),
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaLinhasMinimo,
      ),
      ShowcaseExample(
        title: 'Validação customizada',
        description: 'Função de validação retorna mensagem de erro ou null.',
        preview:
            // #region sg-input-text-area-validacao
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputTextArea(
                    id: 'demo-validation',
                    labelText: context.tx('Sem números'),
                    validation: (v) => RegExp(r'\d').hasMatch(v)
                        ? context.tx('Números não são permitidos.')
                        : null,
                    onValidation: (msg) => setState(() => _validationMsg = msg),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'onValidation: ${_validationMsg == null ? context.tx('válido') : '"$_validationMsg"'}',
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaValidacao,
      ),
      ShowcaseExample(
        title: 'Altura e linhas visíveis',
        description:
            'height controla a altura do container. maxLines define as linhas visíveis do campo.',
        preview:
            // #region sg-input-text-area-linhas
            Column(
              children: [
                SizedBox(
                  width: 384,
                  child: SgInputTextArea(
                    id: 'demo-height-small',
                    labelText: context.tx('Altura 100px, 2 rows'),
                    height: 100,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 384,
                  child: SgInputTextArea(
                    id: 'demo-height-large',
                    labelText: context.tx('Altura 250px, 8 rows'),
                    height: 250,
                    maxLines: 8,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaLinhas,
      ),
      ShowcaseExample(
        title: 'Ícone de prefixo',
        description:
            'Ícone posicionado no canto superior esquerdo do textarea.',
        preview:
            // #region sg-input-text-area-icone
            SizedBox(
              width: 384,
              child: SgInputTextArea(
                id: 'demo-prefix',
                labelText: context.tx('Observações'),
                prefixIcon: const Icon(Icons.notes, size: 16),
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaIcone,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description: 'Sem borda (withBorder=false) e preenchido (filled=true).',
        preview:
            // #region sg-input-text-area-variacoes
            Column(
              children: [
                SizedBox(
                  width: 384,
                  child: SgInputTextArea(
                    id: 'demo-noborder',
                    labelText: context.tx('Sem borda'),
                    withBorder: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 384,
                  child: SgInputTextArea(
                    id: 'demo-filled',
                    labelText: context.tx('Preenchido'),
                    filled: true,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaVariacoes,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description: 'clearButton=false remove o X do input.',
        preview:
            // #region sg-input-text-area-sem-limpar
            SizedBox(
              width: 384,
              child: SgInputTextArea(
                id: 'demo-noclear',
                labelText: context.tx('Sem limpar'),
                clearButton: false,
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaSemLimpar,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description: 'width e borderRadius customizáveis.',
        preview:
            // #region sg-input-text-area-largura
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SgInputTextArea(
                  id: 'demo-w250',
                  labelText: context.tx('250px'),
                  width: 250,
                ),
                SgInputTextArea(
                  id: 'demo-w350',
                  labelText: context.tx('350px arredondado'),
                  width: 350,
                  borderRadius: 16,
                ),
              ],
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado e somente leitura',
        description:
            'enabled=false desabilita o campo; readOnly impede a edição, mas deixa copiar.',
        preview:
            // #region sg-input-text-area-estados
            Column(
              children: [
                SizedBox(
                  width: 384,
                  child: SgInputTextArea(
                    id: 'demo-disabled',
                    labelText: context.tx('Desabilitado'),
                    enabled: false,
                    initialValue: context.tx('Não editável'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 384,
                  child: SgInputTextArea(
                    id: 'demo-readonly',
                    labelText: context.tx('Somente leitura'),
                    readOnly: true,
                    initialValue: context.tx('Apenas leitura'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaEstados,
      ),
      ShowcaseExample(
        title: 'Erro externo',
        description:
            'Prop error exibe mensagem de erro vinda do pai (server-side, etc).',
        preview:
            // #region sg-input-text-area-erro-externo
            SizedBox(
              width: 384,
              child: SgInputTextArea(
                id: 'demo-error',
                labelText: context.tx('Com erro externo'),
                error: context.tx('Descrição muito curta.'),
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaErroExterno,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description: 'onEnter, onExit, onChange, onClear, onValidation.',
        preview:
            // #region sg-input-text-area-eventos
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputTextArea(
                    id: 'demo-events',
                    labelText: context.tx('Digite e observe o log'),
                    required: true,
                    onChange: (v) =>
                        _log('onChange: "${v.replaceAll('\n', r'\n')}"'),
                    onEnter: () => _log(context.tx('onEnter (focus)')),
                    onExit: () => _log(context.tx('onExit (blur)')),
                    onClear: () => _log('onClear'),
                    onValidation: (msg) =>
                        _log('onValidation: ${msg ?? context.tx('válido')}'),
                  ),
                  const SizedBox(height: 12),
                  ShowcaseLogBox(
                    entries: _eventLog,
                    hint: context.tx('Interaja com o textarea...'),
                    height: 160,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-text-area-rotulo
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputTextArea(
                    id: 'sg-input-text-area-label-float',
                    labelText: context.tx('Flutuante'),
                    labelPosition: SgInputTextAreaLabelPosition.float,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputTextArea(
                    id: 'sg-input-text-area-label-top',
                    labelText: context.tx('Acima'),
                    labelPosition: SgInputTextAreaLabelPosition.top,
                  ),
                ),
                SizedBox(
                  width: 360,
                  child: SgInputTextArea(
                    id: 'sg-input-text-area-label-left',
                    labelText: context.tx('Esquerda'),
                    labelPosition: SgInputTextAreaLabelPosition.left,
                    labelWidth: 140,
                    labelAlign: SgInputTextAreaLabelAlign.end,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaRotulo,
      ),
      ShowcaseExample(
        title: 'Elevação',
        description: 'Compare os níveis de sombra disponíveis no campo.',
        preview:
            // #region sg-input-text-area-elevacao
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputTextArea(
                    id: 'sg-input-text-area-elevation-none',
                    labelText: context.tx('Elevação none'),
                    elevation: SgInputTextAreaElevation.none,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputTextArea(
                    id: 'sg-input-text-area-elevation-sm',
                    labelText: context.tx('Elevação sm'),
                    elevation: SgInputTextAreaElevation.sm,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputTextArea(
                    id: 'sg-input-text-area-elevation-md',
                    labelText: context.tx('Elevação md'),
                    elevation: SgInputTextAreaElevation.md,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputTextArea(
                    id: 'sg-input-text-area-elevation-lg',
                    labelText: context.tx('Elevação lg'),
                    elevation: SgInputTextAreaElevation.lg,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextAreaPageSnippets.sgInputTextAreaElevacao,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputTextArea',
      description:
          'Área de texto com rótulo, limites de caracteres, palavras e linhas, contador e ligação a formulário.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputTextArea']!,
        const SgPropSpec(
          name: 'initialValue',
          reactName: 'textareaProps.defaultValue',
          type: 'String?',
          tsType: 'string',
          required: false,
          description:
              'Valor inicial quando não há control (no React vai em textareaProps).',
        ),
        const SgPropSpec(
          name: 'readOnly',
          reactName: 'textareaProps.readOnly',
          type: 'bool?',
          tsType: 'boolean',
          required: false,
          description: 'Somente leitura (no React vai em textareaProps).',
        ),
        const SgPropSpec(
          name: 'autofocus',
          reactName: 'textareaProps.autoFocus',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
          description: 'Foca o campo ao montar.',
        ),
        const SgPropSpec(
          name: 'inputFormatters',
          reactName: 'textareaProps',
          type: 'List<TextInputFormatter>?',
          tsType: 'TextareaHTMLAttributes',
          required: false,
          description:
              'Lista fechada que substitui textareaProps (ADR 50): formatadores de entrada.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'focusNode',
          reactName: 'textareaProps.ref',
          type: 'FocusNode?',
          tsType: 'Ref<HTMLTextAreaElement>',
          required: false,
          description: 'Foco externo.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputTextArea']!
            .where(
              (s) => const {
                'labelPosition',
                'filled',
                'enabled',
                'clearButton',
                'showCharCounter',
                'withBorder',
                'elevation',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputTextArea(
          id: 'pg',
          labelText: 'Observações',
          labelPosition: SgInputTextAreaLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          elevation: SgInputTextAreaElevation.fromValue(
            v['elevation'] as String?,
          ),
          filled: v['filled'] as bool?,
          enabled: v['enabled'] as bool?,
          clearButton: v['clearButton'] as bool?,
          showCharCounter: v['showCharCounter'] as bool?,
          withBorder: v['withBorder'] as bool?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Observações'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputTextAreaLabelPosition.${SgInputTextAreaLabelPosition.fromValue(e.value as String)!.name}',
              'elevation' =>
                'elevation: SgInputTextAreaElevation.${SgInputTextAreaElevation.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputTextArea(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
