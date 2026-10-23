// Controles de tema do showcase: cor semente e raio (o claro/escuro fica no botao do menu).
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

const List<({String label, String hex})> kSeedPresets = [
  (label: 'Azul', hex: '#2563EB'),
  (label: 'Verde', hex: '#16A34A'),
  (label: 'Vermelho', hex: '#DC2626'),
  (label: 'Roxo', hex: '#9333EA'),
  (label: 'Laranja', hex: '#EA580C'),
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
      title: const Text('Tema'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in kSeedPresets)
                ChoiceChip(
                  key: ValueKey('tema-cor-${p.hex}'),
                  label: Text(p.label),
                  selected: seed == p.hex,
                  onSelected: (_) => sg.setTheme(seed: p.hex),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('Raio'),
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
