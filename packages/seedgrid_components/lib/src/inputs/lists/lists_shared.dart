// Pecas compartilhadas de SgPickList e SgOrderList: ligacao a formulario (name + control), props do
// SgGroupBox, item da lista, campo de filtro e coluna de botoes.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../buttons/sg_button.dart';
import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../theme_access.dart';

/// Liga o campo ao SgFormController, como o `<Controller>` do React: valor e erro vem do formulario e
/// as mudancas voltam para ele. Cada State cria um, chama [bind] em didChangeDependencies/didUpdateWidget
/// e [dispose] no fim.
class ListFieldBinding {
  ListFieldBinding(this._notify);

  final VoidCallback _notify;
  SgFormController? form;
  String? name;

  bool get bound => name != null && form != null;
  Object? get value => bound ? form!.getValue(name!) : null;
  String? get errorMessage => bound ? form!.errorOf(name!)?.message : null;

  void bind(
    BuildContext context, {
    required SgFormController? control,
    required String? name,
    required SgRules? rules,
  }) {
    final f = control ?? SgForm.maybeOf(context);
    if (f != form) {
      form?.removeListener(_notify);
      form = f;
      form?.addListener(_notify);
    }
    this.name = name;
    if (bound) form!.registerField(name!, rules: rules);
  }

  /// Grava no formulario; depois de um envio (ou com erro) revalida a cada mudanca, como o RHF.
  Future<void> set(Object? v) async {
    if (!bound) return;
    final revalidate = form!.errorOf(name!) != null || form!.submitCount > 0;
    await form!.setValue(name!, v, shouldValidate: revalidate);
  }

  void dispose() => form?.removeListener(_notify);
}

/// `groupBoxProps` do React: o que se pode repassar ao SgGroupBox (titulo, largura e altura).
class SgListGroupBoxProps {
  const SgListGroupBoxProps({this.title, this.width, this.height});

  final String? title;

  /// Numero (px), 'Npx' ou 'N%'; padrao 100%.
  final Object? width;
  final Object? height;
}

/// Titulo da caixa: `groupBoxProps.title ?? title ?? ''`, e um espaco se vier vazio (o React faz o mesmo
/// para a legenda nao colapsar).
String listBoxTitle(String? title, SgListGroupBoxProps? box) {
  final t = (box?.title ?? title ?? '').trim();
  return t.isEmpty ? ' ' : t;
}

const Color kListErrorColor = Color(0xFFDC2626);

/// Item da lista (`<button role="option">` do React): fundo e borda por estado, texto e marca de arrastar.
class ListEntryTile extends StatefulWidget {
  const ListEntryTile({
    super.key,
    required this.child,
    required this.selected,
    required this.disabled,
    required this.showHandle,
    this.dropHighlight = false,
    this.dimmed = false,
    this.onTap,
    this.focusNode,
    this.onKeyEvent,
    this.semanticsLabel,
  });

  final Widget child;
  final bool selected;

  /// Item desabilitado (o do item ou o do componente): esmaecido e sem clique.
  final bool disabled;

  /// Mostra a marca `::` de arrastar.
  final bool showHandle;

  /// Destino de soltura sob o dedo (anel de 2px).
  final bool dropHighlight;

  /// Item sendo arrastado (opacidade 50%).
  final bool dimmed;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final KeyEventResult Function(FocusNode node, KeyEvent event)? onKeyEvent;
  final String? semanticsLabel;

  @override
  State<ListEntryTile> createState() => _ListEntryTileState();
}

class _ListEntryTileState extends State<ListEntryTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final selected = widget.selected;
    final Color bg = selected
        ? t.primary100
        : (_hover && !widget.disabled ? t.primary50 : t.inputBg);
    final border = widget.dropHighlight
        ? Border.all(color: t.primary400, width: 2)
        : Border.all(color: selected ? t.primary300 : Colors.transparent);
    final body = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.symmetric(
        horizontal: widget.dropHighlight ? 11 : 12,
        vertical: widget.dropHighlight ? 7 : 8,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: border,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: DefaultTextStyle.merge(
              style: TextStyle(fontSize: 14, color: t.text),
              child: widget.child,
            ),
          ),
          if (widget.showHandle)
            ExcludeSemantics(
              child: Text('::', style: TextStyle(fontSize: 12, color: t.muted)),
            ),
        ],
      ),
    );
    return Semantics(
      container: true,
      selected: selected,
      button: true,
      enabled: !widget.disabled,
      label: widget.semanticsLabel,
      child: Focus(
        focusNode: widget.focusNode,
        canRequestFocus: !widget.disabled,
        onKeyEvent: widget.onKeyEvent,
        child: Opacity(
          opacity: widget.dimmed ? 0.5 : (widget.disabled ? 0.6 : 1),
          child: MouseRegion(
            cursor: widget.disabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.disabled ? null : widget.onTap,
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}

/// Moldura da lista (`<ul role="listbox">`): borda, fundo, 4px de padding e altura maxima de 22rem.
class ListFrame extends StatelessWidget {
  const ListFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    return Container(
      constraints: const BoxConstraints(maxHeight: 352),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [child],
        ),
      ),
    );
  }
}

/// Texto de lista vazia.
class ListEmpty extends StatelessWidget {
  const ListEmpty({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    child: Text(
      message,
      style: TextStyle(fontSize: 14, color: sgThemeOf(context).muted),
    ),
  );
}

/// Campo de filtro (`<input>` simples do React).
class ListFilterField extends StatelessWidget {
  const ListFilterField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: t.border),
    );
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(fontSize: 14, color: t.inputFg),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(color: t.inputPlaceholder),
        isDense: true,
        filled: true,
        fillColor: t.inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        enabledBorder: border,
        border: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: t.ring, width: 2),
        ),
      ),
    );
  }
}

/// Botao pequeno de contorno com dica e rotulo de acessibilidade (os botoes de mover do React).
class ListControlButton extends StatelessWidget {
  const ListControlButton({
    super.key,
    required this.label,
    required this.tooltip,
    required this.onClick,
    this.disabled = false,
  });

  final String label;
  final String tooltip;
  final VoidCallback onClick;
  final bool disabled;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Semantics(
      label: tooltip,
      excludeSemantics: true,
      button: true,
      enabled: !disabled,
      child: SgButton(
        size: SgSize.sm,
        appearance: SgAppearance.outline,
        disabled: disabled,
        onClick: onClick,
        label: Text(label),
      ),
    ),
  );
}

/// Teclas modificadoras atuais (o `event.shiftKey/ctrlKey/metaKey` do React).
class ListModifiers {
  const ListModifiers._();

  static bool get shift => HardwareKeyboard.instance.isShiftPressed;
  static bool get ctrlOrMeta =>
      HardwareKeyboard.instance.isControlPressed ||
      HardwareKeyboard.instance.isMetaPressed;
}
