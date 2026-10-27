import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

final _theme = SgTheme.fromInput(defaultSeedTheme, Brightness.light);

Widget host(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: _theme.toThemeData(),
  home: Scaffold(body: child),
);

Finder surface() => find.byKey(const ValueKey('sg-dialog-surface'));
Finder cancelBtn() => find.byKey(const ValueKey('sg-confirmation-cancel'));
Finder confirmBtn() => find.byKey(const ValueKey('sg-confirmation-confirm'));
Finder accent() => find.byKey(const ValueKey('sg-dialog-accent'));
Finder closeBtn() => find.byKey(const ValueKey('sg-dialog-close'));

/// Avanca quadros: o primeiro tick de uma animacao so marca o inicio do relogio, e o hide do Overlay
/// acontece no quadro seguinte ao fim dela.
Future<void> settle(WidgetTester t, [int ms = 400]) async {
  await t.pump();
  for (var i = 0; i < ms ~/ 100 + 3; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

void setSize(WidgetTester t, Size s) {
  t.view.physicalSize = s;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

BoxDecoration buttonDecoration(WidgetTester t, Finder button) =>
    t
            .widget<AnimatedContainer>(
              find.descendant(
                of: button,
                matching: find.byType(AnimatedContainer),
              ),
            )
            .decoration
        as BoxDecoration;

SgButton sgButton(WidgetTester t, Finder f) => t.widget<SgButton>(f);

void main() {
  setUp(resetComponentsI18n);

  group('defaults do React', () {
    testWidgets(
      'severity warning, sem X, sem acento, size sm, textos em ingles',
      (t) async {
        setSize(t, const Size(1000, 800));
        await t.pumpWidget(
          host(
            const SgConfirmationDialog(
              defaultOpen: true,
              title: Text('Sair?'),
              message: Text('Perde o que nao salvou'),
            ),
          ),
        );
        await settle(t);
        expect(find.text('Sair?'), findsOneWidget);
        expect(find.text('Perde o que nao salvou'), findsOneWidget);
        expect(closeBtn(), findsNothing, reason: 'closeable false');
        expect(accent(), findsNothing, reason: 'showSeverityAccent false');
        expect(t.getSize(surface()).width, 384, reason: 'size sm');
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
        expect(
          find.byIcon(Icons.warning_amber_rounded),
          findsOneWidget,
          reason: 'icone padrao de warning',
        );
      },
    );

    testWidgets('textos em pt-BR vem do i18n', (t) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(const SgConfirmationDialog(defaultOpen: true, message: Text('m'))),
      );
      await settle(t);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Confirmar'), findsOneWidget);
    });

    testWidgets(
      'botoes: cancelar outline/secondary/rounded/sm com X; confirmar solid com check, ambos sm',
      (t) async {
        await t.pumpWidget(
          host(
            const SgConfirmationDialog(
              defaultOpen: true,
              severity: SgDialogSeverity.plain,
              message: Text('m'),
            ),
          ),
        );
        await settle(t);
        final c = sgButton(t, cancelBtn());
        expect(c.appearance, SgAppearance.outline);
        expect(c.severity, SgSeverity.secondary);
        expect(c.shape, SgButtonShape.rounded);
        expect(c.size, SgSize.sm);
        expect(
          find.descendant(of: cancelBtn(), matching: find.byIcon(Icons.close)),
          findsOneWidget,
        );
        final k = sgButton(t, confirmBtn());
        expect(k.appearance, SgAppearance.solid);
        expect(k.severity, SgSeverity.primary, reason: 'plain cai em primary');
        expect(
          find.descendant(of: confirmBtn(), matching: find.byIcon(Icons.check)),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'texto do cancelar usa a cor de primeiro plano (para ficar legivel no outline)',
      (t) async {
        await t.pumpWidget(
          host(
            const SgConfirmationDialog(defaultOpen: true, message: Text('m')),
          ),
        );
        await settle(t);
        expect(
          sgButton(t, cancelBtn()).customColors?.bg,
          _theme.color('--foreground'),
        );
        expect(
          sgButton(t, cancelBtn()).customColors?.border,
          _theme.color('--border'),
        );
      },
    );
  });

  group('confirmar e cancelar', () {
    testWidgets(
      'confirmar: chama confirmButton.onClick e onConfirm, avisa onOpenChange(false) e fecha',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          host(
            SgConfirmationDialog(
              defaultOpen: true,
              message: const Text('m'),
              confirmButton: SgConfirmationDialogButtonConfig(
                onClick: () => log.add('btn'),
              ),
              onConfirm: () => log.add('confirm'),
              onOpenChange: (v) => log.add('open:$v'),
            ),
          ),
        );
        await settle(t);
        await t.tap(confirmBtn());
        await settle(t);
        expect(log, ['btn', 'confirm', 'open:false']);
        expect(surface(), findsNothing);
      },
    );

    testWidgets(
      'cancelar: chama cancelButton.onClick e onCancel, avisa onOpenChange(false) e fecha',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          host(
            SgConfirmationDialog(
              defaultOpen: true,
              message: const Text('m'),
              cancelButton: SgConfirmationDialogButtonConfig(
                onClick: () => log.add('btn'),
              ),
              onCancel: () => log.add('cancel'),
              onOpenChange: (v) => log.add('open:$v'),
            ),
          ),
        );
        await settle(t);
        await t.tap(cancelBtn());
        await settle(t);
        expect(log, ['btn', 'cancel', 'open:false']);
        expect(surface(), findsNothing);
      },
    );

    testWidgets('closeOnConfirm false e closeOnCancel false mantem aberto', (
      t,
    ) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            defaultOpen: true,
            message: const Text('m'),
            closeOnConfirm: false,
            closeOnCancel: false,
            onConfirm: () => log.add('confirm'),
            onCancel: () => log.add('cancel'),
            onOpenChange: (v) => log.add('open:$v'),
          ),
        ),
      );
      await settle(t);
      await t.tap(confirmBtn());
      await t.tap(cancelBtn());
      await settle(t);
      expect(log, ['confirm', 'cancel']);
      expect(surface(), findsOneWidget);
    });

    testWidgets('controlado: o pai manda; confirmar so avisa', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            open: true,
            message: const Text('m'),
            onConfirm: () => log.add('confirm'),
            onOpenChange: (v) => log.add('open:$v'),
          ),
        ),
      );
      await settle(t);
      await t.tap(confirmBtn());
      await settle(t);
      expect(log, ['confirm', 'open:false']);
      expect(surface(), findsOneWidget, reason: 'o pai nao fechou');
    });

    testWidgets(
      'fechar pelo Esc conta como cancelar (igual ao React) e onClose tambem dispara',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          host(
            SgConfirmationDialog(
              defaultOpen: true,
              message: const Text('m'),
              onCancel: () => log.add('cancel'),
              onClose: () => log.add('close'),
              onOpenChange: (v) => log.add('open:$v'),
            ),
          ),
        );
        await settle(t);
        await t.sendKeyEvent(LogicalKeyboardKey.escape);
        await settle(t);
        expect(log, ['cancel', 'open:false', 'close']);
      },
    );

    testWidgets(
      'fechar pelo fundo tambem conta como cancelar; closeOnOverlayClick false nao',
      (t) async {
        final log = <String>[];
        await t.pumpWidget(
          host(
            SgConfirmationDialog(
              defaultOpen: true,
              message: const Text('m'),
              onCancel: () => log.add('cancel'),
            ),
          ),
        );
        await settle(t);
        await t.tapAt(const Offset(4, 4));
        await settle(t);
        expect(log, ['cancel']);
        await t.pumpWidget(
          host(
            SgConfirmationDialog(
              key: const ValueKey('b'),
              defaultOpen: true,
              closeOnOverlayClick: false,
              message: const Text('m'),
              onCancel: () => log.add('cancel2'),
            ),
          ),
        );
        await settle(t);
        await t.tapAt(const Offset(4, 4));
        await settle(t);
        expect(log, ['cancel']);
        expect(surface(), findsOneWidget);
      },
    );

    testWidgets('closeable true mostra o X e ele cancela', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            defaultOpen: true,
            closeable: true,
            message: const Text('m'),
            onCancel: () => log.add('cancel'),
          ),
        ),
      );
      await settle(t);
      await t.tap(closeBtn());
      await settle(t);
      expect(log, ['cancel']);
    });

    testWidgets('desabilitar botoes', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            defaultOpen: true,
            message: const Text('m'),
            confirmButton: const SgConfirmationDialogButtonConfig(
              disabled: true,
            ),
            cancelButton: const SgConfirmationDialogButtonConfig(
              disabled: true,
            ),
            onConfirm: () => log.add('c'),
            onCancel: () => log.add('x'),
          ),
        ),
      );
      await settle(t);
      await t.tap(confirmBtn(), warnIfMissed: false);
      await t.tap(cancelBtn(), warnIfMissed: false);
      await settle(t);
      expect(log, isEmpty);
      expect(surface(), findsOneWidget);
    });
  });

  group('configuracao dos botoes', () {
    testWidgets('label, icon, severity, appearance e shape proprios', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            defaultOpen: true,
            message: Text('m'),
            cancelButton: SgConfirmationDialogButtonConfig(
              label: Text('Voltar'),
              icon: Icon(Icons.undo),
              severity: SgSeverity.info,
              appearance: SgAppearance.ghost,
              shape: SgButtonShape.square,
            ),
            confirmButton: SgConfirmationDialogButtonConfig(
              label: Text('Excluir'),
              icon: Icon(Icons.delete),
              severity: SgSeverity.danger,
              appearance: SgAppearance.outline,
              shape: SgButtonShape.circle,
            ),
          ),
        ),
      );
      await settle(t);
      expect(find.text('Voltar'), findsOneWidget);
      expect(find.text('Excluir'), findsOneWidget);
      expect(find.byIcon(Icons.undo), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      final c = sgButton(t, cancelBtn());
      expect(
        (c.appearance, c.severity, c.shape),
        (SgAppearance.ghost, SgSeverity.info, SgButtonShape.square),
      );
      expect(
        c.customColors,
        isNull,
        reason:
            'com appearance/severity proprios nao ha cor padrao do cancelar',
      );
      final k = sgButton(t, confirmBtn());
      expect(
        (k.appearance, k.severity, k.shape),
        (SgAppearance.outline, SgSeverity.danger, SgButtonShape.circle),
      );
    });

    testWidgets('a severidade do dialogo manda no botao de confirmar', (
      t,
    ) async {
      final expected = {
        SgDialogSeverity.primary: SgSeverity.primary,
        SgDialogSeverity.secondary: SgSeverity.secondary,
        SgDialogSeverity.success: SgSeverity.success,
        SgDialogSeverity.info: SgSeverity.info,
        SgDialogSeverity.warning: SgSeverity.warning,
        SgDialogSeverity.help: SgSeverity.help,
        SgDialogSeverity.danger: SgSeverity.danger,
        SgDialogSeverity.plain: SgSeverity.primary,
      };
      for (final e in expected.entries) {
        await t.pumpWidget(
          host(
            SgConfirmationDialog(
              defaultOpen: true,
              severity: e.key,
              message: const Text('m'),
            ),
          ),
        );
        await settle(t);
        expect(sgButton(t, confirmBtn()).severity, e.value, reason: '${e.key}');
        await t.pumpWidget(host(const SizedBox()));
      }
    });

    testWidgets('a severidade do botao vence a do dialogo', (t) async {
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            defaultOpen: true,
            severity: SgDialogSeverity.danger,
            message: Text('m'),
            confirmButton: SgConfirmationDialogButtonConfig(
              severity: SgSeverity.success,
            ),
          ),
        ),
      );
      await settle(t);
      expect(sgButton(t, confirmBtn()).severity, SgSeverity.success);
    });
  });

  group('icone e mensagem', () {
    testWidgets('icones padrao: info, warning e danger; os demais nao tem', (
      t,
    ) async {
      final expected = <SgDialogSeverity, IconData?>{
        SgDialogSeverity.info: Icons.info_outline,
        SgDialogSeverity.warning: Icons.warning_amber_rounded,
        SgDialogSeverity.danger: Icons.cancel_outlined,
        SgDialogSeverity.primary: null,
        SgDialogSeverity.success: null,
        SgDialogSeverity.plain: null,
      };
      for (final e in expected.entries) {
        await t.pumpWidget(
          host(
            SgConfirmationDialog(
              defaultOpen: true,
              severity: e.key,
              message: const Text('m'),
            ),
          ),
        );
        await settle(t);
        final icons = find
            .descendant(
              of: find.byKey(const ValueKey('sg-dialog-surface')),
              matching: find.byType(Icon),
            )
            .evaluate()
            .map((x) => (x.widget as Icon).icon)
            .toSet();
        // botoes tem close e check; o icone da severidade e o resto
        icons.removeAll([Icons.close, Icons.check]);
        expect(
          icons,
          e.value == null ? isEmpty : {e.value},
          reason: '${e.key}',
        );
        await t.pumpWidget(host(const SizedBox()));
      }
    });

    testWidgets('icon proprio substitui o padrao', (t) async {
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            defaultOpen: true,
            icon: Icon(Icons.star, key: ValueKey('meu')),
            message: Text('m'),
          ),
        ),
      );
      await settle(t);
      expect(find.byKey(const ValueKey('meu')), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
    });

    testWidgets('iconPlacement left (ao lado) e top (acima da mensagem)', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            defaultOpen: true,
            icon: Icon(Icons.star, key: ValueKey('i')),
            message: Text('mensagem'),
          ),
        ),
      );
      await settle(t);
      var icon = t.getCenter(find.byKey(const ValueKey('i')));
      var msg = t.getCenter(find.text('mensagem'));
      expect(icon.dx, lessThan(msg.dx));
      expect((icon.dy - msg.dy).abs(), lessThan(20), reason: 'mesma linha');
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            defaultOpen: true,
            iconPlacement: SgConfirmationDialogIconPlacement.top,
            icon: Icon(Icons.star, key: ValueKey('i')),
            message: Text('mensagem'),
          ),
        ),
      );
      await settle(t);
      icon = t.getCenter(find.byKey(const ValueKey('i')));
      msg = t.getCenter(find.text('mensagem'));
      expect(icon.dy, lessThan(msg.dy));
    });

    testWidgets('mensagem com texto secundario 14', (t) async {
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            defaultOpen: true,
            message: Text('mensagem'),
          ),
        ),
      );
      await settle(t);
      final style = t
          .widget<RichText>(
            find
                .descendant(
                  of: find.text('mensagem'),
                  matching: find.byType(RichText),
                )
                .first,
          )
          .text
          .style!;
      expect(style.fontSize, 14);
      expect(style.color, _theme.color('--muted-foreground'));
    });
  });

  group('props repassadas ao SgDialog', () {
    testWidgets(
      'showSeverityAccent true mostra o acento com a cor da severidade',
      (t) async {
        await t.pumpWidget(
          host(
            const SgConfirmationDialog(
              defaultOpen: true,
              showSeverityAccent: true,
              severity: SgDialogSeverity.danger,
              message: Text('m'),
            ),
          ),
        );
        await settle(t);
        expect(
          t.widget<Container>(accent()).color,
          resolveButtonColors(_theme, SgSeverity.danger).bg,
        );
      },
    );

    testWidgets('size, subtitle, leading, trailing, title', (t) async {
      setSize(t, const Size(1200, 800));
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            defaultOpen: true,
            size: SgDialogSize.lg,
            title: Text('Titulo'),
            subtitle: Text('Sub'),
            leading: Icon(Icons.star, key: ValueKey('l')),
            trailing: Icon(Icons.info, key: ValueKey('r')),
            message: Text('m'),
          ),
        ),
      );
      await settle(t);
      expect(t.getSize(surface()).width, 672);
      for (final s in ['Titulo', 'Sub']) {
        expect(find.text(s), findsOneWidget);
      }
      expect(find.byKey(const ValueKey('l')), findsOneWidget);
      expect(find.byKey(const ValueKey('r')), findsOneWidget);
    });

    testWidgets('customColor e elevation', (t) async {
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            defaultOpen: true,
            customColor: '#223344',
            elevation: 'none',
            message: Text('m'),
          ),
        ),
      );
      await settle(t);
      final deco =
          t
                  .widget<DecoratedBox>(
                    find
                        .descendant(
                          of: surface(),
                          matching: find.byType(DecoratedBox),
                        )
                        .first,
                  )
                  .decoration
              as BoxDecoration;
      expect(deco.color, const Color(0xFF223344));
      expect(deco.boxShadow, isEmpty);
    });

    testWidgets('animation, transitionMs e autoCloseMs', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            defaultOpen: true,
            animation: SgDialogAnimation.fade,
            transitionMs: 100,
            autoCloseMs: 500,
            onClose: () => log.add('close'),
            message: const Text('m'),
          ),
        ),
      );
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      expect(log, isEmpty);
      await t.pump(const Duration(milliseconds: 200));
      expect(log, ['close']);
    });

    testWidgets('closeOnEsc false: Esc nao cancela', (t) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            defaultOpen: true,
            closeOnEsc: false,
            onCancel: () => log.add('cancel'),
            message: const Text('m'),
          ),
        ),
      );
      await settle(t);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(t);
      expect(log, isEmpty);
      expect(surface(), findsOneWidget);
    });

    testWidgets('initialFocusRef e restoreFocus chegam ao dialogo', (t) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            defaultOpen: true,
            initialFocusRef: node,
            restoreFocus: false,
            message: Focus(focusNode: node, child: const Text('m')),
          ),
        ),
      );
      await settle(t);
      expect(node.hasFocus, isTrue);
    });

    testWidgets('ariaLabel e rotulo padrao', (t) async {
      final handle = t.ensureSemantics();
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            defaultOpen: true,
            ariaLabel: 'Confirmar saida',
            message: Text('m'),
          ),
        ),
      );
      await settle(t);
      expect(find.bySemanticsLabel(RegExp('Confirmar saida')), findsWidgets);
      handle.dispose();
    });

    testWidgets('classes CSS e lockBodyScroll sao aceitos sem efeito', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          const SgConfirmationDialog(
            defaultOpen: true,
            lockBodyScroll: false,
            overlayClassName: 'a',
            contentClassName: 'b',
            headerClassName: 'c',
            bodyClassName: 'd',
            footerClassName: 'e',
            message: Text('m'),
          ),
        ),
      );
      await settle(t);
      expect(surface(), findsOneWidget);
    });

    testWidgets('open controlado reabre depois de fechar', (t) async {
      final key = GlobalKey<_ToggleHostState>();
      await t.pumpWidget(host(_ToggleHost(key: key)));
      await settle(t);
      expect(surface(), findsOneWidget);
      key.currentState!.set(false);
      await settle(t);
      expect(surface(), findsNothing);
      key.currentState!.set(true);
      await settle(t);
      expect(surface(), findsOneWidget);
    });
  });

  group('mobile-first', () {
    testWidgets('360x640 com mensagem longa: cabe e rola', (t) async {
      setSize(t, const Size(360, 640));
      await t.pumpWidget(
        host(
          SgConfirmationDialog(
            defaultOpen: true,
            iconPlacement: SgConfirmationDialogIconPlacement.top,
            title: const Text(
              'Titulo muito longo que precisa quebrar linha em tela estreita',
            ),
            message: Text('texto ' * 400),
          ),
        ),
      );
      await settle(t);
      expect(t.takeException(), isNull);
      expect(t.getSize(surface()).width, lessThanOrEqualTo(328));
      expect(t.getSize(surface()).height, lessThanOrEqualTo(640 * 0.85 + 0.01));
      expect(find.text('Confirm'), findsOneWidget, reason: 'rodape visivel');
    });

    testWidgets(
      'botoes quebram de linha em largura muito estreita sem estourar',
      (t) async {
        setSize(t, const Size(260, 500));
        await t.pumpWidget(
          host(
            const SgConfirmationDialog(
              defaultOpen: true,
              message: Text('m'),
              cancelButton: SgConfirmationDialogButtonConfig(
                label: Text('Cancelar a operacao'),
              ),
              confirmButton: SgConfirmationDialogButtonConfig(
                label: Text('Confirmar a operacao'),
              ),
            ),
          ),
        );
        await settle(t);
        expect(t.takeException(), isNull);
      },
    );
  });
}

class _ToggleHost extends StatefulWidget {
  const _ToggleHost({super.key});

  @override
  State<_ToggleHost> createState() => _ToggleHostState();
}

class _ToggleHostState extends State<_ToggleHost> {
  bool open = true;

  void set(bool v) => setState(() => open = v);

  @override
  Widget build(BuildContext context) => SgConfirmationDialog(
    open: open,
    onOpenChange: set,
    message: const Text('m'),
  );
}
