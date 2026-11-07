// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_radio_group_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgRadioGroupPageSnippets {
  /// Region `sg-radio-group-apenas-icones`.
  static const String sgRadioGroupApenasIcones = r'''
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
)
''';

  /// Region `sg-radio-group-basico`.
  static const String sgRadioGroupBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRadioGroup(
      id: 'basic',
      title: context.tx('Escolha uma opção'),
      value: _basico,
      onChange: (v) => setState(() => _basico = v),
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
    const SizedBox(height: 8),
    Text('${context.tx('Valor selecionado')}: ${_basico ?? '-'}'),
  ],
)
''';

  /// Region `sg-radio-group-com-groupbox-customizado`.
  static const String sgRadioGroupComGroupboxCustomizado = r'''
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
)
''';

  /// Region `sg-radio-group-com-icones`.
  static const String sgRadioGroupComIcones = r'''
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
)
''';

  /// Region `sg-radio-group-com-opcao-desabilitada`.
  static const String sgRadioGroupComOpcaoDesabilitada = r'''
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
)
''';

  /// Region `sg-radio-group-controle-externo`.
  static const String sgRadioGroupControleExterno = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRadioGroup(
      id: 'external-control',
      title: context.tx('Fruta favorita'),
      value: _externo,
      onChange: (v) => setState(() => _externo = v),
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
    const SizedBox(height: 16),
    SgGrid(
      columns: {'base': 2, 'md': 4},
      gap: 8,
      children: [
        SgButton(
          label: Text(context.tx('Definir Maçã')),
          onClick: () => setState(() => _externo = 'apple'),
        ),
        SgButton(
          label: Text(context.tx('Definir Banana')),
          onClick: () => setState(() => _externo = 'banana'),
        ),
        SgButton(
          label: Text(context.tx('Definir Laranja')),
          onClick: () => setState(() => _externo = 'orange'),
        ),
        SgButton(
          label: Text(context.tx('Limpar')),
          onClick: () => setState(() => _externo = null),
        ),
      ],
    ),
    const SizedBox(height: 16),
    Text(
      '${context.tx('Valor atual')}: ${_externo ?? context.tx('Nenhum')}',
    ),
  ],
)
''';

  /// Region `sg-radio-group-formulario-register`.
  static const String sgRadioGroupFormularioRegister = r'''
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
        (values) =>
            setState(() => _enviadoRegister = '${values['fruit']}'),
      ),
    ),
    if (_enviadoRegister.isNotEmpty)
      Text(
        '${context.tx('Dados do formulário')}: $_enviadoRegister',
      ),
  ],
)
''';

  /// Region `sg-radio-group-grupo-disabled`.
  static const String sgRadioGroupGrupoDisabled = r'''
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
)
''';

  /// Region `sg-radio-group-horizontal-com-icones-coloridos`.
  static const String sgRadioGroupHorizontalComIconesColoridos = r'''
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
)
''';

  /// Region `sg-radio-group-obrigatorio-com-validacao`.
  static const String sgRadioGroupObrigatorioComValidacao = r'''
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

  /// Region `sg-radio-group-orientation-horizontal`.
  static const String sgRadioGroupOrientationHorizontal = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRadioGroup(
      id: 'horizontal',
      title: context.tx('Selecione uma fruta'),
      orientation: SgRadioGroupOrientation.horizontal,
      value: _fruta,
      onChange: (v) => setState(() => _fruta = v),
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
  ],
)
''';

  /// Region `sg-radio-group-read-only`.
  static const String sgRadioGroupReadOnly = r'''
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
)
''';

  /// Region `sg-radio-group-selecao-controlada`.
  static const String sgRadioGroupSelecaoControlada = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRadioGroup(
      id: 'controlled-selection',
      title: context.tx('Seleção controlada'),
      value: _controlada,
      onChange: (v) => setState(() => _controlada = v),
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
    const SizedBox(height: 8),
    Text(
      '${context.tx('Valor')}: ${_controlada ?? context.tx('Nenhum')}',
    ),
  ],
)
''';

  /// Region `sg-radio-group-selection-style-highlight`.
  static const String sgRadioGroupSelectionStyleHighlight = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: SgRadioGroup(
        id: 'highlight-list',
        title: context.tx('Opções'),
        selectionStyle: SgRadioGroupSelectionStyle.highlight,
        value: _highlight,
        onChange: (v) => setState(() => _highlight = v),
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

    const SizedBox(height: 8),
    Text(
      '${context.tx('Valor')}: ${_highlight ?? context.tx('Nenhum')}',
    ),
  ],
)
''';
}
