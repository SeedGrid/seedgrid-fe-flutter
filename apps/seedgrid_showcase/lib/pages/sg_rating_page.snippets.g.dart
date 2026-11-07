// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_rating_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgRatingPageSnippets {
  /// Region `sg-rating-basico`.
  static const String sgRatingBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x403B82F6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SgRating(
        value: _basico,
        onChange: (v) => setState(() => _basico = v),
      ),
    ),
    const SizedBox(height: 8),
    Text('${context.tx('Valor atual')}: $_basico'),
  ],
)
''';

  /// Region `sg-rating-callbacks`.
  static const String sgRatingCallbacks = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRating(
      label: context.tx('Callbacks'),
      value: _cb,
      allowHalf: true,
      onChange: (v) => setState(() {
        _cb = v;
        _pushLog('onChange -> $v');
      }),
      onHover: (v) => setState(() => _cbHover = v),
    ),
    const SizedBox(height: 12),
    SgGrid(
      columns: const {'base': 2, 'md': 4},
      gap: 8,
      children: [
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Zerar')),
          onClick: () => setState(() => _cb = 0),
        ),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Máximo')),
          onClick: () => setState(() => _cb = 5),
        ),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Limpar log')),
          onClick: () => setState(_cbLog.clear),
        ),
      ],
    ),
    const SizedBox(height: 12),
    Text(
      '${context.tx('Selecionado')}: $_cb | ${context.tx('Hover')}: ${_cbHover ?? context.tx('nenhum')}',
    ),
    const SizedBox(height: 12),
    ShowcaseLogBox(
      entries: _cbLog,
      hint: context.tx('Sem eventos'),
      height: 112,
    ),
  ],
)
''';

  /// Region `sg-rating-cores`.
  static const String sgRatingCores = r'''
SgGrid(
  columns: const {'base': 1, 'md': 2},
  gap: 16,
  children: [
    SgRating(
      label: context.tx('Coração'),
      value: _heart,
      color: '#ec4899',
      emptyColor: '#f9a8d4',
      onIcon: const Icon(Icons.favorite, size: 24),
      offIcon: const Icon(Icons.favorite_border, size: 24),
      onChange: (v) => setState(() => _heart = v),
    ),
    SgRating(
      label: context.tx('Curtidas'),
      value: _like,
      color: '#2563eb',
      emptyColor: '#93c5fd',
      onIcon: const Icon(Icons.thumb_up, size: 24),
      offIcon: const Icon(Icons.thumb_up_outlined, size: 24),
      onChange: (v) => setState(() => _like = v),
    ),
    SgRating(
      label: context.tx('Fogo'),
      value: _fire,
      color: '#f97316',
      emptyColor: '#fdba74',
      onIcon: const Icon(Icons.local_fire_department, size: 24),
      offIcon: const Icon(
        Icons.local_fire_department_outlined,
        size: 24,
      ),
      onChange: (v) => setState(() => _fire = v),
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
      label: context.tx('Avalie o produto'),
      name: 'productRating',
      control: _form,
    ),
    const SizedBox(height: 16),
    SgRating(
      label: context.tx('Avalie o filme'),
      name: 'movieRating',
      control: _form,
      allowHalf: true,
    ),
    const SizedBox(height: 16),
    SgButton(
      size: SgSize.sm,
      label: Text(context.tx('Enviar avaliação')),
      onClick: () => _form.handleSubmit(
        (values) => setState(() => _enviado = '$values'),
      ),
    ),
    const SizedBox(height: 16),
    ListenableBuilder(
      listenable: _form,
      builder: (context, _) => Text(
        'watch.productRating: ${_form.watch('productRating')} | watch.movieRating: ${_form.watch('movieRating')}',
      ),
    ),
    const SizedBox(height: 4),
    Text('${context.tx('Último envio')}: $_enviado'),
  ],
)
''';

  /// Region `sg-rating-meia`.
  static const String sgRatingMeia = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRating(
      label: context.tx(
        'Passe o mouse e clique nas meias estrelas',
      ),
      value: _meia,
      allowHalf: true,
      showTooltip: true,
      onChange: (v) => setState(() => _meia = v),
      onHover: (v) => setState(() => _meiaHover = v),
    ),
    const SizedBox(height: 8),
    Text(
      '${context.tx('Selecionado')}: $_meia | ${context.tx('Hover')}: ${_meiaHover ?? context.tx('nenhum')}',
    ),
  ],
)
''';

  /// Region `sg-rating-obrigatorio`.
  static const String sgRatingObrigatorio = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgRating(
      label: context.tx('Avaliação obrigatória'),
      value: _req,
      required: true,
      requiredMessage: context.tx(
        'Informe uma avaliação antes de continuar',
      ),
      onChange: (v) => setState(() => _req = v),
    ),
    const SizedBox(height: 12),
    SgGrid(
      columns: const {'base': 2, 'md': 4},
      gap: 8,
      children: [
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Limpar')),
          onClick: () => setState(() => _req = 0),
        ),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Nota 1')),
          onClick: () => setState(() => _req = 1),
        ),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Nota 5')),
          onClick: () => setState(() => _req = 5),
        ),
      ],
    ),
    const SizedBox(height: 12),
    Text('${context.tx('Valor atual')}: $_req'),
  ],
)
''';

  /// Region `sg-rating-readonly`.
  static const String sgRatingReadonly = r'''
SgGrid(
  columns: const {'base': 1, 'md': 2},
  gap: 16,
  children: [
    SgRating(
      label: context.tx('Somente leitura'),
      value: 3.5,
      allowHalf: true,
      readOnly: true,
    ),
    SgRating(
      label: context.tx('Desabilitado'),
      value: 2,
      enabled: false,
    ),
  ],
)
''';

  /// Region `sg-rating-tamanhos`.
  static const String sgRatingTamanhos = r'''
SgGrid(
  columns: const {'base': 1, 'md': 2},
  gap: 16,
  children: [
    SgRating(
      label: context.tx('sm / 5 estrelas'),
      size: SgRatingSize.sm,
      value: _sm,
      onChange: (v) => setState(() => _sm = v),
    ),
    SgRating(
      label: context.tx('lg / 5 estrelas'),
      size: SgRatingSize.lg,
      value: _lg,
      onChange: (v) => setState(() => _lg = v),
    ),
    SgRating(
      label: context.tx('10 estrelas'),
      stars: 10,
      size: SgRatingSize.sm,
      value: _many,
      onChange: (v) => setState(() => _many = v),
    ),
  ],
)
''';
}
