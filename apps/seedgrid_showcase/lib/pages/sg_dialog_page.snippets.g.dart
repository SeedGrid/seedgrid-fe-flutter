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
            onClick: () {
              _anim.value = a;
              _animacao.value = true;
            },
          ),
      ],
    ),
    ListenableBuilder(
      listenable: Listenable.merge([_animacao, _anim]),
      builder: (context, _) => SgDialog(
        open: _animacao.value,
        onOpenChange: (v) => _animacao.value = v,
        animation: _anim.value,
        transitionMs: 300,
        title: Text(
          '${context.tx('Animação')} ${_anim.value.value}',
        ),
        child: Text(
          context.tx(
            'A animação define como o diálogo entra e sai.',
          ),
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-dialog-auto`.
  static const String sgDialogAuto = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: Text(context.tx('Abrir auto close')),
      appearance: SgAppearance.outline,
      onClick: () => _auto.value = true,
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _auto,
      builder: (context, open, _) => SgDialog(
        open: open,
        onOpenChange: (v) => _auto.value = v,
        autoCloseMs: 3000,
        title: Text(context.tx('Dialog temporizado')),
        subtitle: Text(context.tx('Este dialog fecha sozinho.')),
        child: Text(context.tx('Apenas uma informação rápida.')),
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
      label: Text(context.tx('Abrir dialog')),
      onClick: () => _basico.value = true,
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _basico,
      builder: (context, open, _) => SgDialog(
        open: open,
        onOpenChange: (v) => _basico.value = v,
        title: Text(context.tx('Confirmar ação')),
        subtitle: Text(
          context.tx('Essa ação não pode ser desfeita.'),
        ),
        customColor: '#fff7ed',
        elevation: 'lg',
        leading: const Text('O'),
        trailing: const Text('ID: 428'),
        footer: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SgButton(
              label: Text(context.tx('Cancelar')),
              appearance: SgAppearance.ghost,
              onClick: () => _basico.value = false,
            ),
            const SizedBox(width: 8),
            SgButton(
              label: Text(context.tx('Confirmar')),
              onClick: () => _basico.value = false,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tx('Tem certeza que deseja continuar?')),
            const SizedBox(height: 8),
            SgInputText(
              id: 'dialog-input',
              hintText: context.tx('Escreva algo...'),
            ),
          ],
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-dialog-estrito`.
  static const String sgDialogEstrito = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: Text(context.tx('Abrir estrito')),
      appearance: SgAppearance.outline,
      onClick: () => _estrito.value = true,
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _estrito,
      builder: (context, open, _) => SgDialog(
        open: open,
        onOpenChange: (v) => _estrito.value = v,
        closeable: false,
        closeOnOverlayClick: false,
        closeOnEsc: false,
        title: Text(context.tx('Dialog estrito')),
        subtitle: Text(context.tx('Não fecha por overlay ou ESC.')),
        footer: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SgButton(
              label: Text(context.tx('Cancelar')),
              appearance: SgAppearance.ghost,
              onClick: () => _estrito.value = false,
            ),
            const SizedBox(width: 8),
            SgButton(
              label: Text(context.tx('Confirmar')),
              onClick: () => _estrito.value = false,
            ),
          ],
        ),
        child: Text(
          context.tx(
            'Use quando o usuário precisa tomar uma decisão.',
          ),
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-dialog-sem-close`.
  static const String sgDialogSemClose = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgButton(
      label: Text(context.tx('Abrir sem close')),
      appearance: SgAppearance.outline,
      onClick: () => _semClose.value = true,
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _semClose,
      builder: (context, open, _) => SgDialog(
        open: open,
        onOpenChange: (v) => _semClose.value = v,
        closeable: false,
        title: Text(context.tx('Dialog sem close')),
        subtitle: Text(
          context.tx('Fechamento apenas pelos botões do footer.'),
        ),
        footer: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SgButton(
              label: Text(context.tx('Cancelar')),
              appearance: SgAppearance.ghost,
              onClick: () => _semClose.value = false,
            ),
            const SizedBox(width: 8),
            SgButton(
              label: Text(context.tx('Confirmar')),
              onClick: () => _semClose.value = false,
            ),
          ],
        ),
        child: Text(
          context.tx(
            'Use esse modo quando quiser forçar uma escolha explícita.',
          ),
        ),
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
            onClick: () {
              _sev.value = s;
              _severidade.value = true;
            },
          ),
      ],
    ),
    ListenableBuilder(
      listenable: Listenable.merge([_severidade, _sev]),
      builder: (context, _) => SgDialog(
        open: _severidade.value,
        onOpenChange: (v) => _severidade.value = v,
        severity: SgDialogSeverity.fromValue(_sev.value.value)!,
        title: Text(
          '${context.tx('Severidade')}: ${_sev.value.value}',
        ),
        footer: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SgButton(
              label: Text(context.tx('Cancelar')),
              appearance: SgAppearance.ghost,
              onClick: () => _severidade.value = false,
            ),
            const SizedBox(width: 8),
            SgButton(
              label: Text(context.tx('Confirmar')),
              severity: _sev.value,
              onClick: () => _severidade.value = false,
            ),
          ],
        ),
        child: Text(
          context.tx(
            'O fundo e a faixa do topo seguem a severidade escolhida.',
          ),
        ),
      ),
    ),
  ],
)
''';
}
