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
  final ValueNotifier<num> _basico = ValueNotifier<num>(0);
  final ValueNotifier<num> _meia = ValueNotifier<num>(2.5);
  final ValueNotifier<num?> _meiaHover = ValueNotifier<num?>(null);
  final ValueNotifier<num> _heart = ValueNotifier<num>(4);
  final ValueNotifier<num> _like = ValueNotifier<num>(3);
  final ValueNotifier<num> _fire = ValueNotifier<num>(5);
  final ValueNotifier<num> _sm = ValueNotifier<num>(3);
  final ValueNotifier<num> _lg = ValueNotifier<num>(4);
  final ValueNotifier<num> _many = ValueNotifier<num>(7);
  final ValueNotifier<num> _cb = ValueNotifier<num>(3);
  final ValueNotifier<num?> _cbHover = ValueNotifier<num?>(null);
  final ValueNotifier<List<String>> _cbLog = ValueNotifier<List<String>>([]);
  final ValueNotifier<num> _req = ValueNotifier<num>(0);
  final SgFormController _form = SgFormController(
    defaultValues: {'productRating': 4, 'movieRating': 2.5},
  );
  final ValueNotifier<String> _enviado = ValueNotifier<String>('-');

  @override
  void dispose() {
    for (final n in <ChangeNotifier>[
      _basico,
      _meia,
      _meiaHover,
      _heart,
      _like,
      _fire,
      _sm,
      _lg,
      _many,
      _cb,
      _cbHover,
      _cbLog,
      _req,
      _enviado,
      _form,
    ]) {
      n.dispose();
    }
    super.dispose();
  }

  void _pushLog(String msg) {
    _cbLog.value = [msg, ..._cbLog.value].take(8).toList();
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
                  child: ValueListenableBuilder<num>(
                    valueListenable: _basico,
                    builder: (context, valor, _) => SgRating(
                      value: valor,
                      onChange: (v) => _basico.value = v,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<num>(
                  valueListenable: _basico,
                  builder: (context, valor, _) =>
                      Text('${context.tx('Valor atual')}: $valor'),
                ),
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
                ValueListenableBuilder<num>(
                  valueListenable: _meia,
                  builder: (context, valor, _) => SgRating(
                    label: context.tx(
                      'Passe o mouse e clique nas meias estrelas',
                    ),
                    value: valor,
                    allowHalf: true,
                    showTooltip: true,
                    onChange: (v) => _meia.value = v,
                    onHover: (v) => _meiaHover.value = v,
                  ),
                ),
                const SizedBox(height: 8),
                ListenableBuilder(
                  listenable: Listenable.merge([_meia, _meiaHover]),
                  builder: (context, _) => Text(
                    '${context.tx('Selecionado')}: ${_meia.value} | ${context.tx('Hover')}: ${_meiaHover.value ?? context.tx('nenhum')}',
                  ),
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
                ValueListenableBuilder<num>(
                  valueListenable: _sm,
                  builder: (context, valor, _) => SgRating(
                    label: context.tx('sm / 5 estrelas'),
                    size: SgRatingSize.sm,
                    value: valor,

                    onChange: (v) => _sm.value = v,
                  ),
                ),
                ValueListenableBuilder<num>(
                  valueListenable: _lg,
                  builder: (context, valor, _) => SgRating(
                    label: context.tx('lg / 5 estrelas'),
                    size: SgRatingSize.lg,
                    value: valor,

                    onChange: (v) => _lg.value = v,
                  ),
                ),
                ValueListenableBuilder<num>(
                  valueListenable: _many,
                  builder: (context, valor, _) => SgRating(
                    label: context.tx('10 estrelas'),
                    stars: 10,
                    size: SgRatingSize.sm,
                    value: valor,

                    onChange: (v) => _many.value = v,
                  ),
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
                ValueListenableBuilder<num>(
                  valueListenable: _heart,
                  builder: (context, valor, _) => SgRating(
                    label: context.tx('Coração'),
                    value: valor,
                    color: '#ec4899',
                    emptyColor: '#f9a8d4',
                    onIcon: const Icon(Icons.favorite, size: 24),
                    offIcon: const Icon(Icons.favorite_border, size: 24),

                    onChange: (v) => _heart.value = v,
                  ),
                ),
                ValueListenableBuilder<num>(
                  valueListenable: _like,
                  builder: (context, valor, _) => SgRating(
                    label: context.tx('Curtidas'),
                    value: valor,
                    color: '#2563eb',
                    emptyColor: '#93c5fd',
                    onIcon: const Icon(Icons.thumb_up, size: 24),
                    offIcon: const Icon(Icons.thumb_up_outlined, size: 24),

                    onChange: (v) => _like.value = v,
                  ),
                ),
                ValueListenableBuilder<num>(
                  valueListenable: _fire,
                  builder: (context, valor, _) => SgRating(
                    label: context.tx('Fogo'),
                    value: valor,
                    color: '#f97316',
                    emptyColor: '#fdba74',
                    onIcon: const Icon(Icons.local_fire_department, size: 24),
                    offIcon: const Icon(
                      Icons.local_fire_department_outlined,
                      size: 24,
                    ),

                    onChange: (v) => _fire.value = v,
                  ),
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
                ValueListenableBuilder<num>(
                  valueListenable: _cb,
                  builder: (context, valor, _) => SgRating(
                    label: context.tx('Callbacks'),
                    value: valor,
                    allowHalf: true,
                    onChange: (v) {
                      _cb.value = v;
                      _pushLog('onChange -> $v');
                    },
                    onHover: (v) => _cbHover.value = v,
                  ),
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
                      onClick: () => _cb.value = 0,
                    ),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Máximo')),
                      onClick: () => _cb.value = 5,
                    ),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Limpar log')),
                      onClick: () => _cbLog.value = [],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListenableBuilder(
                  listenable: Listenable.merge([_cb, _cbHover]),
                  builder: (context, _) => Text(
                    '${context.tx('Selecionado')}: ${_cb.value} | ${context.tx('Hover')}: ${_cbHover.value ?? context.tx('nenhum')}',
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<List<String>>(
                  valueListenable: _cbLog,
                  builder: (context, log, _) => ShowcaseLogBox(
                    entries: log,
                    hint: context.tx('Sem eventos'),
                    height: 112,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingCallbacks,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
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
                    (values) => _enviado.value = '$values',
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
                ValueListenableBuilder<String>(
                  valueListenable: _enviado,
                  builder: (context, enviado, _) =>
                      Text('${context.tx('Último envio')}: $enviado'),
                ),
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
                ValueListenableBuilder<num>(
                  valueListenable: _req,
                  builder: (context, valor, _) => SgRating(
                    label: context.tx('Avaliação obrigatória'),
                    value: valor,
                    required: true,
                    requiredMessage: context.tx(
                      'Informe uma avaliação antes de continuar',
                    ),
                    onChange: (v) => _req.value = v,
                  ),
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
                      onClick: () => _req.value = 0,
                    ),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Nota 1')),
                      onClick: () => _req.value = 1,
                    ),
                    SgButton(
                      size: SgSize.sm,
                      appearance: SgAppearance.outline,
                      label: Text(context.tx('Nota 5')),
                      onClick: () => _req.value = 5,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<num>(
                  valueListenable: _req,
                  builder: (context, valor, _) =>
                      Text('${context.tx('Valor atual')}: $valor'),
                ),
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
