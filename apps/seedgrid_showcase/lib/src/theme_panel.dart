// Controles de tema do showcase.
//  - [ShowcaseThemePanel]: cor semente (as mesmas do React, ou um #RRGGBB livre) e raio, aplicados ao vivo (pagina /theme).
//  - [ShowcaseThemeEditor]: o editor aberto pelo botao de tema, igual ao do React: modo claro/escuro, cor personalizada,
//    cores predefinidas e previa de tokens. Edita um RASCUNHO: so o botao Aplicar muda o tema; Cancelar descarta.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seedgrid_components/seedgrid_components.dart'
    show
        SgAppearance,
        SgBadge,
        SgBadgeBadgeStyle,
        SgBadgeSeverity,
        SgBadgeSize,
        SgButton,
        SgCard,
        SgCardCardStyle,
        SgSeverity,
        SgSize,
        showSgColorPicker;
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'showcase_i18n.dart';
import 'theme_tokens_view.dart';

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

final RegExp _hexRe = RegExp(r'^#[0-9a-fA-F]{6}$');

/// Editor de tema (conteudo do bottom sheet do botao de tema). Nada muda no app ate clicar em Aplicar.
class ShowcaseThemeEditor extends StatefulWidget {
  const ShowcaseThemeEditor({super.key});

  @override
  State<ShowcaseThemeEditor> createState() => _ShowcaseThemeEditorState();
}

class _ShowcaseThemeEditorState extends State<ShowcaseThemeEditor> {
  late String _seed;
  late Brightness _mode; // so para a previa: o claro/escuro fica no botao da barra
  late final TextEditingController _hexCtl;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final sg = useSgTheme(context);
    _seed = sg.currentTheme.seed.toUpperCase();
    _mode = sg.currentMode;
    _hexCtl = TextEditingController(text: _seed);
  }

  @override
  void dispose() {
    _hexCtl.dispose();
    super.dispose();
  }

  void _pick(String hex) {
    setState(() {
      _seed = hex.toUpperCase();
      _hexCtl.text = _seed;
    });
  }

  Future<void> _openColorPicker(Color initial) async {
    final picked = await showSgColorPicker(
      context,
      id: 'tema-seletor',
      initialValue: _hexOf(initial),
      title: context.tr('editorPickColor'),
      okLabel: context.tr('editorApply'),
      cancelLabel: context.tr('editorCancel'),
    );
    if (picked != null) _pick(picked);
  }

  void _apply() {
    final sg = useSgTheme(context);
    sg.setTheme(seed: _seed);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final sg = useSgTheme(context);
    final text = Theme.of(context).textTheme;
    final draft = SgTheme.fromInput(
      sg.currentTheme.copyWith(seed: _seed),
      _mode,
    );
    final customValid = _hexRe.hasMatch(_hexCtl.text);
    return Padding(
      key: const ValueKey('tema-editor'),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.tr('editorTitle'), style: text.titleLarge),
          const SizedBox(height: 16),
          Text(context.tr('editorCustomColor'), style: text.labelLarge),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Como o `input type=color` do React: tocar na amostra abre o seletor de cor.
              Tooltip(
                message: context.tr('editorPickColor'),
                child: InkWell(
                  key: const ValueKey('tema-editor-amostra'),
                  borderRadius: BorderRadius.circular(draft.radius),
                  onTap: () => _openColorPicker(
                    customValid ? _hex(_hexCtl.text.toUpperCase()) : _hex(_seed),
                  ),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: customValid
                          ? _hex(_hexCtl.text.toUpperCase())
                          : null,
                      borderRadius: BorderRadius.circular(draft.radius),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  key: const ValueKey('tema-editor-cor-livre'),
                  controller: _hexCtl,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: context.tr('editorCustomColor'),
                    errorText: customValid
                        ? null
                        : context.tr('editorInvalidHex'),
                    border: const OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[#0-9a-fA-F]')),
                    LengthLimitingTextInputFormatter(7),
                  ],
                  onChanged: (v) => setState(() {
                    if (_hexRe.hasMatch(v)) _seed = v.toUpperCase();
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(context.tr('editorPresets'), style: text.labelLarge),
          const SizedBox(height: 8),
          // Grade de 4 colunas com faixas largas (como no editor do React).
          LayoutBuilder(
            builder: (context, c) {
              final w = (c.maxWidth - 3 * 8) / 4;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SeedTile(
                    key: const ValueKey('tema-editor-cor-custom'),
                    width: w,
                    color: customValid ? _hex(_hexCtl.text.toUpperCase()) : null,
                    label: context.tr('editorCustom'),
                    selected: false,
                    onTap: customValid ? () => _pick(_hexCtl.text) : null,
                  ),
                  for (final hex in kSeedPresets)
                    _SeedTile(
                      key: ValueKey('tema-editor-cor-$hex'),
                      width: w,
                      color: _hex(hex),
                      label: context.tr('color.$hex'),
                      selected: _seed == hex,
                      onTap: () => _pick(hex),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          SgCard(
            key: const ValueKey('tema-editor-previa'),
            collapsible: true,
            defaultOpen: false,
            title: context.tr('editorTokenPreview'),
            cardStyle: SgCardCardStyle.outlined,
            // A previa pinta com o rascunho: os componentes leem o tema do contexto.
            child: Theme(
              data: draft.toThemeData(Theme.of(context)),
              child: _TokenPreview(draft: draft),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SgButton(
                key: const ValueKey('tema-editor-cancelar'),
                appearance: SgAppearance.ghost,
                label: context.tr('editorCancel'),
                onClick: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              SgButton(
                key: const ValueKey('tema-editor-aplicar'),
                label: context.tr('editorApply'),
                onClick: _apply,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeedTile extends StatelessWidget {
  const _SeedTile({
    super.key,
    required this.width,
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final double width;
  final Color? color;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = color;
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: width,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? scheme.onSurface : scheme.outline,
              width: selected ? 3 : 1,
            ),
          ),
          child: c == null
              ? Text(label, style: Theme.of(context).textTheme.labelSmall)
              : (selected
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color:
                            ThemeData.estimateBrightnessForColor(c) ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      )
                    : null),
        ),
      ),
    );
  }
}

class _TokenPreview extends StatelessWidget {
  const _TokenPreview({required this.draft});

  final SgTheme draft;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    Widget title(String t) => Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(t.toUpperCase(), style: text.labelMedium),
    );
    const severities = [
      SgSeverity.primary,
      SgSeverity.secondary,
      SgSeverity.success,
      SgSeverity.info,
      SgSeverity.warning,
      SgSeverity.danger,
      SgSeverity.help,
    ];
    const badges = [
      SgBadgeSeverity.primary,
      SgBadgeSeverity.secondary,
      SgBadgeSeverity.success,
      SgBadgeSeverity.info,
      SgBadgeSeverity.warning,
      SgBadgeSeverity.danger,
      SgBadgeSeverity.neutral,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title(context.tr('editorPalette')),
        for (final family in kPaletteFamilies)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: ThemePaletteRow(
              theme: draft,
              family: family,
              keyPrefix: 'tema-editor-paleta',
            ),
          ),
        title(context.tr('editorSemantic')),
        ThemeSemanticTokens(theme: draft, keyPrefix: 'tema-editor-semantico'),
        title(context.tr('editorComponentTokens')),
        ThemeComponentTokens(theme: draft, keyPrefix: 'tema-editor-token'),
        title(context.tr('editorComponents')),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in severities)
              SgButton(severity: s, size: SgSize.sm, label: s.value),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in severities)
              SgButton(
                severity: s,
                size: SgSize.sm,
                appearance: SgAppearance.outline,
                label: s.value,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in badges)
              SgBadge(severity: s, size: SgBadgeSize.sm, value: Text(s.value)),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in badges)
              SgBadge(
                severity: s,
                badgeStyle: SgBadgeBadgeStyle.soft,
                size: SgBadgeSize.sm,
                value: Text(s.value),
              ),
          ],
        ),
      ],
    );
  }
}

String _hexOf(Color c) {
  String two(double v) =>
      (v * 255).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
  return '#${two(c.r)}${two(c.g)}${two(c.b)}'.toUpperCase();
}
