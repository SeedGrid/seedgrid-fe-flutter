// Showcase do SgNotificationBell. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado. A demo usa um backend simulado em memoria
// e um Pulse simulado (o aviso chega na hora, como com o servidor); o uso real (apiUrl, tokenEndpoint) aparece na secao "Uso real", sem numero.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_notification_bell_page.snippets.g.dart';
import '../src/demo_notifications_api.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

const String _realUse = '''SgNotificationBell(
  apiUrl: 'https://api.meuapp.com/user-notifications',
  tokenEndpoint: 'https://api.meuapp.com/realtime/connect',
  requestInit: SgTokenRequestInit(headers: {'Authorization': 'Bearer \$token'}),
  connectionFactory: () => PulseAdapter(), // cliente do Pulse (ver PULSE_ADAPTER.md)
  types: {
    'report.ready': SgNotificationTypeConfig(
      icon: Icon(Icons.description_outlined),
      onOpen: (n) => baixarRelatorio(n.payload?['reportExecutionId']),
    ),
  },
  onNotification: (n) => print(n.title),
)''';

Future<SgRealtimeConnectResponse> _demoToken() async =>
    const SgRealtimeConnectResponse(
      enabled: true,
      token: 'demo',
      connectUrl: 'wss://demo.local',
      channels: ['user-notifications'],
    );

class SgNotificationBellPage extends StatefulWidget {
  const SgNotificationBellPage({super.key});

  @override
  State<SgNotificationBellPage> createState() => _SgNotificationBellPageState();
}

class _SgNotificationBellPageState extends State<SgNotificationBellPage> {
  final DemoNotificationsApi _basico = DemoNotificationsApi();
  final DemoNotificationsApi _tipos = DemoNotificationsApi();
  final DemoNotificationsApi _interruptor = DemoNotificationsApi();
  final DemoNotificationsApi _semInterruptor = DemoNotificationsApi();
  final SgSimulatedPulseConnection _pulse = SgSimulatedPulseConnection();
  final ValueNotifier<String> _evento = ValueNotifier<String>('-');

  @override
  void dispose() {
    _evento.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Toque no sino. Aqui não há servidor: a caixa vive em memória e um Pulse simulado avisa na hora quando o botão cria uma notificação nova (sem Pulse, a lista se atualiza ao abrir o sino e no polling de reserva). placement escolhe o lado em que o painel abre.',
        preview:
            // #region sg-notification-bell-basico
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
            ),
        // #endregion
        code: SgNotificationBellPageSnippets.sgNotificationBellBasico,
      ),
      ShowcaseExample(
        title: 'Tipos com ícone e ação',
        description:
            'types liga cada tipo de notificação a um ícone e à ação de abrir (por exemplo, baixar o relatório). Os callbacks avisam o que o usuário fez.',
        preview:
            // #region sg-notification-bell-tipos
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
                      onOpen: (n) =>
                          _evento.value = 'baixar relatório ${n.publicId}',
                    ),
                    'backup.finished': SgNotificationTypeConfig(
                      icon: const Icon(Icons.check_circle_outline),
                      onOpen: (n) =>
                          _evento.value = 'baixar backup ${n.publicId}',
                    ),
                  },
                  onNotificationDelete: (n) =>
                      _evento.value = 'excluiu: ${n.title}',
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _evento,
                  builder: (context, evento, _) =>
                      Text('Último evento: $evento'),
                ),
              ],
            ),
        // #endregion
        code: SgNotificationBellPageSnippets.sgNotificationBellTipos,
      ),
      ShowcaseExample(
        title: 'Interruptor Não lidas',
        description:
            'O painel traz o interruptor Não lidas (aqui, com defaultUnreadOnly desligado, abre em Todas). Ligado, tocar numa notificação a tira da lista e o contador cai na hora; desligado, mostra todas. A escolha não persiste entre recargas.',
        preview:
            // #region sg-notification-bell-interruptor
            SgNotificationBell(
              apiUrl: 'https://demo.local/user-notifications',
              fetcher: _interruptor.fetch,
              defaultUnreadOnly: false,
            ),
        // #endregion
        code: SgNotificationBellPageSnippets.sgNotificationBellInterruptor,
      ),
      ShowcaseExample(
        title: 'Sem o interruptor',
        description:
            'showUnreadToggle: false esconde só o interruptor: o sino continua e o painel lista todas as notificações.',
        preview:
            // #region sg-notification-bell-sem-interruptor
            SgNotificationBell(
              apiUrl: 'https://demo.local/user-notifications',
              fetcher: _semInterruptor.fetch,
              showUnreadToggle: false,
            ),
        // #endregion
        code: SgNotificationBellPageSnippets.sgNotificationBellSemInterruptor,
      ),
    ];

    return SgShowcasePage(
      name: 'SgNotificationBell',
      description:
          'Sino de notificações do usuário logado: contador de não lidas, lista, marcar como lida, excluir e limpar. Conecta-se sozinho ao Pulse e, com ele desligado, faz polling de reserva. Sem regra de negócio: cada tipo tem seu ícone e sua ação.',
      examples: examples,
      realUse: (title: 'Uso real (não executa na demo)', code: _realUse),
      propSpecs: [
        ...sgPropSpecs['SgNotificationBell']!,
        const SgPropSpec(
          name: 'connectionFactory',
          reactName: '-',
          type: 'SgPulseConnection Function()?',
          tsType: '-',
          required: false,
          description:
              'Extra do Flutter: cria o cliente do Pulse quando o sino abre a própria conexão (o SDK ainda não é dependência do pacote).',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgNotificationBell']!
            .where(
              (s) => const {
                'maxVisible',
                'showUnreadToggle',
                'defaultUnreadOnly',
                'pollIntervalMs',
                'eventPattern',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgNotificationBell(
          // A chave refaz o sino quando o limite muda.
          key: ValueKey(
            'pg-${v['maxVisible']}-${v['showUnreadToggle']}-${v['defaultUnreadOnly']}',
          ),
          apiUrl: 'https://demo.local/user-notifications',
          fetcher: DemoNotificationsApi().fetch,
          maxVisible: v['maxVisible'] as num?,
          showUnreadToggle: v['showUnreadToggle'] as bool?,
          defaultUnreadOnly: v['defaultUnreadOnly'] as bool?,
          pollIntervalMs: v['pollIntervalMs'] as num?,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "apiUrl: 'https://demo.local/user-notifications'",
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(
              e.value is String
                  ? "${e.key}: '${e.value}'"
                  : '${e.key}: ${e.value}',
            );
          }
          return 'SgNotificationBell(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
