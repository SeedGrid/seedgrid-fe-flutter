// Showcase do SgCarousel. Mesmos exemplos, na mesma ordem, do showcase React (a fonte da verdade). O codigo
// exibido em cada exemplo e o trecho entre `// #region` e `// #endregion` deste arquivo: exatamente o que
// esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import '../src/showcase_log_box.dart';
import 'sg_carousel_page.snippets.g.dart';

class SgCarouselPage extends StatefulWidget {
  const SgCarouselPage({super.key});

  @override
  State<SgCarouselPage> createState() => _SgCarouselPageState();
}

class _SgCarouselPageState extends State<SgCarouselPage> {
  final ValueNotifier<int> _activeIndex = ValueNotifier(0);
  final ValueNotifier<List<String>> _eventLog = ValueNotifier(const []);

  void _log(String message) {
    final now = DateTime.now().toString().substring(11, 19);
    _eventLog.value = ['[$now] $message', ..._eventLog.value].take(10).toList();
  }

  @override
  void dispose() {
    _activeIndex.dispose();
    _eventLog.dispose();
    super.dispose();
  }

  // Equivale ao createCarouselItems do React (cartoes coloridos no lugar das fotos).
  static List<Widget> _slides([int n = 6]) => [
    for (var i = 0; i < n; i++)
      Container(
        decoration: BoxDecoration(
          color: Colors.primaries[(i * 3) % Colors.primaries.length].shade400,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Item ${i + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Slide ${i + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico - Horizontal',
        description: 'Carrossel horizontal simples com um item visível por vez',
        preview:
            // #region sg-carousel-basico
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
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselBasico,
      ),
      ShowcaseExample(
        title: 'Múltiplos itens visíveis',
        description: 'Carrossel mostrando 3 itens de uma vez',
        preview:
            // #region sg-carousel-multiplos
            SizedBox(
              height: 256,
              child: SgCarousel(
                items: _slides(),
                numVisible: 3,
                numScroll: 1,
                orientation: SgCarouselOrientation.horizontal,
                height: '100%',
              ),
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselMultiplos,
      ),
      ShowcaseExample(
        title: 'Auto play',
        description: 'Carrossel com navegação automática (a cada 2 segundos)',
        preview:
            // #region sg-carousel-autoplay
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
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselAutoplay,
      ),
      ShowcaseExample(
        title: 'Orientação vertical',
        description: 'Carrossel com navegação vertical',
        preview:
            // #region sg-carousel-vertical
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
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselVertical,
      ),
      ShowcaseExample(
        title: 'Vertical - Múltiplos itens',
        description: 'Carrossel vertical mostrando 3 itens de uma vez',
        preview:
            // #region sg-carousel-vertical-multiplos
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
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselVerticalMultiplos,
      ),
      ShowcaseExample(
        title: 'Sem modo circular',
        description: 'Carrossel que para no final (sem loop infinito)',
        preview:
            // #region sg-carousel-sem-circular
            SizedBox(
              height: 256,
              child: SgCarousel(
                items: _slides(),
                numVisible: 1,
                circular: false,
                orientation: SgCarouselOrientation.horizontal,
                height: '100%',
              ),
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselSemCircular,
      ),
      ShowcaseExample(
        title: 'Sem indicadores',
        description: 'Carrossel sem os indicadores (dots) na parte inferior',
        preview:
            // #region sg-carousel-sem-indicadores
            SizedBox(
              height: 256,
              child: SgCarousel(
                items: _slides(),
                numVisible: 1,
                showIndicators: false,
                orientation: SgCarouselOrientation.horizontal,
                height: '100%',
              ),
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselSemIndicadores,
      ),
      ShowcaseExample(
        title: 'Sem navegadores',
        description:
            'Carrossel sem os botões de navegação (apenas indicadores)',
        preview:
            // #region sg-carousel-sem-navegadores
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
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselSemNavegadores,
      ),
      ShowcaseExample(
        title: 'Gap customizado',
        description:
            'Carrossel com espaçamento personalizado entre itens (gap: 32px)',
        preview:
            // #region sg-carousel-gap
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
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselGap,
      ),
      ShowcaseExample(
        title: 'Com callbacks',
        description: 'Carrossel com evento de mudança de índice',
        preview:
            // #region sg-carousel-callbacks
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
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselCallbacks,
      ),
      ShowcaseExample(
        title: 'Exemplo responsivo',
        description:
            'Carrossel que se adapta ao tamanho da tela mostrando diferentes quantidades de itens',
        preview:
            // #region sg-carousel-responsivo
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
            ),
        // #endregion
        code: SgCarouselPageSnippets.sgCarouselResponsivo,
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
