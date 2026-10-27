// Showcase do SgConfirmationDialog. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_confirmation_dialog_page.snippets.g.dart';

class SgConfirmationDialogPage extends StatefulWidget {
  const SgConfirmationDialogPage({super.key});

  @override
  State<SgConfirmationDialogPage> createState() =>
      _SgConfirmationDialogPageState();
}

class _SgConfirmationDialogPageState extends State<SgConfirmationDialogPage> {
  bool _basico = false;
  bool _severidade = false;
  SgDialogSeverity _sev = SgDialogSeverity.warning;
  bool _botoes = false;
  bool _icone = false;
  bool _pg = false;
  String _resultado = '';

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
                  label: const Text('Excluir registro'),
                  severity: SgSeverity.danger,
                  onClick: () => setState(() => _basico = true),
                ),
                if (_resultado.isNotEmpty) Text(_resultado),
                SgConfirmationDialog(
                  open: _basico,
                  onOpenChange: (open) => setState(() => _basico = open),
                  title: const Text('Excluir registro?'),
                  message: const Text('Esta ação não pode ser desfeita.'),
                  onConfirm: () => setState(() => _resultado = 'Confirmado'),
                  onCancel: () => setState(() => _resultado = 'Cancelado'),
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
                        onClick: () => setState(() {
                          _sev = SgDialogSeverity.fromValue(s.value)!;
                          _severidade = true;
                        }),
                      ),
                  ],
                ),
                SgConfirmationDialog(
                  open: _severidade,
                  onOpenChange: (open) => setState(() => _severidade = open),
                  severity: _sev,
                  showSeverityAccent: true,
                  title: Text('Severidade ${_sev.value}'),
                  message: const Text(
                    'Veja o ícone, o fundo e o botão de confirmar.',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgConfirmationDialogPageSnippets.sgConfirmationDialogSeveridade,
      ),
      ShowcaseExample(
        title: 'Botões personalizados',
        description: 'Rótulo, ícone, severidade e aparência de cada botão.',
        preview:
            // #region sg-confirmation-dialog-botoes
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgButton(
                  label: const Text('Sair sem salvar'),
                  appearance: SgAppearance.outline,
                  onClick: () => setState(() => _botoes = true),
                ),
                SgConfirmationDialog(
                  open: _botoes,
                  onOpenChange: (open) => setState(() => _botoes = open),
                  severity: SgDialogSeverity.danger,
                  title: const Text('Descartar alterações?'),
                  message: const Text(
                    'As alterações não salvas serão perdidas.',
                  ),
                  cancelButton: const SgConfirmationDialogButtonConfig(
                    label: Text('Continuar editando'),
                    icon: Icon(Icons.edit),
                  ),
                  confirmButton: const SgConfirmationDialogButtonConfig(
                    label: Text('Descartar'),
                    icon: Icon(Icons.delete),
                    appearance: SgAppearance.outline,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgConfirmationDialogPageSnippets.sgConfirmationDialogBotoes,
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
                  label: const Text('Publicar'),
                  severity: SgSeverity.success,
                  onClick: () => setState(() => _icone = true),
                ),
                SgConfirmationDialog(
                  open: _icone,
                  onOpenChange: (open) => setState(() => _icone = open),
                  severity: SgDialogSeverity.success,
                  iconPlacement: SgConfirmationDialogIconPlacement.top,
                  icon: const Icon(Icons.rocket_launch, size: 28),
                  closeable: true,
                  title: const Text('Publicar agora?'),
                  message: const Text('A versão ficará visível para todos.'),
                ),
              ],
            ),
        // #endregion
        code: SgConfirmationDialogPageSnippets.sgConfirmationDialogIcone,
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
              onClick: () => setState(() => _pg = true),
            ),
            SgConfirmationDialog(
              open: _pg,
              onOpenChange: (open) => setState(() => _pg = open),
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
