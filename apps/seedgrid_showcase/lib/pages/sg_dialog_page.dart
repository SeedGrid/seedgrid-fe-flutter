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
  bool _basico = false;
  bool _severidade = false;
  SgDialogSeverity _sev = SgDialogSeverity.plain;
  bool _animacao = false;
  SgDialogAnimation _anim = SgDialogAnimation.zoom;
  bool _cores = false;
  bool _fechamento = false;
  bool _pg = false;

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Título, subtítulo, corpo e rodapé. Fecha pelo X, pelo Esc ou clicando no fundo.',
        preview:
            // #region sg-dialog-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir diálogo')),
                  onClick: () => setState(() => _basico = true),
                ),
                SgDialog(
                  open: _basico,
                  onOpenChange: (open) => setState(() => _basico = open),
                  title: Text(context.tx('Novo cadastro')),
                  subtitle: Text(context.tx('Preencha os dados abaixo')),
                  footer: SgButton(
                    label: Text(context.tx('Salvar')),
                    onClick: () => setState(() => _basico = false),
                  ),
                  child: Text(context.tx('O conteúdo do diálogo fica aqui.')),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogBasico,
      ),
      ShowcaseExample(
        title: 'Severidades',
        description:
            'Cada severidade tinge o fundo e a faixa do topo do diálogo com a cor do botão correspondente, como no SgWhistler.',
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
                        onClick: () => setState(() {
                          _sev = SgDialogSeverity.fromValue(s.value)!;
                          _severidade = true;
                        }),
                      ),
                  ],
                ),
                SgDialog(
                  open: _severidade,
                  onOpenChange: (open) => setState(() => _severidade = open),
                  severity: _sev,
                  size: SgDialogSize.sm,
                  title: Text('Severidade ${_sev.value}'),
                  footer: SgButton(
                    label: Text(context.tx('Confirmar')),
                    severity:
                        SgSeverity.fromValue(_sev.value) ?? SgSeverity.primary,
                    onClick: () => setState(() => _severidade = false),
                  ),
                  child: Text(
                    context.tx(
                      'O fundo e a faixa do topo seguem a severidade escolhida.',
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogSeveridade,
      ),
      ShowcaseExample(
        title: 'Animações e fechamento automático',
        description:
            'fade, zoom e slideUp; autoCloseMs fecha sozinho depois do tempo.',
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
                        onClick: () => setState(() {
                          _anim = a;
                          _animacao = true;
                        }),
                      ),
                  ],
                ),
                SgDialog(
                  open: _animacao,
                  onOpenChange: (open) => setState(() => _animacao = open),
                  animation: _anim,
                  transitionMs: 300,
                  autoCloseMs: 3000,
                  title: Text('Animação ${_anim.value}'),
                  child: Text(
                    context.tx('Este diálogo fecha sozinho em 3 segundos.'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogAnimacao,
      ),
      ShowcaseExample(
        title: 'Cor customizada e sombra',
        description:
            'customColor aceita Color ou texto CSS; o texto e as bordas se adaptam à luminância.',
        preview:
            // #region sg-dialog-cores
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir diálogo escuro')),
                  onClick: () => setState(() => _cores = true),
                ),
                SgDialog(
                  open: _cores,
                  onOpenChange: (open) => setState(() => _cores = open),
                  customColor: '#101820',
                  elevation: 'lg',
                  title: Text(context.tx('Modo escuro')),
                  subtitle: Text(context.tx('Paleta derivada da cor de fundo')),
                  child: Text(context.tx('Texto claro sobre fundo escuro.')),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogCores,
      ),
      ShowcaseExample(
        title: 'Controle de fechamento',
        description:
            'Sem X, sem Esc e sem clique no fundo: só o botão do rodapé fecha.',
        preview:
            // #region sg-dialog-fechamento
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir diálogo obrigatório')),
                  onClick: () => setState(() => _fechamento = true),
                ),
                SgDialog(
                  open: _fechamento,
                  onOpenChange: (open) => setState(() => _fechamento = open),
                  closeable: false,
                  closeOnEsc: false,
                  closeOnOverlayClick: false,
                  title: Text(context.tx('Atenção')),
                  footer: SgButton(
                    label: Text(context.tx('Entendi')),
                    onClick: () => setState(() => _fechamento = false),
                  ),
                  child: Text(
                    context.tx('É preciso confirmar para continuar.'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgDialogPageSnippets.sgDialogFechamento,
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
              onClick: () => setState(() => _pg = true),
            ),
            SgDialog(
              open: _pg,
              onOpenChange: (open) => setState(() => _pg = open),
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
              closeOnOverlayClick: (v['closeOnOverlayClick'] as bool?) ?? true,
              restoreFocus: (v['restoreFocus'] as bool?) ?? true,
              child: const Text('Mude as props e abra de novo.'),
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
