# O SgRealtimeProvider e o SgNotificationBell sobre o SDK do Pulse

Os dois widgets criam sozinhos o cliente do SDK `seedgrid_pulse_subscriber` (classe `SgPulseSdkConnection`, em
sg_pulse_sdk_connection.dart), como o React cria o `PulseSubscriberClient`. A dependencia esta no pubspec do pacote **por git, com
tag fixa** (`flutter-subscriber-v2.0.0` do repositorio publico `SeedGrid/seedgrid-pulse-sdk`), sem arvore irma e sem credencial.
O `pubspec` tem `publish_to: none`, que aceita dependencia git; o pacote so vai ao pub.dev depois de os componentes serem bem testados.

`connectionFactory` continua existindo como extra OPCIONAL do Flutter: troca o cliente (testes, simulacao com
`SgSimulatedPulseConnection`, ou outro cliente que implemente `SgPulseConnection`). `apiUrl` e `tokenEndpoint` absolutos sao excecao de
plataforma (no Flutter nao existe "mesma origem").

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

## Como o adaptador funciona (resumo do codigo ja incluido no pacote)

O codigo completo esta em `sg_pulse_sdk_connection.dart`: mapeia os estados do SDK, converte `createdAt` em `publishedAt`, repassa `ReconnectConfig` via
`connectOptions` e liga `autoAck: true`.
