// Showcase do SgColorPicker (componente somente Flutter). O codigo exibido em cada exemplo e o trecho entre
// `// #region` e `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_color_picker_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgColorPickerPage extends StatefulWidget {
  const SgColorPickerPage({super.key});

  @override
  State<SgColorPickerPage> createState() => _SgColorPickerPageState();
}

class _SgColorPickerPageState extends State<SgColorPickerPage> {
  String _basico = '#16803D';
  String _controlada = '#0EA5E9';
  String _predefinida = '#EF4444';
  String _dialogo = '#7C3AED';
  final SgFormController _form = SgFormController(
    defaultValues: {'marca': '#F97316'},
  );
  String _enviado = '';

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
        description:
            'defaultValue define a cor inicial; onChange entrega a cor em #RRGGBB maiúsculo a cada mudança válida.',
        preview:
            // #region sg-color-picker-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgColorPicker(
                  id: 'cor-basico',
                  defaultValue: '#16803D',
                  ariaLabel: 'Cor',
                  onChange: (hex) => setState(() => _basico = hex),
                ),
                Text(_basico),
              ],
            ),
        // #endregion
        code: SgColorPickerPageSnippets.sgColorPickerBasico,
      ),
      ShowcaseExample(
        title: 'Valor controlado',
        description:
            'Com value, o pai decide a cor: o painel só muda quando o value muda.',
        preview:
            // #region sg-color-picker-controlado
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgColorPicker(
                  id: 'cor-controlada',
                  labelText: context.tx('Cor da marca'),
                  value: _controlada,
                  onChange: (hex) => setState(() => _controlada = hex),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Voltar para azul')),
                  onClick: () => setState(() => _controlada = '#0EA5E9'),
                ),
              ],
            ),
        // #endregion
        code: SgColorPickerPageSnippets.sgColorPickerControlado,
      ),
      ShowcaseExample(
        title: 'Cores predefinidas',
        description: 'presets mostra uma paleta; tocar numa cor a escolhe.',
        preview:
            // #region sg-color-picker-predefinidas
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
                  onChange: (hex) => setState(() => _predefinida = hex),
                ),
                Text(_predefinida),
              ],
            ),
        // #endregion
        code: SgColorPickerPageSnippets.sgColorPickerPredefinidas,
      ),
      ShowcaseExample(
        title: 'Barras (matiz, saturação e brilho)',
        description:
            'mode: SgColorPickerMode.sliders troca o gradiente por três barras: matiz, saturação e brilho.',
        preview:
            // #region sg-color-picker-barras
            const SgColorPicker(
              id: 'cor-barras',
              defaultValue: '#16803D',
              mode: SgColorPickerMode.sliders,
              width: '80%',
            ),
        // #endregion
        code: SgColorPickerPageSnippets.sgColorPickerBarras,
      ),
      ShowcaseExample(
        title: 'Sem campo hex',
        description: 'showHex: false esconde o campo de texto #RRGGBB.',
        preview:
            // #region sg-color-picker-sem-hex
            const SgColorPicker(
              id: 'cor-sem-hex',
              defaultValue: '#0EA5E9',
              showHex: false,
              width: '80%',
            ),
        // #endregion
        code: SgColorPickerPageSnippets.sgColorPickerSemHex,
      ),
      ShowcaseExample(
        title: 'Desabilitado',
        description:
            'enabled: false bloqueia os sliders, o campo hex e as cores predefinidas.',
        preview:
            // #region sg-color-picker-desabilitado
            const SgColorPicker(
              id: 'cor-desabilitada',
              defaultValue: '#336699',
              presets: ['#EF4444', '#10B981'],
              enabled: false,
            ),
        // #endregion
        code: SgColorPickerPageSnippets.sgColorPickerDesabilitado,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control ligam o seletor ao SgFormController; o valor enviado é o #RRGGBB.',
        preview:
            // #region sg-color-picker-formulario
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
                    (values) => setState(() => _enviado = '${values['marca']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text(_enviado),
              ],
            ),
        // #endregion
        code: SgColorPickerPageSnippets.sgColorPickerFormulario,
      ),
      ShowcaseExample(
        title: 'Diálogo showSgColorPicker',
        description:
            'showSgColorPicker abre o painel num diálogo e devolve a cor escolhida, ou null se cancelar.',
        preview:
            // #region sg-color-picker-dialogo
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
                      initialValue: _dialogo,
                      presets: const ['#EF4444', '#10B981', '#7C3AED'],
                    );
                    if (hex != null) setState(() => _dialogo = hex);
                  },
                ),
                Container(width: 32, height: 32, color: sgHexToColor(_dialogo)),
                Text(_dialogo),
              ],
            ),
        // #endregion
        code: SgColorPickerPageSnippets.sgColorPickerDialogo,
      ),
    ];

    return SgShowcasePage(
      name: 'SgColorPicker',
      description:
          'Seletor de cor com área em gradiente (saturação e brilho) e barra de matiz, ou três barras, prévia, campo hex (#RRGGBB), cores predefinidas e diálogo showSgColorPicker.',
      examples: examples,
      propSpecs: sgFlutterOnlyPropSpecs['SgColorPicker']!,
      playground: SgPlayground(
        specs: sgFlutterOnlyPropSpecs['SgColorPicker']!
            .where(
              (s) => const {
                'enabled',
                'mode',
                'showHex',
                'labelText',
                'error',
                'ariaLabel',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgColorPicker(
          id: 'pg',
          defaultValue: '#7C3AED',
          enabled: (v['enabled'] as bool?) ?? true,
          mode: v['mode'] == 'sliders'
              ? SgColorPickerMode.sliders
              : SgColorPickerMode.gradient,
          showHex: (v['showHex'] as bool?) ?? true,
          labelText: v['labelText'] as String?,
          error: v['error'] as String?,
          ariaLabel: v['ariaLabel'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "defaultValue: '#7C3AED'"];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(
              e.value is String
                  ? "${e.key}: '${e.value}'"
                  : '${e.key}: ${e.value}',
            );
          }
          return 'SgColorPicker(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
