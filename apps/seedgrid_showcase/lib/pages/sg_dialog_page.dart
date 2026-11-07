// Showcase do SgDialog. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado. O dialogo aparece no Overlay
// raiz; o que fica na pagina e o botao que o abre.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_dialog_page.snippets.g.dart';

class SgDialogPage extends StatefulWidget {
  const SgDialogPage({super.key});

  @override
  State<SgDialogPage> createState() => _SgDialogPageState();
}

class _SgDialogPageState extends State<SgDialogPage> {
  final ValueNotifier<bool> _basico = ValueNotifier(false);
  final ValueNotifier<bool> _severidade = ValueNotifier(false);
  final ValueNotifier<SgSeverity> _sev = ValueNotifier(SgSeverity.primary);
  final ValueNotifier<bool> _semClose = ValueNotifier(false);
  final ValueNotifier<bool> _estrito = ValueNotifier(false);
  final ValueNotifier<bool> _auto = ValueNotifier(false);
  final ValueNotifier<bool> _animacao = ValueNotifier(false);
  final ValueNotifier<SgDialogAnimation> _anim = ValueNotifier(
    SgDialogAnimation.zoom,
  );
  final ValueNotifier<bool> _pg = ValueNotifier(false);

  @override
  void dispose() {
    for (final n in [
      _basico,
      _severidade,
      _semClose,
      _estrito,
      _auto,
      _animacao,
      _pg,
    ]) {
      n.dispose();
    }
    _sev.dispose();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Dialog com title, subtitle, leading e trailing.',
        preview:
            // #region sg-dialog-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir dialog')),
                  onClick: () => _basico.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _basico,
                  builder: (context, open, _) => SgDialog(
                    open: open,
                    onOpenChange: (v) => _basico.value = v,
                    title: Text(context.tx('Confirmar ação')),
                    subtitle: Text(
                      context.tx('Essa ação não pode ser desfeita.'),
                    ),
                    customColor: '#fff7ed',
                    elevation: 'lg',
                    leading: const Text('O'),
                    trailing: const Text('ID: 428'),
                    footer: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SgButton(
                          label: Text(context.tx('Cancelar')),
                          appearance: SgAppearance.ghost,
                          onClick: () => _basico.value = false,
                        ),
                        const SizedBox(width: 8),
                        SgButton(
                          label: Text(context.tx('Confirmar')),
                          onClick: () => _basico.value = false,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tx('Tem certeza que deseja continuar?')),
                        const SizedBox(height: 8),
                        SgInputText(
                          id: 'dialog-input',
                          hintText: context.tx('Escreva algo...'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogBasico,
      ),
      ShowcaseExample(
        title: 'Severidade',
        description:
            'Cada severidade tinge o fundo e a faixa do topo do diálogo, como no SgWhistler.',
        preview:
            // #region sg-dialog-severidade
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in SgSeverity.values)
                      SgButton(
                        label: Text(s.value),
                        severity: s,
                        onClick: () {
                          _sev.value = s;
                          _severidade.value = true;
                        },
                      ),
                  ],
                ),
                ListenableBuilder(
                  listenable: Listenable.merge([_severidade, _sev]),
                  builder: (context, _) => SgDialog(
                    open: _severidade.value,
                    onOpenChange: (v) => _severidade.value = v,
                    severity: SgDialogSeverity.fromValue(_sev.value.value)!,
                    title: Text(
                      '${context.tx('Severidade')}: ${_sev.value.value}',
                    ),
                    footer: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SgButton(
                          label: Text(context.tx('Cancelar')),
                          appearance: SgAppearance.ghost,
                          onClick: () => _severidade.value = false,
                        ),
                        const SizedBox(width: 8),
                        SgButton(
                          label: Text(context.tx('Confirmar')),
                          severity: _sev.value,
                          onClick: () => _severidade.value = false,
                        ),
                      ],
                    ),
                    child: Text(
                      context.tx(
                        'O fundo e a faixa do topo seguem a severidade escolhida.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogSeveridade,
      ),
      ShowcaseExample(
        title: 'Sem closeable',
        description: 'Exemplo sem botão de fechar no header.',
        preview:
            // #region sg-dialog-sem-close
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir sem close')),
                  appearance: SgAppearance.outline,
                  onClick: () => _semClose.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _semClose,
                  builder: (context, open, _) => SgDialog(
                    open: open,
                    onOpenChange: (v) => _semClose.value = v,
                    closeable: false,
                    title: Text(context.tx('Dialog sem close')),
                    subtitle: Text(
                      context.tx('Fechamento apenas pelos botões do footer.'),
                    ),
                    footer: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SgButton(
                          label: Text(context.tx('Cancelar')),
                          appearance: SgAppearance.ghost,
                          onClick: () => _semClose.value = false,
                        ),
                        const SizedBox(width: 8),
                        SgButton(
                          label: Text(context.tx('Confirmar')),
                          onClick: () => _semClose.value = false,
                        ),
                      ],
                    ),
                    child: Text(
                      context.tx(
                        'Use esse modo quando quiser forçar uma escolha explícita.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogSemClose,
      ),
      ShowcaseExample(
        title: 'Sem overlay e ESC',
        description: 'Fechamento apenas pelos botões do footer.',
        preview:
            // #region sg-dialog-estrito
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir estrito')),
                  appearance: SgAppearance.outline,
                  onClick: () => _estrito.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _estrito,
                  builder: (context, open, _) => SgDialog(
                    open: open,
                    onOpenChange: (v) => _estrito.value = v,
                    closeable: false,
                    closeOnOverlayClick: false,
                    closeOnEsc: false,
                    title: Text(context.tx('Dialog estrito')),
                    subtitle: Text(context.tx('Não fecha por overlay ou ESC.')),
                    footer: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SgButton(
                          label: Text(context.tx('Cancelar')),
                          appearance: SgAppearance.ghost,
                          onClick: () => _estrito.value = false,
                        ),
                        const SizedBox(width: 8),
                        SgButton(
                          label: Text(context.tx('Confirmar')),
                          onClick: () => _estrito.value = false,
                        ),
                      ],
                    ),
                    child: Text(
                      context.tx(
                        'Use quando o usuário precisa tomar uma decisão.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogEstrito,
      ),
      ShowcaseExample(
        title: 'Fechamento automático',
        description: 'Fecha automaticamente após alguns segundos.',
        preview:
            // #region sg-dialog-auto
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir auto close')),
                  appearance: SgAppearance.outline,
                  onClick: () => _auto.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _auto,
                  builder: (context, open, _) => SgDialog(
                    open: open,
                    onOpenChange: (v) => _auto.value = v,
                    autoCloseMs: 3000,
                    title: Text(context.tx('Dialog temporizado')),
                    subtitle: Text(context.tx('Este dialog fecha sozinho.')),
                    child: Text(context.tx('Apenas uma informação rápida.')),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogAuto,
      ),
      ShowcaseExample(
        title: 'Animações',
        description:
            'animation escolhe como o diálogo entra e sai (fade, zoom ou slideUp) e transitionMs define a duração.',
        preview:
            // #region sg-dialog-animacao
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final a in SgDialogAnimation.values)
                      SgButton(
                        label: Text(a.value),
                        appearance: SgAppearance.outline,
                        size: SgSize.sm,
                        onClick: () {
                          _anim.value = a;
                          _animacao.value = true;
                        },
                      ),
                  ],
                ),
                ListenableBuilder(
                  listenable: Listenable.merge([_animacao, _anim]),
                  builder: (context, _) => SgDialog(
                    open: _animacao.value,
                    onOpenChange: (v) => _animacao.value = v,
                    animation: _anim.value,
                    transitionMs: 300,
                    title: Text(
                      '${context.tx('Animação')} ${_anim.value.value}',
                    ),
                    child: Text(
                      context.tx(
                        'A animação define como o diálogo entra e sai.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogAnimacao,
      ),
    ];

    const playgroundProps = {
      'size',
      'severity',
      'animation',
      'showTopAccent',
      'closeable',
      'closeOnEsc',
      'closeOnOverlayClick',
      'restoreFocus',
    };
    return SgShowcasePage(
      name: 'SgDialog',
      description:
          'Diálogo modal com título, corpo e rodapé, foco preso, fechamento por Esc e fundo, severidade, animação e fechamento automático.',
      examples: examples,
      propSpecs: sgPropSpecs['SgDialog']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgDialog']!
            .where((s) => playgroundProps.contains(s.name))
            .toList(),
        builder: (context, v) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SgButton(
              label: const Text('Abrir'),
              onClick: () => _pg.value = true,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _pg,
              builder: (context, open, _) => SgDialog(
                open: open,
                onOpenChange: (v) => _pg.value = v,
                title: const Text('Playground'),
                size:
                    SgDialogSize.fromValue(v['size'] as String?) ??
                    SgDialogSize.md,
                severity:
                    SgDialogSeverity.fromValue(v['severity'] as String?) ??
                    SgDialogSeverity.plain,
                animation:
                    SgDialogAnimation.fromValue(v['animation'] as String?) ??
                    SgDialogAnimation.zoom,
                showTopAccent: (v['showTopAccent'] as bool?) ?? true,
                closeable: (v['closeable'] as bool?) ?? true,
                closeOnEsc: (v['closeOnEsc'] as bool?) ?? true,
                closeOnOverlayClick:
                    (v['closeOnOverlayClick'] as bool?) ?? true,
                restoreFocus: (v['restoreFocus'] as bool?) ?? true,
                child: const Text('Mude as props e abra de novo.'),
              ),
            ),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>["title: const Text('Playground')"];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'size' =>
                'size: SgDialogSize.${SgDialogSize.fromValue(e.value as String)!.name}',
              'severity' =>
                'severity: SgDialogSeverity.${SgDialogSeverity.fromValue(e.value as String)!.name}',
              'animation' =>
                'animation: SgDialogAnimation.${SgDialogAnimation.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgDialog(\n  open: open,\n  onOpenChange: setOpen,\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
