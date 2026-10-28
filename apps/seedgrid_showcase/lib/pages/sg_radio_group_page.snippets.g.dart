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
      title: context.tx('Tamanho'),
      source: [
        SgRadioGroupOption(
          label: context.tx('Pequeno'),
          value: 'p',
        ),
        SgRadioGroupOption(label: context.tx('Médio'), value: 'm'),
        SgRadioGroupOption(
          label: context.tx('Grande'),
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
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRadioGroup(
      id: 'icones',
      title: context.tx('iconOnly'),
      iconOnly: true,
      orientation: SgRadioGroupOrientation.horizontal,
      selectionStyle: SgRadioGroupSelectionStyle.highlight,
      value: 'a',
      source: [
        SgRadioGroupOption(
          label: context.tx('Estrela'),
          value: 'a',
          icon: Icon(Icons.star),
        ),
        SgRadioGroupOption(
          label: context.tx('Coração'),
          value: 'b',
          icon: Icon(Icons.favorite),
        ),
      ],
    ),
    SizedBox(height: 16),
    SgRadioGroup(
      id: 'leitura',
      title: context.tx('readOnly'),
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
      title: context.tx('disabled'),
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
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRadioGroup(
      id: 'horizontal',
      title: context.tx('Horizontal'),
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
      title: context.tx('Highlight'),
      selectionStyle: SgRadioGroupSelectionStyle.highlight,
      value: 'lista',
      source: [
        SgRadioGroupOption(
          label: context.tx('Lista'),
          value: 'lista',
          icon: Icon(Icons.list, size: 16),
        ),
        SgRadioGroupOption(
          label: context.tx('Grade'),
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
      title: context.tx('Plano'),
      required: true,
      source: [
        SgRadioGroupOption(
          label: context.tx('Grátis'),
          value: 'free',
        ),
        SgRadioGroupOption(label: context.tx('Pro'), value: 'pro'),
      ],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['plano']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';
}
