// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_whistle_host_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgWhistleHostPageSnippets {
  /// Region `sg-whistle-host-basico`.
  static const String sgWhistleHostBasico = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(
      label: Text(context.tx('Sucesso')),
      severity: SgSeverity.success,
      onClick: () => sgWhistle.success(
        SgWhistleOptions(message: context.tx('Salvo pelo host')),
      ),
    ),
    SgButton(
      label: Text(context.tx('Erro')),
      severity: SgSeverity.danger,
      onClick: () => sgWhistle.error(
        SgWhistleOptions(message: context.tx('Falhou pelo host')),
      ),
    ),
    SgButton(
      label: Text(context.tx('Limpar')),
      appearance: SgAppearance.ghost,
      onClick: sgWhistle.dismiss,
    ),
  ],
)
''';

  /// Region `sg-whistle-host-prevalece`.
  static const String sgWhistleHostPrevalece = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SgWhistler(),
    SgButton(
      label: Text(context.tx('Disparar')),
      onClick: () => sgWhistle.info(
        SgWhistleOptions(message: context.tx('Só aparece no host')),
      ),
    ),
  ],
)
''';

  /// Region `sg-whistle-host-props`.
  static const String sgWhistleHostProps = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    FilterChip(
      label: Text(context.tx('rounded')),
      selected: _rounded,
      onSelected: (v) => setState(() => _rounded = v),
    ),
    SgButton(
      label: Text(context.tx('Disparar')),
      onClick: () => sgWhistle.success(
        SgWhistleOptions(
          message: context.tx('Cantos do host'),
          duration: 3000,
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-whistle-host-varios`.
  static const String sgWhistleHostVarios = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    FilterChip(
      label: Text(context.tx('Segundo host (cantos retos)')),
      selected: _extraHost,
      onSelected: (v) => setState(() => _extraHost = v),
    ),
    SgButton(
      label: Text(context.tx('Disparar')),
      onClick: () => sgWhistle.warning(
        SgWhistleOptions(
          message: context.tx('Quem está ativo?'),
          duration: 3000,
        ),
      ),
    ),
  ],
)
''';
}
