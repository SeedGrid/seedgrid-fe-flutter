// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'enums.g.dart';
import '../props/sg_prop_spec.dart';

/// Props públicas de `SgNotificationBell` no React — Sino de notificacoes do usuario logado: contador de nao lidas, lista de ate 100 notificacoes com titulo, texto, data e estado lida/nao lida, marcar como lida, excluir, marcar todas e limpar. Autonomo: conecta-se sozinho ao Pulse (token vindo do backend, sem apikey no front) e reaproveita o SgRealtimeProvider se houver; com o Pulse desligado faz polling de reserva. Sem regra de negocio: cada tipo de notificacao tem icone e acao ao abrir.
/// O widget deve declarar `implements SgNotificationBellProps`.
abstract interface class SgNotificationBellProps {
  /// Base das rotas da extension user-notifications (BFF, mesma origem). Padrão: `/api/user-notifications`.
  String? get apiUrl;
  /// O painel abre em Não lidas (ainda não clicadas); ignorada com showUnreadToggle=false e não persiste entre recargas. Padrão: `true`.
  bool? get defaultUnreadOnly;
  /// Evento do Pulse que dispara a leitura. Padrão: `user-notification.*`.
  String? get eventPattern;
  /// Substitui o fetch (apps sem BFF, testes, demonstracao). Tipo TS: `((input: string, init?: RequestInit) =&gt; Promise&lt;Response&gt;)` (sem tradução exata; ver excecoes.json).
  Function? get fetcher;
  /// Maximo de notificacoes na lista; as mais antigas saem. Padrão: `100`.
  num? get maxVisible;
  /// Chegou uma notificacao nova (aviso do Pulse). Tipo TS: `((notification: SgNotification) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onNotification;
  /// O usuario excluiu uma notificacao. Tipo TS: `((notification: SgNotification) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onNotificationDelete;
  /// O usuario abriu uma notificacao (depois do onOpen do tipo). Tipo TS: `((notification: SgNotification) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onOpen;
  /// O polling consultou a API: contador, instante da ultima consulta e motivo (disabled ou unavailable). Tipo TS: `((stats: SgPollingStats) =&gt; void)` (sem tradução exata; ver excecoes.json).
  Function? get onPollingTick;
  /// De que lado do sino o painel abre (como o placement do SgPopup); auto escolhe o lado em que cabe. Padrão: `auto`.
  SgNotificationBellPlacement? get placement;
  /// Intervalo do polling de reserva (so com o Pulse desligado ou fora do ar), preso entre 30 e 60 s, com jitter e backoff em erro. Padrão: `45000`.
  num? get pollIntervalMs;
  /// Opcoes do fetch (ex.: headers com Authorization quando nao ha cookie). Tipo TS: `RequestInit` (sem tradução exata; ver excecoes.json).
  Object? get requestInit;
  /// Mostra o interruptor Não lidas no topo do painel; false esconde só o interruptor (o sino fica) e o painel lista tudo. Padrão: `true`.
  bool? get showUnreadToggle;
  /// Rota que entrega o token do Pulse; usada quando nao ha SgRealtimeProvider acima. Padrão: `/api/realtime/connect`.
  String? get tokenEndpoint;
  /// Tipo da notificacao -&gt; icone e acao ao abrir (onOpen). O sino nao conhece o negocio. Tipo TS: `Record&lt;string, SgNotificationTypeConfig&gt;` (sem tradução exata; ver excecoes.json).
  Object? get types;
}

/// Especificação das props de `SgNotificationBell` (tabela de props e playground do showcase).
const List<SgPropSpec> sgNotificationBellPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'apiUrl',
    reactName: 'apiUrl',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '/api/user-notifications',
    description: 'Base das rotas da extension user-notifications (BFF, mesma origem).',
  ),
  SgPropSpec(
    name: 'defaultUnreadOnly',
    reactName: 'defaultUnreadOnly',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'O painel abre em Não lidas (ainda não clicadas); ignorada com showUnreadToggle=false e não persiste entre recargas.',
  ),
  SgPropSpec(
    name: 'eventPattern',
    reactName: 'eventPattern',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: 'user-notification.*',
    description: 'Evento do Pulse que dispara a leitura.',
  ),
  SgPropSpec(
    name: 'fetcher',
    reactName: 'fetcher',
    type: 'Function?',
    tsType: '((input: string, init?: RequestInit) => Promise<Response>)',
    required: false,
    description: 'Substitui o fetch (apps sem BFF, testes, demonstracao).',
    exact: false,
  ),
  SgPropSpec(
    name: 'maxVisible',
    reactName: 'maxVisible',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '100',
    description: 'Maximo de notificacoes na lista; as mais antigas saem.',
  ),
  SgPropSpec(
    name: 'onNotification',
    reactName: 'onNotification',
    type: 'Function?',
    tsType: '((notification: SgNotification) => void)',
    required: false,
    description: 'Chegou uma notificacao nova (aviso do Pulse).',
    exact: false,
  ),
  SgPropSpec(
    name: 'onNotificationDelete',
    reactName: 'onNotificationDelete',
    type: 'Function?',
    tsType: '((notification: SgNotification) => void)',
    required: false,
    description: 'O usuario excluiu uma notificacao.',
    exact: false,
  ),
  SgPropSpec(
    name: 'onOpen',
    reactName: 'onOpen',
    type: 'Function?',
    tsType: '((notification: SgNotification) => void)',
    required: false,
    description: 'O usuario abriu uma notificacao (depois do onOpen do tipo).',
    exact: false,
  ),
  SgPropSpec(
    name: 'onPollingTick',
    reactName: 'onPollingTick',
    type: 'Function?',
    tsType: '((stats: SgPollingStats) => void)',
    required: false,
    description: 'O polling consultou a API: contador, instante da ultima consulta e motivo (disabled ou unavailable).',
    exact: false,
  ),
  SgPropSpec(
    name: 'placement',
    reactName: 'placement',
    type: 'SgNotificationBellPlacement?',
    tsType: 'SgNotificationPlacement',
    required: false,
    defaultValue: 'auto',
    description: 'De que lado do sino o painel abre (como o placement do SgPopup); auto escolhe o lado em que cabe.',
    values: <String>['top', 'left', 'right', 'bottom', 'auto'],
  ),
  SgPropSpec(
    name: 'pollIntervalMs',
    reactName: 'pollIntervalMs',
    type: 'num?',
    tsType: 'number',
    required: false,
    defaultValue: '45000',
    description: 'Intervalo do polling de reserva (so com o Pulse desligado ou fora do ar), preso entre 30 e 60 s, com jitter e backoff em erro.',
  ),
  SgPropSpec(
    name: 'requestInit',
    reactName: 'requestInit',
    type: 'Object?',
    tsType: 'RequestInit',
    required: false,
    description: 'Opcoes do fetch (ex.: headers com Authorization quando nao ha cookie).',
    exact: false,
  ),
  SgPropSpec(
    name: 'showUnreadToggle',
    reactName: 'showUnreadToggle',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Mostra o interruptor Não lidas no topo do painel; false esconde só o interruptor (o sino fica) e o painel lista tudo.',
  ),
  SgPropSpec(
    name: 'tokenEndpoint',
    reactName: 'tokenEndpoint',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '/api/realtime/connect',
    description: 'Rota que entrega o token do Pulse; usada quando nao ha SgRealtimeProvider acima.',
  ),
  SgPropSpec(
    name: 'types',
    reactName: 'types',
    type: 'Object?',
    tsType: 'Record<string, SgNotificationTypeConfig>',
    required: false,
    description: 'Tipo da notificacao -> icone e acao ao abrir (onOpen). O sino nao conhece o negocio.',
    exact: false,
  ),
];
