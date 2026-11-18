## Não lançado — 2026-11-17

### Alterado

* **BREAKING** — `SgInputNumber` e `SgInputCurrency` perderam `required` e `requiredMessage` (tipos, asterisco no rótulo e validação). Para exigir um valor, use `minValue` e `minValueMessage`.
* **BREAKING** — O zero conta como valor: `minValue` e `maxValue` validam também o `0` (antes o zero era tratado como vazio e pulava os limites). Com `emptyValueIsNull`, o vazio de verdade (`null`) continua sem erro de limite.
* A mensagem padrão de mínimo e máximo usa o separador decimal do idioma (pt-BR `0,01`; en-US `0.01`).
* `Ctrl+A` seguido de dígito substitui o valor; `Backspace` com tudo selecionado apaga tudo.
* **BREAKING** — Campos com máscara (`SgInputCPF`, `SgInputCNPJ`, `SgInputCPFCNPJ`, `SgInputPhone`, `SgInputPostalCode`) guardam e entregam sempre o valor mascarado (`529.982.247-25`, `(11) 98765-4321`, `01310-100`), digitado ou posto por código (`setValue`, `reset`, valor inicial). Valor externo maior que a máscara é cortado nela.
* **BREAKING** — `SgInputDateTime`: `valueMode` (`local` padrão, `utc` ou `offset`) e fusos IANA em `timeZone`; antes o `onChange` entregava sempre o instante UTC.
* `SgMultiSelect` e `SgMultiSelectChips`: `requiredMessage` e o erro de obrigatório aparece também fora de formulário, ao perder o foco.
* `SgButton`: `onClick` pode devolver um `Future`; enquanto pendente o botão fica em `loading` automático e cliques são ignorados. `onClick` síncrono segue igual.
* `SgClock` e `SgCalendar`: nova prop `draggable` no topo (`null` = automático, arrasta a partir de 640 px; `true`; `false`), com prioridade sobre `cardProps.draggable`.
* A classe de regras de validação (`rules`) foi removida. A validação usa as props diretas de cada campo (`required`, `requiredMessage`, `minLength`, `validation`...), como no React; `SgFormController.registerField` recebe `required` (mensagem) no lugar de `rules`. Em `SgMultiSelect`, `SgMultiSelectChips` e `SgPeriodSelector`, `required` só acrescenta o asterisco (como no React).
* `disabled` virou `enabled` (padrão `true`, igual ao React), inclusive em itens, nós e opções. `disabled: true` equivale a `enabled: false`.

### Novo

* Botão `danger` (tema escuro) e botão/selo/avatar `info`: texto branco com contraste ≥ 4,5:1 nos dois temas; alerta e link não mudam.
* Selo e avatar `danger` (tema): o texto sobre o vermelho de erro é branco com contraste ≥ 4,5:1 (o vermelho escurece só o necessário); o número do selo do `SgNotificationBell` deixa de sair preto.
* Tema (`seedgrid_theme`): a cor de destaque tem contraste mínimo de 4,5:1 garantido (mesma fórmula do React): texto sobre fundo, texto do contorno, anel de foco; fundo cheio de botão na cor pura da semente.
* Showcase: aviso para girar o aparelho com o celular deitado.
* `SgColorPicker` (somente Flutter, sem equivalente no React): seletor de cor com área em gradiente (saturação e brilho) e barra de matiz, ou três barras (`mode: SgColorPickerMode.sliders`), campo hex, cores predefinidas e `showSgColorPicker`.

## 0.0.1

* TODO: Describe initial release.
