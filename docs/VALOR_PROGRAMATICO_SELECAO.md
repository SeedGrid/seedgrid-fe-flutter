# Valor programático nos campos de escolha

Carregar um valor por código (dado salvo, `setValue` do formulário, prop `value` do pai) tem de funcionar em
todos os campos de escolha, inclusive para **limpar**. Esta é a matriz de testes e as decisões.

Testes: `packages/seedgrid_components/test/programmatic/selection_*_test.dart`.
Vetores do React REAL (esbuild + jsdom + react-hook-form): `test/programmatic/react_vectors/`.
Regerar: `node packages/seedgrid_components/test/programmatic/react_vectors/generate.mjs ../seedgrid-fe-components/packages/seedgrid-fe-components [componentes...]`.

## Vias testadas

- a: valor inicial (`value` / `defaultValue` / padrão do formulário)
- b: `value` controlado mudando por fora (outro item, vazio/nulo, fora das opções, o mesmo)
- c: `name` + `control` com `setValue` / `reset` / `getValue`
- d: opções que chegam depois do valor, opções mudando, tipo do id (número x texto)
- e: o que `onChange` emite (e que mudar por fora NÃO emite)
- f: validação depois de setar (aparece/some, `trigger`)
- g: setar com o painel aberto ou o campo focado e continuar interagindo
- h: `disabled` / `readOnly`

## Matriz (OK = passa; R = comparado com o React real; F = teste direto no Flutter; n/a = não se aplica)

| Componente | a | b | c | d | e | f | g | h | Fonte |
|---|---|---|---|---|---|---|---|---|---|
| SgCombobox | OK | OK | OK | OK | OK | OK | OK | OK | R (31) |
| SgAutocomplete | OK | OK | OK | OK | OK | OK | OK | OK | R (26) |
| SgMultiSelect | OK | OK | OK | OK | OK | OK | OK | OK | R (73, junto com Chips) |
| SgMultiSelectChips | OK | OK | OK | OK | OK | OK | OK | OK | R |
| SgCheckboxGroup | OK | OK | OK | OK | OK | OK | OK | OK | R (121, junto com os 4 abaixo) |
| SgRadioGroup | OK | OK | OK | OK | OK | OK | OK | OK | R |
| SgToggleSwitch | OK | OK | OK | n/a | OK | OK | OK | OK | R |
| SgSlider | OK | OK | OK | OK (passo) | OK | n/a | OK | OK | R |
| SgRating | OK | OK | OK | n/a | OK | OK | OK | OK | R |
| SgInputOTP | OK | OK | OK | OK (máscara) | OK | OK | OK | OK | R (33) |
| SgPickList | OK | OK | OK | OK | OK | OK | OK | OK | F (21, com OrderList) |
| SgOrderList | OK | OK | OK | OK | OK | OK | OK | OK | F |
| SgCalendar | OK | OK | n/a (sem name/control) | OK (min/max) | OK | n/a | OK | OK (isDateDisabled) | F (8); regras do `value` já têm vetores em `test/widgets/calendar_vectors` |
| SgPeriodSelector | OK | OK | OK | n/a | OK | OK | OK | OK | F (14, com YearPart); é um SgCombobox por dentro |
| SgYearPartSelector | OK | OK | n/a (sem name/control) | OK (normalização) | OK | n/a | n/a | OK | F |
| SgTextEditor (valueHtml) | OK | OK | OK | OK (HTML ruim) | OK | OK | OK | OK | F (10); a conversão HTML já tem vetores do TipTap |
| Extras do Flutter | | | | | | | | | `selection_extras_test.dart` (7) |

Lista, Calendário e Editor não foram comparados com o React no nível "valor programático" (a lógica deles
já tem vetores próprios): os testes diretos cobrem as mesmas vias.

## Bugs do Flutter achados e corrigidos

1. **Não conseguia limpar por fora** (o pai passa `value: null` e o campo mostrava o valor antigo ou o inicial):
   SgCombobox, SgRadioGroup, SgCheckboxGroup, SgToggleSwitch, SgMultiSelect/Chips, SgAutocomplete,
   SgPeriodSelector e SgTextEditor. Corrigido sincronizando o estado interno quando a prop muda.
2. **SgAutocomplete perdia `setValue` feito com o campo focado**: o componente ignorava todo valor externo
   enquanto focado. Agora ignora só o eco do que ele mesmo emitiu (`_lastEmitted`).
3. **SgRadioGroup emitia de novo** ao tocar no radio já marcado.
4. **SgCombobox não revalidava** após o usuário escolher num campo com erro.
5. **SgPeriodSelector**: depois de `reset()` / `setValue(null)` o campo ficava com a última escolha do usuário
   (estado interno) e `value` voltando a nulo mostrava o valor inicial. Ligado ao formulário, agora quem manda é o formulário.
6. **SgTextEditor**: `reset()` sem padrão, `setValue(null)`, valor que não é texto e `valueHtml` voltando a nulo
   deixavam o texto antigo. Agora limpam.
7. **SgInputOTP**: ao mudar a máscara, o valor era refeito a partir do que a máscara anterior tinha cortado.
   Agora refaz a partir do valor de fora (`value` ou formulário), como o React.
8. **SgSlider**: `initialValue` do campo usava o mínimo como `double` (tipo diferente do que o resto grava).

## Defeitos do React (só registrados; o Flutter decide o comportamento mais correto)

- D-1: dentro de formulário (`Controller`) o `onValueChange` do usuário (Combobox, Autocomplete) e o `onChange`
  (MultiSelect, Slider) são engolidos.
- D-2: Autocomplete não guarda `lastSelected` do valor inicial; digitar e sair apaga o campo em vez de restaurar.
- D-3: `SgInputText` ignora `inputProps.onFocus`, então `openOnFocus` e a guarda de foco do Autocomplete/Combobox nunca funcionam.
- D-4: no ToggleSwitch a prop `checked` sobrepõe o valor do formulário.
- D-5: Slider recebe NaN para texto não numérico vindo do formulário (cai no ponto médio).
- D-6: depois de o erro ser posto por `trigger`, o React não revalida quando o usuário muda o valor (só no submit).
- D-7: CheckboxGroup com `value: null` quebra no modo simples (não exercitado).
- D-8: RadioGroup com valor `undefined` no formulário cai no estado interno antigo.
- D-9: PeriodSelector e TextEditor no formulário: `reset` sem padrão deixa a última escolha/texto (passam `undefined`).
- D-10: o readOnly do OTP não impede o jsdom de digitar (artefato do teste; o Flutter respeita readOnly).

## Decisões

- Dart não distingue `null` de `undefined`: `value: null` significa "sem valor controlado" e, se antes havia
  valor, **limpa** o campo.
- Com erro mostrado (ou depois de um submit), o usuário mudar o valor **revalida** (corrige D-6).
- O usuário agindo chama o `onChange` do componente **e** grava no formulário em Combobox, Autocomplete e Slider.
  A família MultiSelect reproduz D-1 de propósito, porque `sg_multi_select_test.dart` (~linha 1000) fixa
  "o onChange do usuário NÃO é chamado dentro do formulário". **Inconsistência a decidir pelo dono.**
- Campos sem valor no formulário registram o padrão do tipo (`[]` em multi/checkbox, `false` no toggle, o mínimo no
  slider); o React deixa `undefined`.
- OTP: `value: null` depois de um valor não nulo é ignorado (igual ao `undefined` do React); não alterado.
- Mudar por fora nunca emite `onChange`.

## Divergências documentadas nos testes (overrides)

Cada uma está no cabeçalho do respectivo arquivo, com o motivo: revalidação ao agir (D-6), padrões do tipo no
formulário, `skipEventsInForm` (D-1) e artefatos do jsdom (disabled/readOnly entregando cliques).
