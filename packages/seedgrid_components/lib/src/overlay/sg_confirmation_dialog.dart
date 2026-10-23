// Porte de SgConfirmationDialog (React: src/overlay/SgConfirmationDialog.tsx): um SgDialog com
// mensagem e os botoes cancelar/confirmar. Defaults do React: severity warning, closeable false,
// size sm, sem acento de severidade, fecha ao cancelar e ao confirmar. Os icones padrao de
// severidade (info, aviso, perigo) usam os icones do Material em vez dos SVG do React.
import 'package:flutter/material.dart';

import '../buttons/sg_button.dart';
import '../commons/commons_colors.dart' show tokenChain;
import '../generated/enums.g.dart';
import '../generated/sg_confirmation_dialog.g.dart';
import '../i18n/i18n.dart';
import '../theme_access.dart';
import 'sg_dialog.dart';

/// Configuracao de um dos botoes (`SgConfirmationDialogButtonConfig` do React). `className` nao existe.
class SgConfirmationDialogButtonConfig {
  const SgConfirmationDialogButtonConfig({
    this.label,
    this.icon,
    this.severity,
    this.appearance,
    this.shape,
    this.disabled,
    this.onClick,
  });

  final Widget? label;
  final Widget? icon;
  final SgSeverity? severity;
  final SgAppearance? appearance;
  final SgButtonShape? shape;
  final bool? disabled;
  final VoidCallback? onClick;
}

class SgConfirmationDialog extends StatefulWidget
    implements SgConfirmationDialogProps {
  const SgConfirmationDialog({
    super.key,
    this.open,
    this.defaultOpen = false,
    this.onOpenChange,
    this.onClose,
    this.title,
    this.message,
    this.icon,
    this.iconPlacement = SgConfirmationDialogIconPlacement.left,
    this.severity = SgDialogSeverity.warning,
    this.customColor,
    this.elevation,
    this.showSeverityAccent = false,
    this.cancelButton,
    this.confirmButton,
    this.onCancel,
    this.onConfirm,
    this.closeOnCancel = true,
    this.closeOnConfirm = true,
    this.closeable = false,
    this.size = SgDialogSize.sm,
    this.subtitle,
    this.leading,
    this.trailing,
    this.animation = SgDialogAnimation.zoom,
    this.transitionMs = 160,
    this.autoCloseMs,
    this.overlayClassName,
    this.contentClassName,
    this.headerClassName,
    this.bodyClassName,
    this.footerClassName,
    this.closeOnOverlayClick = true,
    this.closeOnEsc = true,
    this.lockBodyScroll = true,
    this.initialFocusRef,
    this.restoreFocus = true,
    this.ariaLabel,
  });

  @override
  final bool? open;
  @override
  final bool defaultOpen;
  @override
  final ValueChanged<bool>? onOpenChange;
  @override
  final VoidCallback? onClose;
  @override
  final Widget? title;
  @override
  final Widget? message;

  /// `null` usa o icone padrao da severidade (info, warning, danger); sem icone para as demais.
  @override
  final Widget? icon;
  @override
  final SgConfirmationDialogIconPlacement iconPlacement;
  @override
  final SgDialogSeverity severity;
  @override
  final Object? customColor;
  @override
  final Object? elevation;
  @override
  final bool showSeverityAccent;
  @override
  final SgConfirmationDialogButtonConfig? cancelButton;
  @override
  final SgConfirmationDialogButtonConfig? confirmButton;
  @override
  final VoidCallback? onCancel;
  @override
  final VoidCallback? onConfirm;
  @override
  final bool closeOnCancel;
  @override
  final bool closeOnConfirm;
  @override
  final bool closeable;
  @override
  final SgDialogSize size;
  @override
  final Widget? subtitle;
  @override
  final Widget? leading;
  @override
  final Widget? trailing;
  @override
  final SgDialogAnimation animation;
  @override
  final num transitionMs;
  @override
  final num? autoCloseMs;

  /// Sem equivalente (classes CSS): so cumprem o contrato, sem efeito.
  @override
  final String? overlayClassName;
  @override
  final String? contentClassName;
  @override
  final String? headerClassName;
  @override
  final String? bodyClassName;
  @override
  final String? footerClassName;
  @override
  final bool closeOnOverlayClick;
  @override
  final bool closeOnEsc;
  @override
  final bool lockBodyScroll;
  @override
  final FocusNode? initialFocusRef;
  @override
  final bool restoreFocus;
  @override
  final String? ariaLabel;

  @override
  State<SgConfirmationDialog> createState() => _SgConfirmationDialogState();
}

class _SgConfirmationDialogState extends State<SgConfirmationDialog> {
  late bool _openUncontrolled = widget.defaultOpen;
  bool get _open => widget.open ?? _openUncontrolled;

  void _setOpen(bool next) {
    if (widget.open == null) setState(() => _openUncontrolled = next);
    widget.onOpenChange?.call(next);
  }

  void _fireCancel() {
    widget.cancelButton?.onClick?.call();
    widget.onCancel?.call();
  }

  void _handleCancel() {
    _fireCancel();
    if (widget.closeOnCancel) _setOpen(false);
  }

  void _handleConfirm() {
    widget.confirmButton?.onClick?.call();
    widget.onConfirm?.call();
    if (widget.closeOnConfirm) _setOpen(false);
  }

  // Fechar pelo dialogo (Esc, fundo, X) conta como cancelar, igual ao React.
  void _handleDialogOpenChange(bool next) {
    if (!next && _open) _fireCancel();
    _setOpen(next);
  }

  static SgSeverity? _buttonSeverity(SgDialogSeverity s) => switch (s) {
    SgDialogSeverity.primary => SgSeverity.primary,
    SgDialogSeverity.secondary => SgSeverity.secondary,
    SgDialogSeverity.success => SgSeverity.success,
    SgDialogSeverity.info => SgSeverity.info,
    SgDialogSeverity.warning => SgSeverity.warning,
    SgDialogSeverity.help => SgSeverity.help,
    SgDialogSeverity.danger => SgSeverity.danger,
    SgDialogSeverity.plain => null,
  };

  Widget? _defaultSeverityIcon(SgDialogSeverity s) => switch (s) {
    SgDialogSeverity.info => const Icon(
      Icons.info_outline,
      size: 20,
      color: Color(0xFF0284C7),
    ),
    SgDialogSeverity.warning => const Icon(
      Icons.warning_amber_rounded,
      size: 20,
      color: Color(0xFFD97706),
    ),
    SgDialogSeverity.danger => const Icon(
      Icons.cancel_outlined,
      size: 20,
      color: Color(0xFFDC2626),
    ),
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final fg = tokenChain(theme, ['--foreground']);
    final border = tokenChain(theme, ['--border']);
    final muted = tokenChain(theme, ['--muted']);
    final mutedFg = tokenChain(theme, ['--muted-foreground']);
    final cancel = w.cancelButton;
    final confirm = w.confirmButton;

    final cancelLabel =
        cancel?.label ?? Text(t(i18n, 'components.actions.cancel'));
    final confirmLabel =
        confirm?.label ?? Text(t(i18n, 'components.actions.confirm'));
    final resolvedIcon = w.icon ?? _defaultSeverityIcon(w.severity);

    // No React o outline do SgButton usa `bg` como cor do texto: mantem o texto visivel.
    final cancelColors =
        (cancel?.appearance == null && cancel?.severity == null)
        ? SgButtonCustomColors(
            bg: fg,
            fg: fg,
            border: border,
            hoverBg: muted.withValues(alpha: 0.8),
            hoverFg: fg,
            hoverBorder: border,
            activeBg: muted,
          )
        : null;

    final message = DefaultTextStyle.merge(
      style: TextStyle(fontSize: 14, color: mutedFg),
      child: w.message ?? const SizedBox.shrink(),
    );
    final Widget body = resolvedIcon == null
        ? message
        : (w.iconPlacement == SgConfirmationDialogIconPlacement.top
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [resolvedIcon, const SizedBox(height: 12), message],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    resolvedIcon,
                    const SizedBox(width: 12),
                    Expanded(child: message),
                  ],
                ));

    return SgDialog(
      open: _open,
      onOpenChange: _handleDialogOpenChange,
      onClose: w.onClose,
      closeable: w.closeable,
      severity: w.severity,
      showTopAccent: w.showSeverityAccent,
      customColor: w.customColor,
      elevation: w.elevation,
      title: w.title,
      size: w.size,
      subtitle: w.subtitle,
      leading: w.leading,
      trailing: w.trailing,
      animation: w.animation,
      transitionMs: w.transitionMs,
      autoCloseMs: w.autoCloseMs,
      overlayClassName: w.overlayClassName,
      contentClassName: w.contentClassName,
      headerClassName: w.headerClassName,
      bodyClassName: w.bodyClassName,
      footerClassName: w.footerClassName,
      closeOnOverlayClick: w.closeOnOverlayClick,
      closeOnEsc: w.closeOnEsc,
      lockBodyScroll: w.lockBodyScroll,
      initialFocusRef: w.initialFocusRef,
      restoreFocus: w.restoreFocus,
      ariaLabel: w.ariaLabel,
      // Wrap: em tela estreita os botoes passam para a linha de baixo em vez de estourar.
      footer: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          SgButton(
            key: const ValueKey('sg-confirmation-cancel'),
            size: SgSize.sm,
            appearance: cancel?.appearance ?? SgAppearance.outline,
            severity: cancel?.severity ?? SgSeverity.secondary,
            shape: cancel?.shape ?? SgButtonShape.rounded,
            disabled: cancel?.disabled,
            customColors: cancelColors,
            leftIcon: cancel?.icon ?? const Icon(Icons.close),
            onClick: _handleCancel,
            child: cancelLabel,
          ),
          SgButton(
            key: const ValueKey('sg-confirmation-confirm'),
            size: SgSize.sm,
            appearance: confirm?.appearance ?? SgAppearance.solid,
            severity:
                confirm?.severity ??
                _buttonSeverity(w.severity) ??
                SgSeverity.primary,
            shape: confirm?.shape ?? SgButtonShape.rounded,
            disabled: confirm?.disabled,
            leftIcon: confirm?.icon ?? const Icon(Icons.check),
            onClick: _handleConfirm,
            child: confirmLabel,
          ),
        ],
      ),
      child: body,
    );
  }
}
