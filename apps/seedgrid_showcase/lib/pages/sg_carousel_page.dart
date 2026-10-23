// Showcase do SgCarousel. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_carousel_page.snippets.g.dart';

class SgCarouselPage extends StatefulWidget {
  const SgCarouselPage({super.key});

  @override
  State<SgCarouselPage> createState() => _SgCarouselPageState();
}

class _SgCarouselPageState extends State<SgCarouselPage> {
  int _slide = 0;

  static List<Widget> _slides(int n) => [
    for (var i = 0; i < n; i++)
      Container(
        decoration: BoxDecoration(
          color: Colors.primaries[(i * 3) % Colors.primaries.length].shade400,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          'Slide ${i + 1}',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Setas, indicadores e deslizar o dedo. Slide atual: ${_slide + 1}.',
        preview:
            // #region sg-carousel-basico
            SgCarousel(
              height: 160,
              items: _slides(5),
              onIndexChange: (i) => setState(() => _slide = i),
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselBasico,
      ),
      ShowcaseExample(
        title: 'Vários itens visíveis',
        preview:
            // #region sg-carousel-varios
            SgCarousel(
              height: 120,
              items: _slides(8),
              numVisible: 3,
              numScroll: 2,
              gap: 12,
              circular: false,
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselVarios,
      ),
      ShowcaseExample(
        title: 'Reprodução automática',
        description:
            'Avança a cada 2 s e pausa enquanto você toca ou passa o mouse.',
        preview:
            // #region sg-carousel-autoplay
            SgCarousel(
              height: 140,
              items: _slides(4),
              autoPlay: true,
              autoPlayInterval: 2000,
              showNavigators: false,
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselAutoplay,
      ),
      ShowcaseExample(
        title: 'Vertical e navegadores próprios',
        preview:
            // #region sg-carousel-vertical
            SgCarousel(
              height: 200,
              width: 260,
              orientation: SgCarouselOrientation.vertical,
              items: _slides(4),
              customNavigators: const SgCarouselNavigators(
                prev: Icon(Icons.expand_less),
                next: Icon(Icons.expand_more),
              ),
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselVertical,
      ),
    ];

    return SgShowcasePage(
      name: 'SgCarousel',
      description:
          'Carrossel de itens com setas, indicadores, reprodução automática, vários itens visíveis e orientação vertical.',
      examples: examples,
      propSpecs: sgPropSpecs['SgCarousel']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgCarousel']!
            .where(
              (s) => const {
                'orientation',
                'circular',
                'autoPlay',
                'showNavigators',
                'showIndicators',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgCarousel(
          key: ValueKey('${v['orientation']}'),
          height: 160,
          width: 280,
          items: _slides(5),
          orientation:
              SgCarouselOrientation.fromValue(v['orientation'] as String?) ??
              SgCarouselOrientation.horizontal,
          circular: (v['circular'] as bool?) ?? true,
          autoPlay: (v['autoPlay'] as bool?) ?? false,
          showNavigators: (v['showNavigators'] as bool?) ?? true,
          showIndicators: (v['showIndicators'] as bool?) ?? true,
        ),
        codeBuilder: (v) {
          final args = <String>['height: 160', 'items: slides'];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'orientation' =>
                'orientation: SgCarouselOrientation.${SgCarouselOrientation.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgCarousel(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
