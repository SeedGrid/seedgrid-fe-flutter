## Não lançado

### Alterado

* A classe de regras de validação (`rules`) foi removida. A validação usa as props diretas de cada campo (`required`, `requiredMessage`, `minLength`, `validation`...), como no React; `SgFormController.registerField` recebe `required` (mensagem) no lugar de `rules`. Em `SgMultiSelect`, `SgMultiSelectChips` e `SgPeriodSelector`, `required` só acrescenta o asterisco (como no React).
* `disabled` virou `enabled` (padrão `true`, igual ao React), inclusive em itens, nós e opções. `disabled: true` equivale a `enabled: false`.

### Novo

* `SgColorPicker` (somente Flutter, sem equivalente no React): seletor de cor com área em gradiente (saturação e brilho) e barra de matiz, ou três barras (`mode: SgColorPickerMode.sliders`), campo hex, cores predefinidas e `showSgColorPicker`.

## 0.0.1

* TODO: Describe initial release.
