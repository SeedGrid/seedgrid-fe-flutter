import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'pages/modelo_page.dart';
import 'pages/sg_button_page.dart';
import 'pages/sg_input_text_page.dart';

void main() => runApp(const ShowcaseApp());

/// Paginas do showcase. Cada componente portado ganha uma entrada aqui.
final List<({String name, WidgetBuilder builder})> kShowcasePages = [
  (name: 'SgButton', builder: (_) => const SgButtonPage()),
  (name: 'SgInputText', builder: (_) => const SgInputTextPage()),
  (name: 'Página-modelo', builder: (_) => const ModeloPage()),
];

class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  // O SeedThemeProvider fica abaixo do MaterialApp (builder): assim o SgTheme entra no ThemeData
  // que os widgets leem e o claro/escuro troca em tempo de execucao.
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SeedGrid Flutter',
    theme: ThemeData(useMaterial3: true),
    builder: (context, child) => SeedThemeProvider(child: child!),
    home: const ShowcaseHome(),
  );
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({super.key, this.initial = 0});

  final int initial;

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  late int _index = widget.initial;

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
    final page = KeyedSubtree(
      key: ValueKey(_index),
      child: kShowcasePages[_index].builder(context),
    );
    final menu = ListView(
      children: [
        for (var i = 0; i < kShowcasePages.length; i++)
          ListTile(
            key: ValueKey('nav-${kShowcasePages[i].name}'),
            title: Text(kShowcasePages[i].name),
            selected: i == _index,
            onTap: () {
              setState(() => _index = i);
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
