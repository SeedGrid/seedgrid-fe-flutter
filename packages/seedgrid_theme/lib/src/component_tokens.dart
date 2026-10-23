// Porte de @seedgrid/fe-theme src/theme/componentTokens.ts.
// A paridade com o TypeScript e conferida por test/parity.

import 'theme_config.dart';

/// Equivale a `generateComponentTokens(baseVars)`: aliases por componente
/// (`--sg-btn-primary-bg`, `--sg-input-border`...) sobre as variaveis base.
ThemeVars generateComponentTokens(ThemeVars baseVars) {
  final c = <String, String>{};

  String rgb(String name) {
    final v = baseVars[name];
    return (v != null && v.isNotEmpty) ? 'rgb($v)' : '';
  }

  // Botoes de severidade: bg 600, hover 700, active 800, ring 400.
  void severity(String tokenName, String scale, String on) {
    c['--sg-btn-$tokenName-bg'] = rgb('--sg-$scale-600');
    c['--sg-btn-$tokenName-fg'] = rgb(on);
    c['--sg-btn-$tokenName-border'] = rgb('--sg-$scale-600');
    c['--sg-btn-$tokenName-hover-bg'] = rgb('--sg-$scale-700');
    c['--sg-btn-$tokenName-active-bg'] = rgb('--sg-$scale-800');
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
