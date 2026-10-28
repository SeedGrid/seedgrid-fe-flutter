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
      child: Text(
        context.tx('Este diálogo fecha sozinho em 3 segundos.'),
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
      label: Text(context.tx('Abrir diálogo')),
      onClick: () => setState(() => _basico = true),
    ),
    SgDialog(
      open: _basico,
      onOpenChange: (open) => setState(() => _basico = open),
      title: Text(context.tx('Novo cadastro')),
      subtitle: Text(context.tx('Preencha os dados abaixo')),
      footer: SgButton(
        label: Text(context.tx('Salvar')),
        onClick: () => setState(() => _basico = false),
      ),
      child: Text(context.tx('O conteúdo do diálogo fica aqui.')),
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
      label: Text(context.tx('Abrir diálogo escuro')),
      onClick: () => setState(() => _cores = true),
    ),
    SgDialog(
      open: _cores,
      onOpenChange: (open) => setState(() => _cores = open),
      customColor: '#101820',
      elevation: 'lg',
      title: Text(context.tx('Modo escuro')),
      subtitle: Text(context.tx('Paleta derivada da cor de fundo')),
      child: Text(context.tx('Texto claro sobre fundo escuro.')),
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
      label: Text(context.tx('Abrir diálogo obrigatório')),
      onClick: () => setState(() => _fechamento = true),
    ),
    SgDialog(
      open: _fechamento,
      onOpenChange: (open) => setState(() => _fechamento = open),
      closeable: false,
      closeOnEsc: false,
      closeOnOverlayClick: false,
      title: Text(context.tx('Atenção')),
      footer: SgButton(
        label: Text(context.tx('Entendi')),
        onClick: () => setState(() => _fechamento = false),
      ),
      child: Text(
        context.tx('É preciso confirmar para continuar.'),
      ),
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
        for (final s in SgSeverity.values)
          SgButton(
            label: Text(s.value),
            severity: s,
            onClick: () => setState(() {
              _sev = SgDialogSeverity.fromValue(s.value)!;
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
      footer: SgButton(
        label: Text(context.tx('Confirmar')),
        severity:
            SgSeverity.fromValue(_sev.value) ?? SgSeverity.primary,
        onClick: () => setState(() => _severidade = false),
      ),
      child: Text(
        context.tx(
          'O fundo e a faixa do topo seguem a severidade escolhida.',
        ),
      ),
    ),
  ],
)
''';
}
