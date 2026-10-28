// Showcase do SgFloatActionButton. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// Nos exemplos o botao usa `absolute: true` dentro de uma area de 260 px, para ficar no proprio
// exemplo; sem `absolute` ele flutua sobre a janela inteira (como `position: fixed`).
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_float_action_button_page.snippets.g.dart';

class SgFloatActionButtonPage extends StatefulWidget {
  const SgFloatActionButtonPage({super.key});

  @override
  State<SgFloatActionButtonPage> createState() =>
      _SgFloatActionButtonPageState();
}

class _SgFloatActionButtonPageState extends State<SgFloatActionButtonPage> {
  int _cliques = 0;
  String _ultima = '';

  Widget _area(Widget child) => SizedBox(
    height: 260,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico e posições',
        description:
            'Botão de ação principal fixo num canto. Padrão: rightBottom, 24 px da borda.',
        preview:
            // #region sg-fab-basico
            SizedBox(
              height: 260,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Center(child: Text('Cliques: $_cliques')),
                    SgFloatActionButton(
                      absolute: true,
                      hint: context.tx('Novo item'),
                      onClick: () => setState(() => _cliques++),
                    ),
                    const SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.leftTop,
                      severity: SgFloatActionButtonSeverity.success,
                      icon: Icon(Icons.check),
                    ),
                    const SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.centerBottom,
                      severity: SgFloatActionButtonSeverity.danger,
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabBasico,
      ),
      ShowcaseExample(
        title: 'Aparência',
        description:
            'severity, size, shape, elevation, color customizada, loading e disabled.',
        preview:
            // #region sg-fab-aparencia
            SizedBox(
              height: 260,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Stack(
                  children: [
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.leftTop,
                      size: SgFloatActionButtonSize.sm,
                      severity: SgFloatActionButtonSeverity.secondary,
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.centerTop,
                      shape: SgFloatActionButtonShape.rounded,
                      elevation: SgFloatActionButtonElevation.lg,
                      severity: SgFloatActionButtonSeverity.warning,
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.rightTop,
                      size: SgFloatActionButtonSize.lg,
                      shape: SgFloatActionButtonShape.square,
                      color: '#7C3AED',
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.leftBottom,
                      loading: true,
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.centerBottom,
                      disabled: true,
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabAparencia,
      ),
      ShowcaseExample(
        title: 'Speed-dial',
        description:
            'Com actions, o toque abre as ações secundárias; clicar fora ou Esc fecha. direction define o lado.',
        preview:
            // #region sg-fab-speed-dial
            SizedBox(
              height: 260,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Center(child: Text('Última ação: $_ultima')),
                    SgFloatActionButton(
                      absolute: true,
                      icon: const Icon(Icons.add),
                      activeIcon: const Icon(Icons.close),
                      actions: [
                        SgFABAction(
                          icon: const Icon(Icons.edit),
                          label: context.tx('Editar'),
                          onClick: () => setState(() => _ultima = 'editar'),
                        ),
                        SgFABAction(
                          icon: const Icon(Icons.share),
                          label: context.tx('Compartilhar'),
                          severity: SgFloatActionButtonSeverity.info,
                          onClick: () =>
                              setState(() => _ultima = 'compartilhar'),
                        ),
                        SgFABAction(
                          icon: Icon(Icons.delete),
                          label: context.tx('Excluir'),
                          disabled: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabSpeedDial,
      ),
      ShowcaseExample(
        title: 'Layouts em arco',
        description:
            'type: circle, semiCircle ou quarterCircle espalha as ações em arco; radius ajusta o alcance.',
        preview:
            // #region sg-fab-arco
            SizedBox(
              height: 260,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.centerBottom,
                      type: SgFloatActionButtonType.semiCircle,
                      radius: 90,
                      actions: [
                        SgFABAction(
                          icon: Icon(Icons.home),
                          label: context.tx('Início'),
                        ),
                        SgFABAction(
                          icon: Icon(Icons.search),
                          label: context.tx('Buscar'),
                        ),
                        SgFABAction(
                          icon: Icon(Icons.person),
                          label: context.tx('Perfil'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabArco,
      ),
      ShowcaseExample(
        title: 'Animações',
        description:
            'animation (scale, fade, slide, rotate, pulse) disparada em animationOn: mount, hover ou click. Cada botão também abre um speed-dial ao tocar.',
        preview:
            // #region sg-fab-animacoes
            SizedBox(
              height: 260,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.leftBottom,
                      animation: SgFloatActionButtonAnimation.pulse,
                      actions: [
                        SgFABAction(
                          icon: Icon(Icons.edit),
                          label: context.tx('Editar'),
                        ),
                        SgFABAction(
                          icon: Icon(Icons.share),
                          label: context.tx('Compartilhar'),
                        ),
                      ],
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      position: SgFloatActionButtonPosition.centerBottom,
                      animation: SgFloatActionButtonAnimation.rotate,
                      animationOn: SgFloatActionButtonAnimationOn.hover,
                      actions: [
                        SgFABAction(
                          icon: Icon(Icons.edit),
                          label: context.tx('Editar'),
                        ),
                        SgFABAction(
                          icon: Icon(Icons.share),
                          label: context.tx('Compartilhar'),
                        ),
                      ],
                    ),
                    SgFloatActionButton(
                      absolute: true,
                      animation: SgFloatActionButtonAnimation.scale,
                      animationOn: SgFloatActionButtonAnimationOn.click,
                      actions: [
                        SgFABAction(
                          icon: Icon(Icons.edit),
                          label: context.tx('Editar'),
                        ),
                        SgFABAction(
                          icon: Icon(Icons.share),
                          label: context.tx('Compartilhar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabAnimacoes,
      ),
      ShowcaseExample(
        title: 'Arrastar e lembrar a posição',
        description:
            'enableDragDrop permite arrastar; com dragId a posição é guardada. Botão direito (ou toque longo) oferece reiniciar.',
        preview:
            // #region sg-fab-arrastar
            SizedBox(
              height: 260,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    SgFloatActionButton(
                      absolute: true,
                      enableDragDrop: true,
                      dragId: 'showcase-fab',
                      hint: context.tx('Arraste-me'),
                      actions: [
                        SgFABAction(
                          icon: Icon(Icons.edit),
                          label: context.tx('Editar'),
                        ),
                        SgFABAction(
                          icon: Icon(Icons.share),
                          label: context.tx('Enviar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        // #endregion
        code: SgFloatActionButtonPageSnippets.sgFabArrastar,
      ),
    ];

    const playgroundProps = {
      'position',
      'severity',
      'size',
      'shape',
      'elevation',
      'animation',
      'animationOn',
      'loading',
      'disabled',
    };
    return SgShowcasePage(
      name: 'SgFloatActionButton',
      description:
          'Botão de ação flutuante para a tarefa de maior destaque, com hint, posição, arrastar e speed-dial de ações secundárias.',
      examples: examples,
      propSpecs: sgPropSpecs['SgFloatActionButton']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgFloatActionButton']!
            .where((s) => playgroundProps.contains(s.name))
            .toList(),
        builder: (context, v) => _area(
          Stack(
            children: [
              SgFloatActionButton(
                key: ValueKey(
                  '${v['position']}|${v['animation']}|${v['animationOn']}',
                ),
                absolute: true,
                position:
                    SgFloatActionButtonPosition.fromValue(
                      v['position'] as String?,
                    ) ??
                    SgFloatActionButtonPosition.rightBottom,
                severity:
                    SgFloatActionButtonSeverity.fromValue(
                      v['severity'] as String?,
                    ) ??
                    SgFloatActionButtonSeverity.primary,
                size:
                    SgFloatActionButtonSize.fromValue(v['size'] as String?) ??
                    SgFloatActionButtonSize.md,
                shape:
                    SgFloatActionButtonShape.fromValue(v['shape'] as String?) ??
                    SgFloatActionButtonShape.circle,
                elevation:
                    SgFloatActionButtonElevation.fromValue(
                      v['elevation'] as String?,
                    ) ??
                    SgFloatActionButtonElevation.md,
                animation:
                    SgFloatActionButtonAnimation.fromValue(
                      v['animation'] as String?,
                    ) ??
                    SgFloatActionButtonAnimation.scale,
                animationOn:
                    SgFloatActionButtonAnimationOn.fromValue(
                      v['animationOn'] as String?,
                    ) ??
                    SgFloatActionButtonAnimationOn.mount,
                loading: (v['loading'] as bool?) ?? false,
                disabled: (v['disabled'] as bool?) ?? false,
              ),
            ],
          ),
        ),
        codeBuilder: (v) {
          final args = <String>['absolute: true'];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'position' =>
                'position: SgFloatActionButtonPosition.${SgFloatActionButtonPosition.fromValue(e.value as String)!.name}',
              'severity' =>
                'severity: SgFloatActionButtonSeverity.${SgFloatActionButtonSeverity.fromValue(e.value as String)!.name}',
              'size' =>
                'size: SgFloatActionButtonSize.${SgFloatActionButtonSize.fromValue(e.value as String)!.name}',
              'shape' =>
                'shape: SgFloatActionButtonShape.${SgFloatActionButtonShape.fromValue(e.value as String)!.name}',
              'elevation' =>
                'elevation: SgFloatActionButtonElevation.${SgFloatActionButtonElevation.fromValue(e.value as String)!.name}',
              'animation' =>
                'animation: SgFloatActionButtonAnimation.${SgFloatActionButtonAnimation.fromValue(e.value as String)!.name}',
              'animationOn' =>
                'animationOn: SgFloatActionButtonAnimationOn.${SgFloatActionButtonAnimationOn.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgFloatActionButton(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
