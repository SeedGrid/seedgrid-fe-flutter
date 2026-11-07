// Showcase do SgWhistleHost. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// O host da pagina fica numa faixa no rodape; os avisos aparecem ali.
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_whistle_host_page.snippets.g.dart';

const _warmColors = <SgWhistleSeverity, SgWhistleColors>{
  SgWhistleSeverity.defaultValue: SgWhistleColors(
    bg: Color(0xFFFFF7ED),
    fg: Color(0xFF7C2D12),
    border: Color(0xFFFDBA74),
  ),
  SgWhistleSeverity.success: SgWhistleColors(
    bg: Color(0xFFECFDF5),
    fg: Color(0xFF065F46),
    border: Color(0xFF34D399),
  ),
  SgWhistleSeverity.info: SgWhistleColors(
    bg: Color(0xFFEFF6FF),
    fg: Color(0xFF1D4ED8),
    border: Color(0xFF60A5FA),
  ),
  SgWhistleSeverity.warning: SgWhistleColors(
    bg: Color(0xFFFFFBEB),
    fg: Color(0xFF92400E),
    border: Color(0xFFF59E0B),
  ),
  SgWhistleSeverity.error: SgWhistleColors(
    bg: Color(0xFFFEF2F2),
    fg: Color(0xFFB91C1C),
    border: Color(0xFFF87171),
  ),
  SgWhistleSeverity.loading: SgWhistleColors(
    bg: Color(0xFFF5F3FF),
    fg: Color(0xFF6D28D9),
    border: Color(0xFFA78BFA),
  ),
};

class SgWhistleHostPage extends StatefulWidget {
  const SgWhistleHostPage({super.key});

  @override
  State<SgWhistleHostPage> createState() => _SgWhistleHostPageState();
}

class _SgWhistleHostPageState extends State<SgWhistleHostPage> {
  final ValueNotifier<Map<String, Object?>> _cfg = ValueNotifier({});
  final ValueNotifier<String?> _activeId = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _avisoId = ValueNotifier<String?>(null);
  final ValueNotifier<bool> _warm = ValueNotifier<bool>(false);
  final ValueNotifier<int> _total = ValueNotifier<int>(0);
  final ValueNotifier<bool> _ouvindo = ValueNotifier<bool>(false);
  VoidCallback? _parar;
  final ValueNotifier<bool> _extraHost = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _parar?.call();
    dismissSgWhistle();
    _cfg.dispose();
    _activeId.dispose();
    _avisoId.dispose();
    _warm.dispose();
    _total.dispose();
    _ouvindo.dispose();
    _extraHost.dispose();
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
            'Monte um SgWhistleHost onde o layout deve revelar mensagens contextuais. Depois dispare whistles de qualquer lugar da página.',
        preview:
            // #region sg-whistle-host-basico
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              gap: 8,
              children: [
              SgButton(
                label: const Text('sgWhistle.show'),
                onClick: () => sgWhistle.show(
                SgWhistleOptions(
                  title: context.tx('Exemplo base'),
                  message: context.tx('Um whistle padrão apareceu no rodapé da página.'),
                ),
              ),
              ),
              SgButton(
                label: const Text('sgWhistle.success'),
                severity: SgSeverity.success,
                onClick: () => sgWhistle.success(
                SgWhistleOptions(
                  title: context.tx('Salvo'),
                  message: context.tx('Esta mensagem permaneceu no fluxo do documento.'),
                ),
              ),
              ),
              SgButton(
                label: const Text('sgWhistle.dismiss'),
                appearance: SgAppearance.outline,
                onClick: sgWhistle.dismiss,
              ),
              ],
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostBasico,
      ),
      ShowcaseExample(
        title: 'Severidades e comportamento do stack',
        description:
            'O serviço expõe métodos de conveniência por severidade, enquanto props do host como max, newestOnTop e gap controlam o stack.',
        preview:
            // #region sg-whistle-host-severidades
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              gap: 8,
              children: [
              SgButton(
                label: const Text('default'),
                onClick: () => sgWhistle.show(
                SgWhistleOptions(
                  title: context.tx('Nota de contexto'),
                  message: context.tx('Feedback inline renderizado dentro do fluxo do layout.'),
                  duration: 5000,
                ),
              ),
              ),
              SgButton(
                label: const Text('success'),
                severity: SgSeverity.success,
                onClick: () => sgWhistle.success(
                SgWhistleOptions(
                  title: context.tx('Salvo'),
                  message: context.tx('O registro foi persistido com sucesso.'),
                  duration: 5000,
                ),
              ),
              ),
              SgButton(
                label: const Text('info'),
                severity: SgSeverity.info,
                onClick: () => sgWhistle.info(
                SgWhistleOptions(
                  title: context.tx('Atenção'),
                  message: context.tx('Esta seção pode mostrar progresso ou dicas contextuais.'),
                  duration: 5000,
                ),
              ),
              ),
              SgButton(
                label: const Text('warning'),
                severity: SgSeverity.warning,
                onClick: () => sgWhistle.warning(
                SgWhistleOptions(
                  title: context.tx('Revisão pendente'),
                  message: context.tx('A ação precisa de confirmação antes de continuar.'),
                  duration: 5000,
                ),
              ),
              ),
              SgButton(
                label: const Text('error'),
                severity: SgSeverity.danger,
                onClick: () => sgWhistle.error(
                SgWhistleOptions(
                  title: context.tx('Ação falhou'),
                  message: context.tx('A requisição retornou um erro e precisa de atenção.'),
                  duration: 5000,
                ),
              ),
              ),
              SgButton(
                label: const Text('loading'),
                appearance: SgAppearance.outline,
                onClick: () => sgWhistle.loading(
                SgWhistleOptions(
                  title: context.tx('Processando...'),
                  message: context.tx('Processando sem bloquear o layout da página.'),
                  duration: 0,
                ),
              ),
              ),
              ],
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostSeveridades,
      ),
      ShowcaseExample(
        title: 'Ações, estilos de borda e opacidade',
        description:
            'Whistles podem expor CTAs rápidas e ênfase visual leve sem precisar de posicionamento em overlay.',
        preview:
            // #region sg-whistle-host-acoes
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Ação + desfazer')),
                  severity: SgSeverity.warning,
                  onClick: () => sgWhistle.warning(
                    SgWhistleOptions(
                      title: context.tx('Seção arquivada'),
                      message: context.tx('A ação é reversível por alguns segundos.'),
                      borderStyle: SgWhistleBorderStyle.leftAccent,
                      opacity: 0.96,
                      action: SgWhistleAction(
                        label: context.tx('Desfazer'),
                        onClick: () => sgWhistle.success(
                          SgWhistleOptions(
                            title: context.tx('Desfazer aplicado'),
                            message: context.tx('A seção arquivada voltou para a lista ativa.'),
                            borderStyle: SgWhistleBorderStyle.soft,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                for (final style in SgWhistleBorderStyle.values)
                  SgButton(
                    label: Text(style.value),
                    appearance: SgAppearance.outline,
                    onClick: () => sgWhistle.info(
                      SgWhistleOptions(
                        title: context.txf('Estilo de borda: {style}', {'style': style.value}),
                        message: context.tx(
                          'Use borderStyle e opacity para ênfase contextual sem sair do fluxo do layout.',
                        ),
                        borderStyle: style,
                        opacity: style == SgWhistleBorderStyle.none ? 0.88 : 1,
                      ),
                    ),
                  ),
              ],
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostAcoes,
      ),
      ShowcaseExample(
        title: 'Atualizar por id',
        description:
            'Fluxos de loading geralmente são criados uma vez e depois atualizados no lugar conforme a tarefa conclui ou falha.',
        preview:
            // #region sg-whistle-host-atualizar
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Iniciar carregamento')),
                  onClick: () => _activeId.value = sgWhistle.loading(
                    SgWhistleOptions(
                      title: context.tx('Sincronizando'),
                      message: context.tx(
                        'O mesmo id de whistle será atualizado quando a requisição terminar.',
                      ),
                      borderStyle: SgWhistleBorderStyle.leftAccent,
                      dismissible: false,
                    ),
                  ),
                ),
                for (final ok in [true, false])
                  SgButton(
                    label: ok
                        ? Text(context.tx('Concluir com sucesso'))
                        : Text(context.tx('Concluir com erro')),
                    severity: ok ? SgSeverity.success : SgSeverity.danger,
                    onClick: () {
                      final id = _activeId.value;
                      if (id == null) {
                        sgWhistle.warning(
                          SgWhistleOptions(
                            title: context.tx('Nenhum loading ativo'),
                            message: context.tx(
                              'Inicie um whistle de loading antes de tentar atualizá-lo.',
                            ),
                          ),
                        );
                        return;
                      }
                      sgWhistle.update(
                        id,
                        SgWhistleCustomOptions(
                          severity: ok
                              ? SgWhistleSeverity.success
                              : SgWhistleSeverity.error,
                          title: ok
                              ? context.tx('Sincronização concluída')
                              : context.tx('Sincronização falhou'),
                          message: ok
                              ? context.tx('O whistle de loading foi atualizado no lugar.')
                              : context.tx(
                                  'O mesmo id de whistle agora renderiza o estado de erro.',
                                ),
                          dismissible: true,
                          duration: 5000,
                        ),
                      );
                      _activeId.value = null;
                    },
                  ),
                SgButton(
                  label: Text(context.tx('Descartar ativo')),
                  appearance: SgAppearance.outline,
                  onClick: () {
                    final id = _activeId.value;
                    if (id != null) sgWhistle.dismiss(id);
                  },
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: _activeId,
                  builder: (context, id, _) => Text('activeId: ${id ?? 'none'}'),
                ),
              ],
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostAtualizar,
      ),
      ShowcaseExample(
        title: 'sgWhistle.promise',
        description:
            'O helper centraliza as transições de estado de loading, sucesso e erro para fluxos assíncronos.',
        preview:
            // #region sg-whistle-host-promise
            SgButton(
              label: Text(context.tx('Rodar demo de promise')),
              onClick: () async {
                final enviando = context.tx('Enviando relatório');
                final aguardando = context.tx('Aguardando o servidor...');
                final enviado = context.tx('Relatório enviado');
                final falhou = context.tx('Envio falhou');
                try {
                  await sgWhistle.promise<String>(
                    () async {
                      await Future<void>.delayed(const Duration(milliseconds: 1200));
                      if (Random().nextDouble() < 0.35) {
                        throw Exception('simulated network error');
                      }
                      return 'SG-2026-031';
                    },
                    SgWhistlePromiseStates<String>(
                      loading: SgWhistleOptions(title: enviando, message: aguardando),
                      success: (String protocolo) => SgWhistleOptions(
                        title: enviado,
                        message: context.txf('Protocolo {protocol} gerado com sucesso.', {
                          'protocol': protocolo,
                        }),
                        borderStyle: SgWhistleBorderStyle.soft,
                      ),
                      error: (Object erro) => SgWhistleOptions(
                        title: falhou,
                        message: erro.toString(),
                        borderStyle: SgWhistleBorderStyle.fullAccent,
                      ),
                    ),
                  );
                } catch (_) {
                  // o erro ja foi mostrado pelo sgWhistle.promise
                }
              },
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostPromise,
      ),
      ShowcaseExample(
        title: 'Renderizador personalizado e cores do host',
        description:
            'Use sgWhistle.custom para JSX arbitrário e customColors no host para alinhar o stack com o contexto ao redor.',
        preview:
            // #region sg-whistle-host-custom
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Whistle personalizado')),
                  onClick: () => sgWhistle.custom(
                    (String id) => SgStack(
                      gap: 8,
                      children: [
                        Text(
                          context.tx('Renderizador personalizado'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          context.tx(
                            'Este whistle renderiza JSX arbitrário e ainda usa o mesmo ciclo de vida imperativo.',
                          ),
                        ),
                        SgStack(
                          direction: SgStackDirection.row,
                          wrap: true,
                          gap: 8,
                          children: [
                            SgButton(
                              label: Text(context.tx('Fechar')),
                              size: SgSize.sm,
                              onClick: () => sgWhistle.dismiss(id),
                            ),
                            SgButton(
                              label: Text(context.tx('Escalar')),
                              size: SgSize.sm,
                              appearance: SgAppearance.outline,
                              onClick: () {
                                sgWhistle.dismiss(id);
                                sgWhistle.success(
                                  SgWhistleOptions(
                                    title: context.tx('Escalado'),
                                    message: context.tx(
                                      'O whistle personalizado disparou uma ação de acompanhamento.',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SgWhistleCustomOptions(
                      message: 'custom',
                      duration: 0,
                      dismissible: false,
                      borderStyle: SgWhistleBorderStyle.fullAccent,
                    ),
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Alternar paleta do host')),
                  appearance: SgAppearance.outline,
                  onClick: () => _warm.value = !_warm.value,
                ),
              ],
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostCustom,
      ),
      ShowcaseExample(
        title: 'O host prevalece sobre o SgWhistler solto',
        description:
            'A caixa abaixo tem um SgWhistler solto, mas há um SgWhistleHost na página: o solto não desenha nada e cada aviso aparece uma vez só.',
        preview:
            // #region sg-whistle-host-prevalece
            SgStack(
              gap: 8,
              align: SgStackAlign.start,
              children: [
                SgButton(
                  label: Text(context.tx('Disparar')),
                  onClick: () => sgWhistle.info(
                    SgWhistleOptions(message: context.tx('Só aparece no host')),
                  ),
                ),
                const SgWhistler(),
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
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              align: SgStackAlign.center,
              gap: 8,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _extraHost,
                  builder: (context, ativo, _) => SgButton(
                    label: Text('${context.tx('Segundo host (cantos retos)')}: $ativo'),
                    appearance: SgAppearance.outline,
                    onClick: () => _extraHost.value = !ativo,
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Disparar')),
                  onClick: () => sgWhistle.warning(
                    SgWhistleOptions(
                      message: context.tx('Quem está ativo?'),
                      duration: 3000,
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgWhistleHostPageSnippets.sgWhistleHostVarios,
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
        ListenableBuilder(
          listenable: Listenable.merge([_cfg, _warm]),
          builder: (context, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SgWhistleHost(
              newestOnTop: _cfg.value['newestOnTop'] == true,
              customColors: _warm.value ? _warmColors : null,
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _extraHost,
          builder: (context, ativo, _) => ativo
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SgWhistleHost(rounded: false),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
