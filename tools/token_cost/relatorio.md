# Custo em tokens: KB x MCP de componentes (MC.0)

Tokenizador: **o200k_base (OpenAI/tiktoken)**, aproximacao dos tokens do Claude. O valor absoluto muda de tokenizador para tokenizador; a razao KB/MCP e o que sustenta a decisao.

Origem dos dados: saidas reais do MCP por stdio (`--platform=react|flutter`, `collect.mjs`) e os arquivos reais da KB. 12 componentes e 6 buscas por plataforma.

## Resumo por tipo de consulta (tokens por consulta, media)

| Plataforma | Tipo | KB | MCP | MCP leve | KB / MCP | KB / MCP leve |
|---|---|---:|---:|---:|---:|---:|
| react | conhecer | 2948 | 1132 | 792 | 2.6x | 3.7x |
| react | validar | 59 | 168 | - | 0.4x | - |
| react | achar | 3205 | 298 | - | 10.7x | - |
| flutter | conhecer | 3891 | 2159 | 792 | 1.8x | 4.9x |
| flutter | validar | n/c (a KB Flutter nao tem validador) | - | - | - | - |
| flutter | achar | 3205 | 302 | - | 10.6x | - |

`conhecer` = conhecer um componente; `achar` = achar o componente por necessidade; `validar` = validar props. MCP = `get_component` completo (padrao); MCP leve = `get_component` com `fields: "props"`. Em `achar`, a KB le o `Preciso-de.md` inteiro e o MCP faz uma busca vetorial.

## Custo fixo por conversa

| Plataforma | KB (SKILL.md + Indice.md, lidos sempre) | MCP (definicoes das tools) |
|---|---:|---:|
| react | 3481 | 2096 |
| flutter | 3481 | 1806 |

Na pratica, uma conversa paga o custo fixo uma vez e depois cada consulta. Custo total para N consultas `conhecer`:

| Plataforma | N | KB | MCP | KB / MCP |
|---|---:|---:|---:|---:|
| react | 1 | 6429 | 3228 | 2.0x |
| react | 3 | 12325 | 5491 | 2.2x |
| react | 5 | 18221 | 7754 | 2.3x |
| react | 10 | 32962 | 13413 | 2.5x |
| flutter | 1 | 7372 | 3965 | 1.9x |
| flutter | 3 | 15153 | 8284 | 1.8x |
| flutter | 5 | 22935 | 12603 | 1.8x |
| flutter | 10 | 42388 | 23400 | 1.8x |

## Detalhe por consulta

### react / conhecer

| Consulta | KB | MCP | MCP leve | Observacao |
|---|---:|---:|---:|---|
| SgButton | 4564 | 904 | 572 |  |
| SgInputText | 2759 | 1266 | 901 |  |
| SgInputCPF | 1514 | 1323 | 983 |  |
| SgInputCurrency | 2469 | 1262 | 904 |  |
| SgCombobox | 1941 | 1379 | 1119 |  |
| SgDatatable | 1961 | 1185 | 951 |  |
| SgDialog | 3389 | 1117 | 775 |  |
| SgCalendar | 4245 | 1006 | 646 |  |
| SgMenu | 4314 | 1683 | 1102 |  |
| SgToggleSwitch | 1425 | 736 | 519 |  |
| SgGrid | 3815 | 795 | 452 |  |
| SgToolBar | 2981 | 924 | 576 |  |

### react / validar

| Consulta | KB | MCP | MCP leve | Observacao |
|---|---:|---:|---:|---|
| SgButton | 61 | 111 | - |  |
| SgInputText | 56 | 199 | - |  |
| SgInputCPF | 56 | 200 | - |  |
| SgInputCurrency | 56 | 199 | - |  |
| SgCombobox | 57 | 215 | - |  |
| SgDatatable | 70 | 232 | - |  |
| SgDialog | 56 | 151 | - |  |
| SgCalendar | 62 | 141 | - |  |
| SgMenu | 57 | 144 | - |  |
| SgToggleSwitch | 57 | 171 | - |  |
| SgGrid | 62 | 113 | - |  |
| SgToolBar | 58 | 143 | - |  |

### react / achar

| Consulta | KB | MCP | MCP leve | Observacao |
|---|---:|---:|---:|---|
| campo para digitar CPF | 3205 | 280 | - |  |
| tabela com paginacao e ordenacao | 3205 | 281 | - |  |
| dialogo de confirmacao ao excluir | 3205 | 291 | - |  |
| escolher uma data | 3205 | 375 | - |  |
| lista dupla para mover itens entre duas colunas | 3205 | 272 | - |  |
| campo de valor em moeda | 3205 | 290 | - |  |

### flutter / conhecer

| Consulta | KB | MCP | MCP leve | Observacao |
|---|---:|---:|---:|---|
| SgButton | 2560 | 1578 | 440 |  |
| SgInputText | 4409 | 3119 | 972 |  |
| SgInputCPF | 4629 | 2482 | 1029 |  |
| SgInputCurrency | 4558 | 2079 | 977 |  |
| SgCombobox | 5239 | 2174 | 1130 |  |
| SgDatatable | 4394 | 3032 | 925 |  |
| SgDialog | 3875 | 2092 | 783 |  |
| SgCalendar | 3140 | 1115 | 593 |  |
| SgMenu | 5461 | 3519 | 1201 |  |
| SgToggleSwitch | 3112 | 1838 | 538 |  |
| SgGrid | 2372 | 1208 | 398 |  |
| SgToolBar | 2940 | 1677 | 520 |  |

### flutter / validar

| Consulta | KB | MCP | MCP leve | Observacao |
|---|---:|---:|---:|---|
| SgButton | n/a | 105 | - |  |
| SgInputText | n/a | 219 | - |  |
| SgInputCPF | n/a | 138 | - |  |
| SgInputCurrency | n/a | 254 | - |  |
| SgCombobox | n/a | 234 | - |  |
| SgDatatable | n/a | 373 | - |  |
| SgDialog | n/a | 260 | - |  |
| SgCalendar | n/a | 228 | - |  |
| SgMenu | n/a | 295 | - |  |
| SgToggleSwitch | n/a | 180 | - |  |
| SgGrid | n/a | 194 | - |  |
| SgToolBar | n/a | 346 | - |  |

### flutter / achar

| Consulta | KB | MCP | MCP leve | Observacao |
|---|---:|---:|---:|---|
| campo para digitar CPF | 3205 | 280 | - |  |
| tabela com paginacao e ordenacao | 3205 | 287 | - |  |
| dialogo de confirmacao ao excluir | 3205 | 286 | - |  |
| escolher uma data | 3205 | 373 | - |  |
| lista dupla para mover itens entre duas colunas | 3205 | 289 | - |  |
| campo de valor em moeda | 3205 | 295 | - |  |

## Limites

- Tokenizador da OpenAI como aproximacao do Claude (decisao do dono em 2026-10-29); para numeros exatos do Claude, trocar `tok()` pela API `count_tokens` da Anthropic.
- Conta o que entra no contexto (argumentos e saidas das tools, trechos lidos da KB); nao conta o raciocinio do modelo nem o codigo que ele escreve depois.
- A KB Flutter nao tem busca por necessidade propria nem validador: usa o `Preciso-de.md` compartilhado e o contrato `.g.dart`.
