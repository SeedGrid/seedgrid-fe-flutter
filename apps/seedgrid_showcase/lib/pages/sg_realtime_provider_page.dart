// Showcase do SgRealtimeProvider e dos hooks useSgRealtimeEvent / useSgRealtimeStatus. A conexao com
// o Pulse e SIMULADA (SgSimulatedPulseConnection): os botoes fazem o papel do servidor. O codigo
// exibido em cada exemplo e o trecho entre `// #region` e `// #endregion` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_realtime_provider_page.snippets.g.dart';

class SgRealtimeProviderPage extends StatefulWidget {
  const SgRealtimeProviderPage({super.key});

  @override
  State<SgRealtimeProviderPage> createState() => _SgRealtimeProviderPageState();
}

class _SgRealtimeProviderPageState extends State<SgRealtimeProviderPage> {
  final SgSimulatedPulseConnection _pulse = SgSimulatedPulseConnection();
  final SgSimulatedPulseConnection _pulse2 = SgSimulatedPulseConnection();
  final List<String> _avisos = [];
  int _backups = 0;
  int _outros = 0;

  // O "backend" do token: sempre liga o realtime.
  Future<SgRealtimeConnectResponse> _token() async =>
      const SgRealtimeConnectResponse(
        enabled: true,
        token: 'pct_demo',
        expiresAt: 1759700000,
      );

  @override
  void dispose() {
    _pulse.dispose();
    _pulse2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Simulador',
        description:
            'Os botões fazem o papel do Pulse: publicam um aviso, derrubam a conexão e revogam a credencial.',
        preview:
            // #region sg-realtime-provider-simulador
            SgRealtimeProvider(
              channels: const ['backup'],
              fetchToken: _token,
              connectionFactory: () => _pulse,
              child: SgRealtimeEventListener(
                channel: 'backup',
                events: 'backup.finished.*',
                handler: (e) =>
                    setState(() => _avisos.add('${e.event} #${e.messageId}')),
                child: Builder(
                  builder: (context) {
                    final r = useSgRealtimeStatus(context);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estado: ${r.status.value}  (conectado: ${r.connected})',
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            SgButton(
                              label: const Text(
                                'Publicar backup.finished.success',
                              ),
                              onClick: () => _pulse.emitMessage(
                                channel: 'backup',
                                event: 'backup.finished.success',
                                messageId: '${_avisos.length + 1}',
                              ),
                            ),
                            SgButton(
                              label: const Text('Queda e reconexão'),
                              appearance: SgAppearance.outline,
                              onClick: () => _pulse.simulateReconnect(),
                            ),
                            SgButton(
                              label: const Text('Revogar credencial'),
                              severity: SgSeverity.danger,
                              appearance: SgAppearance.outline,
                              onClick: _pulse.simulateRevoked,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Avisos: ${_avisos.isEmpty ? '(nenhum)' : _avisos.join(', ')}',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
        // #endregion
        code: SgRealtimeProviderPageSnippets.sgRealtimeProviderSimulador,
      ),
      ShowcaseExample(
        title: 'Polling de reserva',
        description:
            'Enquanto não está conectado, a tela cai no polling; conectado, dispensa.',
        preview:
            // #region sg-realtime-provider-polling
            SgRealtimeProvider(
              channels: const ['backup'],
              fetchToken: _token,
              connectionFactory: () => _pulse2,
              child: Builder(
                builder: (context) {
                  final r = useSgRealtimeStatus(context);
                  return Row(
                    children: [
                      Icon(r.connected ? Icons.bolt : Icons.sync, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          r.connected
                              ? 'Avisos em tempo real: sem polling.'
                              : 'Sem realtime (${r.status.value}): consultando a API a cada 5 s.',
                        ),
                      ),
                      const SizedBox(width: 12),
                      SgButton(
                        label: const Text('Derrubar'),
                        appearance: SgAppearance.outline,
                        size: SgSize.sm,
                        onClick: () =>
                            _pulse2.emitState(SgPulseState.reconnecting),
                      ),
                    ],
                  );
                },
              ),
            ),
        // #endregion
        code: SgRealtimeProviderPageSnippets.sgRealtimeProviderPolling,
      ),
      ShowcaseExample(
        title: 'Canais e padrões de evento',
        description:
            'Cada ouvinte escolhe canal e padrão (nome exato, lista, prefixo.* ou *).',
        preview:
            // #region sg-realtime-provider-padroes
            Builder(
              builder: (context) {
                final sim = SgSimulatedPulseConnection();
                return SgRealtimeProvider(
                  channels: const ['backup', 'audit'],
                  fetchToken: _token,
                  connectionFactory: () => sim,
                  child: SgRealtimeEventListener(
                    channel: 'backup',
                    events: const ['backup.started', 'backup.finished.*'],
                    handler: (_) => setState(() => _backups++),
                    child: SgRealtimeEventListener(
                      channel: 'audit',
                      events: '*',
                      handler: (_) => setState(() => _outros++),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SgButton(
                            label: const Text('backup.finished.error'),
                            onClick: () => sim.emitMessage(
                              channel: 'backup',
                              event: 'backup.finished.error',
                            ),
                          ),
                          SgButton(
                            label: const Text('backup.other'),
                            appearance: SgAppearance.outline,
                            onClick: () => sim.emitMessage(
                              channel: 'backup',
                              event: 'backup.other',
                            ),
                          ),
                          SgButton(
                            label: const Text('audit.login'),
                            appearance: SgAppearance.outline,
                            onClick: () => sim.emitMessage(
                              channel: 'audit',
                              event: 'audit.login',
                            ),
                          ),
                          Text('backup: $_backups  |  audit: $_outros'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        // #endregion
        code: SgRealtimeProviderPageSnippets.sgRealtimeProviderPadroes,
      ),
      ShowcaseExample(
        title: 'Desligado',
        description:
            'Com disabled (ex.: enquanto não há usuário logado) não pede token nem conecta.',
        preview:
            // #region sg-realtime-provider-desligado
            SgRealtimeProvider(
              channels: const ['backup'],
              disabled: true,
              fetchToken: _token,
              child: Builder(
                builder: (context) => Text(
                  'Estado: ${useSgRealtimeStatus(context).status.value}',
                ),
              ),
            ),
        // #endregion
        code: SgRealtimeProviderPageSnippets.sgRealtimeProviderDesligado,
      ),
    ];

    return SgShowcasePage(
      name: 'SgRealtimeProvider',
      description:
          'Avisos em tempo real para o usuário logado pelo SeedGrid Pulse: pede o token ao backend, conecta, reconecta sozinho e informa o estado para a tela decidir entre aviso e polling.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgRealtimeProvider']!,
        const SgPropSpec(
          name: 'connectionFactory',
          reactName: '(interno do React)',
          type: 'SgPulseConnection Function()?',
          tsType: 'PulseSubscriberClient',
          required: false,
          description:
              'Cria o cliente do Pulse (o React o cria por dentro). Veja PULSE_ADAPTER.md para ligar ao SDK real.',
        ),
        const SgPropSpec(
          name: 'tokenFetcher',
          reactName: 'fetch',
          type: 'SgFetcher?',
          tsType: '(input, init) => Promise<Response>',
          required: false,
          description: 'fetch injetável do pedido de token padrão (testes).',
        ),
      ],
      playground: SgPlayground(
        specs: const [
          SgPropSpec(
            name: 'disabled',
            reactName: 'enabled',
            type: 'bool?',
            tsType: 'boolean',
            required: false,
            defaultValue: 'false',
            description: 'No React a prop é enabled (invertida).',
          ),
          SgPropSpec(
            name: 'backend',
            reactName: '(resposta do token)',
            type: 'String?',
            tsType: 'string',
            required: false,
            defaultValue: 'liga',
            values: ['liga', 'desliga', 'erro'],
          ),
        ],
        builder: (context, v) {
          final backend = (v['backend'] as String?) ?? 'liga';
          return SgRealtimeProvider(
            // A chave faz o provider recomeçar quando a resposta simulada do backend muda.
            key: ValueKey('pg-$backend'),
            channels: const ['demo'],
            disabled: v['disabled'] as bool?,
            fetchToken: () async => switch (backend) {
              'desliga' => const SgRealtimeConnectResponse(enabled: false),
              'erro' => throw Exception('HTTP 503'),
              _ => const SgRealtimeConnectResponse(
                enabled: true,
                token: 'pct_demo',
              ),
            },
            connectionFactory: SgSimulatedPulseConnection.new,
            child: Builder(
              builder: (context) =>
                  Text('Estado: ${useSgRealtimeStatus(context).status.value}'),
            ),
          );
        },
        codeBuilder: (v) {
          final args = <String>["channels: const ['demo']"];
          if (v['disabled'] == true) args.add('disabled: true');
          args.addAll([
            'fetchToken: seuBackend.pedirToken',
            'connectionFactory: () => PulseSdkConnection()',
            'child: ...',
          ]);
          return 'SgRealtimeProvider(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
