// Tipos de dados do SgMenu (React: `SgMenuNode`, `SgMenuSelection`, `SgMenuBrand`, `SgMenuUser`, `search`).
// Mesmos nomes de campo do React; `icon`/`image`/`avatar` sao `Widget` (no React, `ReactNode`).
import 'package:flutter/widgets.dart';

/// Item do menu (`SgMenuNode` do React). `badge` e texto ou numero.
class SgMenuNode {
  const SgMenuNode({
    required this.id,
    required this.label,
    this.hint,
    this.url,
    this.children,
    this.disabled = false,
    this.icon,
    this.badge,
    this.onClick,
  });

  final String id;
  final String label;

  /// Dica exibida ao passar o mouse (ou manter pressionado); com o menu recolhido, o `label` vira a dica.
  final String? hint;
  final String? url;
  final List<SgMenuNode>? children;
  final bool disabled;
  final Widget? icon;

  /// `string | number` no React.
  final Object? badge;
  final VoidCallback? onClick;

  bool get hasChildren => children != null && children!.isNotEmpty;

  /// `Boolean(node.url || node.onClick)`: o item tem destino ou acao propria.
  bool get hasActionTarget =>
      (url != null && url!.isNotEmpty) || onClick != null;

  SgMenuNode copyWith({
    List<SgMenuNode>? children,
    bool clearChildren = false,
  }) => SgMenuNode(
    id: id,
    label: label,
    hint: hint,
    url: url,
    children: clearChildren ? null : (children ?? this.children),
    disabled: disabled,
    icon: icon,
    badge: badge,
    onClick: onClick,
  );
}

/// Selecao ativa por id ou por url (`SgMenuSelection`).
class SgMenuSelection {
  const SgMenuSelection({this.activeId, this.activeUrl});

  final String? activeId;
  final String? activeUrl;
}

/// Bloco de marca no topo (`SgMenuBrand`). `imageSrc` e uma URL de rede.
class SgMenuBrand {
  const SgMenuBrand({this.title, this.imageSrc, this.image, this.onClick});

  final String? title;
  final String? imageSrc;
  final Widget? image;
  final VoidCallback? onClick;
}

/// Bloco do usuario (`SgMenuUser`). `avatarSrc` e uma URL de rede.
class SgMenuUser {
  const SgMenuUser({
    required this.name,
    this.subtitle,
    this.avatarSrc,
    this.avatar,
    this.onClick,
  });

  final String name;
  final String? subtitle;
  final String? avatarSrc;
  final Widget? avatar;
  final VoidCallback? onClick;
}

/// Busca integrada (`search: { enabled, placeholder }`).
class SgMenuSearch {
  const SgMenuSearch({required this.enabled, this.placeholder});

  final bool enabled;
  final String? placeholder;
}
