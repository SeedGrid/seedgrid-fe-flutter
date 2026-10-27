# Ligando o SgRealtimeProvider ao SDK do Pulse

O `SgRealtimeProvider` fala com a interface `SgPulseConnection` (sg_pulse_connection.dart), nao com o SDK direto:
 o `seedgrid_pulse_subscriber` ainda nao esta no pub.dev, e uma dependencia de caminho para fora do repositorio
quebraria o `pub get` de quem nao tem a arvore irma.

## Comparacao dos SDKs (verificada em 2026-10-23)

| | Flutter `seedgrid_pulse_subscriber` 2.0.0 | React `@seedgrid/pulse-subscriber-react` 3.0.0 |
|---|---|---|
| Token curto (`getToken`), chamado antes de cada (re)conexao | sim | sim |
| `connectUrl` no token, `baseUrl` opcional | sim | sim |
| Estados | `idle, connecting, connected, subscribed, reconnecting, disconnected, error, authError` | os mesmos (`auth-error` no fio) |
| `4403` credencial revogada e terminal | sim | sim |
| `unsubscribe`, `subscribedChannels`, `autoAck` (nao publicados) | sim | sim |
| Campo de data da mensagem | `createdAt` | `publishedAt` |

A diferenca 2.0.0 x 3.0.0 e so de numeracao: a 2.0.0 do React nunca foi publicada e a 3.0.0 foi a primeira versao no npm,
com as mesmas mudancas. Nao ha defasagem de funcionalidade; o unico ajuste e o nome do campo de data.

## Verificado ao vivo (2026-10-27)

O `SgRealtimeProvider` com este adaptador foi executado contra o Pulse real (conta de demonstracao do `exemplo-pulse`), com o fluxo de producao: o widget faz `POST` num BFF local, o BFF emite o token curto com a chave `project` (`issueConnectToken`), o provider conecta no WebSocket, assina um canal e recebe o que o publisher publica. Resultado, com `autoAck` ligado e desligado: status `connected`; a mensagem publicada para `usr_1` chegou com o mesmo `messageId`; a publicada para `usr_2` **nao** chegou na conexao de `usr_1`. A chave `project` ficou so no BFF. Reconexao com pendentes (conexao derrubada, mensagem publicada com ela caida): a mensagem chegou uma vez ao reconectar e uma 2a queda nao reentregou nada, com `autoAck` ligado e desligado (para mensagens em modo `notification` o `autoAck` nao muda o resultado; o modo `processed`, que espera confirmacao, nao foi exercitado). Os testes estao em `seedgrid-platform-work/scripts/pulse-realtime-live/`.

## Adaptador (compila contra o SDK 2.0.0)

Copie para o app que depende do SDK:

```dart
import 'package:seedgrid_pulse_subscriber/seedgrid_pulse_subscriber.dart' as pulse;

import 'package:seedgrid_components/seedgrid_components.dart';

/// Liga o SgRealtimeProvider ao SDK `seedgrid_pulse_subscriber`.
///
/// Uso:
/// ```dart
/// SgRealtimeProvider(
///   channels: const ['backup'],
///   tokenEndpoint: 'https://meu-app/api/realtime/connect',
///   connectionFactory: () => PulseSdkConnection(),
///   child: ...,
/// )
/// ```
class PulseSdkConnection implements SgPulseConnection {
  // autoAck: true, como o exemplo-pulse: o SDK confirma cada mensagem entregue (sem isso o Pulse pode reentregar).
  PulseSdkConnection([pulse.PulseSubscriber? subscriber]) : _subscriber = subscriber ?? pulse.PulseSubscriber(autoAck: true);

  final pulse.PulseSubscriber _subscriber;

  static SgPulseState _map(pulse.ConnectionState s) => switch (s) {
    pulse.ConnectionState.idle => SgPulseState.idle,
    pulse.ConnectionState.connecting => SgPulseState.connecting,
    pulse.ConnectionState.connected => SgPulseState.connected,
    pulse.ConnectionState.subscribed => SgPulseState.subscribed,
    pulse.ConnectionState.reconnecting => SgPulseState.reconnecting,
    pulse.ConnectionState.disconnected => SgPulseState.disconnected,
    pulse.ConnectionState.error => SgPulseState.error,
    pulse.ConnectionState.authError => SgPulseState.authError,
  };

  @override
  Stream<SgPulseState> get states => _subscriber.states.map(_map);

  @override
  Stream<SgPulseMessage> get messages => _subscriber.messages.map(
    (m) => SgPulseMessage(
      channel: m.channel,
      event: m.event,
      data: m.data,
      messageId: m.messageId,
      publishedAt: m.createdAt, // no SDK Flutter o campo se chama createdAt (no React, publishedAt)
    ),
  );

  /// [options] pode ser um `pulse.ReconnectConfig` (politica de reconexao); o resto e ignorado.
  @override
  Future<void> connect({required SgPulseTokenGetter getToken, String? baseUrl, Object? options}) =>
      _subscriber.connect(
        pulse.ConnectInput(
          baseUrl: baseUrl,
          getToken: () async {
            final t = await getToken();
            return pulse.PulseConnectToken(token: t.token, expiresAt: t.expiresAt, connectUrl: t.connectUrl);
          },
          reconnect: options is pulse.ReconnectConfig ? options : const pulse.ReconnectConfig(),
        ),
      );

  @override
  Future<void> subscribe(List<String> channels) => _subscriber.subscribe(pulse.SubscribeInput(channels: channels));

  @override
  Future<void> disconnect() => _subscriber.disconnect();
}
```
