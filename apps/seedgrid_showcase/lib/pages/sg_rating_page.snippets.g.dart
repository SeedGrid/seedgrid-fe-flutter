// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_rating_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgRatingPageSnippets {
  /// Region `sg-rating-basico`.
  static const String sgRatingBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRating(
      id: 'basico',
      label: 'Sua avaliação',
      value: 3,
      onChange: (v) => setState(() => _nota = v),
      onHover: (v) => setState(() => _hover = v),
    ),
    Text(
      'Nota: $_nota${_hover == null ? '' : ' (passando: $_hover)'}',
    ),
  ],
)
''';

  /// Region `sg-rating-formulario`.
  static const String sgRatingFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRating(
      id: 'form',
      name: 'nota',
      control: _form,
      label: 'Nota do atendimento',
      required: true,
    ),
    const SizedBox(height: 12),
    SgButton(
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '${values['nota']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-rating-meia`.
  static const String sgRatingMeia = r'''
const SgRating(
  id: 'meia',
  allowHalf: true,
  showTooltip: true,
  cancel: false,
  value: 2.5,
)
''';

  /// Region `sg-rating-visual`.
  static const String sgRatingVisual = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRating(
      id: 'sm',
      size: SgRatingSize.sm,
      cancel: false,
      value: 4,
    ),
    SizedBox(height: 8),
    SgRating(
      id: 'xl',
      size: SgRatingSize.xl,
      cancel: false,
      value: 2,
    ),
    SizedBox(height: 8),
    SgRating(
      id: 'cores',
      color: '#E11D48',
      emptyColor: '#9CA3AF',
      cancel: false,
      value: 3,
    ),
    SizedBox(height: 8),
    SgRating(
      id: 'icones',
      stars: 3,
      cancel: false,
      value: 2,
      onIcon: Icon(Icons.favorite, color: Colors.red),
      offIcon: Icon(Icons.favorite_border, color: Colors.grey),
    ),
  ],
)
''';
}
