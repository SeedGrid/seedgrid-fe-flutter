// Porte de @seedgrid/fe-theme src/theme/componentTokens.ts.
// A paridade com o TypeScript e conferida por test/parity.

import 'color_utils.dart';
import 'theme_config.dart';

/// Equivale a `generateComponentTokens(baseVars)`: aliases por componente
/// (`--sg-btn-primary-bg`, `--sg-input-border`...) sobre as variaveis base.
ThemeVars generateComponentTokens(ThemeVars baseVars) {
  final c = <String, String>{};

  String rgb(String name) {
    final v = baseVars[name];
    return (v != null && v.isNotEmpty) ? 'rgb($v)' : '';
  }

  // Botao de severidade: fundo (tom 600), hover (700) e active (800). Se o melhor texto sobre o fundo ficar < 4,5:1,
  // o fundo e ajustado (adjustBgForOnColor) e o texto de cada estado e escolhido por contraste sobre o PROPRIO
  // fundo daquele estado. Sem fundo valido, cai no --sg-on-* informado (normal) ou no texto do estado normal.
  ({String bg, String fg})? stateColors(String varName) {
    final m = RegExp(
      r'^\s*(\d+)\s+(\d+)\s+(\d+)\s*$',
    ).firstMatch(baseVars[varName] ?? '');
    if (m == null) return null;
    final bgHex = adjustBgForOnColor(
      rgbToHex(
        double.parse(m.group(1)!),
        double.parse(m.group(2)!),
        double.parse(m.group(3)!),
      ),
    );
    return (
      bg: 'rgb(${toRgbVarValue(bgHex)})',
      fg: 'rgb(${toRgbVarValue(pickOnColor(bgHex))})',
    );
  }

  void severity(String tokenName, String scale, String on) {
    final normal = stateColors('--sg-$scale-600');
    final hover = stateColors('--sg-$scale-700');
    final active = stateColors('--sg-$scale-800');
    final normalBg = normal?.bg ?? rgb('--sg-$scale-600');
    final normalFg = normal?.fg ?? rgb(on);
    c['--sg-btn-$tokenName-bg'] = normalBg;
    c['--sg-btn-$tokenName-fg'] = normalFg;
    c['--sg-btn-$tokenName-border'] = normalBg;
    c['--sg-btn-$tokenName-hover-bg'] = hover?.bg ?? rgb('--sg-$scale-700');
    c['--sg-btn-$tokenName-hover-fg'] = hover?.fg ?? normalFg;
    c['--sg-btn-$tokenName-active-bg'] = active?.bg ?? rgb('--sg-$scale-800');
    c['--sg-btn-$tokenName-active-fg'] = active?.fg ?? normalFg;
    c['--sg-btn-$tokenName-ring'] = rgb('--sg-$scale-400');
  }

  severity('primary', 'primary', '--sg-on-primary');
  severity('secondary', 'secondary', '--sg-on-secondary');
  severity('success', 'success', '--sg-on-success');
  severity('info', 'info', '--sg-on-info');
  severity('warning', 'warning', '--sg-on-warning');
  severity('danger', 'error', '--sg-on-error');
  // Help usa o terciario, para melhor visibilidade.
  severity('help', 'tertiary', '--sg-on-tertiary');

  // Plain/Ghost
  c['--sg-btn-plain-bg'] = 'transparent';
  c['--sg-btn-plain-fg'] = rgb('--sg-text');
  c['--sg-btn-plain-border'] = rgb('--sg-border');
  c['--sg-btn-plain-hover-bg'] = rgb('--sg-muted-surface');
  c['--sg-btn-plain-active-bg'] = rgb('--sg-border');
  c['--sg-btn-plain-ring'] = rgb('--sg-ring');

  // Input
  c['--sg-input-bg'] = rgb('--sg-surface');
  c['--sg-input-fg'] = rgb('--sg-text');
  c['--sg-input-border'] = rgb('--sg-border');
  c['--sg-input-border-hover'] = rgb('--sg-primary-400');
  c['--sg-input-border-focus'] = rgb('--sg-primary-600');
  c['--sg-input-ring'] = rgb('--sg-ring');
  c['--sg-input-placeholder'] = rgb('--sg-muted');
  c['--sg-input-disabled-bg'] = rgb('--sg-disabled');
  c['--sg-input-disabled-fg'] = rgb('--sg-on-disabled');

  // Card
  c['--sg-card-bg'] = rgb('--sg-surface');
  c['--sg-card-fg'] = rgb('--sg-text');
  c['--sg-card-border'] = rgb('--sg-border');
  c['--sg-card-header-bg'] = rgb('--sg-muted-surface');

  // Alert/Banner
  for (final kind in const ['info', 'success', 'warning', 'error']) {
    c['--sg-alert-$kind-bg'] = rgb('--sg-$kind-100');
    c['--sg-alert-$kind-fg'] = rgb('--sg-$kind-700');
    c['--sg-alert-$kind-border'] = rgb('--sg-$kind-300');
  }

  // Badge
  c['--sg-badge-bg'] = rgb('--sg-badge');
  c['--sg-badge-fg'] = rgb('--sg-on-badge');

  // Tooltip
  c['--sg-tooltip-bg'] = rgb('--sg-tooltip');
  c['--sg-tooltip-fg'] = rgb('--sg-on-tooltip');

  // Modal/Dialog
  c['--sg-modal-bg'] = rgb('--sg-surface');
  c['--sg-modal-fg'] = rgb('--sg-text');
  c['--sg-modal-overlay'] = 'rgb(0 0 0)';

  // Dropdown/Menu
  c['--sg-menu-bg'] = rgb('--sg-surface');
  c['--sg-menu-fg'] = rgb('--sg-text');
  c['--sg-menu-border'] = rgb('--sg-border');
  c['--sg-menu-item-hover-bg'] = rgb('--sg-muted-surface');
  c['--sg-menu-item-active-bg'] = rgb('--sg-primary-100');

  // Table
  c['--sg-table-bg'] = rgb('--sg-surface');
  c['--sg-table-fg'] = rgb('--sg-text');
  c['--sg-table-border'] = rgb('--sg-border');
  c['--sg-table-header-bg'] = rgb('--sg-muted-surface');
  c['--sg-table-row-hover-bg'] = rgb('--sg-muted-surface');
  c['--sg-table-row-selected-bg'] = rgb('--sg-primary-100');

  return c;
}
