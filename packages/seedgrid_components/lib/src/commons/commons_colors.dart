// Cores das severidades de SgBadge e SgAvatar. No React as duas usam os aliases legados do tema
// (`hsl(var(--primary))` com cadeias de fallback, ex.: success = --tertiary -> --accent -> --primary);
// aqui a mesma cadeia, lida de SgTheme.vars (os aliases legados saem por `theme.color('--primary')`).
import 'package:flutter/painting.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

/// Primeiro token existente da cadeia (equivale a `var(--a, var(--b, var(--c)))`).
Color tokenChain(SgTheme t, List<String> chain) {
  for (final name in chain) {
    if (t.vars.containsKey(name)) return t.color(name);
  }
  throw StateError('Nenhum token do tema entre: ${chain.join(', ')}');
}

class SeverityColors {
  const SeverityColors({
    required this.bg,
    required this.fg,
    required this.border,
    required this.ring,
  });
  final Color bg, fg, border, ring;
}

/// Paleta base das severidades `primary|secondary|success|warning|danger|info|neutral` (`custom` usa a de `primary`).
SeverityColors severityColors(SgTheme t, String severity) {
  Color c(List<String> chain) => tokenChain(t, chain);
  final ring = tokenChain(t, ['--ring']);
  switch (severity) {
    case 'secondary':
      return SeverityColors(
        bg: c(['--secondary']),
        fg: c(['--secondary-foreground']),
        border: c(['--secondary']),
        ring: ring,
      );
    case 'success':
      return SeverityColors(
        bg: c(['--tertiary', '--accent', '--primary']),
        fg: c([
          '--tertiary-foreground',
          '--accent-foreground',
          '--primary-foreground',
        ]),
        border: c(['--tertiary', '--accent', '--primary']),
        ring: ring,
      );
    case 'warning':
      return SeverityColors(
        bg: c(['--accent', '--secondary', '--primary']),
        fg: c([
          '--accent-foreground',
          '--secondary-foreground',
          '--primary-foreground',
        ]),
        border: c(['--accent', '--secondary', '--primary']),
        ring: ring,
      );
    case 'danger':
      return SeverityColors(
        bg: c(['--destructive']),
        fg: c(['--destructive-foreground']),
        border: c(['--destructive']),
        ring: ring,
      );
    case 'info':
      return SeverityColors(
        bg: c(['--secondary', '--primary']),
        fg: c(['--secondary-foreground', '--primary-foreground']),
        border: c(['--secondary', '--primary']),
        ring: ring,
      );
    case 'neutral':
      return SeverityColors(
        bg: c(['--muted']),
        fg: c(['--muted-foreground']),
        border: c(['--border']),
        ring: ring,
      );
    case 'primary':
    case 'custom':
    default:
      return SeverityColors(
        bg: c(['--primary']),
        fg: c(['--primary-foreground']),
        border: c(['--primary']),
        ring: ring,
      );
  }
}
