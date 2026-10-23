/// Descrição de uma prop pública de um componente, gerada a partir do React
/// (`tools/gen_props`). Alimenta a tabela "Referência de Props" e o playground do showcase.
class SgPropSpec {
  const SgPropSpec({
    required this.name,
    required this.reactName,
    required this.type,
    required this.tsType,
    required this.required,
    this.defaultValue,
    this.description,
    this.values,
    this.exact = true,
  });

  /// Nome no Dart (pode diferir do React: `enabled` → `disabled`, `children` → `child`).
  final String name;

  /// Nome no React.
  final String reactName;

  /// Tipo Dart do contrato.
  final String type;

  /// Tipo no TypeScript.
  final String tsType;
  final bool required;

  /// Padrão do React, como texto, quando o meta o declara.
  final String? defaultValue;
  final String? description;

  /// Valores literais aceitos (enum), como no React.
  final List<String>? values;

  /// `false` quando o tipo Dart do contrato é genérico (função, união, tipo nomeado a portar).
  final bool exact;
}
