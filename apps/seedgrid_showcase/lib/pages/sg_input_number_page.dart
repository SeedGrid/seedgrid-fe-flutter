// Showcase do SgInputNumber. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import '../src/showcase_log_box.dart';
import 'sg_input_number_page.snippets.g.dart';

class SgInputNumberPage extends StatefulWidget {
  const SgInputNumberPage({super.key});

  @override
  State<SgInputNumberPage> createState() => _SgInputNumberPageState();
}

class _SgInputNumberPageState extends State<SgInputNumberPage> {
  final SgFormController _form = SgFormController(
    defaultValues: {
      'valor': '',
      'controlled': '',
      'prefix': '',
      'suffix': '',
      'both': '',
    },
  );
  final ValueNotifier<String> _enviado = ValueNotifier('');
  final ValueNotifier<String?> _validationMsg = ValueNotifier(null);
  final ValueNotifier<List<String>> _eventLog = ValueNotifier(const []);
  final ValueNotifier<List<String>> _iconLog = ValueNotifier(const []);
  final Map<String, String> _standalone = {};
  final ValueNotifier<String> _standaloneResult = ValueNotifier('');

  void _log(String entry) => _eventLog.value = [entry, ..._eventLog.value];

  @override
  void dispose() {
    _form.dispose();
    _enviado.dispose();
    _validationMsg.dispose();
    _eventLog.dispose();
    _iconLog.dispose();
    _standaloneResult.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Campo ligado a um formulário (SgFormController): name + control; o valor sai no envio.',
        preview:
            // #region sg-input-number-basico
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputNumber(
                    id: 'demo-basic',
                    labelText: context.tx('Valor'),
                    name: 'valor',
                    control: _form,
                    decimals: 2,
                  ),
                  const SizedBox(height: 8),
                  SgButton(
                    size: SgSize.sm,
                    appearance: SgAppearance.outline,
                    label: Text(context.tx('Enviar')),
                    onClick: () => _form.handleSubmit(
                      (values) => _enviado.value = '${values['valor']}',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String>(
                    valueListenable: _enviado,
                    builder: (context, enviado, _) =>
                        Text('${context.tx('Valor')}: $enviado'),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description:
            'Valida ao perder o foco (validateOnBlur=true por padrão).',
        preview:
            // #region sg-input-number-obrigatorio
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputNumber(
                    id: 'demo-required',
                    labelText: context.tx('Campo obrigatório'),
                    required: true,
                    decimals: 2,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputNumber(
                    id: 'demo-required-custom',
                    labelText: context.tx('Mensagem customizada'),
                    required: true,
                    requiredMessage: context.tx('Informe um valor.'),
                    decimals: 2,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberObrigatorio,
      ),
      ShowcaseExample(
        title: 'Controlado',
        description:
            'Use quando precisa do valor em tempo real e de setValue externos.',
        preview:
            // #region sg-input-number-controlado
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputNumber(
                    id: 'demo-controlled',
                    labelText: context.tx('Valor controlado'),
                    name: 'controlled',
                    control: _form,
                    decimals: 2,
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
                        label: Text(context.tx('Setar via API')),
                        onClick: () => _form.setValue('controlled', '12345.00'),
                      ),
                      SgButton(
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        label: Text(context.tx('Resetar')),
                        onClick: () => _form.setValue('controlled', '0.00'),
                      ),
                      SgButton(
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        severity: SgSeverity.danger,
                        label: Text(context.tx('Limpar')),
                        onClick: () => _form.setValue('controlled', ''),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberControlado,
      ),
      ShowcaseExample(
        title: 'Validação customizada',
        description: 'Função de validação retorna mensagem ou null.',
        preview:
            // #region sg-input-number-validacao
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputNumber(
                    id: 'demo-validation',
                    labelText: context.tx('Apenas número par'),
                    decimals: 0,
                    validation: (v) {
                      final n = num.tryParse(v);
                      return n != null && n % 2 == 0
                          ? null
                          : context.tx('Use um número par.');
                    },
                    onValidation: (msg) => _validationMsg.value = msg,
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String?>(
                    valueListenable: _validationMsg,
                    builder: (context, msg, _) => Text(
                      'onValidation: ${msg == null ? context.tx('válido') : '"$msg"'}',
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberValidacao,
      ),
      ShowcaseExample(
        title: 'Ícone de prefixo',
        description: 'Ícone posicionado à esquerda do input.',
        preview:
            // #region sg-input-number-icone
            SizedBox(
              width: 320,
              child: SgInputNumber(
                id: 'demo-prefix-icon',
                labelText: context.tx('Buscar valor'),
                decimals: 2,
                prefixIcon: const Icon(Icons.search, size: 16),
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberIcone,
      ),
      ShowcaseExample(
        title: 'Prefixo e sufixo',
        description: 'Prefixo/sufixo são apenas visuais.',
        preview:
            // #region sg-input-number-afixos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputNumber(
                    id: 'demo-prefix-text',
                    labelText: context.tx('Preço'),
                    prefixText: r'R$',
                    name: 'prefix',
                    control: _form,
                    decimals: 2,
                  ),
                ),
                ListenableBuilder(
                  listenable: _form,
                  builder: (context, _) => Text(
                    '${context.tx('Valor')}: ${_form.getValue('prefix') ?? ''}',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputNumber(
                    id: 'demo-suffix-text',
                    labelText: context.tx('Peso'),
                    suffixText: 'kg',
                    name: 'suffix',
                    control: _form,
                    decimals: 2,
                  ),
                ),
                ListenableBuilder(
                  listenable: _form,
                  builder: (context, _) => Text(
                    '${context.tx('Valor')}: ${_form.getValue('suffix') ?? ''}',
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputNumber(
                    id: 'demo-both',
                    labelText: context.tx('Valor total'),
                    prefixText: r'R$',
                    suffixText: 'm',
                    name: 'both',
                    control: _form,
                    decimals: 2,
                  ),
                ),
                ListenableBuilder(
                  listenable: _form,
                  builder: (context, _) => Text(
                    '${context.tx('Valor')}: ${_form.getValue('both') ?? ''}',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberAfixos,
      ),
      ShowcaseExample(
        title: 'Botões de ícone',
        description: 'iconButtons recebe uma lista de widgets.',
        preview:
            // #region sg-input-number-botoes
            SizedBox(
              width: 384,
              child: Column(
                children: [
                  SgInputNumber(
                    id: 'demo-iconbtns',
                    labelText: context.tx('Número para copiar'),
                    decimals: 2,
                    iconButtons: [
                      SgButton(
                        iconOnly: true,
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        leftIcon: const Icon(Icons.copy),
                        onClick: () => _iconLog.value = [
                          context.tx('Copiado'),
                          ..._iconLog.value,
                        ],
                      ),
                      SgButton(
                        iconOnly: true,
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        leftIcon: const Icon(Icons.notifications_outlined),
                        onClick: () => _iconLog.value = [
                          context.tx('Alerta disparado!'),
                          ..._iconLog.value,
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<List<String>>(
                    valueListenable: _iconLog,
                    builder: (context, entries, _) => ShowcaseLogBox(
                      entries: entries,
                      hint: context.tx('Digite algo e clique nos ícones...'),
                      height: 96,
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberBotoes,
      ),
      ShowcaseExample(
        title: 'Sem negativo',
        description: 'Bloqueia o sinal de menos.',
        preview:
            // #region sg-input-number-sem-negativo
            SizedBox(
              width: 320,
              child: SgInputNumber(
                id: 'demo-no-negative',
                labelText: context.tx('Apenas positivo'),
                allowNegative: false,
                decimals: 2,
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberSemNegativo,
      ),
      ShowcaseExample(
        title: 'Sem decimais',
        description: 'decimals=0 (apenas inteiro com separador de milhar).',
        preview:
            // #region sg-input-number-sem-decimais
            SizedBox(
              width: 320,
              child: SgInputNumber(
                id: 'demo-no-decimals',
                labelText: context.tx('Quantidade'),
                decimals: 0,
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberSemDecimais,
      ),
      ShowcaseExample(
        title: 'Min/Max',
        description: 'Valida intervalo numérico.',
        preview:
            // #region sg-input-number-minmax
            SizedBox(
              width: 320,
              child: SgInputNumber(
                id: 'demo-minmax',
                labelText: context.tx('Entre 10 e 100'),
                minValue: 10,
                maxValue: 100,
                decimals: 2,
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberMinmax,
      ),
      ShowcaseExample(
        title: 'Valor vazio',
        description:
            'emptyValueIsNull permite limpar totalmente (o valor passa a ser null em vez de 0).',
        preview:
            // #region sg-input-number-vazio
            SizedBox(
              width: 320,
              child: SgInputNumber(
                id: 'demo-empty',
                labelText: context.tx('Pode ficar vazio'),
                emptyValueIsNull: true,
                decimals: 2,
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberVazio,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description: 'Sem borda (withBorder=false) e preenchido (filled=true).',
        preview:
            // #region sg-input-number-variacoes
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputNumber(
                    id: 'demo-noborder',
                    labelText: context.tx('Sem borda'),
                    withBorder: false,
                    decimals: 2,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputNumber(
                    id: 'demo-filled',
                    labelText: context.tx('Preenchido'),
                    filled: true,
                    decimals: 2,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberVariacoes,
      ),
      ShowcaseExample(
        title: 'Standalone (form completo)',
        description:
            'Exemplo 100% standalone com default no load e botão salvar.',
        preview:
            // #region sg-input-number-standalone
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputNumber(
                    id: 'standalone-a',
                    labelText: context.tx('Entrada 1'),
                    decimals: 2,
                    onChange: (v) => _standalone['a'] = '${v ?? ''}',
                  ),
                  const SizedBox(height: 12),
                  SgInputNumber(
                    id: 'standalone-b',
                    labelText: context.tx('Entrada 2'),
                    decimals: 2,
                    onChange: (v) => _standalone['b'] = '${v ?? ''}',
                  ),
                  const SizedBox(height: 12),
                  SgInputNumber(
                    id: 'standalone-c',
                    labelText: context.tx('Entrada 3'),
                    decimals: 2,
                    onChange: (v) => _standalone['c'] = '${v ?? ''}',
                  ),
                  const SizedBox(height: 12),
                  SgButton(
                    size: SgSize.sm,
                    appearance: SgAppearance.outline,
                    label: Text(context.tx('Salvar')),
                    onClick: () => _standaloneResult.value = jsonEncode({
                      'a': _standalone['a'] ?? '',
                      'b': _standalone['b'] ?? '',
                      'c': _standalone['c'] ?? '',
                    }),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String>(
                    valueListenable: _standaloneResult,
                    builder: (context, resultado, _) => Text(
                      '${context.tx('Resultado')}: ${resultado.isEmpty ? '-' : resultado}',
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberStandalone,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description:
            'Exemplo sem formulário com onEnter, onExit, onChange, onClear, onValidation.',
        preview:
            // #region sg-input-number-eventos
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputNumber(
                    id: 'demo-events',
                    labelText: context.tx('Digite e observe o log'),
                    required: true,
                    decimals: 2,
                    onChange: (v) => _log('onChange: $v'),
                    onEnter: () => _log('onEnter (focus)'),
                    onExit: () => _log('onExit (blur)'),
                    onClear: () => _log('onClear'),
                    onValidation: (msg) =>
                        _log('onValidation: ${msg ?? context.tx('válido')}'),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<List<String>>(
                    valueListenable: _eventLog,
                    builder: (context, entries, _) => ShowcaseLogBox(
                      entries: entries,
                      hint: context.tx('Interaja com o input...'),
                      height: 160,
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberEventos,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description: 'width e borderRadius customizáveis.',
        preview:
            // #region sg-input-number-largura
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SgInputNumber(
                  id: 'demo-w200',
                  labelText: context.tx('200px'),
                  width: 200,
                  decimals: 2,
                ),
                SgInputNumber(
                  id: 'demo-w300',
                  labelText: context.tx('300px arredondado'),
                  width: 300,
                  borderRadius: 20,
                  decimals: 2,
                ),
              ],
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberLargura,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-number-rotulo
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputNumber(
                    id: 'sg-input-number-label-float',
                    labelText: context.tx('Flutuante'),
                    labelPosition: SgInputNumberLabelPosition.float,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputNumber(
                    id: 'sg-input-number-label-top',
                    labelText: context.tx('Acima'),
                    labelPosition: SgInputNumberLabelPosition.top,
                  ),
                ),
                SizedBox(
                  width: 360,
                  child: SgInputNumber(
                    id: 'sg-input-number-label-left',
                    labelText: context.tx('Esquerda'),
                    labelPosition: SgInputNumberLabelPosition.left,
                    labelWidth: 140,
                    labelAlign: SgInputNumberLabelAlign.end,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputNumberPageSnippets.sgInputNumberRotulo,
      ),
    ];

    const playgroundProps = {
      'labelPosition',
      'elevation',
      'emptyValueIsNull',
      'allowNegative',
      'enabled',
      'readOnly',
      'required',
      'filled',
      'withBorder',
      'clearButton',
      'prefixText',
      'suffixText',
      'hintText',
      'placeholder',
    };
    return SgShowcasePage(
      name: 'SgInputNumber',
      description:
          'Campo numérico com formatação por idioma, casas decimais, sinal, limites e ligação a formulário (SgForm).',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputNumber']!,
        const SgPropSpec(
          name: 'initialValue',
          reactName: 'inputProps.defaultValue',
          type: 'Object?',
          tsType: 'string | number',
          required: false,
          description: 'Valor inicial sem formulário ("1234.5" ou "12,5").',
          exact: false,
        ),
        const SgPropSpec(
          name: 'value',
          reactName: 'inputProps.value',
          type: 'Object?',
          tsType: 'string | number',
          required: false,
          description: 'Valor controlado de fora; mudar atualiza o campo.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputNumber']!
            .where((s) => playgroundProps.contains(s.name))
            .toList(),
        builder: (context, v) => SgInputNumber(
          key: ValueKey('pg-${v['emptyValueIsNull']}'),
          id: 'pg',
          labelText: 'Valor',
          labelPosition: SgInputNumberLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          elevation: SgInputNumberElevation.fromValue(
            v['elevation'] as String?,
          ),
          emptyValueIsNull: v['emptyValueIsNull'] as bool?,
          allowNegative: v['allowNegative'] as bool?,
          enabled: v['enabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          required: v['required'] as bool?,
          filled: v['filled'] as bool?,
          withBorder: v['withBorder'] as bool?,
          clearButton: v['clearButton'] as bool?,
          prefixText: v['prefixText'] as String?,
          suffixText: v['suffixText'] as String?,
          hintText: v['hintText'] as String?,
          placeholder: v['placeholder'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Valor'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputNumberLabelPosition.${SgInputNumberLabelPosition.fromValue(e.value as String)!.name}',
              'elevation' =>
                'elevation: SgInputNumberElevation.${SgInputNumberElevation.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputNumber(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
