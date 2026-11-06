// Caixa de log dos exemplos de "Eventos" (equivale ao <div className="h-40 overflow-y-auto ..."> dos showcases React).
import 'package:flutter/material.dart';

class ShowcaseLogBox extends StatelessWidget {
  const ShowcaseLogBox({
    super.key,
    required this.entries,
    required this.hint,
    this.height = 160,
  });

  /// Entradas, a mais recente primeiro.
  final List<String> entries;

  /// Texto mostrado enquanto nao ha entradas.
  final String hint;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('showcase-log-box'),
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: entries.isEmpty
          ? Text(hint, style: theme.textTheme.bodySmall)
          : ListView(
              children: [
                for (final e in entries)
                  Text(e, style: const TextStyle(fontFamily: 'monospace')),
              ],
            ),
    );
  }
}
