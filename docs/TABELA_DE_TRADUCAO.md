# Tabela de tradução React -> Dart

Como escrever em Flutter o que você já escreve com `@seedgrid/fe-components`. Cada regra cita a origem
(ADR da KB `SeedGrid/Dev/ADR/`, trecho do README ou arquivo e símbolo do código). Nada aqui é suposição:
o que não tem origem fica na seção "Lacunas".

Criada na T8.2 (teste de familiaridade) a partir das ADRs 49, 50 e 52 e do README; as linhas marcadas
com **(T8.2)** foram acrescentadas depois de portar as três telas de `apps/seedgrid_showcase/test/familiarity/`
e cada uma aponta o arquivo que a comprova.

## Nomes, props e eventos

| React | Dart | Origem |
|---|---|---|
| `<SgButton>`, `<SgInputText>`... | mesmo nome de widget, mesmas props e mesmos valores | README (abertura); ADR 50 |
| `onChange`, `onSelect`, `onClick`... | mesmo nome (`onChange`, não `onChanged`) | ADR 50 item 1; README "Regras" |
| `disabled` | `disabled` | ADR 50 item 2 |
| `enabled={x}` (alguns inputs) | `disabled: !x` (alias com valor invertido) | ADR 50 item 2 |
| `className`, `style` | não existem; use as props nomeadas (`width`, `height`, `padding`, `customColors`...) | ADR 50 item 5; README "Regras" |
| `width`, `height`, `padding` | mesmos nomes; `num` (px) ou texto `'Npx'`, `'N%'`, `'Nrem'` conforme o componente | ADR 50 item 5; `layout/basic/sg_grid.dart` (`gap`), `sg_group_box.dart` (`width`/`height`) |
| string literal (`severity="danger"`) | enum (`SgSeverity.danger`) | ADR 50 item 3; `generated/enums.g.dart` |
| `children` | `child` (um filho) ou `children` (lista), conforme o widget | ADR 50 item 4; `sg_group_box.dart` (`child`), `sg_grid.dart` e `sg_panel.dart` (`children`) |
| `React.ReactNode` | `Widget`; nas props de **texto** (`SgButton.label`/`child`, `SgDialog.title`/`subtitle`, `SgConfirmationDialog.title`/`message`/`subtitle`/`confirmButton.label`, `SgCard.title`/`description`) o tipo é `Object?`: aceita `String` **ou** `Widget` (`title: 'Delete'` ou `title: Text('Delete')`). Lista fechada em `TEXT_OR_WIDGET` (`tools/gen_props/emit.mjs`); conversão por `sgNode` (**T8.2 ajuste**) | ADR 50 item 4; `props/sg_node.dart`; `tools/gen_props/emit.mjs` (`TEXT_OR_WIDGET`) |
| `ref` | `controller` (ex.: `SgDatatableController`) ou `GlobalKey` | ADR 50 item 4; `inputs/datatable/sg_datatable.dart` (`SgDatatableController`) |
| `inputProps` (atributos do `<input>`) | props nomeadas (`keyboardType`, `inputFormatters`, `autofocus`, `textInputAction`, `autofillHints`, `obscureText`); `inputProps` é aceito e ignorado | ADR 50 item 6; `inputs/sg_input_text.dart` |
| `label`, `labelText`, `labelPosition`, `hintText`, `prefixText`, `suffixText`, `elevation`, `filled`, `clearButton` | mesmos nomes; `label`/`labelText` são `String?` | ADR 50 item 7; `generated/sg_input_text.g.dart` |
| props herdadas do HTML (`onClick`, `disabled`, `type`, `children`) | lista fechada em cada widget; no `SgButton`: `onClick`, `disabled`, `type` (`SgButtonType`), `child` | ADR 50; `buttons/sg_button.dart` (cabeçalho) |
| `<SgButton>texto</SgButton>` | `SgButton(child: 'texto')` ou `label: 'texto'` (String ou Widget); `child` vence `label` **(ajuste T8.2)** | `buttons/sg_button.dart` (`child`); comprovado em `test/familiarity/palpites_corrigidos_test.dart` |
| `columns={{ base: 1, sm: 2 }}` no `SgGrid` | `columns: {'base': 1, 'sm': 2}` (campo `Object?`: int ou `Map<String,int>`) | `layout/basic/sg_grid.dart` (`sgGridColumnsFor`) |
| `<div className="sm:col-span-2">` dentro de `SgGrid` | `SgPanel(span: 2, borderStyle: SgPanelBorderStyle.none, children: [...])`; o estouro de 20 px com erro de validação no filho (BUG-2) foi corrigido no `SgGrid` (linhas automáticas só usam `minHeight`, não altura tight) | `layout/basic/sg_grid.dart` (`_GridItem`, `SgPanel.span`); `generated/enums.g.dart` (`SgPanelBorderStyle`) |

## Formulário (react-hook-form -> SgForm)

| React | Dart | Origem |
|---|---|---|
| `useForm({ defaultValues })` | `SgFormController(defaultValues: {...})` | ADR 49; `form/sg_form.dart` (cabeçalho) |
| `control={control}` e `name="x"` no campo | `control: form`, `name: 'x'` | ADR 49 item 3; `form/sg_form.dart` |
| `register={register}` | não existe (todo campo é controlado); use `control` | ADR 49 item 4 |
| `rules={{ required: 'msg', maxLength: {value: 10, message: 'm'} }}` | `rules: SgRules(required: 'msg', maxLength: SgRuleValue(10, 'm'))` | ADR 49 item 2; `form/sg_rules.dart` |
| `required` no componente | `required: true` (+ `requiredMessage`); vira a regra com mensagem i18n | ADR 49 item 5; `form/sg_rules.dart` (`mergeRequiredRule`) |
| `watch("x")` | `form.watch('x')` (só lê); para redesenhar, `ListenableBuilder(listenable: form, ...)` | `form/sg_form.dart` (`watch`) |
| `watch()` / `getValues()` | `form.getValues()` (mapa imutável) | `form/sg_form.dart` (`getValues`) |
| `setValue`, `reset`, `trigger`, `setError`, `clearErrors` | mesmos nomes em `SgFormController`; `setValue` e `trigger` devolvem `Future` | `form/sg_form.dart` |
| `formState.errors` / `isSubmitting` / `isValid` / `isDirty` | `form.errors` / `form.isSubmitting` / `form.isValid` / `form.isDirty` | `form/sg_form.dart` |
| `<form onSubmit={handleSubmit(onSubmit)}>` + `<button type="submit">` | `SgForm(controller: form, onValid: onSubmit, child: ...)` + `SgButton(type: SgButtonType.submit)` | `form/sg_form.dart` (`SgForm.onValid`, `submitOf`); `buttons/sg_button.dart` |
| `handleSubmit(onValid, onInvalid)` | `form.handleSubmit(onValid, onInvalid)`: **executa na hora** e devolve `Future<void>`, não devolve callback (decisão: mantido, ver "Não aplicado"); num botão use `onClick: () => form.handleSubmit(cb)` **(T8.2)** | `form/sg_form.dart` (`handleSubmit`); comprovado em `test/familiarity/formulario_screen.dart` |
| botão `type="submit"` | envia o `SgForm` acima; **sem `SgForm` o clique lança `FlutterError` com a mensagem "precisa estar dentro de um SgForm"** (antes não fazia nada, ajuste T8.2); o `onClick` roda antes do erro | `buttons/sg_button.dart` (linha do `submitOf`); `form/sg_form.dart` (`submitOf` devolve nulo sem `SgForm`) |
| Enter num `<input>` dentro do `<form>` envia (envio implícito do HTML: há botão submit ou `onSubmit`) | `SgForm` envia no Enter de campo de uma linha quando há `SgButton(type: submit)` dentro dele ou `onValid`/`onInvalid`; `SgInputTextArea` (multilinha) não; `submitOnEnter: false` desliga. Limite: só a tecla Enter (web/desktop/teclado físico); o botão "concluir" do teclado de tela do mobile não é interceptado **(ajuste T8.2)** | `form/sg_form.dart` (`_onKey`, `submitOnEnter`); `test/widgets/sg_familiarity_fixes_test.dart` |
| `onSubmit(data)` recebe objeto | recebe `Map<String, Object?>` | `form/sg_form.dart` (`SgSubmitValid`) |

## Tabela (SgDatatable)

| React | Dart | Origem |
|---|---|---|
| linhas `T[]` / `SgDatatableRow = Record<string, unknown>` | `List<Map<String, Object?>>` (`SgDatatableRow`); `SgDatatable` não é genérico, não aceita classes | `inputs/datatable/datatable_types.dart` |
| coluna `{ field, header, sortable, filter }` | `SgDatatableColumn(field:, header:, sortable:, filter:)` (const) | `inputs/datatable/datatable_types.dart` |
| `align: "right"` na coluna | `align: SgDatatableColumnAlign.right` | `inputs/datatable/datatable_types.dart` |
| `body: (row) => <.../>` | `body: (row, meta) => Widget`; o segundo argumento é obrigatório na assinatura (`SgDatatableCellMeta`); campo da linha: `row['name']` | `inputs/datatable/datatable_types.dart` |
| `header` (ReactNode) | `Object`: `String`, `num` ou `Widget` | `inputs/datatable/datatable_types.dart` |
| campo aninhado `owner.name` | igual, com ponto | `inputs/datatable/datatable_types.dart` (cabeçalho) |
| `rowsPerPageOptions={[4, 8]}` | `rowsPerPageOptions: [4, 8]` | `inputs/datatable/sg_datatable.dart` |

## Diálogo e toast

| React | Dart | Origem |
|---|---|---|
| `<SgConfirmationDialog open onOpenChange title="x" message="y">` | mesmos nomes e `title: 'x'`, `message: 'y'` (String ou Widget, **ajuste T8.2**) | `overlay/sg_confirmation_dialog.dart`; comprovado em `dialogo_toast_screen.dart` |
| `severity="danger"` no diálogo | `SgDialogSeverity.danger` (enum próprio, tem `plain`; **não** é o `SgSeverity` do botão) **(T8.2)** | `generated/enums.g.dart` (`SgDialogSeverity`); `overlay/sg_confirmation_dialog.dart` |
| `confirmButton={{ label, icon, severity }}` | `SgConfirmationDialogButtonConfig(label: 'Delete', icon: Icon(..), severity: SgSeverity.danger)` (`label` é String ou Widget; `icon` é `Widget?`) | `overlay/sg_confirmation_dialog.dart` |
| `toast.success("x")`, `toast.message`, `toast.dismiss()` | iguais (`toast` global); opções: `toast.success('x', SgToastOptions(description: 'y'))` | `feedback/sg_toast.dart` (cabeçalho e `SgToastFn`) |
| `<SgToaster />` (fixo na janela) | `SgToaster()` em qualquer lugar: em área limitada (filho de `Stack`) preenche o pai; em área ilimitada (`Column`, `ListView`) não ocupa espaço e desenha no `Overlay` da rota **(ajuste T8.2, antes dava "infinite height")**; ou um `SgToastHost` global | `feedback/sg_toaster.dart` (`SizedBox.expand`); `apps/seedgrid_showcase/lib/main.dart` (`SgToastHost`) |

## Divergências deliberadas do React

| Assunto | Dart | Origem |
|---|---|---|
| `onChange`/`onValueChange` do usuário dentro de formulário | sempre chamado (o React engole em Combobox, Autocomplete, MultiSelect, Slider) | ADR 52 item 2 |
| validadores do componente (CPF, CNPJ, e-mail, telefone, CEP, datas) | rodam também em `handleSubmit`/`trigger` (no React só no blur) | ADR 52 item 3 |
| campo com valor inicial/`setValue` | mostra sempre o valor mascarado | `docs/VALOR_PROGRAMATICO.md` (D1) |
| valor do campo no `watch()`/`getValues()` | o `Map` guarda o valor **mascarado** (`"(11) 98765-4321"`, `"01310-100"`). Confirmado no React: `SgInputPhone` aplica `maskPhone` em `event.target.value` antes de o RHF ler (D14, **T8.2**); a moeda guarda a string numérica (`"0.00"`) via `onExternalChange` | `SgInputPhone.tsx` (`onChange`); `SgInputCurrency.tsx` (`onExternalChange`) |
| textos padrão de validação e de ações (`Required field.`, `Search in all columns`, `Clear filters`, `Cancel`/`Confirm`) | idênticos ao React em en-US (D13, **T8.2**); o idioma vem do provider de i18n | `src/i18n/en-US.ts` do React (`components.inputs.required`, `components.datatable.*`, `components.actions.*`) |
| `SgInputPassword required` rejeita `Abcdef1!xyz` por sequência crescente | mesmo padrão do React: `prohibitsSequentialAscCharacters`, `prohibitsSequentialDescCharacters` e `prohibitsRepeatedCharactersInSequence` são `true` por padrão lá também (D16, **T8.2**); a diferença é só quando roda (ADR 52 item 3) | `SgInputPassword.tsx` (props e `hasSequentialCharacters`) |
| breakpoints do `SgGrid` | medem a janela (`MediaQuery`), como o `@media` do React | `layout/basic/sg_grid.dart` (cabeçalho) |

## Não aplicado de propósito (T8.2, segunda rodada)

O relatório da T8.2 propôs estes ajustes; ficaram de fora e o dev React precisa saber da diferença.

| React | Dart (o que fazer) | Por que não mudou |
|---|---|---|
| `rows: T[]` com classes/objetos e `body: (row) => row.name` | `List<Map<String, Object?>>` e `body: (row, meta) => ... row['name']` (os dois parâmetros são obrigatórios na assinatura) | tornar `SgDatatable` genérico (`SgDatatable<T>`) muda o contrato gerado, os acessores de ordenar/filtrar/campo com ponto e ~20 pontos do componente; aceitar `body` com 1 ou 2 argumentos exigiria `Function` e perderia a checagem do analisador. Fica para uma versão própria |
| `appearance="outline"`, `size="sm"` valem em qualquer componente | enum compartilhado quando o alias TS é compartilhado (`SgAppearance`, `SgSeverity`, `SgSize`, `SgElevation`); `Sg<Componente><Prop>` quando a união é inline (`SgInputTextElevation`, `SgDatatableColumnAlign`, `SgPanelBorderStyle`). A regra está no cabeçalho de `enums.g.dart`; o tipo do campo no `<Comp>Props` diz qual usar | unificar os enums apagaria diferenças reais de valores (ex.: `plain` só existe no diálogo) e quebraria todo código existente |
| `severity="danger"` no diálogo | `SgDialogSeverity.danger` (tem `plain`), não `SgSeverity` | o React também tem dois tipos (`SgDialogSeverity` x `Severity`); mantido 1:1 com o contrato |
| `<form onSubmit={handleSubmit(onSubmit)}>` | `SgForm(controller: form, onValid: onSubmit)` ou `onClick: () => form.handleSubmit(cb)` | `handleSubmit` devolvendo `VoidCallback` mudaria a semântica de quem já usa o `Future` (e do `SgForm`); o caminho idiomático (`SgForm`) já cobre o caso |
| `watch()` / `watch("x")` redesenham sozinhos | `ListenableBuilder(listenable: form, builder: ...)`; `watch('x')` só lê, `getValues()` lê tudo | redesenho automático exigiria o controlador conhecer o `BuildContext` de quem chama (como o hook); um `SgFormWatch` fica como evolução |
| `columns={{ base: 1, sm: 2 }}`, `gap`, `padding`, `width` com string livre | `Object?` (int, `Map` ou texto `'16px'`): erro de digitação não é acusado pelo analisador | o contrato gerado do React é uma união de strings; tipar exigiria classes novas em todos os componentes |
| `useState`, `useMemo`, `useEffect` | `setState` e campos do `State`; `initState`/`didUpdateWidget` | é Flutter geral, não API do SeedGrid |
| `lucide-react` (`<Pencil />`) | `Icon(Icons.edit)` (Material Icons) | não há mapa 1:1 de nomes; é escolha de ícone do app |
| estado global do `toast` entre testes | chame `dismissSgToast()` no fim do teste | o `toast` é módulo global também no React |

## Lacunas (sem origem escrita; ver `relatorios/seedgrid-fe-components/2026-10-25-teste-de-familiaridade-flutter.md`)

- Qual enum usar para cada string literal: a regra agora está no cabeçalho de `generated/enums.g.dart` e na seção "Não aplicado"; a escolha por prop continua sendo lida do tipo do `<Comp>Props`.
