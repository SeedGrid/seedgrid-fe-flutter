# Paridade das props de validação (React x Flutter)

Gerado por `node tools/parity_table/validacao.mjs`; não edite à mão. Fonte do React: `tools/gen_props/props-spec.json`. Fonte do Flutter: a interface gerada `SgXxxProps` (o widget `implements` a interface, então o compilador garante nome e tipo) e os padrões do construtor do widget.

Situação: **igual** = mesmo nome, tipo e padrão; **omitida** = prop do React sem par no Flutter (motivo em `tools/gen_props/excecoes.json`); **só Flutter** = prop do Flutter sem par no React.
Resumo: 337 props de validação no React; 305 iguais, 32 omitidas (justificadas), 0 com padrão diferente, 0 faltando; 0 só no Flutter.


## SgAutocomplete

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `maxResult` | `number | undefined` | "50" | `num?` | 50 | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthForSearch` | `number | undefined` | "2" | `num?` | 2 | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | - | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgCheckboxGroup

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | "true" | `bool?` | true | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | false | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgCombobox

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | - | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgFileUpload

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | true | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxSizePerFile` | `SizeLimit | undefined` | - | `Object?` | - | igual |
| `maxSizeTotal` | `SizeLimit | undefined` | - | `Object?` | - | igual |
| `required` | `boolean | undefined` | - | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgImageUpload

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | true | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxSizePerFile` | `SizeLimit | undefined` | - | `Object?` | - | igual |
| `maxSizeTotal` | `SizeLimit | undefined` | - | `Object?` | - | igual |
| `required` | `boolean | undefined` | - | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgInputBirthDate

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxAge` | `number | undefined` | - | `num?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minAge` | `number | undefined` | - | `num?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `(((message: string | null) => void) & ((message: string | null) => void)) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgInputCNPJ

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `invalidMessage` | `string | undefined` | - | `String?` | - | igual |
| `lengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `(((message: string | null) => void) & ((message: string | null) => void)) | undefined` | - | `Function?` | - | igual |
| `publicaCnpjErrorMessage` | `string | undefined` | - | `String?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | true | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `validation` | `(((value: string) => string | null) & ((value: string) => string | null)) | undefined` | - | `Function?` | - | igual |

## SgInputCPF

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `invalidMessage` | `string | undefined` | - | `String?` | - | igual |
| `lengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `(((message: string | null) => void) & ((message: string | null) => void)) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | true | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `validation` | `(((value: string) => string | null) & ((value: string) => string | null)) | undefined` | - | `Function?` | - | igual |

## SgInputCPFCNPJ

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `invalidMessage` | `string | undefined` | - | `String?` | - | igual |
| `lengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `(((message: string | null) => void) & ((message: string | null) => void)) | undefined` | - | `Function?` | - | igual |
| `publicaCnpjErrorMessage` | `string | undefined` | - | `String?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | true | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `validation` | `(((value: string) => string | null) & ((value: string) => string | null)) | undefined` | - | `Function?` | - | igual |

## SgInputCurrency

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxValueMessage` | `string | undefined` | - | `String?` | - | igual |
| `minValueMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgInputDate

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgInputDateTime

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `minuteStep` | `number | undefined` | - | `num?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgInputEmail

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `invalidMessage` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `(((message: string | null) => void) & ((message: string | null) => void)) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | true | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `validation` | `(((value: string) => string | null) & ((value: string) => string | null)) | undefined` | - | `Function?` | - | igual |

## SgInputNumber

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxValueMessage` | `string | undefined` | - | `String?` | - | igual |
| `minValueMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgInputOTP

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | "true" | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | true | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `validation` | `((rawValue: string, maskedValue: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgInputPassword

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `commonPasswordMessage` | `string | undefined` | - | `String?` | - | igual |
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `minSize` | `number | undefined` | 8 | `num?` | 8 | igual |
| `onValidation` | `(((message: string | null) => void) & ((message: string | null) => void)) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgInputPhone

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `invalidMessage` | `string | undefined` | - | `String?` | - | igual |
| `lengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `(((message: string | null) => void) & ((message: string | null) => void)) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | true | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `validation` | `(((value: string) => string | null) & ((value: string) => string | null)) | undefined` | - | `Function?` | - | igual |

## SgInputPostalCode

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `invalidMessage` | `string | undefined` | - | `String?` | - | igual |
| `lengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `(((message: string | null) => void) & ((message: string | null) => void)) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `(((value: string) => string | null) & ((value: string) => string | null)) | undefined` | - | `Function?` | - | igual |
| `viaCepErrorMessage` | `string | undefined` | - | `String?` | - | igual |

## SgInputText

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgInputTextArea

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLinesMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgInputTextSearch

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxLength` | `number | undefined` | - | `num?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minChars` | `number | undefined` | 3 | `num?` | 3 | igual |
| `minLength` | `number | undefined` | - | `num?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | - | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgMultiSelect

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `maxLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minLengthMessage` | `string | undefined` | - | `String?` | - | igual |
| `minNumberOfWords` | `number | undefined` | - | `num?` | - | igual |
| `minNumberOfWordsMessage` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((value: string) => string | null) | undefined` | - | `Function?` | - | igual |

## SgMultiSelectChips

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgOrderList

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `emptyMessage` | `string | undefined` | - | `String?` | - | igual |
| `enabled` | `boolean | undefined` | true | `bool?` | true | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgPeriodSelector

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | "true" | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `required` | `boolean | undefined` | - | `bool?` | - | igual |
| `rules` | `RegisterOptions | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgPickList

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `emptyMessage` | `string | undefined` | - | `String?` | - | igual |
| `enabled` | `boolean | undefined` | true | `bool?` | true | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgRadioGroup

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | "true" | `bool?` | true | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `required` | `boolean | undefined` | false | `bool?` | false | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgRating

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | true | `bool?` | true | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `required` | `boolean | undefined` | "false" | `bool?` | false | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgSlider

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | true | `bool?` | true | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgStepperInput

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | true | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgTextEditor

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | "true" | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |

## SgToggleSwitch

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | - | `bool?` | - | igual |
| `error` | `string | undefined` | - | `String?` | - | igual |
| `onValidation` | `((message: string | null) => void) | undefined` | - | `Function?` | - | igual |
| `required` | `boolean | undefined` | - | `bool?` | - | igual |
| `requiredMessage` | `string | undefined` | - | `String?` | - | igual |
| `rules` | `RegisterOptions<any> | undefined` | - | - | - | omitida: nao aplicavel: a validacao do Flutter usa as props diretas (required, requiredMessage, minLength, validation...); o React repassa `rules` do react-hook-form |
| `validateOnBlur` | `boolean | undefined` | - | `bool?` | - | igual |
| `validation` | `((checked: boolean) => string | null) | undefined` | - | `Function?` | - | igual |

## SgYearPartSelector

| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |
|---|---|---|---|---|---|
| `enabled` | `boolean | undefined` | true | `bool?` | - | igual (nulo aplica o padrão do React no código) |
| `maxYear` | `number | undefined` | "ano corrente + 10" | `num?` | - | igual (nulo aplica o padrão do React no código) |
| `minYear` | `number | undefined` | "ano corrente - 30" | `num?` | - | igual (nulo aplica o padrão do React no código) |
| `required` | `boolean | undefined` | false | `bool?` | - | igual |

