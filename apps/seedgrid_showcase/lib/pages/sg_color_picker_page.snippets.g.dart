// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_color_picker_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgColorPickerPageSnippets {
  /// Region `sg-color-picker-barras`.
  static const String sgColorPickerBarras = r'''
const SgColorPicker(
  id: 'cor-barras',
  defaultValue: '#16803D',
  mode: SgColorPickerMode.sliders,
  width: '80%',
)
''';

  /// Region `sg-color-picker-basico`.
  static const String sgColorPickerBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgColorPicker(
      id: 'cor-basico',
      defaultValue: '#16803D',
      ariaLabel: 'Cor',
      onChange: (hex) => _basico.value = hex,
    ),
    ValueListenableBuilder<String>(
      valueListenable: _basico,
      builder: (context, hex, _) => Text(hex),
    ),
  ],
)
''';

  /// Region `sg-color-picker-controlado`.
  static const String sgColorPickerControlado = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ValueListenableBuilder<String>(
      valueListenable: _controlada,
      builder: (context, hex, _) => SgColorPicker(
        id: 'cor-controlada',
        labelText: context.tx('Cor da marca'),
        value: hex,
        onChange: (novo) => _controlada.value = novo,
      ),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Voltar para azul')),
      onClick: () => _controlada.value = '#0EA5E9',
    ),
  ],
)
''';

  /// Region `sg-color-picker-desabilitado`.
  static const String sgColorPickerDesabilitado = r'''
const SgColorPicker(
  id: 'cor-desabilitada',
  defaultValue: '#336699',
  presets: ['#EF4444', '#10B981'],
  enabled: false,
)
''';

  /// Region `sg-color-picker-dialogo`.
  static const String sgColorPickerDialogo = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      label: Text(context.tx('Escolher cor')),
      onClick: () async {
        final hex = await showSgColorPicker(
          context,
          id: 'cor-dialogo',
          initialValue: _dialogo.value,
          presets: const ['#EF4444', '#10B981', '#7C3AED'],
        );
        if (hex != null) _dialogo.value = hex;
      },
    ),
    ValueListenableBuilder<String>(
      valueListenable: _dialogo,
      builder: (context, hex, _) => Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Container(
            width: 32,
            height: 32,
            color: sgHexToColor(hex),
          ),
          Text(hex),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-color-picker-formulario`.
  static const String sgColorPickerFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgColorPicker(
      id: 'cor-formulario',
      name: 'marca',
      control: _form,
      presets: const ['#F97316', '#10B981', '#7C3AED'],
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => _enviado.value = '${values['marca']}',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _enviado,
      builder: (context, enviado, _) =>
          enviado.isEmpty ? const SizedBox.shrink() : Text(enviado),
    ),
  ],
)
''';

  /// Region `sg-color-picker-predefinidas`.
  static const String sgColorPickerPredefinidas = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgColorPicker(
      id: 'cor-predefinidas',
      defaultValue: '#EF4444',
      presets: const [
        '#EF4444',
        '#F97316',
        '#F59E0B',
        '#10B981',
        '#0EA5E9',
        '#7C3AED',
        '#EC4899',
      ],
      onChange: (hex) => _predefinida.value = hex,
    ),
    ValueListenableBuilder<String>(
      valueListenable: _predefinida,
      builder: (context, hex, _) => Text(hex),
    ),
  ],
)
''';

  /// Region `sg-color-picker-sem-hex`.
  static const String sgColorPickerSemHex = r'''
const SgColorPicker(
  id: 'cor-sem-hex',
  defaultValue: '#0EA5E9',
  showHex: false,
  width: '80%',
)
''';
}
