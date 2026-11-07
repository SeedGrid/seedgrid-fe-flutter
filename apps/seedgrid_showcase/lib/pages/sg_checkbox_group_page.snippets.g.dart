// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_checkbox_group_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgCheckboxGroupPageSnippets {
  /// Region `sg-checkbox-group-apenas-icones`.
  static const String sgCheckboxGroupApenasIcones = r'''
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
)
''';

  /// Region `sg-checkbox-group-basico`.
  static const String sgCheckboxGroupBasico = r'''
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
)
''';

  /// Region `sg-checkbox-group-checked-inicial`.
  static const String sgCheckboxGroupCheckedInicial = r'''
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
)
''';

  /// Region `sg-checkbox-group-com-groupbox-customizado`.
  static const String sgCheckboxGroupComGroupboxCustomizado = r'''
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
)
''';

  /// Region `sg-checkbox-group-com-icones`.
  static const String sgCheckboxGroupComIcones = r'''
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
)
''';

  /// Region `sg-checkbox-group-com-opcao-desabilitada`.
  static const String sgCheckboxGroupComOpcaoDesabilitada = r'''
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
)
''';

  /// Region `sg-checkbox-group-controle-externo`.
  static const String sgCheckboxGroupControleExterno = r'''
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
)
''';

  /// Region `sg-checkbox-group-controller-imperativo`.
  static const String sgCheckboxGroupControllerImperativo = r'''
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
)
''';

  /// Region `sg-checkbox-group-estilo-selecao-highlight`.
  static const String sgCheckboxGroupEstiloSelecaoHighlight = r'''
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
)
''';

  /// Region `sg-checkbox-group-formulario-register`.
  static const String sgCheckboxGroupFormularioRegister = r'''
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
)
''';

  /// Region `sg-checkbox-group-grupo-desabilitado`.
  static const String sgCheckboxGroupGrupoDesabilitado = r'''
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
)
''';

  /// Region `sg-checkbox-group-horizontal-com-icones-coloridos`.
  static const String sgCheckboxGroupHorizontalComIconesColoridos = r'''
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
)
''';

  /// Region `sg-checkbox-group-marcar-todos`.
  static const String sgCheckboxGroupMarcarTodos = r'''
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
)
''';

  /// Region `sg-checkbox-group-obrigatorio-com-validacao`.
  static const String sgCheckboxGroupObrigatorioComValidacao = r'''
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
)
''';

  /// Region `sg-checkbox-group-orientacao-horizontal`.
  static const String sgCheckboxGroupOrientacaoHorizontal = r'''
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
)
''';

  /// Region `sg-checkbox-group-selecao-controlada`.
  static const String sgCheckboxGroupSelecaoControlada = r'''
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
)
''';

  /// Region `sg-checkbox-group-somente-leitura`.
  static const String sgCheckboxGroupSomenteLeitura = r'''
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
)
''';
}
