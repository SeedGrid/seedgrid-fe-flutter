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
| `React.ReactNode` | `Widget` | ADR 50 item 4; `sg_confirmation_dialog.dart` (`title`, `message` são `Widget?`) |
| `ref` | `controller` (ex.: `SgDatatableController`) ou `GlobalKey` | ADR 50 item 4; `inputs/datatable/sg_datatable.dart` (`SgDatatableController`) |
| `inputProps` (atributos do `<input>`) | props nomeadas (`keyboardType`, `inputFormatters`, `autofocus`, `textInputAction`, `autofillHints`, `obscureText`); `inputProps` é aceito e ignorado | ADR 50 item 6; `inputs/sg_input_text.dart` |
| `label`, `labelText`, `labelPosition`, `hintText`, `prefixText`, `suffixText`, `elevation`, `filled`, `clearButton` | mesmos nomes; `label`/`labelText` são `String?` | ADR 50 item 7; `generated/sg_input_text.g.dart` |
| props herdadas do HTML (`onClick`, `disabled`, `type`, `children`) | lista fechada em cada widget; no `SgButton`: `onClick`, `disabled`, `type` (`SgButtonType`), `child` | ADR 50; `buttons/sg_button.dart` (cabeçalho) |
| `<SgButton>texto</SgButton>` | `SgButton(child: Text('texto'))` ou `label: Text('texto')`; `child` vence `label` | `buttons/sg_button.dart` (`child`) |
| `columns={{ base: 1, sm: 2 }}` no `SgGrid` | `columns: {'base': 1, 'sm': 2}` (campo `Object?`: int ou `Map<String,int>`) | `layout/basic/sg_grid.dart` (`sgGridColumnsFor`) |
| `<div className="sm:col-span-2">` dentro de `SgGrid` | `SgPanel(span: 2, borderStyle: SgPanelBorderStyle.none, children: [...])`; **atenção (T8.2)**: com erro de validação no filho o painel estoura 20 px (bug registrado no relatório da T8.2) | `layout/basic/sg_grid.dart` (`_GridItem`, `SgPanel.span`); `generated/enums.g.dart` (`SgPanelBorderStyle`) |

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
| `handleSubmit(onValid, onInvalid)` | `form.handleSubmit(onValid, onInvalid)`: **executa na hora** e devolve `Future<void>`, não devolve callback; num botão use `onClick: () => form.handleSubmit(cb)` **(T8.2)** | `form/sg_form.dart` (`handleSubmit`); comprovado em `test/familiarity/formulario_screen.dart` |
| botão `type="submit"` | só envia se houver um `SgForm` acima; com `control:` solto e sem `SgForm`, o clique não faz nada **(T8.2)** | `buttons/sg_button.dart` (linha do `submitOf`); `form/sg_form.dart` (`submitOf` devolve nulo sem `SgForm`) |
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
| `<SgConfirmationDialog open onOpenChange title="x" message="y">` | mesmos nomes, mas `title` e `message` são `Widget?`: `title: Text('x')` **(T8.2)** | `overlay/sg_confirmation_dialog.dart`; comprovado em `dialogo_toast_screen.dart` |
| `severity="danger"` no diálogo | `SgDialogSeverity.danger` (enum próprio, tem `plain`; **não** é o `SgSeverity` do botão) **(T8.2)** | `generated/enums.g.dart` (`SgDialogSeverity`); `overlay/sg_confirmation_dialog.dart` |
| `confirmButton={{ label, icon, severity }}` | `SgConfirmationDialogButtonConfig(label: Text(..), icon: Icon(..), severity: SgSeverity.danger)` (`label` e `icon` são `Widget?`) | `overlay/sg_confirmation_dialog.dart` |
| `toast.success("x")`, `toast.message`, `toast.dismiss()` | iguais (`toast` global); opções: `toast.success('x', SgToastOptions(description: 'y'))` | `feedback/sg_toast.dart` (cabeçalho e `SgToastFn`) |
| `<SgToaster />` (fixo na janela) | `SgToaster()` como irmão de um `Stack` com área limitada (ocupa todo o espaço: em `Column`/`ListView` dá "BoxConstraints forces an infinite height") **(T8.2)**; ou um `SgToastHost` global | `feedback/sg_toaster.dart` (`SizedBox.expand`); `apps/seedgrid_showcase/lib/main.dart` (`SgToastHost`) |

## Divergências deliberadas do React

| Assunto | Dart | Origem |
|---|---|---|
| `onChange`/`onValueChange` do usuário dentro de formulário | sempre chamado (o React engole em Combobox, Autocomplete, MultiSelect, Slider) | ADR 52 item 2 |
| validadores do componente (CPF, CNPJ, e-mail, telefone, CEP, datas) | rodam também em `handleSubmit`/`trigger` (no React só no blur) | ADR 52 item 3 |
| campo com valor inicial/`setValue` | mostra sempre o valor mascarado | `docs/VALOR_PROGRAMATICO.md` (D1) |
| breakpoints do `SgGrid` | medem a janela (`MediaQuery`), como o `@media` do React | `layout/basic/sg_grid.dart` (cabeçalho) |

## Lacunas (sem origem escrita; ver `relatorios/seedgrid-fe-components/2026-10-25-teste-de-familiaridade-flutter.md`)

- `useState`/`setState`, `useMemo`, `useEffect`: não há regra escrita; o relatório da T8.2 propõe a linha.
- Enter dentro de um campo não envia o formulário (no `<form>` do HTML envia): só o botão `submit` aciona `SgForm` (`submitOf` só é chamado em `sg_button.dart`).
- Qual enum usar para cada string literal (compartilhado `SgSeverity`/`SgAppearance`/`SgSize`, ou do componente `SgDialogSeverity`, `SgInputTextElevation`): só se descobre em `generated/enums.g.dart`.
- Ícones `lucide-react` -> `Icon(Icons.x)`: não há regra escrita.
