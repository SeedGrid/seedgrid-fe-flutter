// Showcase do SgPopup. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo. O painel aparece no Overlay raiz, ancorado na GlobalKey `anchorRef`.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_popup_page.snippets.g.dart';

class SgPopupPage extends StatefulWidget {
  const SgPopupPage({super.key});

  @override
  State<SgPopupPage> createState() => _SgPopupPageState();
}

class _SgPopupPageState extends State<SgPopupPage> {
  final GlobalKey _basicoKey = GlobalKey();
  final GlobalKey _acoesKey = GlobalKey();
  final GlobalKey _posKey = GlobalKey();
  final GlobalKey _fechaKey = GlobalKey();
  final GlobalKey _pgKey = GlobalKey();
  bool _basico = false;
  bool _acoes = false;
  bool _pos = false;
  SgPopupPlacement _placement = SgPopupPlacement.bottom;
  SgPopupAlign _align = SgPopupAlign.start;
  bool _fecha = false;
  bool _pg = false;
  String _ultima = '';

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Título, subtítulo e conteúdo ancorados em um botão. Clique fora ou Esc fecha.',
        preview:
            // #region sg-popup-basico
            Row(
              children: [
                SgButton(
                  key: _basicoKey,
                  label: Text(context.tx('Abrir popup')),
                  onClick: () => setState(() => _basico = !_basico),
                ),
                SgPopup(
                  anchorRef: _basicoKey,
                  open: _basico,
                  onOpenChange: (open) => setState(() => _basico = open),
                  title: context.tx('Perfil'),
                  subtitle: context.tx('Conta pessoal'),
                  child: Text(context.tx('Conteúdo livre do popup.')),
                ),
              ],
            ),
        // #endregion
        code: SgPopupPageSnippets.sgPopupBasico,
      ),
      ShowcaseExample(
        title: 'Ações',
        description:
            'Cada ação tem ícone, dica, severidade e pode manter o popup aberto.',
        preview:
            // #region sg-popup-acoes
            Row(
              children: [
                SgButton(
                  key: _acoesKey,
                  label: Text(context.tx('Ações')),
                  appearance: SgAppearance.outline,
                  onClick: () => setState(() => _acoes = !_acoes),
                ),
                const SizedBox(width: 12),
                if (_ultima.isNotEmpty) Text('Última ação: $_ultima'),
                SgPopup(
                  anchorRef: _acoesKey,
                  open: _acoes,
                  onOpenChange: (open) => setState(() => _acoes = open),
                  actions: [
                    SgPopupAction(
                      label: context.tx('Editar'),
                      icon: const Icon(Icons.edit),
                      hint: context.tx('Abre o editor'),
                      onClick: () => setState(() => _ultima = 'editar'),
                    ),
                    SgPopupAction(
                      label: context.tx('Duplicar (não fecha)'),
                      icon: const Icon(Icons.copy),
                      closeOnClick: false,
                      onClick: () => setState(() => _ultima = 'duplicar'),
                    ),
                    SgPopupAction(
                      label: context.tx('Indisponível'),
                      disabled: true,
                    ),
                    SgPopupAction(
                      label: context.tx('Excluir'),
                      icon: const Icon(Icons.delete),
                      severity: SgPopupSeverity.danger,
                      onClick: () => setState(() => _ultima = 'excluir'),
                    ),
                  ],
                ),
              ],
            ),
        // #endregion
        code: SgPopupPageSnippets.sgPopupAcoes,
      ),
      ShowcaseExample(
        title: 'Posicionamento',
        description:
            'placement e align; no modo auto o popup escolhe o lado que cabe na tela.',
        preview:
            // #region sg-popup-posicionamento
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final p in SgPopupPlacement.values)
                      ChoiceChip(
                        label: Text(p.value),
                        selected: _placement == p,
                        onSelected: (_) => setState(() => _placement = p),
                      ),
                    for (final a in SgPopupAlign.values)
                      ChoiceChip(
                        label: Text('align ${a.value}'),
                        selected: _align == a,
                        onSelected: (_) => setState(() => _align = a),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SgButton(
                  key: _posKey,
                  label: Text(context.tx('Abrir')),
                  onClick: () => setState(() => _pos = !_pos),
                ),
                SgPopup(
                  anchorRef: _posKey,
                  open: _pos,
                  onOpenChange: (open) => setState(() => _pos = open),
                  placement: _placement,
                  align: _align,
                  child: Text('${_placement.value} / ${_align.value}'),
                ),
              ],
            ),
        // #endregion
        code: SgPopupPageSnippets.sgPopupPosicionamento,
      ),
      ShowcaseExample(
        title: 'Fechamento',
        description:
            'Sem fechar por clique fora nem por Esc: só o botão do próprio popup fecha.',
        preview:
            // #region sg-popup-fechamento
            Row(
              children: [
                SgButton(
                  key: _fechaKey,
                  label: Text(context.tx('Abrir fixo')),
                  onClick: () => setState(() => _fecha = !_fecha),
                ),
                SgPopup(
                  anchorRef: _fechaKey,
                  open: _fecha,
                  onOpenChange: (open) => setState(() => _fecha = open),
                  closeOnOutsideClick: false,
                  closeOnEscape: false,
                  title: context.tx('Fixo'),
                  actions: [SgPopupAction(label: context.tx('Fechar'))],
                ),
              ],
            ),
        // #endregion
        code: SgPopupPageSnippets.sgPopupFechamento,
      ),
    ];

    const playgroundProps = {
      'placement',
      'preferPlacement',
      'align',
      'closeOnOutsideClick',
      'closeOnEscape',
    };
    return SgShowcasePage(
      name: 'SgPopup',
      description:
          'Painel flutuante ancorado em um widget, com título, conteúdo e ações; posiciona sozinho dentro da tela.',
      examples: examples,
      propSpecs: sgPropSpecs['SgPopup']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgPopup']!
            .where((s) => playgroundProps.contains(s.name))
            .toList(),
        builder: (context, v) => Row(
          children: [
            SgButton(
              key: _pgKey,
              label: const Text('Abrir'),
              onClick: () => setState(() => _pg = !_pg),
            ),
            SgPopup(
              anchorRef: _pgKey,
              open: _pg,
              onOpenChange: (open) => setState(() => _pg = open),
              title: 'Playground',
              placement:
                  SgPopupPlacement.fromValue(v['placement'] as String?) ??
                  SgPopupPlacement.auto,
              preferPlacement:
                  SgPopupPreferPlacement.fromValue(
                    v['preferPlacement'] as String?,
                  ) ??
                  SgPopupPreferPlacement.right,
              align:
                  SgPopupAlign.fromValue(v['align'] as String?) ??
                  SgPopupAlign.start,
              closeOnOutsideClick: (v['closeOnOutsideClick'] as bool?) ?? true,
              closeOnEscape: (v['closeOnEscape'] as bool?) ?? true,
              child: const Text('Mude as props e abra de novo.'),
            ),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>["title: 'Playground'"];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'placement' =>
                'placement: SgPopupPlacement.${SgPopupPlacement.fromValue(e.value as String)!.name}',
              'preferPlacement' =>
                'preferPlacement: SgPopupPreferPlacement.${SgPopupPreferPlacement.fromValue(e.value as String)!.name}',
              'align' =>
                'align: SgPopupAlign.${SgPopupAlign.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgPopup(\n  anchorRef: anchorKey,\n  open: open,\n  onOpenChange: setOpen,\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
