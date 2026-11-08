// Showcase do SgConfirmationDialog. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_confirmation_dialog_page.snippets.g.dart';

class SgConfirmationDialogPage extends StatefulWidget {
  const SgConfirmationDialogPage({super.key});

  @override
  State<SgConfirmationDialogPage> createState() =>
      _SgConfirmationDialogPageState();
}

class _SgConfirmationDialogPageState extends State<SgConfirmationDialogPage> {
  final ValueNotifier<bool> _basico = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _severidade = ValueNotifier<bool>(false);
  final ValueNotifier<SgDialogSeverity> _sev = ValueNotifier<SgDialogSeverity>(
    SgDialogSeverity.warning,
  );
  final ValueNotifier<bool> _botoes = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _esquerda = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _superficie = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _icone = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _pg = ValueNotifier<bool>(false);
  final ValueNotifier<String> _resultado = ValueNotifier<String>('');

  @override
  void dispose() {
    for (final n in <ChangeNotifier>[
      _basico,
      _severidade,
      _sev,
      _botoes,
      _esquerda,
      _superficie,
      _icone,
      _pg,
      _resultado,
    ]) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Confirmar e cancelar fecham o diálogo; Esc, fundo e X contam como cancelar.',
        preview:
            // #region sg-confirmation-dialog-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Excluir registro')),
                  severity: SgSeverity.danger,
                  onClick: () => _basico.value = true,
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _resultado,
                  builder: (context, resultado, _) => resultado.isEmpty
                      ? const SizedBox.shrink()
                      : Text(resultado),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _basico,
                  builder: (context, open, _) => SgConfirmationDialog(
                    open: open,
                    onOpenChange: (value) => _basico.value = value,
                    title: Text(context.tx('Excluir registro?')),
                    message: Text(
                      context.tx('Esta ação não pode ser desfeita.'),
                    ),
                    onConfirm: () => _resultado.value = 'Confirmado',
                    onCancel: () => _resultado.value = 'Cancelado',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgConfirmationDialogPageSnippets.sgConfirmationDialogBasico,
      ),
      ShowcaseExample(
        title: 'Severidades',
        description:
            'A severidade escolhe o ícone padrão (info, aviso, perigo), tinge o fundo e dá a cor do botão de confirmar.',
        preview:
            // #region sg-confirmation-dialog-severidade
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
                          _sev.value = SgDialogSeverity.fromValue(s.value)!;
                          _severidade.value = true;
                        },
                      ),
                  ],
                ),
                ListenableBuilder(
                  listenable: Listenable.merge([_severidade, _sev]),
                  builder: (context, _) => SgConfirmationDialog(
                    open: _severidade.value,
                    onOpenChange: (value) => _severidade.value = value,
                    severity: _sev.value,
                    showSeverityAccent: true,
                    title: Text('Severidade ${_sev.value.value}'),
                    message: Text(
                      context.tx(
                        'Veja o ícone, o fundo e o botão de confirmar.',
                      ),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgConfirmationDialogPageSnippets.sgConfirmationDialogSeveridade,
      ),
      ShowcaseExample(
        title: 'Ícone à esquerda',
        description:
            'icon próprio e iconPlacement left (padrão): o ícone fica ao lado do texto.',
        preview:
            // #region sg-confirmation-dialog-esquerda
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir aviso')),
                  appearance: SgAppearance.outline,
                  onClick: () => _esquerda.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _esquerda,
                  builder: (context, open, _) => SgConfirmationDialog(
                    open: open,
                    onOpenChange: (value) => _esquerda.value = value,
                    severity: SgDialogSeverity.warning,
                    iconPlacement: SgConfirmationDialogIconPlacement.left,
                    icon: const Icon(Icons.warning_amber_rounded, size: 20),
                    title: Text(context.tx('Alterações não salvas')),
                    message: Text(
                      context.tx(
                        'Você tem atualizações pendentes. Deseja continuar sem salvar?',
                      ),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgConfirmationDialogPageSnippets.sgConfirmationDialogEsquerda,
      ),
      ShowcaseExample(
        title: 'Ícone no topo',
        description: 'icon próprio e iconPlacement top; closeable mostra o X.',
        preview:
            // #region sg-confirmation-dialog-icone
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Publicar')),
                  severity: SgSeverity.success,
                  onClick: () => _icone.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _icone,
                  builder: (context, open, _) => SgConfirmationDialog(
                    open: open,
                    onOpenChange: (value) => _icone.value = value,
                    severity: SgDialogSeverity.success,
                    iconPlacement: SgConfirmationDialogIconPlacement.top,
                    icon: const Icon(Icons.rocket_launch, size: 28),
                    closeable: true,
                    title: Text(context.tx('Publicar agora?')),
                    message: Text(
                      context.tx('A versão ficará visível para todos.'),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgConfirmationDialogPageSnippets.sgConfirmationDialogIcone,
      ),
      ShowcaseExample(
        title: 'Botões customizados',
        description: 'Rótulo, ícone, severidade e aparência de cada botão.',
        preview:
            // #region sg-confirmation-dialog-botoes
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Sair sem salvar')),
                  appearance: SgAppearance.outline,
                  onClick: () => _botoes.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _botoes,
                  builder: (context, open, _) => SgConfirmationDialog(
                    open: open,
                    onOpenChange: (value) => _botoes.value = value,
                    severity: SgDialogSeverity.danger,
                    title: Text(context.tx('Descartar alterações?')),
                    message: Text(
                      context.tx('As alterações não salvas serão perdidas.'),
                    ),
                    cancelButton: SgConfirmationDialogButtonConfig(
                      label: Text(context.tx('Continuar editando')),
                      icon: Icon(Icons.edit),
                    ),
                    confirmButton: SgConfirmationDialogButtonConfig(
                      label: Text(context.tx('Descartar')),
                      icon: Icon(Icons.delete),
                      appearance: SgAppearance.outline,
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgConfirmationDialogPageSnippets.sgConfirmationDialogBotoes,
      ),
      ShowcaseExample(
        title: 'Superfície customizada (customColor + elevation)',
        description:
            'customColor muda o fundo do diálogo e elevation define a sombra.',
        preview:
            // #region sg-confirmation-dialog-superficie
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: Text(context.tx('Abrir superfície customizada')),
                  appearance: SgAppearance.outline,
                  onClick: () => _superficie.value = true,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _superficie,
                  builder: (context, open, _) => SgConfirmationDialog(
                    open: open,
                    onOpenChange: (value) => _superficie.value = value,
                    severity: SgDialogSeverity.danger,
                    customColor: '#fff7ed',
                    elevation:
                        '0 0 0 1px rgba(234, 88, 12, 0.22), 0 24px 56px rgba(234, 88, 12, 0.28)',
                    title: Text(context.tx('Excluir registro?')),
                    message: Text(
                      context.tx('Esta ação não pode ser desfeita.'),
                    ),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgConfirmationDialogPageSnippets.sgConfirmationDialogSuperficie,
      ),
    ];

    const playgroundProps = {
      'severity',
      'iconPlacement',
      'size',
      'showSeverityAccent',
      'closeable',
      'closeOnCancel',
      'closeOnConfirm',
    };
    return SgShowcasePage(
      name: 'SgConfirmationDialog',
      description:
          'Diálogo de confirmação com mensagem, ícone de severidade e botões cancelar e confirmar.',
      examples: examples,
      propSpecs: sgPropSpecs['SgConfirmationDialog']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgConfirmationDialog']!
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
              builder: (context, open, _) => SgConfirmationDialog(
                open: open,
                onOpenChange: (value) => _pg.value = value,
                title: const Text('Playground'),
                message: const Text('Mude as props e abra de novo.'),
                severity:
                    SgDialogSeverity.fromValue(v['severity'] as String?) ??
                    SgDialogSeverity.warning,
                iconPlacement:
                    SgConfirmationDialogIconPlacement.fromValue(
                      v['iconPlacement'] as String?,
                    ) ??
                    SgConfirmationDialogIconPlacement.left,
                size:
                    SgDialogSize.fromValue(v['size'] as String?) ??
                    SgDialogSize.sm,
                showSeverityAccent: (v['showSeverityAccent'] as bool?) ?? false,
                closeable: (v['closeable'] as bool?) ?? false,
                closeOnCancel: (v['closeOnCancel'] as bool?) ?? true,
                closeOnConfirm: (v['closeOnConfirm'] as bool?) ?? true,
              ),
            ),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>[
            "title: const Text('Playground')",
            "message: const Text('Mude as props e abra de novo.')",
          ];
          for (final e in v.entries) {
            if (e.value == null) continue;
            args.add(switch (e.key) {
              'severity' =>
                'severity: SgDialogSeverity.${SgDialogSeverity.fromValue(e.value as String)!.name}',
              'iconPlacement' =>
                'iconPlacement: SgConfirmationDialogIconPlacement.${SgConfirmationDialogIconPlacement.fromValue(e.value as String)!.name}',
              'size' =>
                'size: SgDialogSize.${SgDialogSize.fromValue(e.value as String)!.name}',
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgConfirmationDialog(\n  open: open,\n  onOpenChange: setOpen,\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
