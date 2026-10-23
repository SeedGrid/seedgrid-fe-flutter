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
      label: const Text('Sucesso'),
      severity: SgSeverity.success,
      onClick: () => sgWhistle.success(
        const SgWhistleOptions(message: 'Salvo pelo host'),
      ),
    ),
    SgButton(
      label: const Text('Erro'),
      severity: SgSeverity.danger,
      onClick: () => sgWhistle.error(
        const SgWhistleOptions(message: 'Falhou pelo host'),
      ),
    ),
    SgButton(
      label: const Text('Limpar'),
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
      label: const Text('Disparar'),
      onClick: () => sgWhistle.info(
        const SgWhistleOptions(message: 'Só aparece no host'),
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
      label: const Text('rounded'),
      selected: _rounded,
      onSelected: (v) => setState(() => _rounded = v),
    ),
    SgButton(
      label: const Text('Disparar'),
      onClick: () => sgWhistle.success(
        const SgWhistleOptions(
          message: 'Cantos do host',
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
      label: const Text('Segundo host (cantos retos)'),
      selected: _extraHost,
      onSelected: (v) => setState(() => _extraHost = v),
    ),
    SgButton(
      label: const Text('Disparar'),
      onClick: () => sgWhistle.warning(
        const SgWhistleOptions(
          message: 'Quem está ativo?',
          duration: 3000,
        ),
      ),
    ),
  ],
)
''';
}
