// Showcase do SgDockZone. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_dock_zone_page.snippets.g.dart';

class SgDockZonePage extends StatelessWidget {
  const SgDockZonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Zona horizontal (top e bottom)',
        description:
            'Os filhos ficam em linha, com quebra, espaço de 12 e padding de 8.',
        preview:
            // #region sg-dock-zone-horizontal
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SgDockZone(
                zone: SgDockZoneId.top,
                children: [
                  SgButton(label: Text('Novo'), size: SgSize.sm),
                  SgButton(
                    label: Text('Abrir'),
                    size: SgSize.sm,
                    appearance: SgAppearance.outline,
                  ),
                  SgButton(
                    label: Text('Salvar'),
                    size: SgSize.sm,
                    appearance: SgAppearance.outline,
                  ),
                  SgButton(
                    label: Text('Imprimir'),
                    size: SgSize.sm,
                    appearance: SgAppearance.outline,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDockZonePageSnippets.sgDockZoneHorizontal,
      ),
      ShowcaseExample(
        title: 'Zona vertical (left e right)',
        description:
            'Os filhos ficam em coluna. Use width e height para fixar o tamanho (no React, classes como w-44).',
        preview:
            // #region sg-dock-zone-vertical
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SgDockZone(
                zone: SgDockZoneId.left,
                width: 160,
                height: 180,
                children: [
                  SgButton(
                    label: Text('Clientes'),
                    size: SgSize.sm,
                    appearance: SgAppearance.ghost,
                  ),
                  SgButton(
                    label: Text('Pedidos'),
                    size: SgSize.sm,
                    appearance: SgAppearance.ghost,
                  ),
                  SgButton(
                    label: Text('Config'),
                    size: SgSize.sm,
                    appearance: SgAppearance.ghost,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDockZonePageSnippets.sgDockZoneVertical,
      ),
      ShowcaseExample(
        title: 'Zona livre (free)',
        description: 'A zona free centraliza o conteúdo.',
        preview:
            // #region sg-dock-zone-livre
            Container(
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SgDockZone(
                zone: SgDockZoneId.free,
                height: 140,
                child: Text('Área central livre'),
              ),
            ),
        // #endregion
        code: SgDockZonePageSnippets.sgDockZoneLivre,
      ),
      ShowcaseExample(
        title: 'Um filho (child) ou vários (children)',
        description: 'children tem precedência sobre child.',
        preview:
            // #region sg-dock-zone-filhos
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgDockZone(zone: SgDockZoneId.top, child: Text('só child')),
                  SgDockZone(
                    zone: SgDockZoneId.top,
                    child: Text('child ignorado'),
                    children: [Text('children 1'), Text('children 2')],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDockZonePageSnippets.sgDockZoneFilhos,
      ),
    ];

    return SgShowcasePage(
      name: 'SgDockZone',
      description:
          'Área onde as toolbars se encaixam (top, bottom, left, right ou free). Mostra a prévia de soltura quando uma toolbar é arrastada.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgDockZone']!,
        const SgPropSpec(
          name: 'children',
          reactName: 'children',
          type: 'List<Widget>?',
          tsType: 'ReactNode',
          required: false,
          description: 'Vários filhos; tem precedência sobre child.',
        ),
        const SgPropSpec(
          name: 'width',
          reactName: '-',
          type: 'double?',
          tsType: '-',
          required: false,
          description: 'Largura fixa em px (no React, classes como w-44).',
        ),
        const SgPropSpec(
          name: 'height',
          reactName: '-',
          type: 'double?',
          tsType: '-',
          required: false,
          description: 'Altura fixa em px (no React, classes como h-20).',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgDockZone']!
            .where((s) => s.name == 'zone')
            .toList(),
        builder: (context, v) {
          final zone = SgDockZoneId.values.firstWhere(
            (z) => z.value == v['zone'],
            orElse: () => SgDockZoneId.top,
          );
          return Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Align(
              alignment: switch (zone) {
                SgDockZoneId.top => Alignment.topCenter,
                SgDockZoneId.bottom => Alignment.bottomCenter,
                SgDockZoneId.left => Alignment.centerLeft,
                SgDockZoneId.right => Alignment.centerRight,
                SgDockZoneId.free => Alignment.center,
              },
              child: SgDockZone(
                zone: zone,
                width: 200,
                height: 120,
                children: const [Text('filho 1'), Text('filho 2')],
              ),
            ),
          );
        },
        codeBuilder: (v) {
          final zone = SgDockZoneId.values.firstWhere(
            (z) => z.value == v['zone'],
            orElse: () => SgDockZoneId.top,
          );
          final align = switch (zone) {
            SgDockZoneId.top => 'topCenter',
            SgDockZoneId.bottom => 'bottomCenter',
            SgDockZoneId.left => 'centerLeft',
            SgDockZoneId.right => 'centerRight',
            SgDockZoneId.free => 'center',
          };
          return [
            'Container(',
            '  width: double.infinity,',
            '  height: 260,',
            '  decoration: BoxDecoration(',
            '    border: Border.all(color: Theme.of(context).dividerColor),',
            '    borderRadius: BorderRadius.circular(8),',
            '  ),',
            '  child: Align(',
            '    alignment: Alignment.$align,',
            '    child: SgDockZone(',
            '      zone: SgDockZoneId.${zone.name},',
            '      width: 200,',
            '      height: 120,',
            "      children: [Text('filho 1'), Text('filho 2')],",
            '    ),',
            '  ),',
            ')',
          ].join('\n');
        },
      ),
    );
  }
}
