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
      child: ValueListenableBuilder<num>(
        valueListenable: _basico,
        builder: (context, valor, _) => SgRating(
          value: valor,
          onChange: (v) => _basico.value = v,
        ),
      ),
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<num>(
      valueListenable: _basico,
      builder: (context, valor, _) =>
          Text('${context.tx('Valor atual')}: $valor'),
    ),
  ],
)
''';

  /// Region `sg-rating-callbacks`.
  static const String sgRatingCallbacks = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ValueListenableBuilder<num>(
      valueListenable: _cb,
      builder: (context, valor, _) => SgRating(
        label: context.tx('Callbacks'),
        value: valor,
        allowHalf: true,
        onChange: (v) {
          _cb.value = v;
          _pushLog('onChange -> $v');
        },
        onHover: (v) => _cbHover.value = v,
      ),
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
          onClick: () => _cb.value = 0,
        ),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Máximo')),
          onClick: () => _cb.value = 5,
        ),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Limpar log')),
          onClick: () => _cbLog.value = [],
        ),
      ],
    ),
    const SizedBox(height: 12),
    ListenableBuilder(
      listenable: Listenable.merge([_cb, _cbHover]),
      builder: (context, _) => Text(
        '${context.tx('Selecionado')}: ${_cb.value} | ${context.tx('Hover')}: ${_cbHover.value ?? context.tx('nenhum')}',
      ),
    ),
    const SizedBox(height: 12),
    ValueListenableBuilder<List<String>>(
      valueListenable: _cbLog,
      builder: (context, log, _) => ShowcaseLogBox(
        entries: log,
        hint: context.tx('Sem eventos'),
        height: 112,
      ),
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
    ValueListenableBuilder<num>(
      valueListenable: _heart,
      builder: (context, valor, _) => SgRating(
        label: context.tx('Coração'),
        value: valor,
        color: '#ec4899',
        emptyColor: '#f9a8d4',
        onIcon: const Icon(Icons.favorite, size: 24),
        offIcon: const Icon(Icons.favorite_border, size: 24),

        onChange: (v) => _heart.value = v,
      ),
    ),
    ValueListenableBuilder<num>(
      valueListenable: _like,
      builder: (context, valor, _) => SgRating(
        label: context.tx('Curtidas'),
        value: valor,
        color: '#2563eb',
        emptyColor: '#93c5fd',
        onIcon: const Icon(Icons.thumb_up, size: 24),
        offIcon: const Icon(Icons.thumb_up_outlined, size: 24),

        onChange: (v) => _like.value = v,
      ),
    ),
    ValueListenableBuilder<num>(
      valueListenable: _fire,
      builder: (context, valor, _) => SgRating(
        label: context.tx('Fogo'),
        value: valor,
        color: '#f97316',
        emptyColor: '#fdba74',
        onIcon: const Icon(Icons.local_fire_department, size: 24),
        offIcon: const Icon(
          Icons.local_fire_department_outlined,
          size: 24,
        ),

        onChange: (v) => _fire.value = v,
      ),
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
        (values) => _enviado.value = '$values',
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
    ValueListenableBuilder<String>(
      valueListenable: _enviado,
      builder: (context, enviado, _) =>
          Text('${context.tx('Último envio')}: $enviado'),
    ),
  ],
)
''';

  /// Region `sg-rating-meia`.
  static const String sgRatingMeia = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ValueListenableBuilder<num>(
      valueListenable: _meia,
      builder: (context, valor, _) => SgRating(
        label: context.tx(
          'Passe o mouse e clique nas meias estrelas',
        ),
        value: valor,
        allowHalf: true,
        showTooltip: true,
        onChange: (v) => _meia.value = v,
        onHover: (v) => _meiaHover.value = v,
      ),
    ),
    const SizedBox(height: 8),
    ListenableBuilder(
      listenable: Listenable.merge([_meia, _meiaHover]),
      builder: (context, _) => Text(
        '${context.tx('Selecionado')}: ${_meia.value} | ${context.tx('Hover')}: ${_meiaHover.value ?? context.tx('nenhum')}',
      ),
    ),
  ],
)
''';

  /// Region `sg-rating-obrigatorio`.
  static const String sgRatingObrigatorio = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ValueListenableBuilder<num>(
      valueListenable: _req,
      builder: (context, valor, _) => SgRating(
        label: context.tx('Avaliação obrigatória'),
        value: valor,
        required: true,
        requiredMessage: context.tx(
          'Informe uma avaliação antes de continuar',
        ),
        onChange: (v) => _req.value = v,
      ),
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
          onClick: () => _req.value = 0,
        ),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Nota 1')),
          onClick: () => _req.value = 1,
        ),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Nota 5')),
          onClick: () => _req.value = 5,
        ),
      ],
    ),
    const SizedBox(height: 12),
    ValueListenableBuilder<num>(
      valueListenable: _req,
      builder: (context, valor, _) =>
          Text('${context.tx('Valor atual')}: $valor'),
    ),
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
    ValueListenableBuilder<num>(
      valueListenable: _sm,
      builder: (context, valor, _) => SgRating(
        label: context.tx('sm / 5 estrelas'),
        size: SgRatingSize.sm,
        value: valor,

        onChange: (v) => _sm.value = v,
      ),
    ),
    ValueListenableBuilder<num>(
      valueListenable: _lg,
      builder: (context, valor, _) => SgRating(
        label: context.tx('lg / 5 estrelas'),
        size: SgRatingSize.lg,
        value: valor,

        onChange: (v) => _lg.value = v,
      ),
    ),
    ValueListenableBuilder<num>(
      valueListenable: _many,
      builder: (context, valor, _) => SgRating(
        label: context.tx('10 estrelas'),
        stars: 10,
        size: SgRatingSize.sm,
        value: valor,

        onChange: (v) => _many.value = v,
      ),
    ),
  ],
)
''';
}
