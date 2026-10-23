// Tipos publicos do SgTreeView (React: src/layout/SgTreeView.tsx): no, no em JSON, trilhas, barra de
// confirmacao e controlador. Mesmos nomes de campo do React.
import 'package:flutter/widgets.dart';

/// No da arvore (`SgTreeNode`). `meta` e livre.
class SgTreeNode {
  const SgTreeNode({
    required this.id,
    required this.label,
    this.icon,
    this.children,
    this.disabled,
    this.meta,
  });

  final String id;
  final String label;
  final Widget? icon;
  final List<SgTreeNode>? children;
  final bool? disabled;
  final Object? meta;
}

/// No em forma de dado (`SgTreeNodeJson`): o icone e o NOME de um icone do registro.
class SgTreeNodeJson {
  const SgTreeNodeJson({
    required this.id,
    required this.label,
    this.icon,
    this.disabled,
    this.checked,
    this.children,
    this.meta,
  });

  final String id;
  final String label;
  final String? icon;
  final bool? disabled;
  final bool? checked;
  final List<SgTreeNodeJson>? children;
  final Object? meta;
}

/// `SgTreeIconRegistry`: nome do icone -> widget.
typedef SgTreeIconRegistry = Map<String, Widget>;

/// Opcao de uma trilha `enum`.
class SgTreeTrackOption {
  const SgTreeTrackOption({required this.value, required this.label});
  final String value;
  final String label;
}

/// Uma coluna extra por linha (`SgTreeTrack`). `width` e um valor CSS (`"140px"`, `"12rem"`);
/// padrao 110px. `label` e o cabecalho da coluna.
sealed class SgTreeTrack {
  const SgTreeTrack({required this.id, this.label, this.width});

  final String id;
  final String? label;
  final String? width;
}

/// Trilha de checkbox com cascata pai -> filhos propria, controlada de fora.
class SgTreeTrackBoolean extends SgTreeTrack {
  const SgTreeTrackBoolean({
    required super.id,
    super.label,
    super.width,
    required this.checkedIds,
    required this.onCheckedChange,
    this.disabled,
    this.ariaLabel,
    this.adornment,
  });

  final List<String> checkedIds;
  final ValueChanged<List<String>> onCheckedChange;
  final bool Function(SgTreeNode node)? disabled;
  final String? ariaLabel;

  /// Conteudo livre ao lado do controle, por no.
  final Widget? Function(SgTreeNode node)? adornment;
}

/// Trilha de lista de opcoes (valor escolhido / sem valor / misto) com cascata.
class SgTreeTrackEnum extends SgTreeTrack {
  const SgTreeTrackEnum({
    required super.id,
    super.label,
    super.width,
    required this.options,
    required this.valueByNodeId,
    required this.onChange,
    this.disabled,
    this.ariaLabel,
    this.placeholder,
    this.mixedLabel,
    this.adornment,
  });

  final List<SgTreeTrackOption> options;
  final Map<String, String?> valueByNodeId;
  final ValueChanged<Map<String, String?>> onChange;
  final bool Function(SgTreeNode node)? disabled;
  final String? ariaLabel;
  final String? placeholder;
  final String? mixedLabel;
  final Widget? Function(SgTreeNode node)? adornment;
}

/// Celula livre alinhada com as outras: a arvore so cede a celula (largura e cabecalho).
class SgTreeTrackCustom extends SgTreeTrack {
  const SgTreeTrackCustom({
    required super.id,
    super.label,
    super.width,
    required this.render,
  });

  final Widget Function(SgTreeNode node) render;
}

/// Barra de confirmacao (`SgTreeConfirmBar`); `null` no `confirmBar` = `false` do React.
class SgTreeConfirmBar {
  const SgTreeConfirmBar({
    required this.onConfirm,
    this.label,
    this.hint,
    this.showCancel,
    this.cancelLabel,
    this.sticky,
    this.disabledWhenEmpty,
    this.resetAfterConfirm,
    this.onCancel,
  });

  final String? label;
  final String? hint;
  final bool? showCancel;
  final String? cancelLabel;

  /// No React so muda o CSS; a barra do Flutter fica sempre fora da area que rola.
  final bool? sticky;
  final bool? disabledWhenEmpty;
  final bool? resetAfterConfirm;
  final ValueChanged<List<String>> onConfirm;
  final VoidCallback? onCancel;
}

/// Equivale a `SgTreeViewRef` do React (`ref` vira `controller`, ADR 50).
class SgTreeViewController {
  SgTreeViewControllerHost? _host;

  void attach(SgTreeViewControllerHost host) => _host = host;
  void detach(SgTreeViewControllerHost host) {
    if (identical(_host, host)) _host = null;
  }

  List<String> getCheckedIds() => _host?.checkedIds ?? const [];
  List<String> getCheckedLeafIds() => _host?.checkedLeafIds ?? const [];
  void setCheckedIds(List<String> ids) => _host?.setChecked(ids);
  List<String> getExpandedIds() => _host?.expandedIds ?? const [];
  void setExpandedIds(List<String> ids) => _host?.setExpanded(ids);
  void expandAll() => _host?.expandAll();
  void collapseAll() => _host?.collapseAll();
  void clearChecked() => _host?.clearChecked();
}

/// Contrato interno entre o estado do widget e o [SgTreeViewController].
abstract interface class SgTreeViewControllerHost {
  List<String> get checkedIds;
  List<String> get checkedLeafIds;
  List<String> get expandedIds;
  void setChecked(List<String> ids);
  void setExpanded(List<String> ids);
  void expandAll();
  void collapseAll();
  void clearChecked();
}
