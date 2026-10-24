# Valor programático: campos de texto, máscara, data e número

Escopo: SgInputText, SgInputEmail, SgInputPassword, SgInputTextArea, SgInputTextSearch, SgInputCPF, SgInputCNPJ,
SgInputCPFCNPJ, SgInputPhone, SgInputPostalCode, SgInputBirthDate, SgInputDate, SgInputNumber, SgInputCurrency e
SgStepperInput. (Seleção e escolha: ver `VALOR_PROGRAMATICO_SELECAO.md`.)

Pergunta que os testes respondem: setar um valor por código (ou carregar dados salvos) funciona em todos os campos, sem
quebrar a máscara, a validação nem carregar valor errado?

## Como os testes funcionam

- `packages/seedgrid_components/test/programmatic/vectors/scenarios.mjs` descreve os cenários (valor x variante x
  bateria de ações) em JSON neutro.
- `vectors/generate.mjs` executa cada cenário no componente React REAL (esbuild + jsdom + react-dom + react-hook-form) e grava
  `vectors/{text,br,date,number}.json` (display, erro visível, emitido por onChange, onValidation, valor e erro do form).
- `text_/br_/date_/number_programmatic_test.dart` repetem os mesmos passos no widget Dart e comparam passo a passo.
  Onde o React é defeituoso, um oráculo por grupo (`Rules`) diz o que o Dart deve fazer. Os desvios estão listados abaixo.
- `extras_programmatic_test.dart`: casos escritos à mão (CNPJ alfanumérico, CPF/CNPJ trocando, DDI, valor maior que a máscara,
  erro velho, limite de caracteres, foco, disabled).

Regerar os vetores (a partir da raiz do repo Flutter):

```
node packages/seedgrid_components/test/programmatic/vectors/generate.mjs <caminho>/seedgrid-fe-components/packages/seedgrid-fe-components [grupo]
flutter test test/programmatic   # dentro de packages/seedgrid_components
```

Variável `PROG_OUT=<arquivo>` grava o relatório completo de divergências.

Baterias por valor: `init` (valor inicial), `valor` (prop `value` controlada, inclusive mesmo valor/vazio), `form-default`
(defaultValues), `form-set` (setValue/reset/trigger), `form-valida` (shouldValidate), `foco` (setar com o campo focado e digitar),
`disabled`, mais sequências (`valor-seq`, `form-seq`, `form-rules`, `limpar`).

## Matriz (componente x via)

Legenda: OK = igual ao React; OK* = igual ao React com a decisão registrada abaixo; n/a = a via não existe no componente.

| Componente | a inicial | b `value` | c name+control | d setValue (formatado/cru/lixo) | e onChange/getValue | f validação | g foco+digitar | h disabled |
|---|---|---|---|---|---|---|---|---|
| SgInputText | OK | OK | OK | OK | OK | OK | OK | OK |
| SgInputEmail | OK | OK | OK | OK* (trim, D7) | OK | OK | OK | OK |
| SgInputPassword | OK | OK | OK | OK | OK | OK | OK | OK |
| SgInputTextArea | OK | OK | OK | OK* (CRLF, D8) | OK | OK | OK* (D9) | OK |
| SgInputTextSearch | OK | n/a (React ignora `value`) | OK | OK | OK | OK | OK | OK |
| SgInputCPF | OK* (D1) | OK* | OK | OK* (D1, D4) | OK* (D2) | OK* (D5) | OK | OK |
| SgInputCNPJ (alfanumérico) | OK* | OK* | OK | OK* | OK* | OK* | OK | OK |
| SgInputCPFCNPJ | OK* | OK* | OK | OK* (troca CPF<->CNPJ) | OK* | OK* | OK | OK |
| SgInputPhone | OK* (D6) | OK* | OK | OK* (D6) | OK* | OK* | OK | OK |
| SgInputPostalCode | OK* | OK* | OK | OK* | OK* | OK* | OK | OK |
| SgInputDate | OK* (D10) | OK* | OK | OK* (ISO, ISO com hora, dd/MM/yyyy) | OK | OK | OK | OK |
| SgInputBirthDate | OK* | OK* | OK | OK* | OK | OK (minAge/maxAge) | OK | OK |
| SgInputNumber | OK | OK | OK | OK* (D11) | OK | OK | OK | OK |
| SgInputCurrency | OK | OK | OK | OK* (D11) | OK | OK | OK | OK |
| SgStepperInput | OK | OK | OK | OK* (D12) | OK* (D12) | OK | OK | OK |

Totais (cenários comparados com o React): texto 395, máscaras BR 558, datas 232, números 632, mais 11 casos manuais.

## Decisões

- D1. O campo sempre mostra o valor mascarado, venha de onde vier (inicial, `value`, setValue, reset). O React mostra o valor
  cru de `initialValue`/`defaultValues` (`'12345678909'` aparece sem pontos até o usuário digitar). O teste antigo
  "initialValue aparece como está" (`test/widgets/masked_support.dart`) foi alterado de propósito para
  "initialValue sem máscara aparece mascarado".
- D2. O formulário guarda o valor como foi setado (cru ou formatado), exatamente como o React; depois de digitar, guarda o texto
  mascarado que `onChange` entregou. `onChange` não dispara em setValue/reset/`value` (igual ao React).
- D3. CNPJ alfanumérico (`12.ABC.345/01DE-35`) é aceito com e sem máscara (o React também aceita).
- D4. Valor maior que a máscara (ou com lixo) é exibido cortado/limpo pela máscara, mas a validação (no blur) olha o texto cru
  setado: o erro de tamanho aparece em vez de um valor "consertado" silenciosamente.
- D5. Erro velho: se há erro visível quando o valor muda por fora, ele é revalidado para o valor novo (some se agora é válido);
  `reset` limpa o erro. No React o erro antigo fica na tela até o próximo blur.
- D6. Telefone: `+5511987654321` / `5511987654321` (12 ou 13 dígitos começando com 55) perde o DDI na tela
  (`(11) 98765-4321`). O React corta os primeiros 11 dígitos e mostra um número errado. `onChange`/form não mudam.
- D7. E-mail: espaços e quebras de linha das pontas são removidos ao receber valor por fora (o `<input type=email>` do navegador
  faz o mesmo).
- D8. Textarea: `\r\n` vira `\n` ao receber valor por fora (igual ao navegador).
- D9. Limite `maxLength` com semântica de navegador (`SgMaxLengthFormatter`): valor programático já acima do limite não é
  cortado, não perde dados ao digitar/apagar, e só impede crescer. Antes, digitar após um valor maior que o limite truncava o texto
  inteiro (perda de dados) - bug corrigido.
- D10. Data: aceita ISO `yyyy-MM-dd`, ISO com hora (`2020-01-31T10:00:00Z`) e o texto do locale (`31/01/2020`; `01/31/2020` em en-US).
  O React (`<input type=date>`) só entende ISO e mostra vazio para o resto. Data impossível (`2020-02-30`) fica vazia nos dois.
  Campo controlado (`value`) volta ao `value` se o pai não adotar o que foi digitado.
- D11. `reset()` sem valores e `setValue(null/undefined)` em número/moeda: o campo mostra o estado vazio. O React deixa o texto
  anterior na tela com o formulário vazio (inconsistência visual).
- D12. Stepper ligado a formulário também chama `onChange` (o React troca `onChange` por `field.onChange` e o do usuário nunca roda).
  `value` é `num?`: string numérica e vazio são convertidos antes (React: `Number('')` = 0).
- D13. `setValue(undefined)` volta ao default do formulário só no RHF (comportamento da biblioteca); não é modelado.
- D14. Rejeição de tecla com máscara cheia: o Flutter não dispara `onChanged` quando o texto não muda; o React dispara um evento sem
  efeito. Não há diferença observável para o usuário.

## Defeitos do React (só registrados)

1. `initialValue`/`defaultValues` não passam pela máscara (exibe cru).
2. Telefone com DDI mostra número errado.
3. Erro de validação antigo permanece depois de mudar o valor por fora.
4. `reset()` sem valores / `setValue(null)` deixam texto antigo em número e moeda.
5. Stepper em formulário ignora o `onChange` do usuário.
6. `handleSubmit`/`trigger` do RHF não executam os validadores dos próprios componentes (CPF/CNPJ inválido passa no submit);
   o Dart também não os inclui no `trigger`, igual ao React. Quem precisa deve usar `rules.validate`. Pendência possível: ligar os
   validadores ao `trigger`.
7. Datas: `<input type=date>` só entende ISO; qualquer outro formato some, mas o valor do formulário continua o texto setado.
8. Validação de data/idade mínima depende do valor do DOM no blur, então o `value` controlado e o digitado podem divergir.

## Arquivos alterados (lib)

`form/sg_form.dart` (`resetCount`), `inputs/sg_input_text.dart` (`onValueSet`, `onExitText`, `externalValueNormalizer`, valor cru
para validação), `inputs/masked/masked_core.dart`, `masked/*.dart` (prop `value`, DDI, datas), `text/*` (prop `value`,
`SgMaxLengthFormatter`).
