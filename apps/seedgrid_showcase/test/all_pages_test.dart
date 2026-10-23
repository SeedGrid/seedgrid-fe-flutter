// Testes de aceite automaticos para TODA pagina registrada em kShowcasePages (gerado por
// tools/showcase_snippets/extract.mjs): ancoras, tabela de props, codigo 1:1, playground.
import 'package:seedgrid_showcase/pages/pages.g.dart';

import 'support/page_checks.dart';

void main() {
  for (final page in kShowcasePages) {
    definePageChecks(page);
  }
}
