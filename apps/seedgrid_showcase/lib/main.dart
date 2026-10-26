import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_components/seedgrid_components.dart' show SgToastHost;
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'pages/pages.g.dart';
import 'src/home_page.dart';
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

class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key, this.initialUri});

  /// URL de entrada (`/sg-button#exemplo-3`). Padrao: a URL do navegador na web.
  final Uri? initialUri;

  // O SeedThemeProvider fica abaixo do MaterialApp (builder): assim o SgTheme entra no ThemeData
  // que os widgets leem e o claro/escuro troca em tempo de execucao.
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SeedGrid Flutter',
    theme: ThemeData(useMaterial3: true),
    builder: (context, child) =>
        ShowcaseI18nScope(child: SeedThemeProvider(child: child!)),
    home: ShowcaseHome(initialUri: initialUri ?? (kIsWeb ? Uri.base : Uri())),
  );
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({super.key, this.initialUri});

  final Uri? initialUri;

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  /// Nome da pagina aberta; nulo = pagina inicial.
  String? _page;
  String? _anchor;

  @override
  void initState() {
    super.initState();
    final uri = widget.initialUri;
    final slug = uri == null || uri.pathSegments.isEmpty
        ? null
        : uri.pathSegments.last;
    final found = slug == null
        ? null
        : kShowcasePages.where((p) => showcaseSlug(p.name) == slug).firstOrNull;
    _page = found?.name;
    // Ancora so vale se a pagina da URL existe.
    _anchor = found == null || uri == null || uri.fragment.isEmpty
        ? null
        : uri.fragment;
  }

  /// Escreve `/pagina#ancora` na barra de enderecos (web), sem empilhar historico.
  void _syncUrl() {
    SystemNavigator.routeInformationUpdated(
      uri: Uri(
        path: _page == null ? '/' : '/${showcaseSlug(_page!)}',
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
    final Widget content = entry == null
        ? const ShowcaseHomePage()
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
      selected: entry?.name,
      footer: const ShowcaseThemePanel(),
      onSelect: (name) {
        setState(() {
          _page = name;
          _anchor = null;
        });
        _syncUrl();
        if (!wide) Navigator.of(context).maybePop();
      },
    );
    return Scaffold(
      appBar: wide
          ? null
          : AppBar(
              title: Text(entry?.name ?? context.tr('home')),
              actions: [
                IconButton(
                  key: const ValueKey('abrir-tema'),
                  tooltip: context.tr('theme'),
                  icon: const Icon(Icons.palette_outlined),
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (_) => const SafeArea(
                      child: SingleChildScrollView(child: ShowcaseThemePanel()),
                    ),
                  ),
                ),
                toggle,
              ],
            ),
      drawer: wide ? null : Drawer(child: SafeArea(child: menu)),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: wide
                ? Row(
                    children: [
                      SizedBox(
                        width: 260,
                        child: Column(
                          children: [
                            Expanded(child: menu),
                            toggle,
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(child: content),
                    ],
                  )
                : content,
          ),
          // Host global de toasts: qualquer pagina dispara `toast(...)` sem host local. O SgToaster
          // tem a propria pagina com um toaster solto configuravel, entao ali o host global sai.
          if (entry?.name != 'SgToaster') const SgToastHost(),
        ],
      ),
    );
  }
}
