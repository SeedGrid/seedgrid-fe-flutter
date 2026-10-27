# Relógio (SgClock) e temas

Porte de `src/gadgets/clock/` do `@seedgrid/fe-components`: `SgClock`, `SgTimeProvider` (+ `useSgTime`),
`SgClockThemeProvider` (+ `useSgClockThemeResolver`), `SgClockThemePicker` e `SgClockThemePreview`.

Decisão do dono (ADR 51, D8): **só temas embutidos**. Tema carregado por URL/SVG livre não é portado.

## Formato de tema `sg-clock-theme/1` (JSON)

No React cada tema é um SVG de `viewBox` 100×100 com classes Tailwind. No Flutter, cada elemento do SVG é uma
"op" e o tema é a lista de ops, desenhada por `CustomPainter` no mesmo espaço 100×100 (escala = tamanho / 100).

```json
{
  "formato": "sg-clock-theme/1",
  "viewBox": 100,
  "temas": [
    {
      "id": "classic",
      "label": "Classic",
      "order": 1,
      "tags": ["opcional"],
      "ops": [
        { "op": "circle", "cx": 50, "cy": 50, "r": 48, "fill": { "light": "#f5f5f5", "dark": "#171717" } },
        { "op": "line", "x1": 50, "y1": 4, "x2": 50, "y2": 8, "stroke": "#a3a3a3", "strokeWidth": 0.9, "linecap": "round" },
        { "op": "text", "x": 50, "y": 24, "text": "12", "anchor": "middle", "fill": "#262626", "fontSize": 6, "fontWeight": 600 }
      ]
    }
  ]
}
```

| Campo do tema | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `id` | texto | sim | identificador único; é o que `themeId` e o seletor usam |
| `label` | texto | não | rótulo no seletor (cai no `id`) |
| `order` | inteiro | não | ordem na lista (padrão 999; empate mantém a ordem de registro) |
| `tags` | lista de texto | não | termos extras da busca do seletor |
| `ops` | lista | sim | figuras, de baixo para cima |

Ops (todas em unidades do `viewBox`):

| `op` | Campos | Observações |
|---|---|---|
| `circle` | `cx`, `cy`, `r`, `fill?`, `stroke?`, `strokeWidth?`, `gradient?` | `gradient` = `{cx, cy, r, stops:[{offset, color}]}` radial, em `%` do quadro (como `objectBoundingBox`) |
| `ellipse` | `cx`, `cy`, `rx`, `ry`, `fill?`, `stroke?`, `strokeWidth?` | |
| `line` | `x1`, `y1`, `x2`, `y2`, `stroke?`, `strokeWidth?`, `linecap?` | `linecap: "round"` arredonda as pontas |
| `rect` | `x`, `y`, `width`, `height`, `rx?`, `fill?`, `stroke?`, `strokeWidth?` | `rx` arredonda os cantos |
| `path` | `d`, `fill?`, `stroke?`, `strokeWidth?` | `d` aceita `M m L l H h V v C c Z z` |
| `text` | `x`, `y`, `text`, `anchor?`, `fill?`, `fontSize?`, `fontWeight?`, `letterSpacing?` | `y` é a linha de base; `anchor`: `start`, `middle` ou `end` |

Cor (`fill`/`stroke`): `"none"`, `"#rgb"`, `"#rrggbb"`, `"#rrggbbaa"` (alfa no fim, como no CSS) ou
`{ "light": cor, "dark": cor }` (o `dark:` do Tailwind). Padrões do SVG: `fill` preto, `stroke` nenhum,
`strokeWidth` 1. Coordenadas já vêm com o `translate` dos grupos aplicado.

Os 10 temas embutidos (`classic`, `minimal`, `dark`, `seedgrid`, `music`, `music-notes`, `music-staff`,
`roman-classic`, `roman-ornate`, `segment`) **não são escritos à mão**: saem de
`test/widgets/clock_vectors/generate.mjs`, que executa o `builtins.tsx` do React e converte o SVG em JSON
(`clock_builtin_themes.g.dart`, mesmo conteúdo de `test/widgets/clock_vectors/themes.json`).
O teste `sg_clock_logic_test.dart` valida o esquema, a igualdade entre os dois e a estrutura contra o SVG do React.

Em código também dá para criar um tema com `SgClockTheme(id:, ops: [...])` ou com `paint: (canvas, args) {...}`
(desenho livre no espaço 100×100; `args.size` e `args.dark`).

## Como no React: temas não são registrados sozinhos

`registerSgClockBuiltInThemes()` (registro global) ou
`SgClockThemeProvider(value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn), ...)`.

## O que não foi portado, e o erro que aparece

| Recurso do React | No Flutter |
|---|---|
| Tema por `url` (SVG remoto, `urlThemeCache.ts`) | `SgClockTheme(url:)` é aceito, mas desenhar reporta `SgClockUrlThemeUnsupportedError` (por `FlutterError.reportError`, uma vez por tema) e nada é desenhado. Mensagem cita o tema, a URL e o ADR 51. |
| Fusos IANA completos (`Intl.DateTimeFormat`) | O React usa o banco do navegador; no Flutter a tabela é nossa (`clock_tz_data.g.dart`, gerada do Intl do Node por `test/widgets/clock_vectors/generate_tz_data.mjs`): 464 nomes IANA, com cada mudança de horário de verão de 2019 a 2045, conferidos contra o Intl em milhares de instantes. O padrão continua sendo o fuso da máquina (`timezone` nulo); a tabela só vale quando a pessoa escolhe outro fuso. Também há `UTC`/`GMT`, deslocamentos (`+03:00`, `-0530`, `+03`) e `Etc/GMT+N`. **Manutenção:** regerar a tabela quando um país mudar a regra de horário de verão ou antes de 2045. Nome fora da tabela: `SgClockUnsupportedTimeZoneError` reportado uma vez e o relógio usa o fuso da máquina; `registerSgClockTimeZone` acrescenta ou substitui uma zona. |
| Estilos digitais animados (`segment`, `sevenSegment`, `roller3d`, `flip`, `fade`, `matrix`, `neon`, `discard`) | Dependem dos widgets de dígitos. O `SgClock` os desenha por um construtor registrado: `registerSgClockDigitalStyle(SgClockDigitalStyle.flip, (context, parts) => ...)`. Sem construtor, usa o estilo `default`. `parts` traz hora, minuto, segundo, período, `text`, `textWithPeriod` e `sizePx`, como o React os monta. |
| Períodos do dia por idioma (12h) | Tabela gerada do Intl (`clock_locale_data.g.dart`) para `pt-BR`, `pt-PT`, `en-US`, `es`, `fr`, `de-DE`, `pt`, `en`. Outro idioma cai em `pt-PT` (se `pt-*`) ou `en-US`. Dígitos sempre ASCII. |

## Tempo

`SgClockEnvironment.now` e `SgClockEnvironment.elapsed` fazem o papel de `Date.now()` e `performance.now()` e são
trocáveis em teste (tempo falso). O `SgClock` lê `initialServerTime` só no `initState`, como o React.
Sem `SgTimeProvider` ele se redesenha a cada segundo; com provider, a cada `tick` do provider.
