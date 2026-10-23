// Mensagens traduzidas dos validadores de seedgrid_commons. No TypeScript, validatePassword e
// validateBirthDate ja devolvem o texto; aqui o texto sai do i18n a partir do resultado.

import 'package:seedgrid_commons/seedgrid_commons.dart';

import 'i18n.dart';

/// Equivale ao retorno de `validatePassword(value, policy, i18n)`: `null` se valida.
String? passwordValidationMessage(
  PasswordValidation result, [
  SgComponentsI18n? i18n,
]) {
  final resolved = i18n ?? getComponentsI18n();
  if (result.ok) return null;
  if (result.problems.length == 1 &&
      result.problems.first == PasswordProblem.empty) {
    return t(resolved, 'components.validators.password.empty');
  }
  final reasons = result.problems
      .map(
        (p) => t(
          resolved,
          'components.validators.password.${p.name}',
          p == PasswordProblem.minSize ? {'min': result.minSize} : null,
        ),
      )
      .join('; ');
  return t(resolved, 'components.validators.password.invalid', {
    'reasons': reasons,
  });
}

/// Atalho: valida e traduz de uma vez (igual a chamar `validatePassword` do React).
String? validatePasswordMessage(
  String value, [
  PasswordPolicy policy = const PasswordPolicy(),
  SgComponentsI18n? i18n,
]) => passwordValidationMessage(validatePassword(value, policy), i18n);

/// Equivale ao retorno de `validateBirthDate(value, policy, i18n)`: `null` se valida.
String? birthDateValidationMessage(
  BirthDateValidation result, [
  SgComponentsI18n? i18n,
]) {
  final resolved = i18n ?? getComponentsI18n();
  final problem = result.problem;
  if (problem == null) return null;
  final params = <String, Object?>{
    if (result.min != null) 'min': result.min,
    if (result.max != null) 'max': result.max,
  };
  return t(
    resolved,
    'components.validators.birthdate.${problem.name}',
    params.isEmpty ? null : params,
  );
}

String? validateBirthDateMessage(
  String value,
  BirthDatePolicy policy, {
  SgComponentsI18n? i18n,
  DateTime? today,
}) => birthDateValidationMessage(
  validateBirthDate(value, policy, today: today),
  i18n,
);
