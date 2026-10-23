// Showcase do SgToaster. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// O toaster fica num Stack por cima da pagina (e flutuante, como o `position: fixed` do React); os
// exemplos so disparam toasts e as chaves de aparencia da pagina configuram esse toaster.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_toaster_page.snippets.g.dart';

class SgToasterPage extends StatefulWidget {
  const SgToasterPage({super.key});

  @override
  State<SgToasterPage> createState() => _SgToasterPageState();
}

class _SgToasterPageState extends State<SgToasterPage> {
  // Configuracao do toaster da pagina: o playground e os exemplos de aparencia mexem aqui.
  final ValueNotifier<Map<String, Object?>> _cfg = ValueNotifier({});
  bool _richColors = true;
  bool _rounded = true;
  bool _closeButton = true;

  @override
  void dispose() {
    dismissSgToast();
    _cfg.dispose();
    super.dispose();
  }

  void _publish(Map<String, Object?> values) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !mapEquals(_cfg.value, values))
        _cfg.value = Map.of(values);
    });
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Tipos',
        description:
            'toast(), success, info, warning, error, loading e promise. O toast loading nunca some sozinho.',
        preview:
            // #region sg-toaster-tipos
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgButton(
                  label: const Text('Padrão'),
                  onClick: () => toast('Mensagem simples'),
                ),
                SgButton(
                  label: const Text('Sucesso'),
                  severity: SgSeverity.success,
                  onClick: () => toast.success(
                    'Salvo!',
                    const SgToastOptions(
                      description: 'As alterações foram gravadas.',
                    ),
                  ),
                ),
                SgButton(
                  label: const Text('Info'),
                  severity: SgSeverity.info,
                  onClick: () => toast.info('Nova versão disponível'),
                ),
                SgButton(
                  label: const Text('Aviso'),
                  severity: SgSeverity.warning,
                  onClick: () => toast.warning('Sessão expira em 5 minutos'),
                ),
                SgButton(
                  label: const Text('Erro'),
                  severity: SgSeverity.danger,
                  onClick: () => toast.error('Falha ao salvar'),
                ),
                SgButton(
                  label: const Text('Carregando'),
                  severity: SgSeverity.secondary,
                  onClick: () => toast.loading(
                    'Processando...',
                    const SgToastOptions(id: 'processando'),
                  ),
                ),
                SgButton(
                  label: const Text('Promise'),
                  appearance: SgAppearance.outline,
                  onClick: () => toast.promise<String>(
                    Future<String>.delayed(
                      const Duration(seconds: 2),
                      () => 'ok',
                    ),
                    SgToastPromiseMessages<String>(
                      loading: 'Enviando...',
                      success: (String v) => 'Enviado: $v',
                      error: 'Não foi possível enviar',
                    ),
                  ),
                ),
                SgButton(
                  label: const Text('Limpar tudo'),
                  appearance: SgAppearance.ghost,
                  onClick: toast.dismiss,
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterTipos,
      ),
      ShowcaseExample(
        title: 'Ação e botão de fechar',
        description:
            'Cada toast pode ter uma ação e decidir se mostra o x, por cima do padrão do toaster.',
        preview:
            // #region sg-toaster-acao
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgButton(
                  label: const Text('Com ação'),
                  onClick: () => toast(
                    'Item removido',
                    SgToastOptions(
                      action: SgToastAction(
                        label: 'Desfazer',
                        onClick: () => toast.success('Restaurado'),
                      ),
                    ),
                  ),
                ),
                SgButton(
                  label: const Text('Sem botão de fechar'),
                  appearance: SgAppearance.outline,
                  onClick: () => toast(
                    'Sem x',
                    const SgToastOptions(closeButton: false, duration: 2500),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterAcao,
      ),
      ShowcaseExample(
        title: 'Duração',
        description:
            'A duração do toast vence a do toaster (padrão 4000 ms). Zero deixa o toast fixo.',
        preview:
            // #region sg-toaster-duracao
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgButton(
                  label: const Text('1 segundo'),
                  onClick: () =>
                      toast('Rápido', const SgToastOptions(duration: 1000)),
                ),
                SgButton(
                  label: const Text('8 segundos'),
                  onClick: () =>
                      toast('Devagar', const SgToastOptions(duration: 8000)),
                ),
                SgButton(
                  label: const Text('Fixo'),
                  onClick: () => toast.info(
                    'Fica até fechar',
                    const SgToastOptions(duration: 0),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterDuracao,
      ),
      ShowcaseExample(
        title: 'Aparência do toaster',
        description:
            'richColors, rounded e closeButton do toaster desta página; dispare um toast para ver.',
        preview:
            // #region sg-toaster-aparencia
            Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('richColors'),
                  selected: _richColors,
                  onSelected: (v) => setState(() => _richColors = v),
                ),
                FilterChip(
                  label: const Text('rounded'),
                  selected: _rounded,
                  onSelected: (v) => setState(() => _rounded = v),
                ),
                FilterChip(
                  label: const Text('closeButton'),
                  selected: _closeButton,
                  onSelected: (v) => setState(() => _closeButton = v),
                ),
                SgButton(
                  label: const Text('Disparar'),
                  onClick: () => toast.success(
                    'Toast de teste',
                    const SgToastOptions(
                      description: 'Veja as cores e os cantos.',
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterAparencia,
      ),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        SgShowcasePage(
          name: 'SgToaster',
          description:
              'Renderiza os toasts da API imperativa (toast) em um canto da tela, com cores por tipo, ação, botão de fechar e tempo de vida. Cede a vez quando existe um SgToastHost.',
          examples: examples,
          propSpecs: sgPropSpecs['SgToaster']!,
          playground: SgPlayground(
            specs: sgPropSpecs['SgToaster']!
                .where((s) => s.name == 'position')
                .toList(),
            builder: (context, v) {
              _publish(v);
              return Wrap(
                spacing: 8,
                children: [
                  SgButton(
                    label: const Text('Disparar toast'),
                    onClick: () => toast(
                      'Olá do playground',
                      const SgToastOptions(
                        description: 'Mude a posição acima.',
                      ),
                    ),
                  ),
                  Text('Posição: ${v['position'] ?? 'top-right'}'),
                ],
              );
            },
            codeBuilder: (v) =>
                'SgToaster(${v['position'] == null ? '' : '\n  position: SgToasterPosition.${SgToasterPosition.fromValue(v['position'] as String)!.name},\n'})',
          ),
        ),
        ValueListenableBuilder<Map<String, Object?>>(
          valueListenable: _cfg,
          builder: (context, v, _) => SgToaster(
            position:
                SgToasterPosition.fromValue(v['position'] as String?) ??
                SgToasterPosition.topRight,
            richColors: _richColors,
            rounded: _rounded,
            closeButton: _closeButton,
          ),
        ),
      ],
    );
  }
}
