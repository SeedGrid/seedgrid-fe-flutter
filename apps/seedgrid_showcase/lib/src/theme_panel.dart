// Controles de tema do showcase: cor semente (as mesmas do React, ou um #RRGGBB livre) e raio (o claro/escuro fica no botao do menu).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'showcase_i18n.dart';

/// Cores semente; o nome vem do i18n (`color.<hex>`).
const List<String> kSeedPresets = [
  '#16803D',
  '#0EA5E9',
  '#7C3AED',
  '#EC4899',
  '#F97316',
  '#EF4444',
  '#F59E0B',
  '#10B981',
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
      initiallyExpanded: true,
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
                  avatar: CircleAvatar(backgroundColor: _hex(hex)),
                  label: Text(context.tr('color.$hex')),
                  selected: seed == hex,
                  onSelected: (_) => sg.setTheme(seed: hex),
                ),
            ],
          ),
        ),
        const _CustomSeedField(),
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

Color _hex(String hex) =>
    Color(0xFF000000 | int.parse(hex.substring(1), radix: 16));

/// Campo de cor livre: aplica o tema assim que o texto for um `#RRGGBB` valido.
class _CustomSeedField extends StatelessWidget {
  const _CustomSeedField();

  @override
  Widget build(BuildContext context) {
    final sg = useSgTheme(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        key: const ValueKey('tema-cor-livre'),
        decoration: InputDecoration(
          isDense: true,
          labelText: context.tr('customColor'),
          border: const OutlineInputBorder(),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[#0-9a-fA-F]')),
          LengthLimitingTextInputFormatter(7),
        ],
        onChanged: (v) {
          if (RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(v)) {
            sg.setTheme(seed: v.toUpperCase());
          }
        },
      ),
    );
  }
}
