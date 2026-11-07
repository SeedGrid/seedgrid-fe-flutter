// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_popup_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgPopupPageSnippets {
  /// Region `sg-popup-acoes`.
  static const String sgPopupAcoes = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      key: _acoesKey,
      label: Text(context.tx('Ações')),
      appearance: SgAppearance.outline,
      onClick: () => _acoes.value = !_acoes.value,
    ),
    const SizedBox(width: 12),
    ValueListenableBuilder<String>(
      valueListenable: _ultima,
      builder: (context, ultima, _) => ultima.isEmpty
          ? const SizedBox()
          : Text('${context.tx('Última ação')}: $ultima'),
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _acoes,
      builder: (context, aberto, _) => SgPopup(
        anchorRef: _acoesKey,
        open: aberto,
        onOpenChange: (open) => _acoes.value = open,
        actions: [
          SgPopupAction(
            label: context.tx('Editar'),
            icon: const Icon(Icons.edit),
            hint: context.tx('Abre o editor'),
            onClick: () => _ultima.value = 'editar',
          ),
          SgPopupAction(
            label: context.tx('Duplicar (não fecha)'),
            icon: const Icon(Icons.copy),
            closeOnClick: false,
            onClick: () => _ultima.value = 'duplicar',
          ),
          SgPopupAction(
            label: context.tx('Indisponível'),
            enabled: false,
          ),
          SgPopupAction(
            label: context.tx('Excluir'),
            icon: const Icon(Icons.delete),
            severity: SgPopupSeverity.danger,
            onClick: () => _ultima.value = 'excluir',
          ),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-popup-basico`.
  static const String sgPopupBasico = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      key: _basicoKey,
      label: Text(context.tx('Abrir popup')),
      onClick: () => _basico.value = !_basico.value,
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _basico,
      builder: (context, aberto, _) => SgPopup(
        anchorRef: _basicoKey,
        open: aberto,
        onOpenChange: (open) => _basico.value = open,
        title: context.tx('Confirma'),
        subtitle: context.tx('Tem certeza que deseja continuar?'),
        placement: SgPopupPlacement.auto,
        preferPlacement: SgPopupPreferPlacement.right,
        align: SgPopupAlign.start,
        actions: [
          SgPopupAction(label: context.tx('Sim')),
          SgPopupAction(label: context.tx('Não')),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-popup-custom`.
  static const String sgPopupCustom = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      key: _customKey,
      label: Text(context.tx('Abrir popup custom')),
      onClick: () => _custom.value = !_custom.value,
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _custom,
      builder: (context, aberto, _) => SgPopup(
        anchorRef: _customKey,
        open: aberto,
        onOpenChange: (open) => _custom.value = open,
        title: context.tx('Configuração'),
        placement: SgPopupPlacement.auto,
        child: SgInputText(
          id: 'popup-modo',
          label: context.tx('Modo'),
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-popup-fechamento`.
  static const String sgPopupFechamento = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      key: _fechaKey,
      label: Text(context.tx('Abrir fixo')),
      onClick: () => _fecha.value = !_fecha.value,
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _fecha,
      builder: (context, aberto, _) => SgPopup(
        anchorRef: _fechaKey,
        open: aberto,
        onOpenChange: (open) => _fecha.value = open,
        closeOnOutsideClick: false,
        closeOnEscape: false,
        title: context.tx('Fixo'),
        actions: [SgPopupAction(label: context.tx('Fechar'))],
      ),
    ),
  ],
)
''';

  /// Region `sg-popup-icone-hint`.
  static const String sgPopupIconeHint = r'''
Wrap(
  spacing: 12,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      key: _iconeKey,
      label: Text(context.tx('Abrir popup com ícone')),
      onClick: () => _icone.value = !_icone.value,
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _icone,
      builder: (context, aberto, _) => SgPopup(
        anchorRef: _iconeKey,
        open: aberto,
        onOpenChange: (open) => _icone.value = open,
        title: context.tx('Confirma'),
        placement: SgPopupPlacement.auto,
        preferPlacement: SgPopupPreferPlacement.right,
        align: SgPopupAlign.start,
        actions: [
          SgPopupAction(
            label: context.tx('Aprovar'),
            hint: context.tx('Confirmar aprovação'),
            icon: const Icon(Icons.check, size: 16),
          ),
          SgPopupAction(
            label: context.tx('Rejeitar'),
            hint: context.tx('Negar a ação'),
            icon: const Icon(Icons.close, size: 16),
          ),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-popup-posicionamento`.
  static const String sgPopupPosicionamento = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ListenableBuilder(
      listenable: Listenable.merge([_placement, _align]),
      builder: (context, _) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final p in SgPopupPlacement.values)
            ChoiceChip(
              label: Text(p.value),
              selected: _placement.value == p,
              onSelected: (_) => _placement.value = p,
            ),
          for (final a in SgPopupAlign.values)
            ChoiceChip(
              label: Text('align ${a.value}'),
              selected: _align.value == a,
              onSelected: (_) => _align.value = a,
            ),
        ],
      ),
    ),
    const SizedBox(height: 12),
    SgButton(
      key: _posKey,
      label: Text(context.tx('Abrir')),
      onClick: () => _pos.value = !_pos.value,
    ),
    ListenableBuilder(
      listenable: Listenable.merge([_pos, _placement, _align]),
      builder: (context, _) => SgPopup(
        anchorRef: _posKey,
        open: _pos.value,
        onOpenChange: (open) => _pos.value = open,
        placement: _placement.value,
        align: _align.value,
        child: Text('${_placement.value.value} / ${_align.value.value}'),
      ),
    ),
  ],
)
''';
}
