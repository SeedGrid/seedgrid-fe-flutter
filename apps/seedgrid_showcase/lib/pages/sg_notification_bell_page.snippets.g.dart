// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_notification_bell_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgNotificationBellPageSnippets {
  /// Region `sg-notification-bell-basico`.
  static const String sgNotificationBellBasico = r'''
SgRealtimeProvider(
  channels: const ['user-notifications'],
  fetchToken: _demoToken,
  connectionFactory: () => _pulse,
  child: Wrap(
    spacing: 12,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      SgNotificationBell(
        apiUrl: 'https://demo.local/user-notifications',
        fetcher: _basico.fetch,
      ),
      OutlinedButton(
        onPressed: () {
          final id = _basico.notify(
            'report.ready',
            'Novo relatório',
            'Acabou de ficar pronto.',
          );
          _pulse.emitMessage(
            channel: 'user-notifications',
            event: 'user-notification.created',
            data: {
              'notificationPublicId': id,
              'type': 'report.ready',
            },
          );
        },
        child: Text(context.tx('Simular notificação')),
      ),
    ],
  ),
)
''';

  /// Region `sg-notification-bell-interruptor`.
  static const String sgNotificationBellInterruptor = r'''
SgNotificationBell(
  apiUrl: 'https://demo.local/user-notifications',
  fetcher: _interruptor.fetch,
  defaultUnreadOnly: false,
)
''';

  /// Region `sg-notification-bell-sem-interruptor`.
  static const String sgNotificationBellSemInterruptor = r'''
SgNotificationBell(
  apiUrl: 'https://demo.local/user-notifications',
  fetcher: _semInterruptor.fetch,
  showUnreadToggle: false,
)
''';

  /// Region `sg-notification-bell-tipos`.
  static const String sgNotificationBellTipos = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgNotificationBell(
      apiUrl: 'https://demo.local/user-notifications',
      fetcher: _tipos.fetch,
      types: {
        'report.ready': SgNotificationTypeConfig(
          icon: const Icon(Icons.description_outlined),
          onOpen: (n) => setState(
            () => _evento = 'baixar relatório ${n.publicId}',
          ),
        ),
        'backup.finished': SgNotificationTypeConfig(
          icon: const Icon(Icons.check_circle_outline),
          onOpen: (n) => setState(
            () => _evento = 'baixar backup ${n.publicId}',
          ),
        ),
      },
      onNotificationDelete: (n) =>
          setState(() => _evento = 'excluiu: ${n.title}'),
    ),
    Text('Último evento: $_evento'),
  ],
)
''';
}
