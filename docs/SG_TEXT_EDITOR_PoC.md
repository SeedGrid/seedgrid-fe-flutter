# SgTextEditor: PoC do motor de edição (T7.0) e conversão (T7.1)

Entrada para o ADR 52. Data: 2026-10-24. Flutter 3.38.5 / Dart 3.10.4. Decisão D7 do dono: motor **nativo**, API pública igual à do React.

## O que o React faz

- Motor: TipTap 2.27.2 (ProseMirror) com `starter-kit`, `underline`, `link`, `image`, `text-align`, `text-style` (estendido com `fontSize`), `font-family`, `color`, `highlight` (multicolor), `subscript`, `superscript`.
- **Formato de troca: HTML do corpo** (`editor.getHTML()`), não JSON. Entra por `valueHtml`/`defaultValueHtml` e sai por `onChangeHtml`. `onSave` entrega um `File` `text/html` com o documento completo (`<!doctype>`, `<style>` com o `cssText`, corpo); `Carregar HTML` lê esse arquivo de volta (`<style>` do `<head>` vai para `onCssTextChange`, `body.innerHTML` vira o conteúdo).
- Barra: título (H1/H2/Normal/H3), fonte (5), tamanho (6), B I U S, cor do texto, destaque, sub/sobrescrito, marcadores, numerada, recuar/avançar, 4 alinhamentos, link, imagem, limpar, Salvar, Carregar HTML.

## Candidatos

| | `flutter_quill` | `appflowy_editor` |
|---|---|---|
| Versão | 11.6.0 (última); **11.5.0 é a última que resolve** com Flutter 3.38.5 (11.5.1+ exige Dart ^3.12 / Flutter >=3.44) | 6.2.0 |
| Licença | **MIT** | **MPL-2.0 ou AGPL-3.0** (dupla, tags do pub.dev) |
| `pub get` | ok (11.5.0, 62 pacotes no total; `quill_native_bridge`, `url_launcher`, `html`, `flutter_colorpicker`, `markdown`) | ok (71 pacotes, entre eles `file_picker`, `pdf`, `device_info_plus`, `keyboard_height_plugin`, `universal_html`) |
| Modelo de documento | Delta (lista plana de operações com atributos inline e de linha) | árvore de nós (`Node`) |
| Marcas inline prontas | negrito, itálico, sublinhado, tachado, link, cor, **fundo (destaque)**, fonte, **tamanho**, script sub/sup, código | negrito, itálico, sublinhado, tachado, link, cor, fundo, código; fonte/tamanho/sub/sup exigem extensão própria |
| Blocos | título 1-6, listas (aninhadas por `indent`), citação, bloco de código, **alinhamento**, embeds (imagem etc.) | título, listas aninhadas, citação, alinhamento, imagem, tabela |
| HTML | só por pacotes à parte (`flutter_quill_delta_from_html`, `vsc_quill_delta_to_html`), que não reproduzem o HTML do TipTap | conversores HTML/Markdown embutidos, também diferentes do TipTap |
| Mobile | maduro (teclado, seleção, IME, `QuillController` testável sem navegador) | bom, mais pesado |

### Escolha: `flutter_quill` 11.5.0

1. **Licença**: MIT, sem obrigação de copyleft. O `appflowy_editor` obriga a escolher MPL-2.0 (arquivo a arquivo) ou AGPL-3.0, e o dono não quer essa decisão jurídica no componente.
2. **Cobertura**: o conjunto de atributos do Delta cobre quase 1:1 as marcas do TipTap (inclusive `size` e `script`, que no AppFlowy teriam de ser escritos).
3. **Testabilidade**: `QuillController` + `Document` rodam em `flutter test` sem navegador, o que permitiu provar comandos e conversão contra o TipTap real.
4. **Menos dependências arrastadas** (62 contra 71, sem `pdf`).
- Nenhuma conversão HTML pronta serve (ordem das marcas, `<span style>`, listas `ul>li>p`, atributos do link): a conversão é **própria** (`sg_text_editor_html.dart`).
- O pacote só foi avaliado na prática no `flutter_quill`; o AppFlowy foi comparado por `pub get`, documentação e licença (não implementei o porte nele).
- Custo aceito: travado em 11.5.0 até o repositório subir para Flutter >= 3.44.

## Recursos: suportados

Conferidos por 264 fixtures geradas pelo **TipTap 2.27.2 real** (esbuild + jsdom, mesmas extensões do `SgTextEditor.tsx`): 166 de HTML, 91 de comandos da barra, 7 de documento completo.

negrito, itálico, sublinhado, tachado, código inline, sub/sobrescrito, cor do texto (`#hex`, `rgb()`, `hsl()`, nomes básicos), destaque com cor (`<mark data-color>`), fonte, tamanho (px), título 1-6, alinhamento (left/center/right/justify, em parágrafo, título, item de lista e citação), listas com marcadores e numeradas aninhadas (inclusive misturadas), recuar/avançar com a mesma regra do `sinkListItem`/`liftListItem`, citação, bloco de código, régua horizontal, imagem em bloco (`src`, `alt`, `title`), link (`href`; protocolos permitidos como o `isAllowedUri` do TipTap; `javascript:` é descartado), quebra de linha (`<br>`), limpar formatação (`unsetAllMarks().clearNodes()`), colapso de espaços e texto solto como o ProseMirror, documento completo (`parseDocument`/`buildDocument`).

## Recursos: NÃO suportados (perda explícita, coberta por teste com a saída esperada)

O Delta é uma lista plana de linhas e a linha tem **um** bloco exclusivo (título, lista, citação ou código). Por isso:

| Entrada | O que acontece |
|---|---|
| `<sub>` e `<sup>` no mesmo trecho | vence o mais interno (Delta tem um `script`) |
| `<mark>` sem cor | vira amarelo `#ffff00` |
| `<mark data-color="yellow">` (nome) | vira `#ffff00` |
| Cor com alfa (`#ff000080`, `rgba()`) | alfa descartado |
| `font-size` em `em`, `rem`, `pt`, `%` | convertido para px |
| `<ol start="3">` | numeração recomeça em 1 |
| Item de lista com vários parágrafos | um item, parágrafos unidos por quebra suave |
| Citação com lista, título ou outra citação dentro | achatada em citação de parágrafos |
| Título dentro de item de lista | item de lista comum |
| Bloco de código com marcas ou `class="language-js"` | texto puro, linguagem perdida |
| Tabelas, `iframe`, `video`, `input`, `script`, `style` | descartados (o TipTap também descarta; célula de tabela vira texto) |
| `<span style="font-weight/font-style/text-decoration">` | vira negrito/itálico/sublinhado/tachado e **não** deixa `<span>` vazio (o TipTap deixa; ver defeitos) |
| Imagem `data:` | descartada na leitura (igual ao TipTap, `allowBase64: false`); a barra ainda insere se digitada |
| Atalhos de markdown (`# `, `- `, `1. `, `> `, ` ``` `) | não existem; só os atalhos do `flutter_quill` (Ctrl+B/I/U, etc.) |

## Estratégia de conversão

- **Leitura** (`SgTextEditorHtml.toDelta`): `html` (parser HTML5) → percurso que reproduz o ProseMirror (regras de marcas, colapso de espaços, parágrafo implícito, transparência de tags desconhecidas) → linhas → Delta. `<br>` ↔ U+2028 no texto (o Flutter quebra a linha nesse caractere; há teste); `<img>` e `<hr>` viram embeds de bloco próprios (`sgImage` com JSON `{src,alt,title}`, `sgHr`).
- **Escrita** (`fromDelta`): Delta → linhas; listas viram `ul/ol > li > p` aninhados a partir de `indent`; marcas aninhadas na **ordem do esquema do TipTap** (link > estilo `span` > negrito > itálico > tachado > sublinhado > destaque > sub > sup) com a mesma reutilização de marcas abertas do `DOMSerializer`; escapes de `innerHTML`.
- **Estilos**: o Dart escreve `style="color: #ff0000"` (forma do navegador). O jsdom reescreve para `color: rgb(255, 0, 0);` e põe aspas em fontes com espaço; os testes normalizam só essa notação dos dois lados.
- **Prova**: `sg_text_editor_html_test.dart` lê o HTML do React e compara o que o Dart escreve com o `getHTML()` do TipTap (e uma segunda passada sobre o canônico). Depois `generate.mjs --verify=<dump>` (o teste grava `SG_TE_DUMP=<arquivo>`) faz o **TipTap relê o HTML emitido pelo Dart**: 142 de 166 saídas voltam idênticas; as 24 restantes são exatamente as perdas da tabela acima (mais `red` → `#ff0000`, a mesma cor).
- **Comandos**: `sg_text_editor_commands_test.dart` aplica no Delta a mesma sequência de comandos do TipTap (82 cenários) e compara o HTML final.

## Defeitos do React encontrados (não corrigidos)

1. **O placeholder nunca aparece**: o componente só grava `data-placeholder` e não há extensão `Placeholder` nem CSS no pacote (o Dart mostra o placeholder).
2. **`required` passa com o editor vazio**: o documento vazio vale `<p></p>`, string não vazia (após digitar e apagar).
3. **Carregar HTML e mudar `valueHtml` por fora não chamam `onChangeHtml`** nem atualizam o RHF (`setContent(…, false)`); o conteúdo carregado só chega ao formulário na próxima edição.
4. **Link**: cancelar o `window.prompt` **remove** o link; URL sem protocolo (`exemplo.com`) é gravada como link relativo.
5. **Imagem `data:` inserida pela barra some ao recarregar** (a leitura descarta `data:`, o comando não).
6. **`<span>` vazio**: `<span style="font-weight:bold">` vira `<span><strong>…</strong></span>` (marca `textStyle` sem atributos) e a releitura não é idempotente.
7. Escolher a fonte "Padrão" grava `font-family: inherit` em vez de remover a marca.
8. Os `<select>` de fonte e tamanho não refletem a seleção (valor fixo `defaultValue`).
9. `toggleBulletList` sobre lista numerada aninhada com seleção total apaga o item filho (comportamento do TipTap, visto em `cmd_lista_num_para_bullets`).
10. `exec()` chama `editor.chain().focus()` sem `.run()`: não faz nada (código morto).
11. `buildFullHtmlDocument` interpola `cssText` sem escapar (`</style>` fecha o bloco).
12. `Salvar` e `Carregar HTML` aparecem mesmo sem `onSave`/`onLoad`.

## Divergências intencionais do Dart

- `disabled` reativo; placeholder visível; cancelar o diálogo de link não mexe no link (URL vazia confirmada remove).
- `onSave` recebe `SgTextEditorFile` (nome, mime, bytes) no lugar de `File`; `htmlFilePicker` (extra Dart, ADR 50) troca o seletor de arquivo padrão (`file_picker` 11.0.3, MIT).
- Cor do texto e destaque por diálogo próprio (paleta + `#rrggbb`) no lugar do `<input type="color">`; link/imagem por diálogo no lugar do `window.prompt`.
- Barra em `Wrap` (quebra em linhas no celular), alvos de toque de 44 px abaixo de 600 px de largura.

## Dependências e arquivos

- `packages/seedgrid_components/pubspec.yaml`: `flutter_quill ^11.5.0`, `html ^0.15.4`, `file_picker ^11.0.3`. (Efeito colateral: `flutter pub get` regerou `apps/seedgrid_showcase/windows/flutter/generated_plugin*` e `pubspec.lock`.)
- Código: `packages/seedgrid_components/lib/src/inputs/editor/` (`sg_text_editor.dart`, `sg_text_editor_toolbar.dart`, `sg_text_editor_commands.dart`, `sg_text_editor_html.dart`) e o barril `lib/src/inputs/editor_inputs.dart`.
- Fixtures: `packages/seedgrid_components/test/widgets/sg_text_editor_vectors/` (`generate.mjs`, `cases.mjs`, `cases_extra.mjs`, `vectors.json`).
- Aviso do Flutter: `flutter_quill` declara `uses-material-design: true`; o app que usar o editor precisa de `uses-material-design: true` no próprio pubspec (o showcase já usa Material).
