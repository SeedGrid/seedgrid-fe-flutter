// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../props/sg_prop_spec.dart';

/// Props públicas de `SgRealtimeProvider` no React — Avisos em tempo real para o usuario logado pelo SeedGrid Pulse: pede o token de conexao ao backend (que o emite para o usuario da sessao), conecta direto no Pulse, reconecta sozinho, para quando a credencial e revogada e expoe o status para a tela decidir entre aviso e polling de reserva.
/// O widget deve declarar `implements SgRealtimeProviderProps`.
abstract interface class SgRealtimeProviderProps {
  /// Channels que a aplicacao quer ouvir (ex.: ["backup"]). Tipo TS: `string[]` (sem tradução exata; ver excecoes.json).
  List<Object?> get channels;
  /// Arvore que ouve os avisos com useSgRealtimeEvent. No React e `children`.
  Widget get child;
  /// Opções avançadas do cliente do Pulse (reconexão, `webSocketImpl` em testes...). Tipo TS: `Omit&lt;ConnectInput, "getToken" | "accountKey" | "baseUrl"&gt;` (sem tradução exata; ver excecoes.json).
  Object? get connectOptions;
  /// Liga/desliga (ex.: false enquanto nao ha usuario logado). Padrão: `true`. No React a prop se chama `enabled` (valor invertido); ver ADR 50.
  bool? get disabled;
  /// Substitui o pedido de token inteiro (apps sem BFF, testes). Tipo TS: `(() =&gt; Promise&lt;SgRealtimeConnectResponse&gt;)` (sem tradução exata; ver excecoes.json).
  Function? get fetchToken;
  /// Endereço do Pulse, usado quando o token não traz `connectUrl` (Pulse sem endereço público).
  String? get pulseUrl;
  /// Rota que entrega o token de conexao do usuario logado (a BFF, na mesma origem). Padrão: `/api/realtime/connect`.
  String? get tokenEndpoint;
  /// Opções do `fetch` do token (ex.: `headers: { Authorization: ... }` quando não há cookie). Tipo TS: `RequestInit` (sem tradução exata; ver excecoes.json).
  Object? get tokenRequestInit;
}

/// Especificação das props de `SgRealtimeProvider` (tabela de props e playground do showcase).
const List<SgPropSpec> sgRealtimeProviderPropSpecs = <SgPropSpec>[
  SgPropSpec(
    name: 'channels',
    reactName: 'channels',
    type: 'List<Object?>',
    tsType: 'string[]',
    required: true,
    description: 'Channels que a aplicacao quer ouvir (ex.: ["backup"]).',
    exact: false,
  ),
  SgPropSpec(
    name: 'child',
    reactName: 'children',
    type: 'Widget',
    tsType: 'React.ReactNode',
    required: true,
    description: 'Arvore que ouve os avisos com useSgRealtimeEvent.',
  ),
  SgPropSpec(
    name: 'connectOptions',
    reactName: 'connectOptions',
    type: 'Object?',
    tsType: 'Omit<ConnectInput, "getToken" | "accountKey" | "baseUrl">',
    required: false,
    description: 'Opções avançadas do cliente do Pulse (reconexão, `webSocketImpl` em testes...).',
    exact: false,
  ),
  SgPropSpec(
    name: 'disabled',
    reactName: 'enabled',
    type: 'bool?',
    tsType: 'boolean',
    required: false,
    defaultValue: 'true',
    description: 'Liga/desliga (ex.: false enquanto nao ha usuario logado).',
  ),
  SgPropSpec(
    name: 'fetchToken',
    reactName: 'fetchToken',
    type: 'Function?',
    tsType: '(() => Promise<SgRealtimeConnectResponse>)',
    required: false,
    description: 'Substitui o pedido de token inteiro (apps sem BFF, testes).',
    exact: false,
  ),
  SgPropSpec(
    name: 'pulseUrl',
    reactName: 'pulseUrl',
    type: 'String?',
    tsType: 'string',
    required: false,
    description: 'Endereço do Pulse, usado quando o token não traz `connectUrl` (Pulse sem endereço público).',
  ),
  SgPropSpec(
    name: 'tokenEndpoint',
    reactName: 'tokenEndpoint',
    type: 'String?',
    tsType: 'string',
    required: false,
    defaultValue: '/api/realtime/connect',
    description: 'Rota que entrega o token de conexao do usuario logado (a BFF, na mesma origem).',
  ),
  SgPropSpec(
    name: 'tokenRequestInit',
    reactName: 'tokenRequestInit',
    type: 'Object?',
    tsType: 'RequestInit',
    required: false,
    description: 'Opções do `fetch` do token (ex.: `headers: { Authorization: ... }` quando não há cookie).',
    exact: false,
  ),
];
