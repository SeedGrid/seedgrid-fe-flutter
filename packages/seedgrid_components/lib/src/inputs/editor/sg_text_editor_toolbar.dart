// Barra de ferramentas do SgTextEditor: mesma ordem e mesmos rotulos da barra do React.
// Titulo | fonte | tamanho | B I U S | cor do texto, destaque | x2 x^ | marcadores, numerada, recuar, avancar |
// alinhamentos | link, imagem | limpar | Salvar, Carregar HTML.
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../buttons/sg_button.dart';
import '../../generated/enums.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import 'sg_text_editor_commands.dart';

/// Chave dos widgets da barra: `texteditor-<id>-tb-<nome>`.
ValueKey<String> sgTextEditorToolbarKey(String id, String name) =>
    ValueKey('texteditor-$id-tb-$name');

class SgTextEditorToolbar extends StatelessWidget {
  const SgTextEditorToolbar({
    super.key,
    required this.id,
    required this.controller,
    required this.disabled,
    required this.radius,
    required this.onPickColor,
    required this.onLink,
    required this.onImage,
    required this.onSave,
    required this.onLoad,
  });

  final String id;
  final QuillController controller;
  final bool disabled;
  final double radius;

  /// `true` = destaque, `false` = cor do texto.
  final void Function(bool highlight) onPickColor;
  final VoidCallback onLink;
  final VoidCallback onImage;
  final VoidCallback onSave;
  final VoidCallback onLoad;

  static const fonts = <(String, String?)>[
    ('inherit', null),
    ('Arial', 'Arial'),
    ('Georgia', 'Georgia'),
    ('Times New Roman', 'Times'),
    ('Courier New', 'Courier'),
  ];
  static const sizes = ['12px', '14px', '16px', '18px', '24px', '32px'];

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    String tr(String k) => t(i18n, 'components.textEditor.toolbar.$k');
    final narrow = MediaQuery.sizeOf(context).width < 600;
    final size = narrow ? 44.0 : 36.0;
    final c = controller;
    final cmd = SgTextEditorCommands.isActive;

    Widget divider() => Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: theme.inputBorder,
    );

    Widget button(
      String name,
      String label,
      Widget child, {
      bool active = false,
      required VoidCallback onTap,
      bool enabled = true,
    }) {
      final on = enabled && !disabled;
      return Semantics(
        button: true,
        label: label,
        enabled: on,
        selected: active,
        excludeSemantics: true,
        child: Tooltip(
          message: label,
          child: Opacity(
            opacity: on ? 1 : 0.5,
            child: Material(
              color: active ? theme.mutedSurface : theme.inputBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: theme.inputBorder),
              ),
              child: InkWell(
                key: sgTextEditorToolbarKey(id, name),
                canRequestFocus: false,
                borderRadius: BorderRadius.circular(6),
                onTap: on ? onTap : null,
                child: Container(
                  height: size,
                  constraints: BoxConstraints(minWidth: size),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    widthFactor: 1,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(fontSize: 14, color: theme.text),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget menu(
      String name,
      String label,
      String current,
      List<(String, String)> items,
      void Function(String) onSelected,
    ) {
      return Semantics(
        label: label,
        enabled: !disabled,
        child: Opacity(
          opacity: disabled ? 0.5 : 1,
          child: PopupMenuButton<String>(
            key: sgTextEditorToolbarKey(id, name),
            enabled: !disabled,
            tooltip: label,
            onSelected: onSelected,
            itemBuilder: (_) => [
              for (final (value, text) in items)
                PopupMenuItem<String>(
                  key: sgTextEditorToolbarKey(id, '$name-$value'),
                  value: value,
                  child: Text(text),
                ),
            ],
            child: Container(
              height: size,
              padding: const EdgeInsets.only(left: 8, right: 4),
              decoration: BoxDecoration(
                color: theme.inputBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: theme.inputBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    current,
                    style: TextStyle(fontSize: 14, color: theme.text),
                  ),
                  Icon(Icons.arrow_drop_down, size: 18, color: theme.muted),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final h = SgTextEditorCommands.heading(c);
        final headingValue = h != null && h <= 3 ? 'h$h' : 'p';
        final headingItems = <(String, String)>[
          ('h1', t(i18n, 'components.textEditor.toolbar.heading')),
          ('h2', t(i18n, 'components.textEditor.toolbar.subheading')),
          ('p', t(i18n, 'components.textEditor.toolbar.normal')),
          ('h3', t(i18n, 'components.textEditor.toolbar.heading3')),
        ];
        final fontNow =
            c.getSelectionStyle().attributes['font']?.value as String?;
        final fontItems = [
          for (final (v, l) in fonts)
            (v, l ?? t(i18n, 'components.textEditor.toolbar.defaultFont')),
        ];
        final fontLabel = fontItems
            .firstWhere(
              (e) => e.$1 == (fontNow ?? 'inherit'),
              orElse: () => fontItems.first,
            )
            .$2;
        final sizeNow = c.getSelectionStyle().attributes['size']?.value;
        final sizeValue = sizeNow == null ? '16px' : '${sizeNow}px';
        final sizeLabel = sizeValue.replaceAll('px', '');

        Widget align(String name, String value, IconData icon) => button(
          name,
          tr(name),
          Icon(icon, size: 16),
          active: cmd(c, 'align', value),
          onTap: () => SgTextEditorCommands.setTextAlign(c, value),
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.inputBg,
            border: Border(
              top: BorderSide(color: theme.inputBorder),
              left: BorderSide(color: theme.inputBorder),
              right: BorderSide(color: theme.inputBorder),
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              menu(
                'heading',
                tr('heading'),
                headingItems.firstWhere((e) => e.$1 == headingValue).$2,
                headingItems,
                (v) => SgTextEditorCommands.setHeading(c, v),
              ),
              menu(
                'font',
                tr('defaultFont'),
                fontLabel,
                fontItems,
                (v) => SgTextEditorCommands.setFontFamily(c, v),
              ),
              menu(
                'size',
                tr('defaultFont'),
                sizeLabel,
                [for (final s in sizes) (s, s.replaceAll('px', ''))],
                (v) => SgTextEditorCommands.setFontSize(c, v),
              ),
              divider(),
              button(
                'bold',
                tr('bold'),
                const Text('B', style: TextStyle(fontWeight: FontWeight.bold)),
                active: cmd(c, 'bold'),
                onTap: () => SgTextEditorCommands.toggleBold(c),
              ),
              button(
                'italic',
                tr('italic'),
                const Text('I', style: TextStyle(fontStyle: FontStyle.italic)),
                active: cmd(c, 'italic'),
                onTap: () => SgTextEditorCommands.toggleItalic(c),
              ),
              button(
                'underline',
                tr('underline'),
                const Text(
                  'U',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                active: cmd(c, 'underline'),
                onTap: () => SgTextEditorCommands.toggleUnderline(c),
              ),
              button(
                'strike',
                tr('strike'),
                const Text(
                  'S',
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
                active: cmd(c, 'strike'),
                onTap: () => SgTextEditorCommands.toggleStrike(c),
              ),
              divider(),
              button(
                'textColor',
                tr('textColor'),
                const Icon(Icons.palette_outlined, size: 16),
                onTap: () => onPickColor(false),
              ),
              button(
                'highlightColor',
                tr('highlightColor'),
                const Icon(Icons.border_color_outlined, size: 16),
                onTap: () => onPickColor(true),
              ),
              divider(),
              button(
                'subscript',
                tr('subscript'),
                const Text('x2'),
                active: cmd(c, 'script', 'sub'),
                onTap: () => SgTextEditorCommands.toggleSubscript(c),
              ),
              button(
                'superscript',
                tr('superscript'),
                const Text('x^'),
                active: cmd(c, 'script', 'super'),
                onTap: () => SgTextEditorCommands.toggleSuperscript(c),
              ),
              divider(),
              button(
                'bullets',
                tr('bullets'),
                const Icon(Icons.format_list_bulleted, size: 16),
                active: cmd(c, 'list', 'bullet'),
                onTap: () => SgTextEditorCommands.toggleList(c, 'bullet'),
              ),
              button(
                'numbered',
                tr('numbered'),
                const Icon(Icons.format_list_numbered, size: 16),
                active: cmd(c, 'list', 'ordered'),
                onTap: () => SgTextEditorCommands.toggleList(c, 'ordered'),
              ),
              button(
                'outdent',
                tr('outdent'),
                const Icon(Icons.format_indent_decrease, size: 16),
                onTap: () => SgTextEditorCommands.outdent(c),
              ),
              button(
                'indent',
                tr('indent'),
                const Icon(Icons.format_indent_increase, size: 16),
                onTap: () => SgTextEditorCommands.indent(c),
              ),
              divider(),
              align('alignLeft', 'left', Icons.format_align_left),
              align('alignCenter', 'center', Icons.format_align_center),
              align('alignRight', 'right', Icons.format_align_right),
              align('justify', 'justify', Icons.format_align_justify),
              divider(),
              button(
                'link',
                tr('link'),
                Text(tr('link')),
                active: cmd(c, 'link'),
                onTap: onLink,
              ),
              button(
                'image',
                tr('image'),
                const Icon(Icons.image_outlined, size: 16),
                onTap: onImage,
              ),
              divider(),
              button(
                'clear',
                tr('clear'),
                const Text('X'),
                onTap: () => SgTextEditorCommands.clearFormatting(c),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SgButton(
                    key: sgTextEditorToolbarKey(id, 'save'),
                    severity: SgSeverity.secondary,
                    appearance: SgAppearance.outline,
                    label: Text(t(i18n, 'components.actions.save')),
                    disabled: disabled,
                    onClick: onSave,
                  ),
                  const SizedBox(width: 8),
                  SgButton(
                    key: sgTextEditorToolbarKey(id, 'loadHtml'),
                    severity: SgSeverity.secondary,
                    appearance: SgAppearance.outline,
                    label: Text(t(i18n, 'components.actions.loadHtml')),
                    disabled: disabled,
                    onClick: onLoad,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
