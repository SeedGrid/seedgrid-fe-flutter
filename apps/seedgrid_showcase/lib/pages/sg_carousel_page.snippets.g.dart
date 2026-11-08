// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_carousel_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgCarouselPageSnippets {
  /// Region `sg-carousel-autoplay`.
  static const String sgCarouselAutoplay = r'''
SizedBox(
  height: 256,
  child: SgCarousel(
    items: _slides(),
    numVisible: 1,
    autoPlay: true,
    autoPlayInterval: 2000,
    orientation: SgCarouselOrientation.horizontal,
    height: '100%',
  ),
)
''';

  /// Region `sg-carousel-basico`.
  static const String sgCarouselBasico = r'''
SizedBox(
  height: 256,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: SgCarousel(
      items: _slides(),
      numVisible: 1,
      orientation: SgCarouselOrientation.horizontal,
      height: '100%',
    ),
  ),
)
''';

  /// Region `sg-carousel-callbacks`.
  static const String sgCarouselCallbacks = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.05),
      child: ValueListenableBuilder<int>(
        valueListenable: _activeIndex,
        builder: (context, index, _) =>
            Text('${context.tx('Índice Ativo')}: $index'),
      ),
    ),
    const SizedBox(height: 16),
    SizedBox(
      height: 256,
      child: SgCarousel(
        items: _slides(),
        numVisible: 2,
        numScroll: 1,
        orientation: SgCarouselOrientation.horizontal,
        height: '100%',
        onIndexChange: (index) {
          _activeIndex.value = index;
          _log('${context.tx('Índice mudou para')}: $index');
        },
      ),
    ),
    const SizedBox(height: 16),
    ValueListenableBuilder<List<String>>(
      valueListenable: _eventLog,
      builder: (context, entries, _) => ShowcaseLogBox(
        entries: entries,
        hint: context.tx(
          'Navegue pelo carrossel para ver os eventos...',
        ),
        height: 128,
      ),
    ),
  ],
)
''';

  /// Region `sg-carousel-gap`.
  static const String sgCarouselGap = r'''
SizedBox(
  height: 256,
  child: SgCarousel(
    items: _slides(),
    numVisible: 3,
    numScroll: 1,
    gap: 32,
    orientation: SgCarouselOrientation.horizontal,
    height: '100%',
  ),
)
''';

  /// Region `sg-carousel-multiplos`.
  static const String sgCarouselMultiplos = r'''
SizedBox(
  height: 256,
  child: SgCarousel(
    items: _slides(),
    numVisible: 3,
    numScroll: 1,
    orientation: SgCarouselOrientation.horizontal,
    height: '100%',
  ),
)
''';

  /// Region `sg-carousel-responsivo`.
  static const String sgCarouselResponsivo = r'''
Builder(
  builder: (context) {
    final width = MediaQuery.sizeOf(context).width;
    final visible = width >= 1024 ? 4 : (width >= 768 ? 2 : 1);
    return SizedBox(
      height: 256,
      child: SgCarousel(
        key: ValueKey(visible),
        items: _slides(),
        numVisible: visible,
        numScroll: visible == 4 ? 2 : 1,
        orientation: SgCarouselOrientation.horizontal,
        height: '100%',
      ),
    );
  },
)
''';

  /// Region `sg-carousel-sem-circular`.
  static const String sgCarouselSemCircular = r'''
SizedBox(
  height: 256,
  child: SgCarousel(
    items: _slides(),
    numVisible: 1,
    circular: false,
    orientation: SgCarouselOrientation.horizontal,
    height: '100%',
  ),
)
''';

  /// Region `sg-carousel-sem-indicadores`.
  static const String sgCarouselSemIndicadores = r'''
SizedBox(
  height: 256,
  child: SgCarousel(
    items: _slides(),
    numVisible: 1,
    showIndicators: false,
    orientation: SgCarouselOrientation.horizontal,
    height: '100%',
  ),
)
''';

  /// Region `sg-carousel-sem-navegadores`.
  static const String sgCarouselSemNavegadores = r'''
SizedBox(
  height: 256,
  child: SgCarousel(
    items: _slides(),
    numVisible: 1,
    showNavigators: false,
    autoPlay: true,
    autoPlayInterval: 2500,
    orientation: SgCarouselOrientation.horizontal,
    height: '100%',
  ),
)
''';

  /// Region `sg-carousel-vertical`.
  static const String sgCarouselVertical = r'''
SgGrid(
  columns: 1,
  justify: SgGridJustify.center,
  children: [
    Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 320,
        height: 384,
        child: SgCarousel(
          items: _slides(),
          numVisible: 1,
          orientation: SgCarouselOrientation.vertical,
          height: '100%',
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-carousel-vertical-multiplos`.
  static const String sgCarouselVerticalMultiplos = r'''
SgGrid(
  columns: 1,
  justify: SgGridJustify.center,
  children: [
    Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 320,
        height: 384,
        child: SgCarousel(
          items: _slides(),
          numVisible: 3,
          numScroll: 1,
          orientation: SgCarouselOrientation.vertical,
          height: '100%',
          gap: 8,
        ),
      ),
    ),
  ],
)
''';
}
