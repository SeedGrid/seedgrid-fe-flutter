// Visualizacao dos tokens do tema (paletas 50-900, tokens semanticos e de componente), a mesma do React.
// Usada pela pagina /theme e pela previa do editor de tema; recebe o [SgTheme] a mostrar (o atual ou um rascunho).
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

/// As 7 familias de cor do tema.
const List<String> kPaletteFamilies = [
  'primary',
  'secondary',
  'tertiary',
  'warning',
  'error',
  'info',
  'success',
];

/// Tons de cada familia.
const List<int> kPaletteStops = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

/// Tokens semanticos mostrados na previa do editor (os mesmos do React).
const List<String> kSemanticTokens = [
  'bg',
  'surface',
  'muted-surface',
  'border',
  'ring',
  'text',
  'muted',
  'disabled',
  'on-disabled',
  'link',
  'link-hover',
  'badge',
  'on-badge',
  'tooltip',
  'on-tooltip',
  'on-primary',
  'on-secondary',
  'on-tertiary',
  'on-warning',
  'on-error',
  'on-info',
  'on-success',
];

/// Tokens neutros da pagina /theme: (token, rotulo).
const List<(String, String)> kNeutralTokens = [
  ('bg', 'Background'),
  ('surface', 'Surface (cards, modals)'),
  ('muted-surface', 'Muted Surface'),
  ('border', 'Border'),
  ('text', 'Text'),
  ('muted', 'Muted Text'),
];

/// Grupos de tokens de componente (os mesmos do React): rotulo e tokens (sem o prefixo `--sg-`).
const List<(String, List<String>)> kComponentTokenGroups = [
  (
    'Button Primary',
    [
      'btn-primary-bg',
      'btn-primary-fg',
      'btn-primary-border',
      'btn-primary-hover-bg',
      'btn-primary-active-bg',
      'btn-primary-ring',
    ],
  ),
  (
    'Button Secondary',
    ['btn-secondary-bg', 'btn-secondary-fg', 'btn-secondary-hover-bg'],
  ),
  (
    'Button Success',
    ['btn-success-bg', 'btn-success-fg', 'btn-success-hover-bg'],
  ),
  (
    'Button Danger',
    ['btn-danger-bg', 'btn-danger-fg', 'btn-danger-hover-bg'],
  ),
  (
    'Button Plain',
    [
      'btn-plain-bg',
      'btn-plain-fg',
      'btn-plain-border',
      'btn-plain-hover-bg',
    ],
  ),
  (
    'Input',
    [
      'input-bg',
      'input-fg',
      'input-border',
      'input-border-hover',
      'input-border-focus',
      'input-ring',
      'input-placeholder',
      'input-disabled-bg',
      'input-disabled-fg',
    ],
  ),
  ('Card', ['card-bg', 'card-fg', 'card-border', 'card-header-bg']),
  (
    'Alert',
    [
      'alert-info-bg',
      'alert-info-fg',
      'alert-info-border',
      'alert-success-bg',
      'alert-success-fg',
      'alert-success-border',
      'alert-warning-bg',
      'alert-warning-fg',
      'alert-warning-border',
      'alert-error-bg',
      'alert-error-fg',
      'alert-error-border',
    ],
  ),
  ('Badge / Tooltip', ['badge-bg', 'badge-fg', 'tooltip-bg', 'tooltip-fg']),
  (
    'Modal / Menu / Table',
    [
      'modal-bg',
      'modal-fg',
      'menu-bg',
      'menu-fg',
      'menu-border',
      'menu-item-hover-bg',
      'table-bg',
      'table-header-bg',
      'table-row-hover-bg',
      'table-row-selected-bg',
    ],
  ),
];

/// Cor do token `--sg-<token>` no [theme], ou `null` se nao existir / nao for cor.
Color? themeTokenColor(SgTheme theme, String token) {
  final v = theme.vars['--sg-$token'];
  if (v == null || v.isEmpty) return null;
  try {
    return parseThemeColor(v);
  } on FormatException {
    return null;
  }
}

/// Quadradinho de cor com rotulo; o `tooltip` traz o nome completo do token.
class ThemeTokenSwatch extends StatelessWidget {
  const ThemeTokenSwatch({
    super.key,
    required this.theme,
    required this.token,
    this.label,
    this.size = 20,
  });

  final SgTheme theme;
  final String token;
  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = themeTokenColor(theme, token);
    return Tooltip(
      message: '--sg-$token',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label ?? token,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// Uma familia: 10 tons (50 a 900). As celulas levam a chave `<keyPrefix>-<familia>-<tom>`.
class ThemePaletteRow extends StatelessWidget {
  const ThemePaletteRow({
    super.key,
    required this.theme,
    required this.family,
    this.label,
    this.keyPrefix = 'paleta',
    this.cellHeight = 24,
    this.showStops = false,
  });

  final SgTheme theme;
  final String family;
  final String? label;
  final String keyPrefix;
  final double cellHeight;

  /// Mostra o numero do tom embaixo de cada celula (como na pagina /theme).
  final bool showStops;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final row = Row(
      children: [
        for (final stop in kPaletteStops)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Column(
                children: [
                  Tooltip(
                    message: '--sg-$family-$stop',
                    child: Container(
                      key: ValueKey('$keyPrefix-$family-$stop'),
                      height: cellHeight,
                      decoration: BoxDecoration(
                        color: themeTokenColor(theme, '$family-$stop'),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                  ),
                  if (showStops)
                    Text('$stop', style: text.labelSmall),
                ],
              ),
            ),
          ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label ?? family, style: text.titleSmall),
        const SizedBox(height: 4),
        row,
      ],
    );
  }
}

/// Grupos de tokens de componente com um quadradinho por token.
class ThemeComponentTokens extends StatelessWidget {
  const ThemeComponentTokens({
    super.key,
    required this.theme,
    this.keyPrefix = 'token',
  });

  final SgTheme theme;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (label, tokens) in kComponentTokenGroups) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(label, style: text.labelMedium),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              for (final token in tokens)
                SizedBox(
                  key: ValueKey('$keyPrefix-$token'),
                  width: 180,
                  child: ThemeTokenSwatch(theme: theme, token: token),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Tokens semanticos (`--sg-bg`, `--sg-on-primary`...) em grade.
class ThemeSemanticTokens extends StatelessWidget {
  const ThemeSemanticTokens({
    super.key,
    required this.theme,
    this.keyPrefix = 'semantico',
  });

  final SgTheme theme;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 6,
    children: [
      for (final token in kSemanticTokens)
        SizedBox(
          key: ValueKey('$keyPrefix-$token'),
          width: 150,
          child: ThemeTokenSwatch(theme: theme, token: token),
        ),
    ],
  );
}
