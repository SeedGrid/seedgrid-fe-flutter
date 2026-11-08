// Showcase do SgRadioGroup. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_radio_group_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgRadioGroupPage extends StatefulWidget {
  const SgRadioGroupPage({super.key});

  @override
  State<SgRadioGroupPage> createState() => _SgRadioGroupPageState();
}

class _SgRadioGroupPageState extends State<SgRadioGroupPage> {
  final ValueNotifier<Object?> _basico = ValueNotifier<Object?>('option1');
  final ValueNotifier<Object?> _fruta = ValueNotifier<Object?>(null);
  final ValueNotifier<Object?> _controlada = ValueNotifier<Object?>('option2');
  final ValueNotifier<Object?> _externo = ValueNotifier<Object?>('banana');
  final ValueNotifier<Object?> _highlight = ValueNotifier<Object?>('reserve');
  final ValueNotifier<String> _enviadoObrigatorio = ValueNotifier<String>('');
  final ValueNotifier<String> _enviadoRegister = ValueNotifier<String>('');
  final SgFormController _formObrigatorio = SgFormController();
  final SgFormController _formRegister = SgFormController();

  @override
  void dispose() {
    for (final n in <ChangeNotifier>[
      _basico,
      _fruta,
      _controlada,
      _externo,
      _highlight,
      _enviadoObrigatorio,
      _enviadoRegister,
    ]) {
      n.dispose();
    }
    _formObrigatorio.dispose();
    _formRegister.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        preview:
            // #region sg-radio-group-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<Object?>(
                  valueListenable: _basico,
                  builder: (context, valor, _) => SgRadioGroup(
                    id: 'basic',
                    title: context.tx('Escolha uma opção'),
                    value: valor,
                    onChange: (v) => _basico.value = v,
                    source: [
                      SgRadioGroupOption(
                        label: context.tx('Opção 1'),
                        value: 'option1',
                      ),
                      SgRadioGroupOption(
                        label: context.tx('Opção 2'),
                        value: 'option2',
                      ),
                      SgRadioGroupOption(
                        label: context.tx('Opção 3'),
                        value: 'option3',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<Object?>(
                  valueListenable: _basico,
                  builder: (context, valor, _) => Text(
                    '${context.tx('Valor selecionado')}: ${valor ?? '-'}',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupBasico,
      ),
      ShowcaseExample(
        title: 'Orientação Horizontal',
        preview:
            // #region sg-radio-group-orientation-horizontal
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<Object?>(
                  valueListenable: _fruta,
                  builder: (context, valor, _) => SgRadioGroup(
                    id: 'horizontal',
                    title: context.tx('Selecione uma fruta'),
                    orientation: SgRadioGroupOrientation.horizontal,
                    value: valor,
                    onChange: (v) => _fruta.value = v,
                    source: [
                      SgRadioGroupOption(
                        label: context.tx('Maçã'),
                        value: 'apple',
                      ),
                      SgRadioGroupOption(
                        label: context.tx('Banana'),
                        value: 'banana',
                      ),
                      SgRadioGroupOption(
                        label: context.tx('Laranja'),
                        value: 'orange',
                      ),
                      SgRadioGroupOption(
                        label: context.tx('Uva'),
                        value: 'grape',
                      ),
                    ],
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupOrientationHorizontal,
      ),
      ShowcaseExample(
        title: 'Com Ícones',
        preview:
            // #region sg-radio-group-com-icones
            SgRadioGroup(
              id: 'with-icons',
              title: context.tx('Escolha uma ação'),
              source: [
                SgRadioGroupOption(
                  label: context.tx('Favorito'),
                  value: 'favorite',
                  icon: Icon(Icons.favorite, size: 16),
                ),
                SgRadioGroupOption(
                  label: context.tx('Importante'),
                  value: 'important',
                  icon: Icon(Icons.star, size: 16),
                ),
                SgRadioGroupOption(
                  label: context.tx('Curtir'),
                  value: 'like',
                  icon: Icon(Icons.thumb_up, size: 16),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupComIcones,
      ),
      ShowcaseExample(
        title: 'Apenas Ícones (Icon Only)',
        preview:
            // #region sg-radio-group-apenas-icones
            SgRadioGroup(
              id: 'icon-only',
              title: context.tx('Escolha uma forma'),
              iconOnly: true,
              source: [
                SgRadioGroupOption(
                  label: context.tx('Círculo'),
                  value: 'circle',
                  icon: Icon(Icons.circle, size: 20),
                ),
                SgRadioGroupOption(
                  label: context.tx('Quadrado'),
                  value: 'square',
                  icon: Icon(Icons.square, size: 20),
                ),
                SgRadioGroupOption(
                  label: context.tx('Triângulo'),
                  value: 'triangle',
                  icon: Icon(Icons.change_history, size: 20),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupApenasIcones,
      ),
      ShowcaseExample(
        title: 'Seleção Controlada',
        preview:
            // #region sg-radio-group-selecao-controlada
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<Object?>(
                  valueListenable: _controlada,
                  builder: (context, valor, _) => SgRadioGroup(
                    id: 'controlled-selection',
                    title: context.tx('Seleção controlada'),
                    value: valor,
                    onChange: (v) => _controlada.value = v,
                    source: [
                      SgRadioGroupOption(
                        label: context.tx('Opção 1'),
                        value: 'option1',
                      ),
                      SgRadioGroupOption(
                        label: context.tx('Opção 2'),
                        value: 'option2',
                      ),
                      SgRadioGroupOption(
                        label: context.tx('Opção 3'),
                        value: 'option3',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<Object?>(
                  valueListenable: _controlada,
                  builder: (context, valor, _) => Text(
                    '${context.tx('Valor')}: ${valor ?? context.tx('Nenhum')}',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupSelecaoControlada,
      ),
      ShowcaseExample(
        title: 'Controle Externo (setValue/getValue)',
        preview:
            // #region sg-radio-group-controle-externo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<Object?>(
                  valueListenable: _externo,
                  builder: (context, valor, _) => SgRadioGroup(
                    id: 'external-control',
                    title: context.tx('Fruta favorita'),
                    value: valor,
                    onChange: (v) => _externo.value = v,
                    source: [
                      SgRadioGroupOption(
                        label: context.tx('Maçã'),
                        value: 'apple',
                      ),
                      SgRadioGroupOption(
                        label: context.tx('Banana'),
                        value: 'banana',
                      ),
                      SgRadioGroupOption(
                        label: context.tx('Laranja'),
                        value: 'orange',
                      ),
                      SgRadioGroupOption(
                        label: context.tx('Uva'),
                        value: 'grape',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SgGrid(
                  columns: {'base': 2, 'md': 4},
                  gap: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Definir Maçã')),
                      onClick: () => _externo.value = 'apple',
                    ),
                    SgButton(
                      label: Text(context.tx('Definir Banana')),
                      onClick: () => _externo.value = 'banana',
                    ),
                    SgButton(
                      label: Text(context.tx('Definir Laranja')),
                      onClick: () => _externo.value = 'orange',
                    ),
                    SgButton(
                      label: Text(context.tx('Limpar')),
                      onClick: () => _externo.value = null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<Object?>(
                  valueListenable: _externo,
                  builder: (context, valor, _) => Text(
                    '${context.tx('Valor atual')}: ${valor ?? context.tx('Nenhum')}',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupControleExterno,
      ),
      ShowcaseExample(
        title: 'Com Opção Desabilitada',
        preview:
            // #region sg-radio-group-com-opcao-desabilitada
            SgRadioGroup(
              id: 'with-disabled-option',
              title: context.tx('Nível de prioridade'),
              source: [
                SgRadioGroupOption(label: context.tx('Baixa'), value: 'low'),
                SgRadioGroupOption(label: context.tx('Média'), value: 'medium'),
                SgRadioGroupOption(label: context.tx('Alta'), value: 'high'),
                SgRadioGroupOption(
                  label: context.tx('Urgente'),
                  value: 'urgent',
                  enabled: false,
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupComOpcaoDesabilitada,
      ),
      ShowcaseExample(
        title: 'Grupo Desabilitado',
        preview:
            // #region sg-radio-group-grupo-disabled
            SgRadioGroup(
              id: 'disabled-group',
              title: context.tx('Opções desabilitadas'),
              value: 'option2',
              enabled: false,
              source: [
                SgRadioGroupOption(
                  label: context.tx('Opção 1'),
                  value: 'option1',
                ),
                SgRadioGroupOption(
                  label: context.tx('Opção 2'),
                  value: 'option2',
                ),
                SgRadioGroupOption(
                  label: context.tx('Opção 3'),
                  value: 'option3',
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupGrupoDisabled,
      ),
      ShowcaseExample(
        title: 'Somente Leitura',
        preview:
            // #region sg-radio-group-read-only
            SgRadioGroup(
              id: 'readonly',
              title: context.tx('Configuração atual (somente leitura)'),
              value: 'banana',
              readOnly: true,
              source: [
                SgRadioGroupOption(label: context.tx('Maçã'), value: 'apple'),
                SgRadioGroupOption(
                  label: context.tx('Banana'),
                  value: 'banana',
                ),
                SgRadioGroupOption(
                  label: context.tx('Laranja'),
                  value: 'orange',
                ),
                SgRadioGroupOption(label: context.tx('Uva'), value: 'grape'),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupReadOnly,
      ),
      ShowcaseExample(
        title: 'Obrigatório com Validação',
        preview:
            // #region sg-radio-group-obrigatorio-com-validacao
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRadioGroup(
                  title: context.tx('Preferência de contato *'),
                  name: 'preference',
                  control: _formObrigatorio,
                  required: true,
                  source: [
                    SgRadioGroupOption(
                      label: context.tx('Email'),
                      value: 'email',
                      icon: Icon(Icons.mail, size: 16),
                    ),
                    SgRadioGroupOption(
                      label: context.tx('Telefone'),
                      value: 'phone',
                      icon: Icon(Icons.phone, size: 16),
                    ),
                    SgRadioGroupOption(
                      label: context.tx('Presencial'),
                      value: 'in-person',
                      icon: Icon(Icons.home, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _formObrigatorio.handleSubmit(
                    (values) =>
                        _enviadoObrigatorio.value = '${values['preference']}',
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _enviadoObrigatorio,
                  builder: (context, valor, _) => valor.isEmpty
                      ? const SizedBox.shrink()
                      : Text('${context.tx('Dados do formulário')}: $valor'),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupObrigatorioComValidacao,
      ),
      ShowcaseExample(
        title: 'Horizontal com Ícones Coloridos',
        preview:
            // #region sg-radio-group-horizontal-com-icones-coloridos
            SgRadioGroup(
              id: 'horizontal-colored',
              title: context.tx('Condição climática'),
              orientation: SgRadioGroupOrientation.horizontal,
              source: [
                SgRadioGroupOption(
                  label: context.tx('Sol'),
                  value: 'sun',
                  icon: Icon(Icons.wb_sunny, size: 20, color: Colors.amber),
                ),
                SgRadioGroupOption(
                  label: context.tx('Lua'),
                  value: 'moon',
                  icon: Icon(
                    Icons.nightlight_round,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
                SgRadioGroupOption(
                  label: context.tx('Nuvem'),
                  value: 'cloud',
                  icon: Icon(Icons.cloud, size: 20, color: Colors.grey),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupHorizontalComIconesColoridos,
      ),
      ShowcaseExample(
        title: 'Estilo de Seleção Destacado (Lista)',
        preview:
            // #region sg-radio-group-selection-style-highlight
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: ValueListenableBuilder<Object?>(
                    valueListenable: _highlight,
                    builder: (context, valor, _) => SgRadioGroup(
                      id: 'highlight-list',
                      title: context.tx('Opções'),
                      selectionStyle: SgRadioGroupSelectionStyle.highlight,
                      value: valor,
                      onChange: (v) => _highlight.value = v,
                      source: [
                        SgRadioGroupOption(
                          label: context.tx('Reserva'),
                          value: 'reserve',
                          icon: Icon(
                            Icons.account_balance,
                            size: 16,
                            color: Colors.indigo,
                          ),
                        ),
                        SgRadioGroupOption(
                          label: context.tx('Alerta'),
                          value: 'alert',
                          icon: Icon(
                            Icons.notifications,
                            size: 16,
                            color: Colors.pink,
                          ),
                        ),
                        SgRadioGroupOption(
                          label: context.tx('Atualizar'),
                          value: 'refresh',
                          icon: Icon(
                            Icons.refresh,
                            size: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                ValueListenableBuilder<Object?>(
                  valueListenable: _highlight,
                  builder: (context, valor, _) => Text(
                    '${context.tx('Valor')}: ${valor ?? context.tx('Nenhum')}',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupSelectionStyleHighlight,
      ),
      ShowcaseExample(
        title: 'Com GroupBox Customizado',
        preview:
            // #region sg-radio-group-com-groupbox-customizado
            SgRadioGroup(
              id: 'custom-groupbox',
              title: context.tx('Escolha com estilo customizado'),
              groupBoxProps: SgChoiceGroupBoxProps(
                title: context.tx('Preferências'),
              ),
              source: [
                SgRadioGroupOption(
                  label: context.tx('Favorito'),
                  value: 'favorite',
                  icon: Icon(Icons.favorite, size: 16),
                ),
                SgRadioGroupOption(
                  label: context.tx('Importante'),
                  value: 'important',
                  icon: Icon(Icons.star, size: 16),
                ),
                SgRadioGroupOption(
                  label: context.tx('Curtir'),
                  value: 'like',
                  icon: Icon(Icons.thumb_up, size: 16),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupComGroupboxCustomizado,
      ),
      ShowcaseExample(
        title: 'Formulário - Register',
        preview:
            // #region sg-radio-group-formulario-register
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRadioGroup(
                  title: context.tx('Escolha sua fruta'),
                  name: 'fruit',
                  control: _formRegister,
                  source: [
                    SgRadioGroupOption(
                      label: context.tx('Maçã'),
                      value: 'apple',
                    ),
                    SgRadioGroupOption(
                      label: context.tx('Banana'),
                      value: 'banana',
                    ),
                    SgRadioGroupOption(
                      label: context.tx('Laranja'),
                      value: 'orange',
                    ),
                    SgRadioGroupOption(
                      label: context.tx('Uva'),
                      value: 'grape',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _formRegister.handleSubmit(
                    (values) => _enviadoRegister.value = '${values['fruit']}',
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _enviadoRegister,
                  builder: (context, valor, _) => valor.isEmpty
                      ? const SizedBox.shrink()
                      : Text('${context.tx('Dados do formulário')}: $valor'),
                ),
              ],
            ),
        // #endregion
        code: SgRadioGroupPageSnippets.sgRadioGroupFormularioRegister,
      ),
    ];

    return SgShowcasePage(
      name: 'SgRadioGroup',
      description:
          'Grupo de escolha única com título, orientação, estilo highlight, navegação por setas e ligação a formulário.',
      examples: examples,
      propSpecs: sgPropSpecs['SgRadioGroup']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgRadioGroup']!
            .where(
              (s) => const {
                'orientation',
                'selectionStyle',
                'iconOnly',
                'enabled',
                'readOnly',
                'required',
                'title',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgRadioGroup(
          id: 'pg',
          title: (v['title'] as String?) ?? 'Grupo',
          orientation:
              SgRadioGroupOrientation.fromValue(v['orientation'] as String?) ??
              SgRadioGroupOrientation.vertical,
          selectionStyle:
              SgRadioGroupSelectionStyle.fromValue(
                v['selectionStyle'] as String?,
              ) ??
              SgRadioGroupSelectionStyle.radio,
          iconOnly: (v['iconOnly'] as bool?) ?? false,
          enabled: (v['enabled'] as bool?) ?? true,
          readOnly: (v['readOnly'] as bool?) ?? false,
          required: (v['required'] as bool?) ?? false,
          source: const [
            SgRadioGroupOption(
              label: 'Um',
              value: 1,
              icon: Icon(Icons.star, size: 16),
            ),
            SgRadioGroupOption(
              label: 'Dois',
              value: 2,
              icon: Icon(Icons.favorite, size: 16),
            ),
            SgRadioGroupOption(label: 'Três', value: 3),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            "title: '${v['title'] ?? 'Grupo'}'",
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false || e.key == 'title') {
              continue;
            }
            args.add(switch (e.key) {
              'orientation' =>
                'orientation: SgRadioGroupOrientation.${SgRadioGroupOrientation.fromValue(e.value as String)!.name}',
              'selectionStyle' =>
                'selectionStyle: SgRadioGroupSelectionStyle.${SgRadioGroupSelectionStyle.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgRadioGroup(\n  ${args.join(',\n  ')},\n  source: [...],\n)';
        },
      ),
    );
  }
}
