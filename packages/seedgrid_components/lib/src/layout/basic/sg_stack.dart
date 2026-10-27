// Porte de SgStack (React: src/layout/SgStack.tsx). `div` flex: coluna por padrao, gap, justify/align, wrap e grow.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../generated/enums.g.dart';
import '../../generated/sg_stack.g.dart';
import 'layout_units.dart';

class SgStack extends StatelessWidget implements SgStackProps {
  const SgStack({
    super.key,
    this.align,
    this.children = const [],
    this.direction,
    this.gap,
    this.grow,
    this.justify,
    this.wrap,
  });

  /// Padrao `stretch`.
  @override
  final SgStackAlign? align;

  /// `children` no React.
  final List<Widget> children;

  /// O contrato gerado usa `child` (singular): devolve os filhos numa coluna so para cumprir o contrato.
  @override
  Widget? get child => children.isEmpty ? null : Column(children: children);

  /// Padrao `column`.
  @override
  final SgStackDirection? direction;

  /// `num` (px) ou texto CSS ('Npx', 'Nrem', 'Nvh', 'calc(...)'). Padrao 0.
  @override
  final Object? gap;

  /// `flex-1`: cresce dentro de um pai flex (Row/Column/Flex). Em outro pai nao tem efeito.
  @override
  final bool? grow;

  /// Padrao `start`.
  @override
  final SgStackJustify? justify;

  /// Quebra em varias linhas (`flex-wrap`).
  @override
  final bool? wrap;

  @override
  Widget build(BuildContext context) {
    final row = (direction ?? SgStackDirection.column) == SgStackDirection.row;
    final g = sgSpace(gap, viewport: MediaQuery.sizeOf(context)) ?? 0;
    final j = justify ?? SgStackJustify.start;
    final a = align ?? SgStackAlign.stretch;
    final isGrow = grow ?? false;

    final Widget flex = LayoutBuilder(
      builder: (context, c) {
        if (wrap ?? false) {
          return Wrap(
            direction: row ? Axis.horizontal : Axis.vertical,
            spacing: g,
            runSpacing: g,
            alignment: switch (j) {
              SgStackJustify.start => WrapAlignment.start,
              SgStackJustify.center => WrapAlignment.center,
              SgStackJustify.end => WrapAlignment.end,
              SgStackJustify.between => WrapAlignment.spaceBetween,
              SgStackJustify.around => WrapAlignment.spaceAround,
              SgStackJustify.evenly => WrapAlignment.spaceEvenly,
            },
            // `stretch` nao existe no Wrap: cai em start
            crossAxisAlignment: switch (a) {
              SgStackAlign.center => WrapCrossAlignment.center,
              SgStackAlign.end => WrapCrossAlignment.end,
              _ => WrapCrossAlignment.start,
            },
            children: children,
          );
        }
        // stretch so quando o pai FIXA o eixo transversal. Com altura automatica o CSS iguala os irmaos a mais alta;
        // aqui cada um fica com a propria altura (igualar exigiria IntrinsicHeight).
        final crossTight = row
            ? (c.hasBoundedHeight && c.minHeight == c.maxHeight)
            : (c.hasBoundedWidth && c.minWidth == c.maxWidth);
        // `div` flex e bloco: na linha ocupa a largura disponivel; na coluna a altura e automatica
        // (a nao ser que cresca ou o pai a fixe).
        final fillMain = row
            ? c.hasBoundedWidth
            : (isGrow || (c.hasBoundedHeight && c.minHeight == c.maxHeight));
        return Flex(
          direction: row ? Axis.horizontal : Axis.vertical,
          spacing: g,
          mainAxisSize: fillMain ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: switch (j) {
            SgStackJustify.start => MainAxisAlignment.start,
            SgStackJustify.center => MainAxisAlignment.center,
            SgStackJustify.end => MainAxisAlignment.end,
            SgStackJustify.between => MainAxisAlignment.spaceBetween,
            SgStackJustify.around => MainAxisAlignment.spaceAround,
            SgStackJustify.evenly => MainAxisAlignment.spaceEvenly,
          },
          // stretch com eixo transversal ilimitado e erro no Flutter; no CSS a altura e automatica
          crossAxisAlignment: switch (a) {
            SgStackAlign.center => CrossAxisAlignment.center,
            SgStackAlign.end => CrossAxisAlignment.end,
            SgStackAlign.stretch =>
              crossTight
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.start,
            SgStackAlign.start => CrossAxisAlignment.start,
          },
          children: children,
        );
      },
    );

    // Bloco de largura total na coluna (o div flex preenche a largura do pai quando ela e limitada).
    // Atencao: a closure usa `flex` (outra variavel), nunca a propria variavel que recebe o resultado.
    final Widget body = row
        ? flex
        : LayoutBuilder(
            builder: (context, c) => SizedBox(
              width: c.hasBoundedWidth ? c.maxWidth : null,
              child: flex,
            ),
          );

    if (isGrow) {
      // `flex-1` so vale se o pai for flex: o pai de renderizacao mais proximo precisa ser um RenderFlex.
      return Builder(
        builder: (context) {
          final parent = context.findAncestorRenderObjectOfType<RenderObject>();
          return parent is RenderFlex ? Expanded(child: body) : body;
        },
      );
    }
    return body;
  }
}
