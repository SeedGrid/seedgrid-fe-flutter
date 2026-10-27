// Showcase do SgWhistler. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// O whistler NAO e flutuante: aqui ele ocupa uma faixa fixa no rodape da pagina, onde os avisos aparecem.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_whistler_page.snippets.g.dart';

class SgWhistlerPage extends StatefulWidget {
  const SgWhistlerPage({super.key});

  @override
  State<SgWhistlerPage> createState() => _SgWhistlerPageState();
}

class _SgWhistlerPageState extends State<SgWhistlerPage> {
  final ValueNotifier<Map<String, Object?>> _cfg = ValueNotifier({});
  bool _rounded = true;
  double _gap = 12;

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
        title: 'Severidades',
        description: 'Os avisos aparecem no rodapé da página.',
        preview:
            // #region sg-whistler-severidades
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgButton(
                  label: const Text('Padrão'),
                  onClick: () => sgWhistle.show(
                    const SgWhistleOptions(message: 'Aviso simples'),
                  ),
                ),
                SgButton(
                  label: const Text('Sucesso'),
                  severity: SgSeverity.success,
                  onClick: () => sgWhistle.success(
                    const SgWhistleOptions(
                      title: 'Salvo',
                      message: 'As alterações foram gravadas.',
                    ),
                  ),
                ),
                SgButton(
                  label: const Text('Info'),
                  severity: SgSeverity.info,
                  onClick: () => sgWhistle.info(
                    const SgWhistleOptions(message: 'Há uma nova versão.'),
                  ),
                ),
                SgButton(
                  label: const Text('Aviso'),
                  severity: SgSeverity.warning,
                  onClick: () => sgWhistle.warning(
                    const SgWhistleOptions(message: 'Sessão perto de expirar.'),
                  ),
                ),
                SgButton(
                  label: const Text('Erro'),
                  severity: SgSeverity.danger,
                  onClick: () => sgWhistle.error(
                    const SgWhistleOptions(
                      title: 'Falha',
                      message: 'Não foi possível salvar.',
                    ),
                  ),
                ),
                SgButton(
                  label: const Text('Limpar tudo'),
                  appearance: SgAppearance.ghost,
                  onClick: sgWhistle.dismiss,
                ),
              ],
            ),
        // #endregion
        code: SgWhistlerPageSnippets.sgWhistlerSeveridades,
      ),
      ShowcaseExample(
        title: 'Estilos de borda',
        preview:
            // #region sg-whistler-bordas
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final style in SgWhistleBorderStyle.values)
                  SgButton(
                    label: Text(style.value),
                    appearance: SgAppearance.outline,
                    onClick: () => sgWhistle.info(
                      SgWhistleOptions(
                        message: 'borderStyle: ${style.value}',
                        borderStyle: style,
                        duration: 3000,
                      ),
                    ),
                  ),
              ],
            ),
        // #endregion
        code: SgWhistlerPageSnippets.sgWhistlerBordas,
      ),
      ShowcaseExample(
        title: 'Ação, ícone e onClose',
        description:
            'A ação fecha o aviso; onClose roda quando ele sai por qualquer motivo.',
        preview:
            // #region sg-whistler-acao
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgButton(
                  label: const Text('Com ação'),
                  onClick: () => sgWhistle.warning(
                    SgWhistleOptions(
                      title: 'Rascunho',
                      message: 'Você tem alterações não salvas.',
                      icon: const Icon(Icons.edit),
                      duration: 0,
                      action: SgWhistleAction(
                        label: 'Salvar',
                        onClick: () => sgWhistle.success(
                          const SgWhistleOptions(message: 'Rascunho salvo'),
                        ),
                      ),
                      onClose: () => debugPrint('whistle fechado'),
                    ),
                  ),
                ),
                SgButton(
                  label: const Text('Sem botão de fechar'),
                  appearance: SgAppearance.outline,
                  onClick: () => sgWhistle.info(
                    const SgWhistleOptions(
                      message: 'Some em 3 segundos',
                      dismissible: false,
                      duration: 3000,
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgWhistlerPageSnippets.sgWhistlerAcao,
      ),
      ShowcaseExample(
        title: 'Atualizar e promise',
        description:
            'update troca o conteúdo do mesmo aviso; promise faz isso sozinho (loading, depois success ou error).',
        preview:
            // #region sg-whistler-atualizar
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgButton(
                  label: const Text('Atualizar'),
                  onClick: () {
                    final id = sgWhistle.loading(
                      const SgWhistleOptions(message: 'Gerando relatório...'),
                    );
                    Future<void>.delayed(
                      const Duration(seconds: 2),
                      () => sgWhistle.update(
                        id,
                        const SgWhistleCustomOptions(
                          severity: SgWhistleSeverity.success,
                          message: 'Relatório pronto',
                        ),
                      ),
                    );
                  },
                ),
                SgButton(
                  label: const Text('Promise'),
                  appearance: SgAppearance.outline,
                  onClick: () => sgWhistle.promise<int>(
                    Future<int>.delayed(const Duration(seconds: 2), () => 42),
                    SgWhistlePromiseStates<int>(
                      loading: const SgWhistleOptions(message: 'Calculando...'),
                      success: (int v) =>
                          SgWhistleOptions(message: 'Resultado: $v'),
                      error: const SgWhistleOptions(message: 'Deu erro'),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgWhistlerPageSnippets.sgWhistlerAtualizar,
      ),
      ShowcaseExample(
        title: 'Aparência do whistler',
        description: 'rounded e gap do whistler desta página.',
        preview:
            // #region sg-whistler-aparencia
            Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('rounded'),
                  selected: _rounded,
                  onSelected: (v) => setState(() => _rounded = v),
                ),
                SizedBox(
                  width: 180,
                  child: Slider(
                    value: _gap,
                    min: 0,
                    max: 40,
                    divisions: 8,
                    label: 'gap ${_gap.round()}',
                    onChanged: (v) => setState(() => _gap = v),
                  ),
                ),
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
              ],
            ),
        // #endregion
        code: SgWhistlerPageSnippets.sgWhistlerAparencia,
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: SgShowcasePage(
            name: 'SgWhistler',
            description:
                'Pilha de avisos persistentes ou semi-persistentes, com cores por severidade, ação opcional e máximo visível. Fica no fluxo do layout; cede a vez a um SgWhistleHost.',
            examples: examples,
            propSpecs: sgPropSpecs['SgWhistler']!,
            playground: SgPlayground(
              specs: sgPropSpecs['SgWhistler']!
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
                  'SgWhistler(${v['newestOnTop'] == true ? '\n  newestOnTop: true,\n' : ''})',
            ),
          ),
        ),
        ValueListenableBuilder<Map<String, Object?>>(
          valueListenable: _cfg,
          builder: (context, v, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SgWhistler(
              rounded: _rounded,
              gap: _gap,
              newestOnTop: v['newestOnTop'] == true,
            ),
          ),
        ),
      ],
    );
  }
}
