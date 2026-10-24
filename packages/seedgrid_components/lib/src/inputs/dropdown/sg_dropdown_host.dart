// Superficie compartilhada dos dropdowns (SgCombobox, SgAutocomplete, SgMultiSelect, SgMultiSelectChips).
//
// Regra do dono (ADR 51, mobile-first): em tela estreita (largura < [kSgSelectNarrowWidth]) a lista abre como
// painel de baixo; em tela larga abre ancorada ao campo (OverlayPortal + CompositedTransformFollower).
// Aqui ficam so os encanamentos: portal, ancora, toque fora, troca estreito/largo e o bottom sheet modal.
// O conteudo (lista de opcoes, busca, rodape) e o estilo das superficies sao de cada componente.
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Largura abaixo da qual a lista vira painel de baixo (bottom sheet).
const double kSgSelectNarrowWidth = 600;

/// A lista cabe como painel de baixo? (largura < 600)
bool sgSelectNarrow(BuildContext context) =>
    MediaQuery.sizeOf(context).width < kSgSelectNarrowWidth;

/// `maxWidth: min(32rem, 100vw - 24px)` do React: largura maxima do popup ancorado.
double sgDropdownMaxWidth(double screenWidth) =>
    math.min(512, screenWidth - 24);

/// Envolve o campo ([field]) e mostra a lista quando [open] e verdadeiro.
///
/// - Largo: [popup] fica ancorado abaixo do campo (recebe a largura medida do campo).
/// - Estreito, [modalSheet] falso: [panel] vira painel de baixo colado acima do teclado (sem rota).
/// - Estreito, [modalSheet] verdadeiro: [sheet] abre num `showModalBottomSheet`; se a largura mudar com a lista
///   aberta, chama [onNarrowChanged] para fechar e reabrir na superficie certa; se o modal fechar por gesto,
///   chama [onModalDismissed].
class SgDropdownHost extends StatefulWidget {
  const SgDropdownHost({
    super.key,
    required this.open,
    required this.field,
    required this.popup,
    required this.onOutsideTap,
    this.panel,
    this.sheet,
    this.modalSheet = false,
    this.onNarrowChanged,
    this.onModalDismissed,
  }) : assert(modalSheet ? sheet != null : panel != null);

  final bool open;
  final Widget field;

  /// Popup ancorado (largura do campo medida).
  final Widget Function(BuildContext context, double fieldWidth) popup;

  /// Painel de baixo sem rota (usado quando [modalSheet] e falso).
  final WidgetBuilder? panel;

  /// Conteudo do bottom sheet modal (usado quando [modalSheet] e verdadeiro).
  final WidgetBuilder? sheet;
  final bool modalSheet;

  /// Toque fora do campo e da lista (so chamado quando aberto e sem modal).
  final VoidCallback onOutsideTap;
  final VoidCallback? onNarrowChanged;
  final VoidCallback? onModalDismissed;

  @override
  State<SgDropdownHost> createState() => _SgDropdownHostState();
}

class _SgDropdownHostState extends State<SgDropdownHost> {
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  final Object _group = Object();
  BuildContext? _sheetContext;
  bool _sheetShown = false;
  bool? _narrowWhenOpened;

  bool get _narrow => sgSelectNarrow(context);
  bool get _modalActive => widget.modalSheet && _narrowWhenOpened == true;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(SgDropdownHost old) {
    super.didUpdateWidget(old);
    _sync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Girou o aparelho / mudou a largura com a lista aberta: fecha para reabrir na superficie certa.
    if (widget.modalSheet &&
        widget.open &&
        _narrowWhenOpened != null &&
        _narrowWhenOpened != _narrow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onNarrowChanged?.call();
      });
    }
  }

  @override
  void dispose() {
    if (_portal.isShowing) _portal.hide();
    super.dispose();
  }

  void _sync() {
    // OverlayPortalController.show/hide e a rota do sheet nao podem rodar durante o build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.open) {
        _narrowWhenOpened ??= _narrow;
        if (_modalActive) {
          if (!_sheetShown) _openSheet();
        } else if (!_portal.isShowing) {
          _portal.show();
        }
      } else {
        _narrowWhenOpened = null;
        if (_portal.isShowing) _portal.hide();
        if (_sheetShown) _closeSheet();
      }
    });
  }

  void _openSheet() {
    _sheetShown = true;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        _sheetContext = sheetContext;
        return widget.sheet!(sheetContext);
      },
    ).whenComplete(() {
      _sheetShown = false;
      _sheetContext = null;
      // Fechou por gesto (arrastar/tocar fora): sincroniza o estado.
      if (mounted && widget.open) widget.onModalDismissed?.call();
    });
  }

  void _closeSheet() {
    final ctx = _sheetContext;
    _sheetShown = false;
    if (ctx != null && ctx.mounted) Navigator.of(ctx).pop();
  }

  Widget _surface(BuildContext context) {
    if (sgSelectNarrow(context)) {
      // O contexto do OverlayPortal fica dentro do Scaffold, que remove o viewInsets do MediaQuery; o teclado
      // real vem da janela.
      final view = View.of(context);
      final keyboard = view.viewInsets.bottom / view.devicePixelRatio;
      return TapRegion(
        groupId: _group,
        child: TextFieldTapRegion(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: keyboard),
              child: widget.panel!(context),
            ),
          ),
        ),
      );
    }
    final fieldBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldWidth = fieldBox != null && fieldBox.hasSize
        ? fieldBox.size.width
        : 0.0;
    return TapRegion(
      groupId: _group,
      child: TextFieldTapRegion(
        child: CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 4),
          showWhenUnlinked: false,
          child: Align(
            alignment: Alignment.topLeft,
            child: widget.popup(context, fieldWidth),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => OverlayPortal(
    controller: _portal,
    overlayChildBuilder: _surface,
    child: TapRegion(
      groupId: _group,
      // No modal quem fecha e a propria rota.
      onTapOutside: widget.open && !_modalActive
          ? (_) => widget.onOutsideTap()
          : null,
      child: CompositedTransformTarget(
        link: _link,
        child: KeyedSubtree(key: _fieldKey, child: widget.field),
      ),
    ),
  );
}
