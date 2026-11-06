# SgNotificationBell: contrato compartilhado (P129.F1.T1)

Fonte da verdade: `notificationBellLogic.ts` (React). `vectors.json` e gerado por `generate.mjs`; o Flutter
(`notification_bell_logic.dart`) e o React testam contra ele. Rotas: extension `user-notifications` (P130).

## Item (`SgNotification`)
`publicId`, `type` (livre; o sino so mapeia para icone e acao), `title`, `message?`, `payload?` (so identificadores),
`read`, `readAt?`, `createdAt` (ISO-8601 com offset), `expiresAt?`.

## Regras
- **Ordem:** mais nova primeiro; empate pelo `publicId` DECRESCENTE (como o servidor: ORDER BY created_at DESC, id DESC); instantes truncados para milissegundos (o servidor manda microssegundos). Sem repetidos (vale o ultimo) e sem vencidas (`expiresAt` <= agora). Teto `maxVisible` (padrao e maximo 100, uma pagina da rota; a lista rola no painel): sai a mais antiga.
- **Contador:** vem do servidor (`GET /unread-count`) quando conhecido; senao, as nao lidas da lista local (que e limitada pelo teto); vazio com 0; `99+` acima de 99.
- **Ler / ler todas / excluir:** atualizam a lista local depois da API; ler uma ja lida nao muda nada.
- **Itens novos:** nao lidos, desconhecidos e mais novos que o mais novo ja conhecido (uma antiga so reapareceu: nao e noticia); so eles animam o sino (respeitando "reduzir movimento").
- **Aviso do Pulse** (canal `user-notifications`, evento casando `eventPattern`, padrao `user-notification.*`):
  `created` com `data.notificationPublicId` -> reler a lista (`fetch`; nao existe rota que busque so aquela: a lista e a unica leitura e o id diz qual item e a novidade);
  `created` sem id e `changed` -> reler a lista (`refresh`); outro canal ou evento fora do padrao -> `ignore`.
  `onNotification` dispara so quando a leitura trouxe item novo (uma vez por id).
- **Polling (fallback):** so quando o estado e `disabled` (motivo `disabled`) ou `unavailable`/`auth-error` (motivo `unavailable`).
  `idle`/`connecting`/`connected`/`reconnecting` nao fazem polling. Ao passar para `connected`, ler a lista uma vez.
- **Intervalo:** `pollIntervalMs` preso entre 30 e 60 s (padrao 45 s); a cada falha seguida dobra; jitter de -10% a +10%; o resultado nunca passa de 5 min (teto depois do jitter).
  Em segundo plano (aba oculta / app pausado) o polling para e retoma ao voltar.
- **Ler/excluir com 404:** a notificacao nao existe (apagada, de outro usuario ou expirada: o servidor nao distingue); sai da lista local, sem erro.
- **URLs:** no React `apiUrl`/`tokenEndpoint` podem ser relativos (mesma origem); no Flutter precisam ser absolutos (nao ha origem de pagina).
- **ETag/304 (P129.F1.T3):** o React guarda ETag fraca + corpo de cada pagina da lista (chave = query), manda `If-None-Match` na releitura e, em 304 (sem corpo), reaproveita o corpo guardado. O Flutter faz o mesmo (P129.F3.T4): `SgFetchResponse` ganhou `headers` (opcional, chaves em minusculas) e o fetcher padrao os preenche via `SgHttpClient.send`; cobertura no teste de widget (nao ha logica pura nova para vetores).
- **Provider:** o sino so reaproveita um SgRealtimeProvider que assine `user-notifications`; senao abre o proprio. O provider tenta de novo (5 s ate 60 s) se o `/realtime/connect` falhar (503/429/rede); so `enabled:false` e definitivo.
- **Um laco de polling por vez** (trocar de aba nao abre outro); `onNotification` dispara uma vez por notificacao.
- **Metrica:** `onPollingTick({count, lastAt, reason})` a cada consulta de polling, com o mesmo nome nas duas plataformas.
- **Telas:** `loading` (sem dados ainda), `error` (falha e nada para mostrar), `empty`, `list`. Com lista carregada, a falha vira aviso.
- **Tempo relativo:** `now` (< 1 min, ou futuro), `minute`, `hour` (< 24 h), `day` (< 7 d), `date`; o texto e do i18n.

## Props (mesmos nomes nas duas plataformas)
`apiUrl` (base das rotas, padrao `/api/user-notifications`), `tokenEndpoint`, `types` (tipo -> `icon`/`onOpen`), `eventPattern`,
`pollIntervalMs`, `maxVisible`, `onNotification`, `onNotificationDelete`, `onOpen`, `onPollingTick`.

- **Posicao do painel (`placement`):** `auto` (padrao), `top`, `right`, `bottom`, `left`, como no SgPopup. `auto` tenta abaixo, acima, a direita e a esquerda e usa o primeiro lado em que o painel (largura 416, altura ate 512) cabe com 8 de afastamento; se nenhum cabe, abaixo ou acima, onde ha mais espaco. O painel se alinha ao fim do sino e e empurrado para dentro da janela (margem 8). A funcao pura `panelPosition` tem os vetores em `vectors.panel`. Abaixo de 600 px de largura (Flutter) o painel vira folha de baixo.

- **Interruptor "Nao lidas" (`showUnreadToggle`, `defaultUnreadOnly`):** um `SgToggleSwitch` no topo do painel, que comeca ligado ("Nao lidas" = ainda nao clicadas). `showUnreadToggle=false` esconde SO o interruptor (o sino nunca some) e o painel lista tudo; `defaultUnreadOnly` (padrao true) e ignorada nesse caso. Ligado, a lista e lida com `unreadOnly=true` (a query entra na ETag e no teto de 100) e clicar numa notificacao a tira da lista e baixa o contador na hora; em "Todas" ela so perde o destaque. Lista vazia ligada mostra "Tudo em dia" e o atalho "Ver todas". Aviso novo do Pulse entra nos dois modos. A escolha NAO persiste entre recargas. A logica pura (`visibleItems`, `listQuery`, `afterOpen`, `initialUnreadOnly`, `viewState` com `unreadOnly`) tem os vetores em `vectors.unreadMode` e `vectors.view`.
