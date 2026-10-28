// Showcase do SgRating. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_rating_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgRatingPage extends StatefulWidget {
  const SgRatingPage({super.key});

  @override
  State<SgRatingPage> createState() => _SgRatingPageState();
}

class _SgRatingPageState extends State<SgRatingPage> {
  num _nota = 3;
  num? _hover;
  final SgFormController _form = SgFormController();
  String _enviado = '';

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'value inicial, cancel zera a nota e onHover entrega a nota sob o ponteiro.',
        preview:
            // #region sg-rating-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRating(
                  id: 'basico',
                  label: context.tx('Sua avaliação'),
                  value: 3,
                  onChange: (v) => setState(() => _nota = v),
                  onHover: (v) => setState(() => _hover = v),
                ),
                Text(
                  'Nota: $_nota${_hover == null ? '' : ' (passando: $_hover)'}',
                ),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingBasico,
      ),
      ShowcaseExample(
        title: 'Meia estrela e tooltip',
        description:
            'allowHalf: a metade esquerda da estrela vale 0,5; showTooltip mostra a nota acima.',
        preview:
            // #region sg-rating-meia
            const SgRating(
              id: 'meia',
              allowHalf: true,
              showTooltip: true,
              cancel: false,
              value: 2.5,
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingMeia,
      ),
      ShowcaseExample(
        title: 'Tamanhos, cores e ícones',
        description:
            'size de sm a xl; color e emptyColor como #hex, rgb() ou hsl(var(--token)); ícones próprios.',
        preview:
            // #region sg-rating-visual
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRating(
                  id: 'sm',
                  size: SgRatingSize.sm,
                  cancel: false,
                  value: 4,
                ),
                SizedBox(height: 8),
                SgRating(
                  id: 'xl',
                  size: SgRatingSize.xl,
                  cancel: false,
                  value: 2,
                ),
                SizedBox(height: 8),
                SgRating(
                  id: 'cores',
                  color: '#E11D48',
                  emptyColor: '#9CA3AF',
                  cancel: false,
                  value: 3,
                ),
                SizedBox(height: 8),
                SgRating(
                  id: 'icones',
                  stars: 3,
                  cancel: false,
                  value: 2,
                  onIcon: Icon(Icons.favorite, color: Colors.red),
                  offIcon: Icon(Icons.favorite_border, color: Colors.grey),
                ),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingVisual,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'required usa a mensagem do rating e exige uma nota ao enviar.',
        preview:
            // #region sg-rating-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgRating(
                  id: 'form',
                  name: 'nota',
                  control: _form,
                  label: context.tx('Nota do atendimento'),
                  required: true,
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['nota']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgRatingPageSnippets.sgRatingFormulario,
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
                'disabled',
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
          disabled: (v['disabled'] as bool?) ?? false,
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
