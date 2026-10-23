// Showcase do SgToggleSwitch. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_toggle_switch_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';

class SgToggleSwitchPage extends StatefulWidget {
  const SgToggleSwitchPage({super.key});

  @override
  State<SgToggleSwitchPage> createState() => _SgToggleSwitchPageState();
}

class _SgToggleSwitchPageState extends State<SgToggleSwitchPage> {
  bool _ligado = false;
  final SgFormController _form = SgFormController();
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
        description: 'Clique no rótulo ou na chave; Tab foca e Espaço alterna.',
        preview:
            // #region sg-toggle-switch-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgToggleSwitch(
                  id: 'notificar',
                  label: 'Receber notificações',
                  description: 'Avisos por e-mail',
                  onChange: (v) => setState(() => _ligado = v),
                ),
                Text('Estado: ${_ligado ? 'ligado' : 'desligado'}'),
              ],
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchBasico,
      ),
      ShowcaseExample(
        title: 'Ícones, somente leitura e desabilitado',
        preview:
            // #region sg-toggle-switch-estados
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgToggleSwitch(
                  id: 'icones',
                  label: 'Com ícones',
                  defaultChecked: true,
                  onIcon: Icon(Icons.check, size: 12),
                  offIcon: Icon(Icons.close, size: 12),
                ),
                SizedBox(height: 12),
                SgToggleSwitch(
                  id: 'leitura',
                  label: 'readOnly',
                  readOnly: true,
                  defaultChecked: true,
                ),
                SizedBox(height: 12),
                SgToggleSwitch(id: 'off', label: 'disabled', disabled: true),
              ],
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchEstados,
      ),
      ShowcaseExample(
        title: 'Validação',
        description:
            'required valida ao sair do campo (validateOnBlur) ou a cada mudança (validateOnBlur: false).',
        preview:
            // #region sg-toggle-switch-validacao
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SgToggleSwitch(
                  id: 'termos',
                  label: 'Aceito os termos',
                  required: true,
                  requiredMessage: 'Aceite os termos para continuar',
                ),
                const SizedBox(height: 12),
                SgToggleSwitch(
                  id: 'regra',
                  label: 'Não pode ligar',
                  validateOnBlur: false,
                  validation: (ligado) =>
                      ligado ? 'Esta chave deve ficar desligada' : null,
                ),
              ],
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchValidacao,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        preview:
            // #region sg-toggle-switch-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgToggleSwitch(
                  id: 'newsletter',
                  name: 'newsletter',
                  control: _form,
                  label: 'Assinar a newsletter',
                  required: true,
                  requiredMessage: 'Marque para assinar',
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) =>
                        setState(() => _enviado = '${values['newsletter']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgToggleSwitch',
      description:
          'Chave liga/desliga com rótulo, descrição, ícones, validação e ligação a formulário. SgSwitch é um alias.',
      examples: examples,
      propSpecs: sgPropSpecs['SgToggleSwitch']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgToggleSwitch']!
            .where(
              (s) => const {
                'label',
                'description',
                'disabled',
                'readOnly',
                'required',
                'defaultChecked',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgToggleSwitch(
          key: ValueKey('pg-${v['defaultChecked']}'),
          id: 'pg',
          label: (v['label'] as String?) ?? 'Chave',
          description: v['description'] as String?,
          disabled: v['disabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          required: v['required'] as bool?,
          defaultChecked: v['defaultChecked'] as bool?,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            "label: '${v['label'] ?? 'Chave'}'",
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false || e.key == 'label') {
              continue;
            }
            args.add(
              e.value is String
                  ? "${e.key}: '${e.value}'"
                  : '${e.key}: ${e.value}',
            );
          }
          return 'SgToggleSwitch(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
