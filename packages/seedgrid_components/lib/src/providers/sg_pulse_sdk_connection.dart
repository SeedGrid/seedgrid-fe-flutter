// Liga o SgRealtimeProvider e o SgNotificationBell ao SDK `seedgrid_pulse_subscriber` (2.0.0), a mesma biblioteca que o
// React usa (`@seedgrid/pulse-subscriber-react`). E o cliente PADRAO: sem `connectionFactory` os dois widgets criam este.
import 'dart:async';

import 'package:seedgrid_pulse_subscriber/seedgrid_pulse_subscriber.dart'
    as pulse;

import 'sg_pulse_connection.dart';

/// Cliente do Pulse sobre o SDK real. `autoAck: true`, como o `exemplo-pulse`: o SDK confirma cada mensagem entregue
/// (sem isso o Pulse pode reentregar).
class SgPulseSdkConnection implements SgPulseConnection {
  SgPulseSdkConnection([pulse.PulseSubscriber? subscriber])
    : _subscriber = subscriber ?? pulse.PulseSubscriber(autoAck: true);

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
      // No SDK Flutter o campo se chama `createdAt` (no React, `publishedAt`).
      publishedAt: m.createdAt,
    ),
  );

  /// [options] pode ser um `pulse.ReconnectConfig` (politica de reconexao); o resto e ignorado.
  @override
  Future<void> connect({
    required SgPulseTokenGetter getToken,
    String? baseUrl,
    Object? options,
  }) => _subscriber.connect(
    pulse.ConnectInput(
      baseUrl: baseUrl,
      getToken: () async {
        final t = await getToken();
        return pulse.PulseConnectToken(
          token: t.token,
          expiresAt: t.expiresAt,
          connectUrl: t.connectUrl,
        );
      },
      reconnect: options is pulse.ReconnectConfig
          ? options
          : const pulse.ReconnectConfig(),
    ),
  );

  @override
  Future<void> subscribe(List<String> channels) =>
      _subscriber.subscribe(pulse.SubscribeInput(channels: channels));

  @override
  Future<void> disconnect() => _subscriber.disconnect();
}
