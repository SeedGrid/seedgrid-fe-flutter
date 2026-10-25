# Divergências do React (de propósito)

O porte Flutter segue os componentes React, mas algumas diferenças são decisões, não defeitos esquecidos.
Esta página lista as que o dono decidiu. Os defeitos do React que só foram registrados ficam em
`VALOR_PROGRAMATICO.md` e `VALOR_PROGRAMATICO_SELECAO.md`.

## Decisões do dono

### 2026-10-25 - 1. O `onChange` / `onValueChange` do usuário sempre roda, também dentro de formulário

**React:** com `name` + `control`, o `Controller` troca o callback do usuário pelo `field.onChange`; o `onChange` do
usuário é engolido (SgMultiSelect, SgMultiSelectChips, SgStepperInput, SgSlider, SgCombobox, SgAutocomplete...).

**Flutter:** o callback do usuário é chamado a cada mudança feita pelo usuário, junto com a gravação no formulário
(`setValue`), esteja o campo ligado ao formulário ou não. Mudar o valor por fora (`setValue`, `reset`, prop `value`)
continua sem chamar `onChange`, igual ao React.

**Como ficou:** a varredura de todos os campos com callback de mudança mostrou que só a família MultiSelect ainda
engolia o callback (`SgMultiSelect`, `SgMultiSelectChips`: `_handleChange` fazia `if (isBound) pushToForm else onChange`).
Agora grava no formulário e chama `onChange`. Já chamavam os dois: SgInputText e derivados (CPF, CNPJ, CPF/CNPJ, e-mail,
telefone, CEP, senha, texto longo, busca), SgInputDate/BirthDate, SgInputNumber/Currency, SgStepperInput, SgInputOTP,
SgToggleSwitch (`checked` não sobrepõe o valor do formulário), SgCheckboxGroup, SgRadioGroup, SgRating, SgSlider,
SgCombobox, SgAutocomplete, SgPickList, SgOrderList, SgPeriodSelector, SgTextEditor (`onChangeHtml`).

**Testes:** `test/widgets/sg_multi_select_test.dart` e `sg_multi_select_chips_test.dart` (antes: "o onChange do usuario NAO
e chamado dentro do formulario (defeito do React reproduzido)", agora esperam a chamada, com comentário citando a decisão).
`test/programmatic/selection_multiselect_test.dart` continua com `skipEventsInForm`: o vetor do React não tem o evento,
o Flutter chama os dois.

### 2026-10-25 - 2. `handleSubmit` e `trigger` rodam também os validadores do próprio componente

**React:** o `handleSubmit` / `trigger` do react-hook-form só executam as `rules` do campo. Os validadores do componente
(CPF, CNPJ, e-mail, telefone, CEP, datas, limite de idade, `validation`...) rodam só no blur; um CPF inválido passava no
envio.

**Flutter:** o envio (`handleSubmit`) e o `trigger` (todos ou por campo) executam também o validador do componente, o
mesmo que o campo roda ao perder o foco. Um CPF inválido não passa: `onInvalid` é chamado e o erro aparece sob o campo.

**Mecanismo (contrato do formulário):**

- `typedef SgFieldValidator = FutureOr<String?> Function(Object? value)`: recebe o valor do formulário e devolve a
  mensagem de erro, ou `null`.
- `SgFormController.registerField(name, {rules, initialValue, validator})`: o `validator` fica ao lado das `rules`.
  `SgFormController.unregisterValidator(name, validator)` o remove (o campo chama no `dispose`; só remove se ainda for o
  mesmo validador, então um campo novo com o mesmo nome não é afetado).
- `trigger`: para cada campo roda primeiro as `rules` (ordem do RHF: required, min/max, maxLength/minLength, pattern,
  validate). O validador do componente só roda se as `rules` passaram, então o erro das `rules` vence. O erro do validador
  tem `type: 'validate'` e a mensagem (i18n) que o campo mostra no blur. `trigger()` sem nomes cobre a união dos campos
  com `rules` e dos campos com validador.
- A mensagem entra em `errors` do formulário, então `resolveFieldError(error, erroDoFormulario, erroInterno)` continua
  valendo e o erro fica visível sem código extra. `required` do componente continua indo para as `rules`
  (`mergeRequiredRule`); nos campos em que o React não repassa `required` ao input interno (CPF, CNPJ, CPF/CNPJ, CEP,
  data de nascimento), o validador do componente também confere o obrigatório, então "obrigatório e vazio" falha no envio.
- Campo desabilitado nunca falha. Campo vazio e não obrigatório não falha (o validador devolve `null`).
  `reset()` limpa os erros e o próximo `trigger` volta a validar.
- Corrigir o valor depois de um envio revalida (já era assim para as `rules`), e agora usa também o validador.

**Quem registra o validador:**

| Componente | Validador |
|---|---|
| SgInputText | `required`, `maxLength`, `minLength`, `minNumberOfWords`, `validation` (+ `formValidator` interno dos derivados) |
| SgInputCPF, SgInputCNPJ, SgInputCPFCNPJ, SgInputPhone, SgInputPostalCode | o `validate` do `SgMaskedInput` (tamanho, dígitos verificadores, `validation`, consulta de rede memorizada quando habilitada) |
| SgInputEmail | formato, domínios bloqueados, `validation` |
| SgInputPassword | requisitos de senha, senha comum, `validation` |
| SgInputTextArea | `required`, limites, palavras, linhas, `validation` |
| SgInputTextSearch | herdado do SgInputText |
| SgInputDate | data válida (inclusive data impossível setada por código), `minDate`/`maxDate`, `validation` |
| SgInputBirthDate | os de SgInputDate mais `minAge`/`maxAge` |
| SgInputNumber, SgInputCurrency | `required`, `minValue`, `maxValue`, `validation` |
| SgToggleSwitch | `required`, `validation` |
| SgInputOTP | `required`, `validation(raw, masked)` |

Os demais campos de escolha só têm `required`, que já vai para as `rules`; não precisaram de validador próprio.

**Testes:** `test/form/sg_form_component_validators_test.dart` (para cada tipo: inválido => `onInvalid` + erro visível,
válido => `onValid`, `trigger` por campo, desabilitado, vazio opcional x obrigatório, `reset`, `rules` vencem; mais o
contrato `registerField(validator)` / `unregisterValidator`).

**Riscos conhecidos:** com `validateWithViaCep` / `validateWithPublicaCnpj` ligados, o envio dispara a consulta de rede
(memorizada pelo último valor) se o campo ainda não foi validado. Validadores assíncronos são aguardados em sequência.
