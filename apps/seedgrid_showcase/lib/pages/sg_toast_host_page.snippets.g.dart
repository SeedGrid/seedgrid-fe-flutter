// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_toast_host_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgToastHostPageSnippets {
  /// Region `sg-toast-host-basico`.
  static const String sgToastHostBasico = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(
      label: const Text('Sucesso'),
      severity: SgSeverity.success,
      onClick: () => toast.success('Salvo pelo host'),
    ),
    SgButton(
      label: const Text('Erro'),
      severity: SgSeverity.danger,
      onClick: () => toast.error('Falhou pelo host'),
    ),
    SgButton(
      label: const Text('Limpar'),
      appearance: SgAppearance.ghost,
      onClick: toast.dismiss,
    ),
  ],
)
''';

  /// Region `sg-toast-host-prevalece`.
  static const String sgToastHostPrevalece = r'''
SizedBox(
  height: 120,
  child: Stack(
    children: [
      const SgToaster(position: SgToasterPosition.bottomLeft),
      Align(
        alignment: Alignment.center,
        child: SgButton(
          label: const Text('Disparar'),
          onClick: () => toast('Só aparece no host'),
        ),
      ),
    ],
  ),
)
''';

  /// Region `sg-toast-host-props`.
  static const String sgToastHostProps = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    FilterChip(
      label: const Text('richColors'),
      selected: _rich,
      onSelected: (v) => setState(() => _rich = v),
    ),
    SgButton(
      label: const Text('Disparar'),
      onClick: () => toast.warning(
        'Cores do host',
        const SgToastOptions(duration: 3000),
      ),
    ),
  ],
)
''';

  /// Region `sg-toast-host-varios`.
  static const String sgToastHostVarios = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    FilterChip(
      label: const Text('Segundo host'),
      selected: _extraHost,
      onSelected: (v) => setState(() => _extraHost = v),
    ),
    SgButton(
      label: const Text('Disparar'),
      onClick: () => toast.info(
        'Quem está ativo?',
        const SgToastOptions(duration: 3000),
      ),
    ),
  ],
)
''';
}
