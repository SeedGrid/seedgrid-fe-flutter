// P173.F1.T1: sem `connectionFactory` o SgRealtimeProvider e o SgNotificationBell criam sozinhos o cliente do SDK
// `seedgrid_pulse_subscriber` (como o React). Aqui contra um servidor WebSocket local que fala o protocolo do Pulse.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

class _FakePulse {
  late final HttpServer server;
  final List<String> receivedQueries = [];
  final List<String> frames = [];
  WebSocket? socket;
  final _ready = Completer<void>();

  Future<void> start() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((req) async {
      receivedQueries.add(
        '${req.uri.path}?${req.uri.query}|${req.headers.value('authorization')}',
      );
      final ws = await WebSocketTransformer.upgrade(req);
      socket = ws;
      ws.add(
        jsonEncode({
          'type': 'connected',
          'protocolVersion': 1,
          'connectionId': 'c1',
        }),
      );
      ws.listen((data) {
        frames.add(data as String);
        final obj = jsonDecode(data) as Map;
        if (obj['type'] == 'subscribe') {
          ws.add(
            jsonEncode({
              'type': 'subscribed',
              'channels': obj['channels'],
              'accountId': 'acc_1',
            }),
          );
          if (!_ready.isCompleted) _ready.complete();
        }
      });
    });
  }

  Future<void> get ready => _ready.future;
  String get url => 'ws://127.0.0.1:${server.port}';

  void publish() => socket!.add(
    jsonEncode({
      'type': 'message',
      'messageId': 'm1',
      'protocolVersion': 1,
      'channel': 'backup',
      'event': 'done',
      'data': {'ok': true},
      'createdAt': '2026-11-18T10:00:00Z',
      'requiresAck': true,
    }),
  );

  Future<void> stop() async {
    await socket?.close();
    await server.close(force: true);
  }
}

void main() {
  testWidgets(
    'SgRealtimeProvider sem connectionFactory conecta pelo SDK e entrega a mensagem',
    (t) async {
      await t.runAsync(() async {
        HttpOverrides.global = null;
        final pulse = _FakePulse();
        await pulse.start();
        final events = <SgRealtimeEvent>[];
        var status = '';
        await t.pumpWidget(
          MaterialApp(
            home: SgRealtimeProvider(
              channels: const ['backup'],
              fetchToken: () async => SgRealtimeConnectResponse(
                enabled: true,
                token: 'pct_1',
                expiresAt: 4102444800,
                connectUrl: pulse.url,
              ),
              child: Builder(
                builder: (c) {
                  status = useSgRealtimeStatus(c).status.value;
                  return SgRealtimeEventListener(
                    channel: 'backup',
                    events: '*',
                    handler: events.add,
                    child: Text('status:$status'),
                  );
                },
              ),
            ),
          ),
        );
        await pulse.ready.timeout(const Duration(seconds: 10));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await t.pump();
        expect(pulse.receivedQueries.single, contains('protocolVersion=1'));
        expect(pulse.receivedQueries.single, contains('access_token=pct_1'));
        expect(status, 'connected');
        pulse.publish();
        await Future<void>.delayed(const Duration(milliseconds: 200));
        await t.pump();
        expect(events.single.messageId, 'm1');
        expect(events.single.publishedAt, '2026-11-18T10:00:00Z');
        // autoAck: o SDK confirma a mensagem entregue.
        expect(pulse.frames.any((f) => f.contains('"type":"ack"')), isTrue);
        await t.pumpWidget(const SizedBox());
        await pulse.stop();
      });
    },
  );
}
