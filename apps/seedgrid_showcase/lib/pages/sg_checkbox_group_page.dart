// Showcase do SgCheckboxGroup. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_checkbox_group_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgCheckboxGroupPage extends StatefulWidget {
  const SgCheckboxGroupPage({super.key});

  @override
  State<SgCheckboxGroupPage> createState() => _SgCheckboxGroupPageState();
}

class _SgCheckboxGroupPageState extends State<SgCheckboxGroupPage> {
  List<Object> _basico = const ['option1'];
  List<Object> _horizontal = const [];
  List<Object> _controlada = const ['option2'];
  List<Object> _externo = const ['banana'];
  List<Object> _highlight = const ['reserve'];
  String _saida = '';
  String _enviadoObrigatorio = '';
  String _enviadoRegister = '';
  final SgCheckboxGroupController _controller = SgCheckboxGroupController();
  final SgFormController _formObrigatorio = SgFormController();
  final SgFormController _formRegister = SgFormController();

  @override
  void dispose() {
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
            // #region sg-checkbox-group-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'basic',
                  title: context.tx('Escolha as opções'),
                  value: _basico,
                  onChange: (v) => setState(() => _basico = v),
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 1'),
                      value: 'option1',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 2'),
                      value: 'option2',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 3'),
                      value: 'option3',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${context.tx('Valores selecionados')}: [${_basico.join(', ')}]',
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupBasico,
      ),
      ShowcaseExample(
        title: 'Orientação Horizontal',
        preview:
            // #region sg-checkbox-group-orientacao-horizontal
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'horizontal',
                  title: context.tx('Selecione frutas'),
                  orientation: SgCheckboxGroupOrientation.horizontal,
                  value: _horizontal,
                  onChange: (v) => setState(() => _horizontal = v),
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Maçã'),
                      value: 'apple',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Banana'),
                      value: 'banana',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Laranja'),
                      value: 'orange',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Uva'),
                      value: 'grape',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${context.tx('Valores selecionados')}: [${_horizontal.join(', ')}]',
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupOrientacaoHorizontal,
      ),
      ShowcaseExample(
        title: 'Com Ícones',
        preview:
            // #region sg-checkbox-group-com-icones
            SgCheckboxGroup(
              id: 'with-icons',
              title: context.tx('Escolha ações'),
              source: [
                SgCheckboxGroupOption(
                  label: context.tx('Favorito'),
                  value: 'favorite',
                  icon: Icon(Icons.favorite, size: 16),
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Importante'),
                  value: 'important',
                  icon: Icon(Icons.star, size: 16),
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Curtir'),
                  value: 'like',
                  icon: Icon(Icons.thumb_up, size: 16),
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupComIcones,
      ),
      ShowcaseExample(
        title: 'Apenas Ícones (Icon Only)',
        preview:
            // #region sg-checkbox-group-apenas-icones
            SgCheckboxGroup(
              id: 'icon-only',
              title: context.tx('Escolha formas'),
              iconOnly: true,
              source: [
                SgCheckboxGroupOption(
                  label: context.tx('Círculo'),
                  value: 'circle',
                  icon: Icon(Icons.circle, size: 20),
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Quadrado'),
                  value: 'square',
                  icon: Icon(Icons.square, size: 20),
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Triângulo'),
                  value: 'triangle',
                  icon: Icon(Icons.change_history, size: 20),
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupApenasIcones,
      ),
      ShowcaseExample(
        title: 'Seleção Controlada',
        preview:
            // #region sg-checkbox-group-selecao-controlada
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'controlled-selection',
                  title: context.tx('Seleção controlada'),
                  value: _controlada,
                  onChange: (v) => setState(() => _controlada = v),
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 1'),
                      value: 'option1',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 2'),
                      value: 'option2',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 3'),
                      value: 'option3',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${context.tx('Valor')}: [${_controlada.join(', ')}]'),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupSelecaoControlada,
      ),
      ShowcaseExample(
        title: 'Controle Externo (setValue/getValue)',
        preview:
            // #region sg-checkbox-group-controle-externo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'external-control',
                  title: context.tx('Frutas favoritas'),
                  value: _externo,
                  onChange: (v) => setState(() => _externo = v),
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Maçã'),
                      value: 'apple',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Banana'),
                      value: 'banana',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Laranja'),
                      value: 'orange',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Uva'),
                      value: 'grape',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SgGrid(
                  columns: {'base': 2, 'md': 4},
                  gap: 8,
                  children: [
                    SgButton(
                      label: Text(context.tx('Definir Maçã')),
                      onClick: () => setState(() => _externo = ['apple']),
                    ),
                    SgButton(
                      label: Text(context.tx('Banana + Uva')),
                      onClick: () =>
                          setState(() => _externo = ['banana', 'grape']),
                    ),
                    SgButton(
                      label: Text(context.tx('Selecionar Todos')),
                      onClick: () => setState(
                        () => _externo = ['apple', 'banana', 'orange', 'grape'],
                      ),
                    ),
                    SgButton(
                      label: Text(context.tx('Limpar')),
                      onClick: () => setState(() => _externo = []),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('${context.tx('Valor atual')}: [${_externo.join(', ')}]'),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupControleExterno,
      ),
      ShowcaseExample(
        title: 'Com Opção Desabilitada',
        preview:
            // #region sg-checkbox-group-com-opcao-desabilitada
            SgCheckboxGroup(
              id: 'with-disabled-option',
              title: context.tx('Nível de prioridade'),
              source: [
                SgCheckboxGroupOption(label: context.tx('Baixa'), value: 'low'),
                SgCheckboxGroupOption(
                  label: context.tx('Média'),
                  value: 'medium',
                ),
                SgCheckboxGroupOption(label: context.tx('Alta'), value: 'high'),
                SgCheckboxGroupOption(
                  label: context.tx('Urgente'),
                  value: 'urgent',
                  enabled: false,
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupComOpcaoDesabilitada,
      ),
      ShowcaseExample(
        title: 'Grupo Desabilitado',
        preview:
            // #region sg-checkbox-group-grupo-desabilitado
            SgCheckboxGroup(
              id: 'disabled-group',
              title: context.tx('Opções desabilitadas'),
              value: const ['option2'],
              enabled: false,
              source: [
                SgCheckboxGroupOption(
                  label: context.tx('Opção 1'),
                  value: 'option1',
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Opção 2'),
                  value: 'option2',
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Opção 3'),
                  value: 'option3',
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupGrupoDesabilitado,
      ),
      ShowcaseExample(
        title: 'Somente Leitura',
        preview:
            // #region sg-checkbox-group-somente-leitura
            SgCheckboxGroup(
              id: 'readonly',
              title: context.tx('Configuração atual (somente leitura)'),
              value: const ['banana', 'grape'],
              readOnly: true,
              source: [
                SgCheckboxGroupOption(
                  label: context.tx('Maçã'),
                  value: 'apple',
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Banana'),
                  value: 'banana',
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Laranja'),
                  value: 'orange',
                ),
                SgCheckboxGroupOption(label: context.tx('Uva'), value: 'grape'),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupSomenteLeitura,
      ),
      ShowcaseExample(
        title: 'Obrigatório com Validação',
        description:
            'name + control; required usa a mensagem do i18n e revalida a cada mudança depois do envio.',
        preview:
            // #region sg-checkbox-group-obrigatorio-com-validacao
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'preference',
                  title: context.tx('Preferência de contato *'),
                  name: 'preference',
                  control: _formObrigatorio,
                  required: true,
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Email'),
                      value: 'email',
                      icon: Icon(Icons.mail, size: 16),
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Telefone'),
                      value: 'phone',
                      icon: Icon(Icons.phone, size: 16),
                    ),
                    SgCheckboxGroupOption(
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
                    (values) => setState(
                      () => _enviadoObrigatorio = '${values['preference']}',
                    ),
                  ),
                ),
                if (_enviadoObrigatorio.isNotEmpty)
                  Text(
                    '${context.tx('Dados do formulário')}: $_enviadoObrigatorio',
                  ),
              ],
            ),
        // #endregion
        code:
            SgCheckboxGroupPageSnippets.sgCheckboxGroupObrigatorioComValidacao,
      ),
      ShowcaseExample(
        title: 'Horizontal com Ícones Coloridos',
        preview:
            // #region sg-checkbox-group-horizontal-com-icones-coloridos
            SgCheckboxGroup(
              id: 'horizontal-colored',
              title: context.tx('Condições climáticas'),
              orientation: SgCheckboxGroupOrientation.horizontal,
              source: [
                SgCheckboxGroupOption(
                  label: context.tx('Sol'),
                  value: 'sun',
                  icon: Icon(Icons.wb_sunny, size: 20, color: Colors.amber),
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Lua'),
                  value: 'moon',
                  icon: Icon(
                    Icons.nightlight_round,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Nuvem'),
                  value: 'cloud',
                  icon: Icon(Icons.cloud, size: 20, color: Colors.grey),
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets
            .sgCheckboxGroupHorizontalComIconesColoridos,
      ),
      ShowcaseExample(
        title: 'Estilo de Seleção Highlight (Lista)',
        preview:
            // #region sg-checkbox-group-estilo-selecao-highlight
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: SgCheckboxGroup(
                    id: 'highlight-list',
                    title: context.tx('Opções'),
                    selectionStyle: SgCheckboxGroupSelectionStyle.highlight,
                    value: _highlight,
                    onChange: (v) => setState(() => _highlight = v),
                    source: [
                      SgCheckboxGroupOption(
                        label: context.tx('Reserva'),
                        value: 'reserve',
                        icon: Icon(
                          Icons.account_balance,
                          size: 16,
                          color: Colors.indigo,
                        ),
                      ),
                      SgCheckboxGroupOption(
                        label: context.tx('Alerta'),
                        value: 'alert',
                        icon: Icon(
                          Icons.notifications,
                          size: 16,
                          color: Colors.pink,
                        ),
                      ),
                      SgCheckboxGroupOption(
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

                const SizedBox(height: 8),
                Text('${context.tx('Valor')}: [${_highlight.join(', ')}]'),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupEstiloSelecaoHighlight,
      ),
      ShowcaseExample(
        title: 'Com GroupBox Customizado',
        preview:
            // #region sg-checkbox-group-com-groupbox-customizado
            SgCheckboxGroup(
              id: 'custom-groupbox',
              title: context.tx('Escolha com estilo customizado'),
              groupBoxProps: SgChoiceGroupBoxProps(
                title: context.tx('Preferências'),
              ),
              source: [
                SgCheckboxGroupOption(
                  label: context.tx('Favorito'),
                  value: 'favorite',
                  icon: Icon(Icons.favorite, size: 16),
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Importante'),
                  value: 'important',
                  icon: Icon(Icons.star, size: 16),
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Curtir'),
                  value: 'like',
                  icon: Icon(Icons.thumb_up, size: 16),
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupComGroupboxCustomizado,
      ),
      ShowcaseExample(
        title: 'Formulário - Register',
        preview:
            // #region sg-checkbox-group-formulario-register
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'fruits',
                  title: context.tx('Escolha suas frutas'),
                  name: 'fruits',
                  control: _formRegister,
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Maçã'),
                      value: 'apple',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Banana'),
                      value: 'banana',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Laranja'),
                      value: 'orange',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Uva'),
                      value: 'grape',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _formRegister.handleSubmit(
                    (values) => setState(
                      () => _enviadoRegister = '${values['fruits']}',
                    ),
                  ),
                ),
                if (_enviadoRegister.isNotEmpty)
                  Text(
                    '${context.tx('Dados do formulário')}: $_enviadoRegister',
                  ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupFormularioRegister,
      ),
      ShowcaseExample(
        title: 'Marcar todos (showCheckAll)',
        description:
            "Checkbox 'Selecionar todos' separado por divisor, com estado indeterminado quando parcialmente selecionado",
        preview:
            // #region sg-checkbox-group-marcar-todos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tx('Sem label customizado (usa i18n)')),
                const SizedBox(height: 8),
                SgCheckboxGroup(
                  id: 'check-all',
                  title: context.tx('Exemplo de marcar todos'),
                  showCheckAll: true,
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 1'),
                      value: 'option1',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 2'),
                      value: 'option2',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 3'),
                      value: 'option3',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(context.tx('Com checkAllLabel e checkAllIcon')),
                const SizedBox(height: 8),
                SgCheckboxGroup(
                  id: 'check-all-custom',
                  title: context.tx('Com label + ícone customizados'),
                  showCheckAll: true,
                  checkAllLabel: context.tx('Marcar tudo'),
                  checkAllIcon: Icon(Icons.star, size: 16, color: Colors.amber),
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 1'),
                      value: 'option1',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 2'),
                      value: 'option2',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 3'),
                      value: 'option3',
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupMarcarTodos,
      ),
      ShowcaseExample(
        title: 'Checked inicial no source',
        description:
            'Estado inicial definido diretamente na prop checked de cada opção (modo não controlado)',
        preview:
            // #region sg-checkbox-group-checked-inicial
            SgCheckboxGroup(
              id: 'source-checked',
              title: context.tx('Frutas favoritas (inicial pelo source)'),
              source: [
                SgCheckboxGroupOption(
                  label: context.tx('Maçã'),
                  value: 'apple',
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Banana'),
                  value: 'banana',
                  checked: true,
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Laranja'),
                  value: 'orange',
                ),
                SgCheckboxGroupOption(
                  label: context.tx('Uva'),
                  value: 'grape',
                  checked: true,
                ),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupCheckedInicial,
      ),
      ShowcaseExample(
        title: 'Controle por código',
        description:
            'Acesso imperativo por código: getChecked, checkAll, clearAll, setChecked',
        preview:
            // #region sg-checkbox-group-controller-imperativo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCheckboxGroup(
                  id: 'ref-example',
                  title: context.tx('Selecione as opções'),
                  controller: _controller,
                  showCheckAll: true,
                  source: [
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 1'),
                      value: 'option1',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 2'),
                      value: 'option2',
                    ),
                    SgCheckboxGroupOption(
                      label: context.tx('Opção 3'),
                      value: 'option3',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SgGrid(
                  columns: {'base': 2, 'md': 4},
                  gap: 8,
                  children: [
                    SgButton(
                      label: Text('getChecked()'),
                      onClick: () => setState(() {
                        _saida = _controller.getChecked().toString();
                      }),
                    ),
                    SgButton(
                      label: Text('checkAll()'),
                      onClick: () => setState(() {
                        _controller.checkAll();
                        _saida = 'checkAll()';
                      }),
                    ),
                    SgButton(
                      label: Text('clearAll()'),
                      onClick: () => setState(() {
                        _controller.clearAll();
                        _saida = 'clearAll()';
                      }),
                    ),
                    SgButton(
                      label: Text('setChecked'),
                      onClick: () => setState(() {
                        _controller.setChecked(['option2']);
                        _saida = "setChecked(['option2'])";
                      }),
                    ),
                  ],
                ),
                if (_saida.isNotEmpty) Text('${context.tx('Saída')}: $_saida'),
              ],
            ),
        // #endregion
        code: SgCheckboxGroupPageSnippets.sgCheckboxGroupControllerImperativo,
      ),
    ];

    return SgShowcasePage(
      name: 'SgCheckboxGroup',
      description:
          'Grupo de caixas de seleção múltipla com título, orientação, estilo highlight, "selecionar todos" e ligação a formulário.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgCheckboxGroup']!,
        const SgPropSpec(
          name: 'controller',
          reactName: 'ref',
          type: 'SgCheckboxGroupController?',
          tsType: 'Ref<SgCheckboxGroupRef>',
          required: false,
          description:
              'Controle imperativo (getChecked, setChecked, checkAll, clearAll); substitui o ref do React.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgCheckboxGroup']!
            .where(
              (s) => const {
                'orientation',
                'selectionStyle',
                'iconOnly',
                'enabled',
                'readOnly',
                'required',
                'showCheckAll',
                'title',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgCheckboxGroup(
          id: 'pg',
          title: (v['title'] as String?) ?? 'Grupo',
          orientation:
              SgCheckboxGroupOrientation.fromValue(
                v['orientation'] as String?,
              ) ??
              SgCheckboxGroupOrientation.vertical,
          selectionStyle:
              SgCheckboxGroupSelectionStyle.fromValue(
                v['selectionStyle'] as String?,
              ) ??
              SgCheckboxGroupSelectionStyle.checkbox,
          iconOnly: (v['iconOnly'] as bool?) ?? false,
          enabled: (v['enabled'] as bool?) ?? true,
          readOnly: (v['readOnly'] as bool?) ?? false,
          required: (v['required'] as bool?) ?? false,
          showCheckAll: (v['showCheckAll'] as bool?) ?? false,
          source: const [
            SgCheckboxGroupOption(
              label: 'Um',
              value: 1,
              checked: true,
              icon: Icon(Icons.star, size: 16),
            ),
            SgCheckboxGroupOption(
              label: 'Dois',
              value: 2,
              icon: Icon(Icons.favorite, size: 16),
            ),
            SgCheckboxGroupOption(label: 'Três', value: 3),
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
                'orientation: SgCheckboxGroupOrientation.${SgCheckboxGroupOrientation.fromValue(e.value as String)!.name}',
              'selectionStyle' =>
                'selectionStyle: SgCheckboxGroupSelectionStyle.${SgCheckboxGroupSelectionStyle.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgCheckboxGroup(\n  ${args.join(',\n  ')},\n  source: [...],\n)';
        },
      ),
    );
  }
}
