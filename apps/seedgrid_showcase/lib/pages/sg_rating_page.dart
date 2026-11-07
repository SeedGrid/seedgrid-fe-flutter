// Showcase do SgRating. Mesmos exemplos, na mesma ordem, do showcase React (a fonte da verdade); o exemplo de
// react-hook-form usa o equivalente Flutter (SgFormController). O codigo exibido em cada exemplo e o trecho
// entre `// #region` e `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_rating_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_log_box.dart';
import '../src/showcase_i18n.dart';

class SgRatingPage extends StatefulWidget {
  const SgRatingPage({super.key});

  @override
  State<SgRatingPage> createState() => _SgRatingPageState();
}

class _SgRatingPageState extends State<SgRatingPage> {
  num _basico = 0;
  num _meia = 2.5;
  num? _meiaHover;
  num _heart = 4;
  num _like = 3;
  num _fire = 5;
  num _sm = 3;
  num _lg = 4;
  num _many = 7;
  num _cb = 3;
  num? _cbHover;
  final List<String> _cbLog = [];
  num _req = 0;
  final SgFormController _form = SgFormController(
    defaultValues: {'productRating': 4, 'movieRating': 2.5},
  );
  String _enviado = '-';

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _pushLog(String msg) {
    _cbLog.insert(0, msg);
    if (_cbLog.length > 8) _cbLog.removeLast();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description: 'Exemplo controlado com estado.',
        preview:
            // #region sg-rating-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0x403B82F6)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SgRating(
                    value: _basico,
                    onChange: (v) => setState(() => _basico = v),
                  ),
                ),
                const SizedBox(height: 8),
                Text('${context.tx('Valor atual')}: $_basico'),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingBasico,
      ),
      ShowcaseExample(
        title: 'Meia estrela + tooltip',
        description: 'Permite clicar nas metades e exibir valor no hover.',
        preview:
            // #region sg-rating-meia
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRating(
                  label: context.tx(
                    'Passe o mouse e clique nas meias estrelas',
                  ),
                  value: _meia,
                  allowHalf: true,
                  showTooltip: true,
                  onChange: (v) => setState(() => _meia = v),
                  onHover: (v) => setState(() => _meiaHover = v),
                ),
                const SizedBox(height: 8),
                Text(
                  '${context.tx('Selecionado')}: $_meia | ${context.tx('Hover')}: ${_meiaHover ?? context.tx('nenhum')}',
                ),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingMeia,
      ),
      ShowcaseExample(
        title: 'Read-only e desabilitado',
        description: 'Visualização sem interação e estado desabilitado.',
        preview:
            // #region sg-rating-readonly
            SgGrid(
              columns: const {'base': 1, 'md': 2},
              gap: 16,
              children: [
                SgRating(
                  label: context.tx('Somente leitura'),
                  value: 3.5,
                  allowHalf: true,
                  readOnly: true,
                ),
                SgRating(
                  label: context.tx('Desabilitado'),
                  value: 2,
                  enabled: false,
                ),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingReadonly,
      ),
      ShowcaseExample(
        title: 'Tamanhos e quantidade de estrelas',
        description: 'Controle de size e stars.',
        preview:
            // #region sg-rating-tamanhos
            SgGrid(
              columns: const {'base': 1, 'md': 2},
              gap: 16,
              children: [
                SgRating(
                  label: context.tx('sm / 5 estrelas'),
                  size: SgRatingSize.sm,
                  value: _sm,
                  onChange: (v) => setState(() => _sm = v),
                ),
                SgRating(
                  label: context.tx('lg / 5 estrelas'),
                  size: SgRatingSize.lg,
                  value: _lg,
                  onChange: (v) => setState(() => _lg = v),
                ),
                SgRating(
                  label: context.tx('10 estrelas'),
                  stars: 10,
                  size: SgRatingSize.sm,
                  value: _many,
                  onChange: (v) => setState(() => _many = v),
                ),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingTamanhos,
      ),
      ShowcaseExample(
        title: 'Cores e ícones customizados',
        description: 'Troca de cores e ícones de preenchido/vazio.',
        preview:
            // #region sg-rating-cores
            SgGrid(
              columns: const {'base': 1, 'md': 2},
              gap: 16,
              children: [
                SgRating(
                  label: context.tx('Coração'),
                  value: _heart,
                  color: '#ec4899',
                  emptyColor: '#f9a8d4',
                  onIcon: const Icon(Icons.favorite, size: 24),
                  offIcon: const Icon(Icons.favorite_border, size: 24),
                  onChange: (v) => setState(() => _heart = v),
                ),
                SgRating(
                  label: context.tx('Curtidas'),
                  value: _like,
                  color: '#2563eb',
                  emptyColor: '#93c5fd',
                  onIcon: const Icon(Icons.thumb_up, size: 24),
                  offIcon: const Icon(Icons.thumb_up_outlined, size: 24),
                  onChange: (v) => setState(() => _like = v),
                ),
                SgRating(
                  label: context.tx('Fogo'),
                  value: _fire,
                  color: '#f97316',
                  emptyColor: '#fdba74',
                  onIcon: const Icon(Icons.local_fire_department, size: 24),
                  offIcon: const Icon(
                    Icons.local_fire_department_outlined,
                    size: 24,
                  ),
                  onChange: (v) => setState(() => _fire = v),
                ),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingCores,
      ),
      ShowcaseExample(
        title: 'Callbacks',
        description: 'Exemplo com onChange e onHover + log de eventos.',
        preview:
            // #region sg-rating-callbacks
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRating(
                  label: context.tx('Callbacks'),
                  value: _cb,
                  allowHalf: true,
                  onChange: (v) => setState(() {
                    _cb = v;
                    _pushLog('onChange -> $v');
                  }),
                  onHover: (v) => setState(() => _cbHover = v),
                ),
                const SizedBox(height: 12),
                SgGrid(
                  columns: const {'base': 2, 'md': 4},
                  gap: 8,
                  children: [
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Zerar')),
                      onClick: () => setState(() => _cb = 0),
                    ),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Máximo')),
                      onClick: () => setState(() => _cb = 5),
                    ),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Limpar log')),
                      onClick: () => setState(_cbLog.clear),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${context.tx('Selecionado')}: $_cb | ${context.tx('Hover')}: ${_cbHover ?? context.tx('nenhum')}',
                ),
                const SizedBox(height: 12),
                ShowcaseLogBox(
                  entries: _cbLog,
                  hint: context.tx('Sem eventos'),
                  height: 112,
                ),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingCallbacks,
      ),
      ShowcaseExample(
        title: 'Formulário (SgFormController)',
        description: 'Uso com control/name e envio.',
        preview:
            // #region sg-rating-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRating(
                  label: context.tx('Avalie o produto'),
                  name: 'productRating',
                  control: _form,
                ),
                const SizedBox(height: 16),
                SgRating(
                  label: context.tx('Avalie o filme'),
                  name: 'movieRating',
                  control: _form,
                  allowHalf: true,
                ),
                const SizedBox(height: 16),
                SgButton(
                  size: SgSize.sm,
                  label: Text(context.tx('Enviar avaliação')),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '$values'),
                  ),
                ),
                const SizedBox(height: 16),
                ListenableBuilder(
                  listenable: _form,
                  builder: (context, _) => Text(
                    'watch.productRating: ${_form.watch('productRating')} | watch.movieRating: ${_form.watch('movieRating')}',
                  ),
                ),
                const SizedBox(height: 4),
                Text('${context.tx('Último envio')}: $_enviado'),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingFormulario,
      ),
      ShowcaseExample(
        title: 'Campo obrigatório',
        description: 'Exemplo com required e requiredMessage.',
        preview:
            // #region sg-rating-obrigatorio
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRating(
                  label: context.tx('Avaliação obrigatória'),
                  value: _req,
                  required: true,
                  requiredMessage: context.tx(
                    'Informe uma avaliação antes de continuar',
                  ),
                  onChange: (v) => setState(() => _req = v),
                ),
                const SizedBox(height: 12),
                SgGrid(
                  columns: const {'base': 2, 'md': 4},
                  gap: 8,
                  children: [
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Limpar')),
                      onClick: () => setState(() => _req = 0),
                    ),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Nota 1')),
                      onClick: () => setState(() => _req = 1),
                    ),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Nota 5')),
                      onClick: () => setState(() => _req = 5),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('${context.tx('Valor atual')}: $_req'),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingObrigatorio,
      ),
    ];

    return SgShowcasePage(
      name: 'SgRating',
      description:
          'Avaliação por estrelas com meia estrela, cancelar, tooltip, cores, ícones próprios e ligação a formulário.',
      examples: examples,
      propSpecs: sgPropSpecs['SgRating']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgRating']!
            .where(
              (s) => const {
                'size',
                'allowHalf',
                'cancel',
                'enabled',
                'readOnly',
                'showTooltip',
                'required',
                'label',
                'color',
                'emptyColor',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgRating(
          id: 'pg',
          label: v['label'] as String?,
          size: SgRatingSize.fromValue(v['size'] as String?) ?? SgRatingSize.md,
          allowHalf: (v['allowHalf'] as bool?) ?? false,
          cancel: (v['cancel'] as bool?) ?? true,
          enabled: (v['enabled'] as bool?) ?? true,
          readOnly: (v['readOnly'] as bool?) ?? false,
          showTooltip: (v['showTooltip'] as bool?) ?? false,
          required: (v['required'] as bool?) ?? false,
          color: v['color'] as String?,
          emptyColor: v['emptyColor'] as String?,
          value: 3,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", 'value: 3'];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'size' =>
                'size: SgRatingSize.${SgRatingSize.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgRating(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
