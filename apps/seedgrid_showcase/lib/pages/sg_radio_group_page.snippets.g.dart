// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_radio_group_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgRadioGroupPageSnippets {
  /// Region `sg-radio-group-basico`.
  static const String sgRadioGroupBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRadioGroup(
      id: 'tamanho',
      title: 'Tamanho',
      source: const [
        SgRadioGroupOption(label: 'Pequeno', value: 'p'),
        SgRadioGroupOption(label: 'Médio', value: 'm'),
        SgRadioGroupOption(
          label: 'Grande',
          value: 'g',
          disabled: true,
        ),
      ],
      onChange: (v) => setState(() => _tamanho = v),
    ),
    Text('Escolhido: ${_tamanho ?? '-'}'),
  ],
)
''';

  /// Region `sg-radio-group-estados`.
  static const String sgRadioGroupEstados = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRadioGroup(
      id: 'icones',
      title: 'iconOnly',
      iconOnly: true,
      orientation: SgRadioGroupOrientation.horizontal,
      selectionStyle: SgRadioGroupSelectionStyle.highlight,
      value: 'a',
      source: [
        SgRadioGroupOption(
          label: 'Estrela',
          value: 'a',
          icon: Icon(Icons.star),
        ),
        SgRadioGroupOption(
          label: 'Coração',
          value: 'b',
          icon: Icon(Icons.favorite),
        ),
      ],
    ),
    SizedBox(height: 16),
    SgRadioGroup(
      id: 'leitura',
      title: 'readOnly',
      readOnly: true,
      value: 'x',
      source: [
        SgRadioGroupOption(label: 'X', value: 'x'),
        SgRadioGroupOption(label: 'Y', value: 'y'),
      ],
    ),
    SizedBox(height: 16),
    SgRadioGroup(
      id: 'off',
      title: 'disabled',
      disabled: true,
      value: 'x',
      source: [
        SgRadioGroupOption(label: 'X', value: 'x'),
        SgRadioGroupOption(label: 'Y', value: 'y'),
      ],
    ),
  ],
)
''';

  /// Region `sg-radio-group-estilos`.
  static const String sgRadioGroupEstilos = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRadioGroup(
      id: 'horizontal',
      title: 'Horizontal',
      orientation: SgRadioGroupOrientation.horizontal,
      value: 'b',
      source: [
        SgRadioGroupOption(label: 'A', value: 'a'),
        SgRadioGroupOption(label: 'B', value: 'b'),
        SgRadioGroupOption(label: 'C', value: 'c'),
      ],
    ),
    SizedBox(height: 16),
    SgRadioGroup(
      id: 'highlight',
      title: 'Highlight',
      selectionStyle: SgRadioGroupSelectionStyle.highlight,
      value: 'lista',
      source: [
        SgRadioGroupOption(
          label: 'Lista',
          value: 'lista',
          icon: Icon(Icons.list, size: 16),
        ),
        SgRadioGroupOption(
          label: 'Grade',
          value: 'grade',
          icon: Icon(Icons.grid_view, size: 16),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-radio-group-formulario`.
  static const String sgRadioGroupFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRadioGroup(
      id: 'plano',
      name: 'plano',
      control: _form,
      title: 'Plano',
      required: true,
      source: const [
        SgRadioGroupOption(label: 'Grátis', value: 'free'),
        SgRadioGroupOption(label: 'Pro', value: 'pro'),
      ],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['plano']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';
}
