// Showcase do SgToastHost. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// O host da pagina fica num Stack por cima do conteudo; o playground e as chaves de aparencia o configuram.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_toast_host_page.snippets.g.dart';

class SgToastHostPage extends StatefulWidget {
  const SgToastHostPage({super.key});

  @override
  State<SgToastHostPage> createState() => _SgToastHostPageState();
}

class _SgToastHostPageState extends State<SgToastHostPage> {
  final ValueNotifier<Map<String, Object?>> _cfg = ValueNotifier({});
  bool _extraHost = false;
  bool _rich = true;

  @override
  void dispose() {
    dismissSgToast();
    _cfg.dispose();
    super.dispose();
  }

  void _publish(Map<String, Object?> values) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !mapEquals(_cfg.value, values))
        _cfg.value = Map.of(values);
    });
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Um host para o app inteiro',
        description:
            'Coloque o SgToastHost uma vez, por cima do conteúdo (ex.: no builder do MaterialApp); qualquer tela dispara toasts pela API toast.',
        preview:
            // #region sg-toast-host-basico
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SgButton(
                  label: const Text('Sucesso'),
                  severity: SgSeverity.success,
                  onClick: () => toast.success('Salvo pelo host'),
                ),
                SgButton(
                  label: const Text('Erro'),
                  severity: SgSeverity.danger,
                  onClick: () => toast.error('Falhou pelo host'),
                ),
                SgButton(
                  label: const Text('Limpar'),
                  appearance: SgAppearance.ghost,
                  onClick: toast.dismiss,
                ),
              ],
            ),
        // #endregion
        code: SgToastHostPageSnippets.sgToastHostBasico,
      ),
      ShowcaseExample(
        title: 'O host prevalece sobre o SgToaster solto',
        description:
            'Esta área tem um SgToaster dentro dela, mas existe um SgToastHost na página: o toaster solto não desenha nada, então cada toast aparece uma vez só.',
        preview:
            // #region sg-toast-host-prevalece
            SizedBox(
              height: 120,
              child: Stack(
                children: [
                  const SgToaster(position: SgToasterPosition.bottomLeft),
                  Align(
                    alignment: Alignment.center,
                    child: SgButton(
                      label: const Text('Disparar'),
                      onClick: () => toast('Só aparece no host'),
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgToastHostPageSnippets.sgToastHostPrevalece,
      ),
      ShowcaseExample(
        title: 'Vários hosts',
        description:
            'O último host montado é o ativo; quando ele sai, o anterior volta. Ligue o segundo host (canto inferior esquerdo) e dispare um toast.',
        preview:
            // #region sg-toast-host-varios
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('Segundo host'),
                  selected: _extraHost,
                  onSelected: (v) => setState(() => _extraHost = v),
                ),
                SgButton(
                  label: const Text('Disparar'),
                  onClick: () => toast.info(
                    'Quem está ativo?',
                    const SgToastOptions(duration: 3000),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgToastHostPageSnippets.sgToastHostVarios,
      ),
      ShowcaseExample(
        title: 'Props do host',
        description:
            'O host aceita as mesmas props do SgToaster (aqui: richColors).',
        preview:
            // #region sg-toast-host-props
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('richColors'),
                  selected: _rich,
                  onSelected: (v) => setState(() => _rich = v),
                ),
                SgButton(
                  label: const Text('Disparar'),
                  onClick: () => toast.warning(
                    'Cores do host',
                    const SgToastOptions(duration: 3000),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgToastHostPageSnippets.sgToastHostProps,
      ),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        SgShowcasePage(
          name: 'SgToastHost',
          description:
              'Marca onde os toasts aparecem. Aceita as mesmas props do SgToaster; com host presente, o SgToaster solto cede a vez.',
          examples: examples,
          propSpecs: sgPropSpecs['SgToastHost']!,
          playground: SgPlayground(
            specs: sgPropSpecs['SgToastHost']!
                .where((s) => s.name == 'position')
                .toList(),
            builder: (context, v) {
              _publish(v);
              return Wrap(
                spacing: 8,
                children: [
                  SgButton(
                    label: const Text('Disparar toast'),
                    onClick: () => toast('Olá do playground'),
                  ),
                  Text('Posição: ${v['position'] ?? 'top-right'}'),
                ],
              );
            },
            codeBuilder: (v) =>
                'SgToastHost(${v['position'] == null ? '' : '\n  position: SgToasterPosition.${SgToasterPosition.fromValue(v['position'] as String)!.name},\n'})',
          ),
        ),
        ValueListenableBuilder<Map<String, Object?>>(
          valueListenable: _cfg,
          builder: (context, v, _) => SgToastHost(
            position:
                SgToasterPosition.fromValue(v['position'] as String?) ??
                SgToasterPosition.topRight,
            richColors: _rich,
          ),
        ),
        if (_extraHost)
          const SgToastHost(position: SgToasterPosition.bottomLeft),
      ],
    );
  }
}
