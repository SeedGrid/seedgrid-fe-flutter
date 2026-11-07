// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_confirmation_dialog_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgConfirmationDialogPageSnippets {
  /// Region `sg-confirmation-dialog-basico`.
  static const String sgConfirmationDialogBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: Text(context.tx('Excluir registro')),
      severity: SgSeverity.danger,
      onClick: () => setState(() => _basico = true),
    ),
    if (_resultado.isNotEmpty) Text(_resultado),
    SgConfirmationDialog(
      open: _basico,
      onOpenChange: (open) => setState(() => _basico = open),
      title: Text(context.tx('Excluir registro?')),
      message: Text(context.tx('Esta ação não pode ser desfeita.')),
      onConfirm: () => setState(() => _resultado = 'Confirmado'),
      onCancel: () => setState(() => _resultado = 'Cancelado'),
    ),
  ],
)
''';

  /// Region `sg-confirmation-dialog-botoes`.
  static const String sgConfirmationDialogBotoes = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: Text(context.tx('Sair sem salvar')),
      appearance: SgAppearance.outline,
      onClick: () => setState(() => _botoes = true),
    ),
    SgConfirmationDialog(
      open: _botoes,
      onOpenChange: (open) => setState(() => _botoes = open),
      severity: SgDialogSeverity.danger,
      title: Text(context.tx('Descartar alterações?')),
      message: Text(
        context.tx('As alterações não salvas serão perdidas.'),
      ),
      cancelButton: SgConfirmationDialogButtonConfig(
        label: Text(context.tx('Continuar editando')),
        icon: Icon(Icons.edit),
      ),
      confirmButton: SgConfirmationDialogButtonConfig(
        label: Text(context.tx('Descartar')),
        icon: Icon(Icons.delete),
        appearance: SgAppearance.outline,
      ),
    ),
  ],
)
''';

  /// Region `sg-confirmation-dialog-esquerda`.
  static const String sgConfirmationDialogEsquerda = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: Text(context.tx('Abrir aviso')),
      appearance: SgAppearance.outline,
      onClick: () => setState(() => _esquerda = true),
    ),
    SgConfirmationDialog(
      open: _esquerda,
      onOpenChange: (open) => setState(() => _esquerda = open),
      severity: SgDialogSeverity.warning,
      iconPlacement: SgConfirmationDialogIconPlacement.left,
      icon: const Icon(Icons.warning_amber_rounded, size: 20),
      title: Text(context.tx('Alterações não salvas')),
      message: Text(
        context.tx(
          'Você tem atualizações pendentes. Deseja continuar sem salvar?',
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-confirmation-dialog-icone`.
  static const String sgConfirmationDialogIcone = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: Text(context.tx('Publicar')),
      severity: SgSeverity.success,
      onClick: () => setState(() => _icone = true),
    ),
    SgConfirmationDialog(
      open: _icone,
      onOpenChange: (open) => setState(() => _icone = open),
      severity: SgDialogSeverity.success,
      iconPlacement: SgConfirmationDialogIconPlacement.top,
      icon: const Icon(Icons.rocket_launch, size: 28),
      closeable: true,
      title: Text(context.tx('Publicar agora?')),
      message: Text(
        context.tx('A versão ficará visível para todos.'),
      ),
    ),
  ],
)
''';

  /// Region `sg-confirmation-dialog-severidade`.
  static const String sgConfirmationDialogSeveridade = r'''
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
    SgConfirmationDialog(
      open: _severidade,
      onOpenChange: (open) => setState(() => _severidade = open),
      severity: _sev,
      showSeverityAccent: true,
      title: Text('Severidade ${_sev.value}'),
      message: Text(
        context.tx('Veja o ícone, o fundo e o botão de confirmar.'),
      ),
    ),
  ],
)
''';

  /// Region `sg-confirmation-dialog-superficie`.
  static const String sgConfirmationDialogSuperficie = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: Text(context.tx('Abrir superfície customizada')),
      appearance: SgAppearance.outline,
      onClick: () => setState(() => _superficie = true),
    ),
    SgConfirmationDialog(
      open: _superficie,
      onOpenChange: (open) => setState(() => _superficie = open),
      severity: SgDialogSeverity.danger,
      customColor: '#fff7ed',
      elevation:
          '0 0 0 1px rgba(234, 88, 12, 0.22), 0 24px 56px rgba(234, 88, 12, 0.28)',
      title: Text(context.tx('Excluir registro?')),
      message: Text(context.tx('Esta ação não pode ser desfeita.')),
    ),
  ],
)
''';
}
