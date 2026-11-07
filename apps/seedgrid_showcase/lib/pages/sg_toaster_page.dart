// Showcase do SgToaster. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// O toaster fica num Stack por cima da pagina (e flutuante, como o `position: fixed` do React); os
// exemplos so disparam toasts e as chaves de aparencia da pagina configuram esse toaster.
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_toaster_page.snippets.g.dart';

const SgToasterCustomColors _coresDemo = {
  SgToastType.defaultValue: SgToasterTypeColors(
    bg: Color(0xFF1F2937),
    fg: Color(0xFFF9FAFB),
    border: Color(0xFF6B7280),
  ),
  SgToastType.success: SgToasterTypeColors(
    bg: Color(0xFF065F46),
    fg: Color(0xFFECFEFF),
    border: Color(0xFF10B981),
  ),
  SgToastType.info: SgToasterTypeColors(
    bg: Color(0xFF1E3A8A),
    fg: Color(0xFFDBEAFE),
    border: Color(0xFF60A5FA),
  ),
  SgToastType.warning: SgToasterTypeColors(
    bg: Color(0xFF78350F),
    fg: Color(0xFFFEF3C7),
    border: Color(0xFFF59E0B),
  ),
  SgToastType.error: SgToasterTypeColors(
    bg: Color(0xFF7F1D1D),
    fg: Color(0xFFFEE2E2),
    border: Color(0xFFEF4444),
  ),
  SgToastType.loading: SgToasterTypeColors(
    bg: Color(0xFF312E81),
    fg: Color(0xFFE0E7FF),
    border: Color(0xFF818CF8),
  ),
};

class SgToasterPage extends StatefulWidget {
  const SgToasterPage({super.key});

  @override
  State<SgToasterPage> createState() => _SgToasterPageState();
}

class _SgToasterPageState extends State<SgToasterPage> {
  // Configuracao do toaster da pagina: o playground e os exemplos de aparencia mexem aqui.
  final ValueNotifier<Map<String, Object?>> _cfg = ValueNotifier({});
  final ValueNotifier<bool> _richColors = ValueNotifier(true);
  final ValueNotifier<num> _transparency = ValueNotifier(0);
  final ValueNotifier<bool> _coresPersonalizadas = ValueNotifier(false);
  final ValueNotifier<String?> _loadingId = ValueNotifier(null);
  final ValueNotifier<bool> _rounded = ValueNotifier(true);
  final ValueNotifier<bool> _closeButton = ValueNotifier(true);

  @override
  void dispose() {
    dismissSgToast();
    for (final n in [_cfg, _richColors, _transparency, _coresPersonalizadas, _loadingId, _rounded, _closeButton]) {
      n.dispose();
    }
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
        title: 'Configuração básica',
        description:
            'Neste showcase, o SgToaster já está montado no layout. Em um app real, monte-o uma vez na raiz.',
        preview:
            // #region sg-toaster-basico
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                SgButton(
                  label: Text('toast.message'),
                  onClick: () => toast.message(context.tx('Mensagem básica')),
                ),
                SgButton(
                  label: Text('toast.success'),
                  severity: SgSeverity.success,
                  onClick: () => toast.success(context.tx('Operação concluída')),
                ),
                SgButton(
                  label: Text('toast.dismiss (all)'),
                  appearance: SgAppearance.outline,
                  onClick: toast.dismiss,
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterBasico,
      ),
      ShowcaseExample(
        title: 'Tipos de toast',
        description:
            'Use métodos específicos por severidade.',
        preview:
            // #region sg-toaster-tipos
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                SgButton(
                  label: Text('default'),
                  onClick: () => toast.message(context.tx('Mensagem neutra')),
                ),
                SgButton(
                  label: Text('success'),
                  severity: SgSeverity.success,
                  onClick: () => toast.success(context.tx('Operação concluída')),
                ),
                SgButton(
                  label: Text('info'),
                  severity: SgSeverity.info,
                  onClick: () => toast.info(context.tx('Informação importante')),
                ),
                SgButton(
                  label: Text('warning'),
                  severity: SgSeverity.warning,
                  onClick: () => toast.warning(context.tx('Atenção no fluxo')),
                ),
                SgButton(
                  label: Text('error'),
                  severity: SgSeverity.danger,
                  onClick: () => toast.error(context.tx('Falha ao salvar')),
                ),
                SgButton(
                  label: Text('loading'),
                  appearance: SgAppearance.outline,
                  onClick: () => toast.loading(context.tx('Processando...')),
                ),
                SgButton(
                  label: Text(context.tx('descartar todos')),
                  appearance: SgAppearance.ghost,
                  onClick: toast.dismiss,
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterTipos,
      ),
      ShowcaseExample(
        title: 'Loading por id (atualiza o mesmo toast)',
        description:
            'Guarde o id retornado e reutilize-o para trocar de estado sem criar outro toast.',
        preview:
            // #region sg-toaster-loading-por-id
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Iniciar loading')),
                  onClick: () => _loadingId.value = toast.loading(
                    context.tx('Processando lote...'),
                    SgToastOptions(
                      description: context.tx(
                        'Este toast fica aberto até você atualizá-lo ou fechá-lo.',
                      ),
                    ),
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Concluir com sucesso')),
                  severity: SgSeverity.success,
                  onClick: () {
                    final id = _loadingId.value;
                    if (id == null) {
                      toast.warning(context.tx('Nenhum loading ativo'));
                      return;
                    }
                    toast.success(
                      context.tx('Processamento concluído'),
                      SgToastOptions(
                        id: id,
                        description: context.tx('Atualizado usando o mesmo id.'),
                      ),
                    );
                    _loadingId.value = null;
                  },
                ),
                SgButton(
                  label: Text(context.tx('Concluir com erro')),
                  severity: SgSeverity.danger,
                  onClick: () {
                    final id = _loadingId.value;
                    if (id == null) {
                      toast.warning(context.tx('Nenhum loading ativo'));
                      return;
                    }
                    toast.error(
                      context.tx('Processamento falhou'),
                      SgToastOptions(
                        id: id,
                        description: context.tx('Loading atualizado para erro.'),
                      ),
                    );
                    _loadingId.value = null;
                  },
                ),
                SgButton(
                  label: Text(context.tx('Limpar todos')),
                  appearance: SgAppearance.outline,
                  onClick: toast.dismiss,
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: _loadingId,
                  builder: (context, id, _) => Text('loadingId: ${id ?? 'none'}'),
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterLoadingPorId,
      ),
      ShowcaseExample(
        title: 'toast.promise',
        description:
            'Helper de conveniência para o ciclo de loading/sucesso/erro em promises.',
        preview:
            // #region sg-toaster-promise
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Rodar demo de promise')),
                  onClick: () async {
                    final salvando = context.tx('Salvando pedido...');
                    final salvo = context.tx('Pedido salvo');
                    final falha = context.tx('Falha');
                    try {
                      await toast.promise<String>(
                        Future<String>.delayed(const Duration(milliseconds: 1200), () {
                          if (Random().nextDouble() < 0.35) {
                            throw Exception('Random demo error');
                          }
                          return 'ORD-2026-001';
                        }),
                        SgToastPromiseMessages<String>(
                          loading: salvando,
                          success: (String id) => '$salvo: $id',
                          error: (Object e) => '$falha: $e',
                        ),
                      );
                    } catch (_) {
                      // o erro já foi tratado pelo toast.promise
                    }
                  },
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterPromise,
      ),
      ShowcaseExample(
        title: 'Ações e toast personalizado',
        description:
            'Use action para CTA rápida e custom para renderização livre.',
        preview:
            // #region sg-toaster-acoes
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Toast com ação')),
                  severity: SgSeverity.warning,
                  onClick: () => toast.warning(
                    context.tx('Item arquivado'),
                    SgToastOptions(
                      description: context.tx('Clique em desfazer para restaurar.'),
                      action: SgToastAction(
                        label: context.tx('Desfazer'),
                        onClick: () => toast.success(
                          context.tx('Ação desfeita'),
                          SgToastOptions(
                            description: context.tx('O item voltou para a lista.'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Toast personalizado')),
                  appearance: SgAppearance.outline,
                  onClick: () => toast.custom(
                    (String id) => Container(
                      width: 280,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7F1),
                        border: Border.all(color: const Color(0x80C56A2D)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tx('Toast personalizado'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8F4B1F),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.tx('Conteúdo renderizado via toast.custom(...)'),
                            style: const TextStyle(color: Color(0xFF6B4B33)),
                          ),
                          const SizedBox(height: 8),
                          SgButton(
                            label: Text(context.tx('Fechar')),
                            size: SgSize.sm,
                            onClick: () => toast.dismiss(id),
                          ),
                        ],
                      ),
                    ),
                    const SgToastOptions(duration: 8000, closeButton: false),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterAcoes,
      ),
      ShowcaseExample(
        title: 'Opções por toast',
        description:
            'Cada toast aceita duration, closeButton, description e action.',
        preview:
            // #region sg-toaster-opcoes
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Disparar toast com opções')),
                  onClick: () => toast.info(
                    context.tx('Toast com opções personalizadas'),
                    SgToastOptions(
                      description: context.tx('Duração de 10s, sem closeButton.'),
                      duration: 10000,
                      closeButton: false,
                    ),
                  ),
                ),
                SgButton(
                  label: Text(context.tx('1 segundo')),
                  appearance: SgAppearance.outline,
                  onClick: () => toast('Rápido', const SgToastOptions(duration: 1000)),
                ),
                SgButton(
                  label: Text(context.tx('Fixo (duration: 0)')),
                  appearance: SgAppearance.outline,
                  onClick: () => toast.info(
                    'Fica até fechar',
                    const SgToastOptions(duration: 0),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterOpcoes,
      ),
      ShowcaseExample(
        title: 'Transparência',
        description:
            'Exemplo focado apenas em transparência (80%).',
        preview:
            // #region sg-toaster-transparencia
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Com transparência (80%)')),
                  severity: SgSeverity.success,
                  onClick: () {
                    _transparency.value = 80;
                    toast.success(context.tx('Operação concluída'));
                  },
                ),
                SgButton(
                  label: Text(context.tx('Sem transparência')),
                  appearance: SgAppearance.outline,
                  onClick: () {
                    _transparency.value = 0;
                    toast.success(context.tx('Operação concluída'));
                  },
                ),
                SgButton(
                  label: Text(context.tx('descartar todos')),
                  appearance: SgAppearance.ghost,
                  onClick: toast.dismiss,
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterTransparencia,
      ),
      ShowcaseExample(
        title: 'Cores personalizadas',
        description:
            'Exemplo focado apenas em cores personalizadas por tipo.',
        preview:
            // #region sg-toaster-cores-personalizadas
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _richColors,
                  builder: (context, v, _) => FilterChip(
                    label: Text(context.tx('richColors')),
                    selected: v,
                    onSelected: (value) => _richColors.value = value,
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Cores personalizadas')),
                  severity: SgSeverity.success,
                  onClick: () {
                    _coresPersonalizadas.value = true;
                    toast.success(context.tx('Operação concluída'));
                  },
                ),
                SgButton(
                  label: Text(context.tx('Cores padrão')),
                  appearance: SgAppearance.outline,
                  onClick: () {
                    _coresPersonalizadas.value = false;
                    toast.success(context.tx('Operação concluída'));
                  },
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterCoresPersonalizadas,
      ),
      ShowcaseExample(
        title: 'Cantos arredondados',
        description:
            'rounded é true por padrão (rounded-md). Defina rounded como false para cantos retos - aplica ao toaster inteiro. Alterne ao vivo no Playground acima.',
        preview:
            // #region sg-toaster-arredondados
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 16,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _rounded,
                  builder: (context, v, _) => FilterChip(
                    label: Text(context.tx('rounded')),
                    selected: v,
                    onSelected: (value) => _rounded.value = value,
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _closeButton,
                  builder: (context, v, _) => FilterChip(
                    label: Text(context.tx('closeButton')),
                    selected: v,
                    onSelected: (value) => _closeButton.value = value,
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Disparar')),
                  onClick: () => toast.success(context.tx('Operação concluída')),
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterArredondados,
      ),
      ShowcaseExample(
        title: 'Fechar por código (dismissSgToast)',
        description:
            'toast.dismiss é açúcar para dismissSgToast, que também é exportado direto. Com id fecha aquele toast; sem id, todos.',
        preview:
            // #region sg-toaster-fechar-por-codigo
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir toast')),
                  onClick: () => toast.loading(context.tx('Processando lote...'), const SgToastOptions(id: 'lote')),
                ),
                SgButton(
                  label: Text("dismissSgToast('lote')"),
                  appearance: SgAppearance.outline,
                  onClick: () => dismissSgToast('lote'),
                ),
                SgButton(
                  label: Text('dismissSgToast()'),
                  appearance: SgAppearance.outline,
                  onClick: dismissSgToast,
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterFecharPorCodigo,
      ),
      ShowcaseExample(
        title: 'Observar a fila (subscribeSgToasts)',
        description:
            'Recebe a lista de toasts abertos a cada mudança e devolve a função que cancela a inscrição. Ele já chama o listener uma vez com a lista atual, então não é preciso ler o estado inicial em outro lugar.',
        preview:
            // #region sg-toaster-observar-a-fila
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                StreamBuilder<List<SgToastRecord>>(
                  stream: Stream<List<SgToastRecord>>.multi((controller) {
                    controller.onCancel = subscribeSgToasts(controller.add);
                  }),
                  builder: (context, snapshot) => Text(
                    '${context.tx('Toasts abertos')}: ${snapshot.data?.length ?? 0}',
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Abrir toast')),
                  onClick: () => toast.message(context.tx('Mensagem básica')),
                ),
                SgButton(
                  label: Text(context.tx('descartar todos')),
                  appearance: SgAppearance.outline,
                  onClick: toast.dismiss,
                ),
              ],
            ),
        // #endregion
        code: SgToasterPageSnippets.sgToasterObservarAFila,
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
                runSpacing: 8,
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
        ListenableBuilder(
          listenable: Listenable.merge([
            _cfg,
            _richColors,
            _rounded,
            _closeButton,
            _transparency,
            _coresPersonalizadas,
          ]),
          builder: (context, _) => SgToaster(
            position:
                SgToasterPosition.fromValue(_cfg.value['position'] as String?) ??
                SgToasterPosition.topRight,
            richColors: _richColors.value,
            rounded: _rounded.value,
            closeButton: _closeButton.value,
            transparency: _transparency.value,
            customColors: _coresPersonalizadas.value ? _coresDemo : null,
          ),
        ),
      ],
    );
  }
}
