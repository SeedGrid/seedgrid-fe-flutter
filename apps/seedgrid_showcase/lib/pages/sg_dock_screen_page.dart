// Showcase do SgDockScreen. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// As toolbars (SgToolBar) ainda nao foram portadas: os exemplos usam botoes como "toolbars" de mentira.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_dock_screen_page.snippets.g.dart';

class SgDockScreenPage extends StatelessWidget {
  const SgDockScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Tela com as cinco zonas',
        description:
            'Grade padrão: colunas laterais de 12rem (192) e centro flexível; topo e base com a altura do conteúdo.',
        preview:
            // #region sg-dock-screen-basico
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const SgDockScreen(
                id: 'showcase-dock-screen-basico',
                fullscreen: false,
                height: 320,
                children: [
                  SgDockZone(
                    zone: SgDockZoneId.top,
                    children: [
                      SgButton(
                        label: Text('Início'),
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                      ),
                      SgButton(
                        label: Text('Buscar'),
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                      ),
                    ],
                  ),
                  SgDockZone(
                    zone: SgDockZoneId.bottom,
                    children: [
                      SgButton(
                        label: Text('Relatórios'),
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                      ),
                    ],
                  ),
                  SgDockZone(
                    zone: SgDockZoneId.left,
                    children: [
                      SgButton(
                        label: Text('Clientes'),
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
                  SgDockZone(
                    zone: SgDockZoneId.right,
                    children: [
                      SgButton(
                        label: Text('Equipe'),
                        size: SgSize.sm,
                        appearance: SgAppearance.ghost,
                      ),
                    ],
                  ),
                  SgDockZone(
                    zone: SgDockZoneId.free,
                    child: Text('Área central livre'),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgDockScreenPageSnippets.sgDockScreenBasico,
      ),
      ShowcaseExample(
        title: 'Largura, altura e padding',
        description:
            'width e height aceitam número (px) ou texto como "520px"; padding afasta a grade da borda.',
        preview:
            // #region sg-dock-screen-tamanho
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const SgDockScreen(
                id: 'showcase-dock-screen-tamanho',
                fullscreen: false,
                width: '520px',
                height: 220,
                padding: 12,
                children: [
                  SgDockZone(
                    zone: SgDockZoneId.top,
                    child: SgButton(label: Text('Topo'), size: SgSize.sm),
                  ),
                  SgDockZone(
                    zone: SgDockZoneId.left,
                    child: SgButton(
                      label: Text('Esquerda'),
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                    ),
                  ),
                  SgDockZone(zone: SgDockZoneId.free, child: Text('Centro')),
                ],
              ),
            ),
        // #endregion
        code: SgDockScreenPageSnippets.sgDockScreenTamanho,
      ),
      ShowcaseExample(
        title: 'Conteúdo no centro',
        description: 'Um filho que não é SgDockZone vai para a célula central.',
        preview:
            // #region sg-dock-screen-conteudo
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const SgDockScreen(
                id: 'showcase-dock-screen-conteudo',
                fullscreen: false,
                height: 200,
                children: [
                  SgDockZone(zone: SgDockZoneId.left, child: Text('Menu')),
                  Center(child: Text('Conteúdo da página')),
                  SgDockZone(zone: SgDockZoneId.right, child: Text('Ajuda')),
                ],
              ),
            ),
        // #endregion
        code: SgDockScreenPageSnippets.sgDockScreenConteudo,
      ),
    ];

    return SgShowcasePage(
      name: 'SgDockScreen',
      description:
          'Tela completa com um SgDockLayout interno e a grade padrão de zonas (topo, base, esquerda, direita e centro livre).',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgDockScreen']!,
        const SgPropSpec(
          name: 'children',
          reactName: 'children',
          type: 'List<Widget>?',
          tsType: 'ReactNode',
          required: false,
          description: 'Vários filhos; normalmente SgDockZone.',
        ),
        const SgPropSpec(
          name: 'store',
          reactName: '-',
          type: 'SgDockLayoutStore?',
          tsType: '-',
          required: false,
          description: 'Persistência do estado do layout interno.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgDockScreen']!
            .where((s) => s.name == 'fullscreen' || s.name == 'screenId')
            .toList(),
        builder: (context, v) => SizedBox(
          height: 160,
          child: SgDockScreen(
            id: 'playground-dock-screen',
            screenId: v['screenId'] as String?,
            fullscreen: (v['fullscreen'] as bool?) ?? false,
            height: 160,
            children: const [
              SgDockZone(zone: SgDockZoneId.top, child: Text('Topo')),
              SgDockZone(zone: SgDockZoneId.free, child: Text('Centro')),
            ],
          ),
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'playground-dock-screen'"];
          if (v['screenId'] != null) args.add("screenId: '${v['screenId']}'");
          args.add('fullscreen: ${(v['fullscreen'] as bool?) ?? false}');
          args.add('height: 160');
          args.add('children: [...]');
          return 'SgDockScreen(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
