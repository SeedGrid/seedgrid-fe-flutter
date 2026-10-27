// Showcase do SgWhistleHost. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// O host da pagina fica numa faixa no rodape; os avisos aparecem ali.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_whistle_host_page.snippets.g.dart';

class SgWhistleHostPage extends StatefulWidget {
  const SgWhistleHostPage({super.key});

  @override
  State<SgWhistleHostPage> createState() => _SgWhistleHostPageState();
}

class _SgWhistleHostPageState extends State<SgWhistleHostPage> {
  final ValueNotifier<Map<String, Object?>> _cfg = ValueNotifier({});
  bool _extraHost = false;
  bool _rounded = true;

  @override
  void dispose() {
    dismissSgWhistle();
    _cfg.dispose();
    super.dispose();
  }

  void _publish(Map<String, Object?> values) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !mapEquals(_cfg.value, values)) {
        _cfg.value = Map.of(values);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Um host para a tela',
        description:
            'O SgWhistleHost marca o lugar dos avisos; qualquer código dispara pela API sgWhistle.',
        preview:
            // #region sg-whistle-host-basico
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgButton(
                  label: const Text('Sucesso'),
                  severity: SgSeverity.success,
                  onClick: () => sgWhistle.success(
                    const SgWhistleOptions(message: 'Salvo pelo host'),
                  ),
                ),
                SgButton(
                  label: const Text('Erro'),
                  severity: SgSeverity.danger,
                  onClick: () => sgWhistle.error(
                    const SgWhistleOptions(message: 'Falhou pelo host'),
                  ),
                ),
                SgButton(
                  label: const Text('Limpar'),
                  appearance: SgAppearance.ghost,
                  onClick: sgWhistle.dismiss,
                ),
              ],
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostBasico,
      ),
      ShowcaseExample(
        title: 'O host prevalece sobre o SgWhistler solto',
        description:
            'A caixa abaixo tem um SgWhistler solto, mas há um SgWhistleHost na página: o solto não desenha nada e cada aviso aparece uma vez só.',
        preview:
            // #region sg-whistle-host-prevalece
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SgWhistler(),
                SgButton(
                  label: const Text('Disparar'),
                  onClick: () => sgWhistle.info(
                    const SgWhistleOptions(message: 'Só aparece no host'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostPrevalece,
      ),
      ShowcaseExample(
        title: 'Vários hosts',
        description:
            'O último host montado é o ativo (aqui, um segundo host com cantos retos); ao sair, o anterior volta.',
        preview:
            // #region sg-whistle-host-varios
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('Segundo host (cantos retos)'),
                  selected: _extraHost,
                  onSelected: (v) => setState(() => _extraHost = v),
                ),
                SgButton(
                  label: const Text('Disparar'),
                  onClick: () => sgWhistle.warning(
                    const SgWhistleOptions(
                      message: 'Quem está ativo?',
                      duration: 3000,
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostVarios,
      ),
      ShowcaseExample(
        title: 'Props do host',
        description:
            'O host aceita as mesmas props do SgWhistler (aqui: rounded).',
        preview:
            // #region sg-whistle-host-props
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('rounded'),
                  selected: _rounded,
                  onSelected: (v) => setState(() => _rounded = v),
                ),
                SgButton(
                  label: const Text('Disparar'),
                  onClick: () => sgWhistle.success(
                    const SgWhistleOptions(
                      message: 'Cantos do host',
                      duration: 3000,
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostProps,
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: SgShowcasePage(
            name: 'SgWhistleHost',
            description:
                'Marca onde os whistles aparecem. Aceita as mesmas props do SgWhistler; com host presente, o SgWhistler solto cede a vez.',
            examples: examples,
            propSpecs: sgPropSpecs['SgWhistleHost']!,
            playground: SgPlayground(
              specs: sgPropSpecs['SgWhistleHost']!
                  .where((s) => s.name == 'newestOnTop')
                  .toList(),
              builder: (context, v) {
                _publish(v);
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: const Text('Disparar 2 avisos'),
                      onClick: () {
                        sgWhistle.info(
                          const SgWhistleOptions(
                            message: 'Primeiro',
                            duration: 4000,
                          ),
                        );
                        sgWhistle.success(
                          const SgWhistleOptions(
                            message: 'Segundo',
                            duration: 4000,
                          ),
                        );
                      },
                    ),
                    Text('newestOnTop: ${v['newestOnTop'] ?? false}'),
                  ],
                );
              },
              codeBuilder: (v) =>
                  'SgWhistleHost(${v['newestOnTop'] == true ? '\n  newestOnTop: true,\n' : ''})',
            ),
          ),
        ),
        ValueListenableBuilder<Map<String, Object?>>(
          valueListenable: _cfg,
          builder: (context, v, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SgWhistleHost(
              rounded: _rounded,
              newestOnTop: v['newestOnTop'] == true,
            ),
          ),
        ),
        if (_extraHost)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SgWhistleHost(rounded: false),
          ),
      ],
    );
  }
}
