import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_components/seedgrid_components.dart'
    show
        SgEnvironmentPartial,
        NamespaceProvider,
        SgEnvironmentProvider,
        SgPersistencePartial,
        SgToastHost;
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'pages/pages.g.dart';
import 'src/home_page.dart';
import 'src/showcase_extra_pages.dart';
import 'src/showcase_i18n.dart';
import 'src/sg_showcase_page.dart';
import 'src/showcase_menu.dart';
import 'src/theme_panel.dart';
import 'src/url_strategy.dart';

void main() {
  configureUrlStrategy();
  runApp(const ShowcaseApp());
}

/// Slug da pagina na URL: `SgInputText` -> `sg-input-text`.
String showcaseSlug(String name) => name
    .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]}-${m[2]}')
    .replaceAllMapped(RegExp(r'([A-Z]+)([A-Z][a-z])'), (m) => '${m[1]}-${m[2]}')
    .toLowerCase();

String? _namespace() => 'showcase';

class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({
    super.key,
    this.initialUri,
    this.initialMenuCollapsed = true,
  });

  /// Como no React, o menu abre recolhido (so icones); o estado nao e lembrado entre recargas.
  final bool initialMenuCollapsed;

  /// URL de entrada (`/sg-button#exemplo-3`). Padrao: a URL do navegador na web.
  final Uri? initialUri;

  // O SeedThemeProvider fica abaixo do MaterialApp (builder): assim o SgTheme entra no ThemeData
  // que os widgets leem e o claro/escuro troca em tempo de execucao.
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SeedGrid Components for Flutter',
    theme: ThemeData(useMaterial3: true),
    // O SgEnvironmentProvider liga a persistencia dos componentes (ex.: ordem e visibilidade das colunas do SgDatatable
    // com `id`). Sem namespace nada e lido nem gravado: um app real usa o tenant/usuario; o showcase usa um fixo.
    builder: (context, child) => SgEnvironmentProvider(
      value: const SgEnvironmentPartial(
        namespaceProvider: NamespaceProvider(_namespace),
        persistence: SgPersistencePartial(scope: 'app:seedgrid-showcase'),
      ),
      child: ShowcaseI18nScope(child: SeedThemeProvider(child: child!)),
    ),
    home: ShowcaseHome(
      initialUri: initialUri ?? (kIsWeb ? Uri.base : Uri()),
      initialMenuCollapsed: initialMenuCollapsed,
    ),
  );
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({
    super.key,
    this.initialUri,
    this.initialMenuCollapsed = true,
  });

  final Uri? initialUri;
  final bool initialMenuCollapsed;

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  /// Nome da pagina aberta; nulo = pagina inicial.
  String? _page;
  String? _anchor;
  late bool _menuCollapsed = widget.initialMenuCollapsed;

  @override
  void initState() {
    super.initState();
    final uri = widget.initialUri;
    final slug = uri == null || uri.pathSegments.isEmpty
        ? null
        : uri.pathSegments.last;
    final fixed = kFixedPageSlugs.entries
        .where((e) => e.value == slug)
        .firstOrNull
        ?.key;
    final found = slug == null
        ? null
        : kShowcasePages.where((p) => showcaseSlug(p.name) == slug).firstOrNull;
    _page = fixed ?? found?.name;
    // Ancora so vale se a pagina da URL existe.
    _anchor = (found == null) || uri == null || uri.fragment.isEmpty
        ? null
        : uri.fragment;
  }

  String _slugOf(String page) => kFixedPageSlugs[page] ?? showcaseSlug(page);

  /// Escreve `/pagina#ancora` na barra de enderecos (web), sem empilhar historico.
  void _syncUrl() {
    SystemNavigator.routeInformationUpdated(
      uri: Uri(
        path: _page == null ? '/' : '/${_slugOf(_page!)}',
        fragment: _anchor,
      ),
      replace: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final sg = useSgTheme(context);
    final toggle = IconButton(
      key: const ValueKey('alternar-tema'),
      tooltip: context.tr('toggleTheme'),
      visualDensity: VisualDensity.compact,
      icon: Icon(
        sg.currentMode == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
      ),
      onPressed: () => sg.setMode(
        sg.currentMode == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );
    final entry = _page == null
        ? null
        : kShowcasePages.where((p) => p.name == _page).firstOrNull;
    final Widget content = _page == kThemePage
        ? const ShowcaseThemePage()
        : _page == kCreditsPage
        ? const ShowcaseCreditsPage()
        : entry == null
        ? ShowcaseHomePage(
            onOpen: (name) {
              setState(() {
                _page = name;
                _anchor = null;
              });
              _syncUrl();
            },
          )
        : ShowcaseLocation(
            anchor: _anchor,
            onAnchorChanged: (id) {
              _anchor = id;
              _syncUrl();
            },
            child: KeyedSubtree(
              key: ValueKey(entry.name),
              child: entry.builder(context),
            ),
          );
    final menu = ShowcaseMenu(
      selected: _page == kThemePage || _page == kCreditsPage
          ? _page
          : entry?.name,
      collapsed: wide && _menuCollapsed,
      showCollapseButton: wide,
      onCollapsedChange: (v) => setState(() => _menuCollapsed = v),
      onSelect: (name) {
        setState(() {
          _page = name;
          _anchor = null;
        });
        _syncUrl();
        if (!wide) Navigator.of(context).maybePop();
      },
    );
    // Teclado: o primeiro Tab cai no menu (antes da barra e da faixa de idioma), que e a navegacao principal.
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Scaffold(
        // Tema e claro/escuro ficam na linha do idioma (acima da barra), como no React.
        appBar: AppBar(
          title: Text(
            _page == kThemePage
                ? context.tr('themeSystem')
                : _page == kCreditsPage
                ? context.tr('creditsLicenses')
                : entry?.name ?? context.tr('home'),
          ),
        ),
        drawer: wide ? null : Drawer(child: SafeArea(child: menu)),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Column(
                children: [
                  ShowcaseLanguagePicker(
                    trailing: [
                      IconButton(
                        key: const ValueKey('abrir-tema'),
                        tooltip: context.tr('theme'),
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.palette_outlined),
                        onPressed: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          builder: (_) => const SafeArea(
                            child: SingleChildScrollView(
                              child: ShowcaseThemeEditor(),
                            ),
                          ),
                        ),
                      ),
                      toggle,
                    ],
                  ),
                  Expanded(
                    child: wide
                        ? Row(
                            children: [
                              AnimatedSize(
                                duration: const Duration(milliseconds: 150),
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: _menuCollapsed ? 56 : 280,
                                  child: FocusTraversalOrder(
                                    order: const NumericFocusOrder(0),
                                    child: menu,
                                  ),
                                ),
                              ),
                              const VerticalDivider(width: 1),
                              Expanded(child: content),
                            ],
                          )
                        : content,
                  ),
                ],
              ),
            ),
            // Host global de toasts: qualquer pagina dispara `toast(...)` sem host local. O SgToaster
            // tem a propria pagina com um toaster solto configuravel, entao ali o host global sai.
            if (entry?.name != 'SgToaster') const SgToastHost(),
          ],
        ),
      ),
    );
  }
}
