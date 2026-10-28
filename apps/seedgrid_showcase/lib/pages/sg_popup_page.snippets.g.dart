// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_popup_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgPopupPageSnippets {
  /// Region `sg-popup-acoes`.
  static const String sgPopupAcoes = r'''
Row(
  children: [
    SgButton(
      key: _acoesKey,
      label: Text(context.tx('Ações')),
      appearance: SgAppearance.outline,
      onClick: () => setState(() => _acoes = !_acoes),
    ),
    const SizedBox(width: 12),
    if (_ultima.isNotEmpty) Text('Última ação: $_ultima'),
    SgPopup(
      anchorRef: _acoesKey,
      open: _acoes,
      onOpenChange: (open) => setState(() => _acoes = open),
      actions: [
        SgPopupAction(
          label: context.tx('Editar'),
          icon: const Icon(Icons.edit),
          hint: context.tx('Abre o editor'),
          onClick: () => setState(() => _ultima = 'editar'),
        ),
        SgPopupAction(
          label: context.tx('Duplicar (não fecha)'),
          icon: const Icon(Icons.copy),
          closeOnClick: false,
          onClick: () => setState(() => _ultima = 'duplicar'),
        ),
        SgPopupAction(
          label: context.tx('Indisponível'),
          disabled: true,
        ),
        SgPopupAction(
          label: context.tx('Excluir'),
          icon: const Icon(Icons.delete),
          severity: SgPopupSeverity.danger,
          onClick: () => setState(() => _ultima = 'excluir'),
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-popup-basico`.
  static const String sgPopupBasico = r'''
Row(
  children: [
    SgButton(
      key: _basicoKey,
      label: Text(context.tx('Abrir popup')),
      onClick: () => setState(() => _basico = !_basico),
    ),
    SgPopup(
      anchorRef: _basicoKey,
      open: _basico,
      onOpenChange: (open) => setState(() => _basico = open),
      title: context.tx('Perfil'),
      subtitle: context.tx('Conta pessoal'),
      child: Text(context.tx('Conteúdo livre do popup.')),
    ),
  ],
)
''';

  /// Region `sg-popup-fechamento`.
  static const String sgPopupFechamento = r'''
Row(
  children: [
    SgButton(
      key: _fechaKey,
      label: Text(context.tx('Abrir fixo')),
      onClick: () => setState(() => _fecha = !_fecha),
    ),
    SgPopup(
      anchorRef: _fechaKey,
      open: _fecha,
      onOpenChange: (open) => setState(() => _fecha = open),
      closeOnOutsideClick: false,
      closeOnEscape: false,
      title: context.tx('Fixo'),
      actions: [SgPopupAction(label: context.tx('Fechar'))],
    ),
  ],
)
''';

  /// Region `sg-popup-posicionamento`.
  static const String sgPopupPosicionamento = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final p in SgPopupPlacement.values)
          ChoiceChip(
            label: Text(p.value),
            selected: _placement == p,
            onSelected: (_) => setState(() => _placement = p),
          ),
        for (final a in SgPopupAlign.values)
          ChoiceChip(
            label: Text('align ${a.value}'),
            selected: _align == a,
            onSelected: (_) => setState(() => _align = a),
          ),
      ],
    ),
    const SizedBox(height: 12),
    SgButton(
      key: _posKey,
      label: Text(context.tx('Abrir')),
      onClick: () => setState(() => _pos = !_pos),
    ),
    SgPopup(
      anchorRef: _posKey,
      open: _pos,
      onOpenChange: (open) => setState(() => _pos = open),
      placement: _placement,
      align: _align,
      child: Text('${_placement.value} / ${_align.value}'),
    ),
  ],
)
''';
}
