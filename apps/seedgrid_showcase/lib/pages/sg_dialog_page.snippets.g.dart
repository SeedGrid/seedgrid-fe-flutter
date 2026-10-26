// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_dialog_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgDialogPageSnippets {
  /// Region `sg-dialog-animacao`.
  static const String sgDialogAnimacao = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final a in SgDialogAnimation.values)
          SgButton(
            label: Text(a.value),
            appearance: SgAppearance.outline,
            size: SgSize.sm,
            onClick: () => setState(() {
              _anim = a;
              _animacao = true;
            }),
          ),
      ],
    ),
    SgDialog(
      open: _animacao,
      onOpenChange: (open) => setState(() => _animacao = open),
      animation: _anim,
      transitionMs: 300,
      autoCloseMs: 3000,
      title: Text('Animação ${_anim.value}'),
      child: const Text(
        'Este diálogo fecha sozinho em 3 segundos.',
      ),
    ),
  ],
)
''';

  /// Region `sg-dialog-basico`.
  static const String sgDialogBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: const Text('Abrir diálogo'),
      onClick: () => setState(() => _basico = true),
    ),
    SgDialog(
      open: _basico,
      onOpenChange: (open) => setState(() => _basico = open),
      title: const Text('Novo cadastro'),
      subtitle: const Text('Preencha os dados abaixo'),
      footer: SgButton(
        label: const Text('Salvar'),
        onClick: () => setState(() => _basico = false),
      ),
      child: const Text('O conteúdo do diálogo fica aqui.'),
    ),
  ],
)
''';

  /// Region `sg-dialog-cores`.
  static const String sgDialogCores = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: const Text('Abrir diálogo escuro'),
      onClick: () => setState(() => _cores = true),
    ),
    SgDialog(
      open: _cores,
      onOpenChange: (open) => setState(() => _cores = open),
      customColor: '#101820',
      elevation: 'lg',
      title: const Text('Modo escuro'),
      subtitle: const Text('Paleta derivada da cor de fundo'),
      child: const Text('Texto claro sobre fundo escuro.'),
    ),
  ],
)
''';

  /// Region `sg-dialog-fechamento`.
  static const String sgDialogFechamento = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: const Text('Abrir diálogo obrigatório'),
      onClick: () => setState(() => _fechamento = true),
    ),
    SgDialog(
      open: _fechamento,
      onOpenChange: (open) => setState(() => _fechamento = open),
      closeable: false,
      closeOnEsc: false,
      closeOnOverlayClick: false,
      title: const Text('Atenção'),
      footer: SgButton(
        label: const Text('Entendi'),
        onClick: () => setState(() => _fechamento = false),
      ),
      child: const Text('É preciso confirmar para continuar.'),
    ),
  ],
)
''';

  /// Region `sg-dialog-severidade`.
  static const String sgDialogSeveridade = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in SgDialogSeverity.values)
          SgButton(
            label: Text(s.value),
            appearance: SgAppearance.outline,
            size: SgSize.sm,
            onClick: () => setState(() {
              _sev = s;
              _severidade = true;
            }),
          ),
      ],
    ),
    SgDialog(
      open: _severidade,
      onOpenChange: (open) => setState(() => _severidade = open),
      severity: _sev,
      size: SgDialogSize.sm,
      title: Text('Severidade ${_sev.value}'),
      child: Text(
        'Faixa do topo: ${switch (_sev) {
          SgDialogSeverity.primary => '--primary',
          SgDialogSeverity.secondary || SgDialogSeverity.info || SgDialogSeverity.help => '--secondary',
          SgDialogSeverity.success => '--tertiary',
          SgDialogSeverity.warning => '--accent',
          SgDialogSeverity.danger => '--destructive',
          SgDialogSeverity.plain => '--border',
        }}. Tamanho sm (largura máxima de 384).',
      ),
    ),
  ],
)
''';
}
