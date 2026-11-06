// Backend de mentira (em memoria) para o showcase do SgNotificationBell: responde as mesmas rotas da extension
// user-notifications. Numa aplicacao real nao existe: o sino usa o apiUrl do backend.
import 'dart:convert';

import 'package:seedgrid_components/seedgrid_components.dart';

class DemoNotificationsApi {
  DemoNotificationsApi({bool seed = true}) {
    if (seed) {
      _items = [
        _make(
          'demo-1',
          'report.ready',
          'Relatório de vendas pronto',
          'O relatório de outubro terminou de gerar.',
          2,
          false,
        ),
        _make(
          'demo-2',
          'backup.finished',
          'Backup concluído',
          'O backup diário terminou sem erros.',
          18,
          false,
        ),
        _make(
          'demo-3',
          'invite.accepted',
          'Convite aceito',
          'Marina entrou na sua equipe.',
          1500,
          true,
        ),
      ];
    }
  }

  List<SgNotification> _items = [];
  int _counter = 0;

  static SgNotification _make(
    String id,
    String type,
    String title,
    String message,
    int minutesAgo,
    bool read,
  ) => SgNotification(
    publicId: id,
    type: type,
    title: title,
    message: message,
    read: read,
    createdAt: DateTime.now()
        .subtract(Duration(minutes: minutesAgo))
        .toUtc()
        .toIso8601String(),
  );

  /// Cria uma notificacao nova (como se o backend a tivesse gravado) e devolve o publicId.
  String notify(String type, String title, String message) {
    _counter++;
    final id = 'demo-new-$_counter';
    _items = [_make(id, type, title, message, 0, false), ..._items];
    return id;
  }

  SgFetchResponse _json(Object body, [int status = 200]) =>
      SgFetchResponse(status, jsonEncode(body));

  Future<SgFetchResponse> fetch(SgFetchRequest r) async {
    final path = r.url.split('?').first;
    if (path.endsWith('/realtime/connect')) return _json({'enabled': false});
    final segs = path.split('/');
    if (r.method == 'GET' && path.endsWith('/unread-count')) {
      return _json({'count': _items.where((i) => !i.read).length});
    }
    if (r.method == 'GET') {
      final list = r.url.contains('unreadOnly=true')
          ? _items.where((i) => !i.read).toList()
          : _items;
      return _json({
        'items': [for (final i in list) i.toJson()],
        'page': 0,
        'size': 100,
        'total': list.length,
      });
    }
    if (r.method == 'POST' && path.endsWith('/read-all')) {
      _items = [for (final i in _items) i.copyWith(read: true)];
      return _json({'updated': 1});
    }
    if (r.method == 'POST' && path.endsWith('/read')) {
      final id = segs[segs.length - 2];
      _items = [
        for (final i in _items) i.publicId == id ? i.copyWith(read: true) : i,
      ];
      return const SgFetchResponse(204);
    }
    if (r.method == 'DELETE' && path.endsWith('/user-notifications')) {
      _items = [];
      return _json({'deleted': 1});
    }
    if (r.method == 'DELETE') {
      final id = segs.last;
      _items = [
        for (final i in _items)
          if (i.publicId != id) i,
      ];
      return const SgFetchResponse(204);
    }
    return _json({}, 404);
  }
}
