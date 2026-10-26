// Controles de tema do showcase: cor semente e raio (o claro/escuro fica no botao do menu).
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'showcase_i18n.dart';

/// Cores semente; o nome vem do i18n (`color.<hex>`).
const List<String> kSeedPresets = [
  '#2563EB',
  '#16A34A',
  '#DC2626',
  '#9333EA',
  '#EA580C',
];

class ShowcaseThemePanel extends StatelessWidget {
  const ShowcaseThemePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final sg = useSgTheme(context);
    final seed = sg.currentTheme.seed.toUpperCase();
    final radius = (sg.currentTheme.radius ?? 12).toDouble();
    return ExpansionTile(
      key: const ValueKey('tema-painel'),
      title: Text(context.tr('theme')),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final hex in kSeedPresets)
                ChoiceChip(
                  key: ValueKey('tema-cor-$hex'),
                  label: Text(context.tr('color.$hex')),
                  selected: seed == hex,
                  onSelected: (_) => sg.setTheme(seed: hex),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(context.tr('radius')),
              Expanded(
                child: Slider(
                  key: const ValueKey('tema-raio'),
                  min: 0,
                  max: 24,
                  divisions: 24,
                  value: radius.clamp(0, 24),
                  label: radius.round().toString(),
                  onChanged: (v) => sg.setTheme(radius: v),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
