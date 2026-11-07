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
  final GlobalKey _iconeKey = GlobalKey();
  final GlobalKey _customKey = GlobalKey();
  final GlobalKey _acoesKey = GlobalKey();
  final GlobalKey _posKey = GlobalKey();
  final GlobalKey _fechaKey = GlobalKey();
  final GlobalKey _pgKey = GlobalKey();
  final ValueNotifier<bool> _basico = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _icone = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _custom = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _acoes = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _pos = ValueNotifier<bool>(false);
  final ValueNotifier<SgPopupPlacement> _placement =
      ValueNotifier<SgPopupPlacement>(SgPopupPlacement.bottom);
  final ValueNotifier<SgPopupAlign> _align = ValueNotifier<SgPopupAlign>(
    SgPopupAlign.start,
  );
  final ValueNotifier<bool> _fecha = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _pg = ValueNotifier<bool>(false);
  final ValueNotifier<String> _ultima = ValueNotifier<String>('');

  @override
  void dispose() {
    for (final n in [_basico, _icone, _custom, _acoes, _pos, _fecha, _pg]) {
      n.dispose();
    }
    _placement.dispose();
    _align.dispose();
    _ultima.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Popup controlado com ações e conteúdo.',
        preview:
            // #region sg-popup-basico
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgButton(
                  key: _basicoKey,
                  label: Text(context.tx('Abrir popup')),
                  onClick: () => _basico.value = !_basico.value,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _basico,
                  builder: (context, aberto, _) => SgPopup(
                    anchorRef: _basicoKey,
                    open: aberto,
                    onOpenChange: (open) => _basico.value = open,
                    title: context.tx('Confirma'),
                    subtitle: context.tx('Tem certeza que deseja continuar?'),
                    placement: SgPopupPlacement.auto,
                    preferPlacement: SgPopupPreferPlacement.right,
                    align: SgPopupAlign.start,
                    actions: [
                      SgPopupAction(label: context.tx('Sim')),
                      SgPopupAction(label: context.tx('Não')),
                    ],
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgPopupPageSnippets.sgPopupBasico,
      ),
      ShowcaseExample(
        title: 'Ícone e hint',
        description: 'Ações com ícone e hint (tooltip).',
        preview:
            // #region sg-popup-icone-hint
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgButton(
                  key: _iconeKey,
                  label: Text(context.tx('Abrir popup com ícone')),
                  onClick: () => _icone.value = !_icone.value,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _icone,
                  builder: (context, aberto, _) => SgPopup(
                    anchorRef: _iconeKey,
                    open: aberto,
                    onOpenChange: (open) => _icone.value = open,
                    title: context.tx('Confirma'),
                    placement: SgPopupPlacement.auto,
                    preferPlacement: SgPopupPreferPlacement.right,
                    align: SgPopupAlign.start,
                    actions: [
                      SgPopupAction(
                        label: context.tx('Aprovar'),
                        hint: context.tx('Confirmar aprovação'),
                        icon: const Icon(Icons.check, size: 16),
                      ),
                      SgPopupAction(
                        label: context.tx('Rejeitar'),
                        hint: context.tx('Negar a ação'),
                        icon: const Icon(Icons.close, size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgPopupPageSnippets.sgPopupIconeHint,
      ),
      ShowcaseExample(
        title: 'Conteúdo custom',
        description: 'Use children para renderizar qualquer conteúdo.',
        preview:
            // #region sg-popup-custom
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgButton(
                  key: _customKey,
                  label: Text(context.tx('Abrir popup custom')),
                  onClick: () => _custom.value = !_custom.value,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _custom,
                  builder: (context, aberto, _) => SgPopup(
                    anchorRef: _customKey,
                    open: aberto,
                    onOpenChange: (open) => _custom.value = open,
                    title: context.tx('Configuração'),
                    placement: SgPopupPlacement.auto,
                    child: SgInputText(
                      id: 'popup-modo',
                      label: context.tx('Modo'),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgPopupPageSnippets.sgPopupCustom,
      ),
      ShowcaseExample(
        title: 'Ações',
        description:
            'Cada ação tem ícone, dica, severidade e pode manter o popup aberto.',
        preview:
            // #region sg-popup-acoes
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgButton(
                  key: _acoesKey,
                  label: Text(context.tx('Ações')),
                  appearance: SgAppearance.outline,
                  onClick: () => _acoes.value = !_acoes.value,
                ),
                const SizedBox(width: 12),
                ValueListenableBuilder<String>(
                  valueListenable: _ultima,
                  builder: (context, ultima, _) => ultima.isEmpty
                      ? const SizedBox()
                      : Text('${context.tx('Última ação')}: $ultima'),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _acoes,
                  builder: (context, aberto, _) => SgPopup(
                    anchorRef: _acoesKey,
                    open: aberto,
                    onOpenChange: (open) => _acoes.value = open,
                    actions: [
                      SgPopupAction(
                        label: context.tx('Editar'),
                        icon: const Icon(Icons.edit),
                        hint: context.tx('Abre o editor'),
                        onClick: () => _ultima.value = 'editar',
                      ),
                      SgPopupAction(
                        label: context.tx('Duplicar (não fecha)'),
                        icon: const Icon(Icons.copy),
                        closeOnClick: false,
                        onClick: () => _ultima.value = 'duplicar',
                      ),
                      SgPopupAction(
                        label: context.tx('Indisponível'),
                        enabled: false,
                      ),
                      SgPopupAction(
                        label: context.tx('Excluir'),
                        icon: const Icon(Icons.delete),
                        severity: SgPopupSeverity.danger,
                        onClick: () => _ultima.value = 'excluir',
                      ),
                    ],
                  ),
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
                ListenableBuilder(
                  listenable: Listenable.merge([_placement, _align]),
                  builder: (context, _) => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final p in SgPopupPlacement.values)
                        ChoiceChip(
                          label: Text(p.value),
                          selected: _placement.value == p,
                          onSelected: (_) => _placement.value = p,
                        ),
                      for (final a in SgPopupAlign.values)
                        ChoiceChip(
                          label: Text('align ${a.value}'),
                          selected: _align.value == a,
                          onSelected: (_) => _align.value = a,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SgButton(
                  key: _posKey,
                  label: Text(context.tx('Abrir')),
                  onClick: () => _pos.value = !_pos.value,
                ),
                ListenableBuilder(
                  listenable: Listenable.merge([_pos, _placement, _align]),
                  builder: (context, _) => SgPopup(
                    anchorRef: _posKey,
                    open: _pos.value,
                    onOpenChange: (open) => _pos.value = open,
                    placement: _placement.value,
                    align: _align.value,
                    child: Text('${_placement.value.value} / ${_align.value.value}'),
                  ),
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
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SgButton(
                  key: _fechaKey,
                  label: Text(context.tx('Abrir fixo')),
                  onClick: () => _fecha.value = !_fecha.value,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _fecha,
                  builder: (context, aberto, _) => SgPopup(
                    anchorRef: _fechaKey,
                    open: aberto,
                    onOpenChange: (open) => _fecha.value = open,
                    closeOnOutsideClick: false,
                    closeOnEscape: false,
                    title: context.tx('Fixo'),
                    actions: [SgPopupAction(label: context.tx('Fechar'))],
                  ),
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
              onClick: () => _pg.value = !_pg.value,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _pg,
              builder: (context, aberto, _) => SgPopup(
                anchorRef: _pgKey,
                open: aberto,
                onOpenChange: (open) => _pg.value = open,
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
                closeOnOutsideClick:
                    (v['closeOnOutsideClick'] as bool?) ?? true,
                closeOnEscape: (v['closeOnEscape'] as bool?) ?? true,
                child: const Text('Mude as props e abra de novo.'),
              ),
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
