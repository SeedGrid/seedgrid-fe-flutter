// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_float_action_button_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgFloatActionButtonPageSnippets {
  /// Region `sg-fab-animacoes`.
  static const String sgFabAnimacoes = r'''
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
          position: SgFloatActionButtonPosition.leftBottom,
          animation: SgFloatActionButtonAnimation.pulse,
        ),
        SgFloatActionButton(
          absolute: true,
          position: SgFloatActionButtonPosition.centerBottom,
          animation: SgFloatActionButtonAnimation.rotate,
          animationOn: SgFloatActionButtonAnimationOn.hover,
        ),
        SgFloatActionButton(
          absolute: true,
          animation: SgFloatActionButtonAnimation.scale,
          animationOn: SgFloatActionButtonAnimationOn.click,
        ),
      ],
    ),
  ),
)
''';

  /// Region `sg-fab-aparencia`.
  static const String sgFabAparencia = r'''
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
)
''';

  /// Region `sg-fab-arco`.
  static const String sgFabArco = r'''
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
          position: SgFloatActionButtonPosition.centerBottom,
          type: SgFloatActionButtonType.semiCircle,
          radius: 90,
          actions: [
            SgFABAction(icon: Icon(Icons.home), label: 'Início'),
            SgFABAction(icon: Icon(Icons.search), label: 'Buscar'),
            SgFABAction(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ],
    ),
  ),
)
''';

  /// Region `sg-fab-arrastar`.
  static const String sgFabArrastar = r'''
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
          enableDragDrop: true,
          dragId: 'showcase-fab',
          hint: 'Arraste-me',
          actions: [
            SgFABAction(icon: Icon(Icons.edit), label: 'Editar'),
            SgFABAction(icon: Icon(Icons.share), label: 'Enviar'),
          ],
        ),
      ],
    ),
  ),
)
''';

  /// Region `sg-fab-basico`.
  static const String sgFabBasico = r'''
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
          hint: 'Novo item',
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
)
''';

  /// Region `sg-fab-speed-dial`.
  static const String sgFabSpeedDial = r'''
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
              label: 'Editar',
              onClick: () => setState(() => _ultima = 'editar'),
            ),
            SgFABAction(
              icon: const Icon(Icons.share),
              label: 'Compartilhar',
              severity: SgFloatActionButtonSeverity.info,
              onClick: () =>
                  setState(() => _ultima = 'compartilhar'),
            ),
            const SgFABAction(
              icon: Icon(Icons.delete),
              label: 'Excluir',
              disabled: true,
            ),
          ],
        ),
      ],
    ),
  ),
)
''';
}
