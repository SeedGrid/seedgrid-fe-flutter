// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_realtime_provider_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgRealtimeProviderPageSnippets {
  /// Region `sg-realtime-provider-desligado`.
  static const String sgRealtimeProviderDesligado = r'''
SgRealtimeProvider(
  channels: const ['backup'],
  disabled: true,
  fetchToken: _token,
  child: Builder(
    builder: (context) => Text(
      'Estado: ${useSgRealtimeStatus(context).status.value}',
    ),
  ),
)
''';

  /// Region `sg-realtime-provider-padroes`.
  static const String sgRealtimeProviderPadroes = r'''
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
                label: Text(context.tx('backup.finished.error')),
                onClick: () => sim.emitMessage(
                  channel: 'backup',
                  event: 'backup.finished.error',
                ),
              ),
              SgButton(
                label: Text(context.tx('backup.other')),
                appearance: SgAppearance.outline,
                onClick: () => sim.emitMessage(
                  channel: 'backup',
                  event: 'backup.other',
                ),
              ),
              SgButton(
                label: Text(context.tx('audit.login')),
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
)
''';

  /// Region `sg-realtime-provider-polling`.
  static const String sgRealtimeProviderPolling = r'''
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
            label: Text(context.tx('Derrubar')),
            appearance: SgAppearance.outline,
            size: SgSize.sm,
            onClick: () =>
                _pulse2.emitState(SgPulseState.reconnecting),
          ),
        ],
      );
    },
  ),
)
''';

  /// Region `sg-realtime-provider-simulador`.
  static const String sgRealtimeProviderSimulador = r'''
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
                  label: Text(
                    context.tx('Publicar backup.finished.success'),
                  ),
                  onClick: () => _pulse.emitMessage(
                    channel: 'backup',
                    event: 'backup.finished.success',
                    messageId: '${_avisos.length + 1}',
                  ),
                ),
                SgButton(
                  label: Text(context.tx('Queda e reconexão')),
                  appearance: SgAppearance.outline,
                  onClick: () => _pulse.simulateReconnect(),
                ),
                SgButton(
                  label: Text(context.tx('Revogar credencial')),
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
)
''';
}
