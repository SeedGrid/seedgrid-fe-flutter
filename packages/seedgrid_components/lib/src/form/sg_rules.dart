// Regras de validacao de campo. Equivale ao `RegisterOptions` do react-hook-form usado pelos
// componentes SeedGrid (ADR 49): required, min, max, minLength, maxLength, pattern, validate.
import 'dart:async';

/// Valor de regra com mensagem, equivalente a `{ value, message }` do RHF.
class SgRuleValue<T> {
  const SgRuleValue(this.value, [this.message]);
  final T value;
  final String? message;
}

/// Falha de validacao de um campo. `type` usa os mesmos nomes do RHF (`required`, `min`, `max`,
/// `minLength`, `maxLength`, `pattern`, `validate`). `message` pode vir vazio, como no RHF.
class SgFieldError {
  const SgFieldError(this.type, [this.message = '']);
  final String type;
  final String message;
}

/// `validate` do RHF: devolve `true`/`null` (ok), `false` (invalido sem mensagem) ou texto (mensagem).
typedef SgValidate = FutureOr<Object?> Function(Object? value);

/// Regras de um campo. Cada campo aceita o valor puro ou `SgRuleValue` com mensagem:
/// `SgRules(required: 'Informe o nome', maxLength: SgRuleValue(10, 'Muito longo'))`.
/// `required` aceita `true` ou o texto da mensagem.
class SgRules {
  const SgRules({
    this.required,
    this.min,
    this.max,
    this.minLength,
    this.maxLength,
    this.pattern,
    this.validate,
  });

  final Object? required;
  final Object? min;
  final Object? max;
  final Object? minLength;
  final Object? maxLength;
  final Object? pattern;
  final SgValidate? validate;

  SgRules copyWith({Object? required, SgValidate? validate}) => SgRules(
    required: required ?? this.required,
    min: min,
    max: max,
    minLength: minLength,
    maxLength: maxLength,
    pattern: pattern,
    validate: validate ?? this.validate,
  );
}

/// Equivale a `mergeRequiredRule` do React: a prop `required` do componente vira a regra
/// `required` com [message], sem sobrescrever uma regra `required` que ja exista.
SgRules? mergeRequiredRule(SgRules? rules, bool? required, String message) {
  if (required != true) return rules;
  if (rules == null) return SgRules(required: message);
  final r = rules.required;
  if (r == null || r == false) return rules.copyWith(required: message);
  return rules;
}

/// Equivale a `resolveFieldError`: a primeira mensagem nao vazia.
String? resolveFieldError(String? a, [String? b, String? c]) {
  for (final e in [a, b, c]) {
    if (e != null && e.trim().isNotEmpty) return e;
  }
  return null;
}

(T, String?) _unwrap<T>(Object? raw) =>
    raw is SgRuleValue ? (raw.value as T, raw.message) : (raw as T, null);

bool _isEmpty(Object? v) =>
    v == null || v == '' || v == false || (v is Iterable && v.isEmpty);

/// Valida [value] contra [rules]. Ordem do RHF: required, min/max, maxLength/minLength, pattern,
/// validate. Devolve `null` se valido.
Future<SgFieldError?> validateRules(SgRules rules, Object? value) async {
  final req = rules.required;
  if (req != null && req != false && _isEmpty(value)) {
    return SgFieldError('required', req is String ? req : '');
  }
  // min/max/minLength/maxLength/pattern so rodam com valor preenchido; `validate` roda sempre (como no RHF).
  if (_isEmpty(value)) return _runValidate(rules, value);

  if (rules.min != null || rules.max != null) {
    final n = value is num ? value : num.tryParse('$value');
    if (n != null) {
      if (rules.min != null) {
        final (v, m) = _unwrap<num>(rules.min);
        if (n < v) return SgFieldError('min', m ?? '');
      }
      if (rules.max != null) {
        final (v, m) = _unwrap<num>(rules.max);
        if (n > v) return SgFieldError('max', m ?? '');
      }
    }
  }
  final len = value is String
      ? value.length
      : (value is Iterable ? value.length : null);
  if (len != null) {
    if (rules.maxLength != null) {
      final (v, m) = _unwrap<num>(rules.maxLength);
      if (len > v) return SgFieldError('maxLength', m ?? '');
    }
    if (rules.minLength != null) {
      final (v, m) = _unwrap<num>(rules.minLength);
      if (len < v) return SgFieldError('minLength', m ?? '');
    }
  }
  if (rules.pattern != null && value is String) {
    final (RegExp re, String? m) = _unwrap<RegExp>(rules.pattern);
    if (!re.hasMatch(value)) return SgFieldError('pattern', m ?? '');
  }
  return _runValidate(rules, value);
}

Future<SgFieldError?> _runValidate(SgRules rules, Object? value) async {
  if (rules.validate == null) return null;
  final r = await rules.validate!(value);
  if (r is String && r.isNotEmpty) return SgFieldError('validate', r);
  if (r == false) return const SgFieldError('validate');
  return null;
}
