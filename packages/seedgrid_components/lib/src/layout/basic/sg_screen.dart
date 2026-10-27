// Porte de SgScreen (React: src/layout/SgScreen.tsx): area raiz de uma tela. Em tela cheia (padrao)
// ocupa a largura do pai e a altura da JANELA (`100dvh`); o conteudo segue as regras de docking
// (SgPanel com `align`), com `client` como alinhamento do container.
import 'package:flutter/material.dart';

import '../../generated/sg_screen.g.dart';
import 'dock_content.dart';
import 'layout_units.dart';
import '../../generated/enums.g.dart';

class SgScreen extends StatelessWidget implements SgScreenProps {
  const SgScreen({
    super.key,
    this.children = const [],
    this.fullscreen,
    this.height,
    this.padding,
    this.width,
  });

  /// `children` no React.
  final List<Widget> children;

  /// O contrato gerado usa `child` (singular): devolve os filhos numa coluna so para cumprir o contrato.
  @override
  Widget? get child => children.isEmpty ? null : Column(children: children);

  /// Padrao `true`: largura 100% e altura `100dvh` (altura da janela), a menos que width/height sejam informados.
  @override
  final bool? fullscreen;

  /// `num` (px), 'Npx' ou 'N%'.
  @override
  final Object? height;

  /// Espaco interno. `num` (px) ou 'Npx'/'Nrem'.
  @override
  final Object? padding;

  /// `num` (px), 'Npx' ou 'N%'.
  @override
  final Object? width;

  @override
  Widget build(BuildContext context) {
    final full = fullscreen ?? true;
    final screen = MediaQuery.sizeOf(context);
    final viewportH = screen.height;
    return LayoutBuilder(
      builder: (context, c) {
        final availW = c.hasBoundedWidth ? c.maxWidth : double.infinity;
        final availH = c.hasBoundedHeight ? c.maxHeight : double.infinity;
        final w = width != null
            ? sgSize(width, availW, viewport: screen)
            : (full ? (c.hasBoundedWidth ? c.maxWidth : null) : null);
        final h = height != null
            ? sgSize(height, availH, viewport: screen)
            : (full ? viewportH : null);
        final pad = sgSpace(padding, viewport: screen);
        Widget body = sgDockContent(
          children: children,
          align: SgPanelAlign.client,
        );
        if (pad != null) {
          body = Padding(padding: EdgeInsets.all(pad), child: body);
        }
        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: w,
            height: h,
            child: ClipRect(child: body),
          ),
        );
      },
    );
  }
}
