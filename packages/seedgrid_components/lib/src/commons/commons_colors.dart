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

/// Mantem [preferred] se tiver contraste >= 3:1 sobre [bg]; senao troca por preto/branco (o que contrastar mais).
/// O gerador de tema escolhe o texto por contraste minimo 4,5:1 sobre o tom 500; os botoes usam o tom 600, entao
/// esta rede de seguranca continua valendo: aqui e so a severidade (paridade com o React).
Color legibleOn(Color bg, Color preferred) {
  double ratio(Color a, Color b) {
    final la = a.computeLuminance(), lb = b.computeLuminance();
    return (la > lb ? la + 0.05 : lb + 0.05) /
        (la > lb ? lb + 0.05 : la + 0.05);
  }

  if (ratio(preferred, bg) >= 3) return preferred;
  const dark = Color(0xFF0B0B0C), light = Color(0xFFFFFFFF);
  return ratio(dark, bg) >= ratio(light, bg) ? dark : light;
}

/// Cores semanticas da severidade, lidas dos tokens `--sg-btn-<severidade>-*` do gerador de tema (os mesmos do
/// SgButton). Sao eles que distinguem success/warning/info/secondary; os aliases legados (`--tertiary`,
/// `--accent`) colapsam tudo no mesmo cinza no tema semente (P140). Null se o tema nao tiver o token.
SeverityColors? semanticSeverityColors(SgTheme t, String severity) {
  final base = '--sg-btn-$severity';
  if (!t.vars.containsKey('$base-bg') || !t.vars.containsKey('$base-fg')) {
    return null;
  }
  Color pick(String suffix, Color fallback) =>
      t.vars.containsKey('$base-$suffix') ? t.color('$base-$suffix') : fallback;
  final bg = t.color('$base-bg');
  return SeverityColors(
    bg: bg,
    fg: legibleOn(bg, t.color('$base-fg')),
    border: pick('border', bg),
    ring: pick('ring', bg.withValues(alpha: 0.35)),
  );
}

/// Paleta base das severidades `primary|secondary|success|warning|danger|info|neutral` (`custom` usa a de `primary`).
SeverityColors severityColors(SgTheme t, String severity) {
  if (const {'secondary', 'success', 'warning', 'info'}.contains(severity)) {
    final semantic = semanticSeverityColors(t, severity);
    if (semantic != null) return semantic;
  }
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
