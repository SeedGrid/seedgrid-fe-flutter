import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'pages/pages.g.dart';
import 'src/sg_showcase_page.dart';
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
    builder: (context, child) => SeedThemeProvider(child: child!),
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
  late int _index;
  String? _anchor;

  @override
  void initState() {
    super.initState();
    final uri = widget.initialUri;
    final slug = uri == null || uri.pathSegments.isEmpty
        ? null
        : uri.pathSegments.last;
    final found = slug == null
        ? -1
        : kShowcasePages.indexWhere((p) => showcaseSlug(p.name) == slug);
    _index = found < 0 ? 0 : found;
    // Ancora so vale se a pagina da URL existe.
    _anchor = found < 0 || uri == null || uri.fragment.isEmpty
        ? null
        : uri.fragment;
  }

  /// Escreve `/pagina#ancora` na barra de enderecos (web), sem empilhar historico.
  void _syncUrl() {
    SystemNavigator.routeInformationUpdated(
      uri: Uri(
        path: '/${showcaseSlug(kShowcasePages[_index].name)}',
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
      tooltip: 'Claro / escuro',
      icon: Icon(
        sg.currentMode == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
      ),
      onPressed: () => sg.setMode(
        sg.currentMode == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );
    final page = ShowcaseLocation(
      anchor: _anchor,
      onAnchorChanged: (id) {
        _anchor = id;
        _syncUrl();
      },
      child: KeyedSubtree(
        key: ValueKey(_index),
        child: kShowcasePages[_index].builder(context),
      ),
    );
    final menu = ListView(
      children: [
        for (var i = 0; i < kShowcasePages.length; i++)
          ListTile(
            key: ValueKey('nav-${kShowcasePages[i].name}'),
            title: Text(kShowcasePages[i].name),
            selected: i == _index,
            onTap: () {
              setState(() {
                _index = i;
                _anchor = null;
              });
              _syncUrl();
              if (!wide) Navigator.of(context).maybePop();
            },
          ),
      ],
    );
    return Scaffold(
      appBar: wide
          ? null
          : AppBar(title: Text(kShowcasePages[_index].name), actions: [toggle]),
      drawer: wide ? null : Drawer(child: SafeArea(child: menu)),
      body: SafeArea(
        child: wide
            ? Row(
                children: [
                  SizedBox(
                    width: 220,
                    child: Column(
                      children: [
                        Expanded(child: menu),
                        toggle,
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: page),
                ],
              )
            : page,
      ),
    );
  }
}
