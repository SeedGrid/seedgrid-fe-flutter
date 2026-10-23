// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_carousel_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgCarouselPageSnippets {
  /// Region `sg-carousel-autoplay`.
  static const String sgCarouselAutoplay = r'''
SgCarousel(
  height: 140,
  items: _slides(4),
  autoPlay: true,
  autoPlayInterval: 2000,
  showNavigators: false,
)
''';

  /// Region `sg-carousel-basico`.
  static const String sgCarouselBasico = r'''
SgCarousel(
  height: 160,
  items: _slides(5),
  onIndexChange: (i) => setState(() => _slide = i),
)
''';

  /// Region `sg-carousel-varios`.
  static const String sgCarouselVarios = r'''
SgCarousel(
  height: 120,
  items: _slides(8),
  numVisible: 3,
  numScroll: 2,
  gap: 12,
  circular: false,
)
''';

  /// Region `sg-carousel-vertical`.
  static const String sgCarouselVertical = r'''
SgCarousel(
  height: 200,
  width: 260,
  orientation: SgCarouselOrientation.vertical,
  items: _slides(4),
  customNavigators: const SgCarouselNavigators(
    prev: Icon(Icons.expand_less),
    next: Icon(Icons.expand_more),
  ),
)
''';
}
