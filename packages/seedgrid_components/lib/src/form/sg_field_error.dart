// Erro de validacao de um campo e helpers de mensagem. A validacao dos campos usa as props diretas de cada
// componente (`required`, `requiredMessage`, `minLength`, `validation`...); nao existe mais um objeto de regras.

/// Falha de validacao de um campo. `type` usa os nomes do RHF (`required`, `validate`, `manual`...).
/// `message` pode vir vazio, como no RHF.
class SgFieldError {
  const SgFieldError(this.type, [this.message = '']);
  final String type;
  final String message;
}

/// Mensagem de obrigatorio a registrar no formulario: [message] quando [required] e `true`, senao `null`.
String? requiredMessageFor(bool? required, String message) =>
    required == true ? message : null;

/// Equivale a `resolveFieldError`: a primeira mensagem nao vazia.
String? resolveFieldError(String? a, [String? b, String? c]) {
  for (final e in [a, b, c]) {
    if (e != null && e.trim().isNotEmpty) return e;
  }
  return null;
}

/// Vazio para fins de `required`: nulo, texto vazio, `false` ou colecao vazia.
bool sgIsEmptyValue(Object? v) =>
    v == null || v == '' || v == false || (v is Iterable && v.isEmpty);
