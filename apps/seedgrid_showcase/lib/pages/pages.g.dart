// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Registro das paginas do showcase (menu do app e testes automaticos).

import 'package:flutter/widgets.dart';

import 'sg_button_page.dart';
import 'sg_input_text_page.dart';
import 'modelo_page.dart';

/// Uma pagina do showcase. `examples` = numero de regioes `// #region` do arquivo (links esperados).
typedef ShowcasePageEntry = ({String name, String file, int examples, WidgetBuilder builder});

final List<ShowcasePageEntry> kShowcasePages = <ShowcasePageEntry>[
  (name: 'SgButton', file: 'lib/pages/sg_button_page.dart', examples: 5, builder: (_) => const SgButtonPage()),
  (name: 'SgInputText', file: 'lib/pages/sg_input_text_page.dart', examples: 5, builder: (_) => const SgInputTextPage()),
  (name: 'Modelo', file: 'lib/pages/modelo_page.dart', examples: 6, builder: (_) => const ModeloPage()),
];
