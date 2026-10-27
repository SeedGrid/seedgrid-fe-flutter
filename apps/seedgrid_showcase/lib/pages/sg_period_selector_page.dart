// Showcase do SgPeriodSelector. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_period_selector_page.snippets.g.dart';

class SgPeriodSelectorPage extends StatefulWidget {
  const SgPeriodSelectorPage({super.key});

  @override
  State<SgPeriodSelectorPage> createState() => _SgPeriodSelectorPageState();
}

class _SgPeriodSelectorPageState extends State<SgPeriodSelectorPage> {
  final SgFormController _form = SgFormController();
  String _basico = 'Nenhum período escolhido';
  String _personalizado = 'Nenhum período escolhido';
  String _ingles = 'No period chosen';
  String _enviado = '';
  bool _passados = true;
  bool _atuais = true;
  bool _futuros = false;
  bool _todos = true;
  bool _periodo = true;

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
            'Escolha um período para receber o intervalo de datas já resolvido (início às 00:00:00 e fim às 23:59:59.999). Não dispara nada ao abrir a página.',
        preview:
            // #region sg-period-selector-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPeriodSelector(
                  label: 'Período',
                  onChange: (p) => setState(
                    () => _basico =
                        '${p.label}: ${p.startDate?.toIso8601String().substring(0, 10) ?? '-'} a ${p.endDate?.toIso8601String().substring(0, 10) ?? '-'}',
                  ),
                ),
                const SizedBox(height: 8),
                Text(_basico),
              ],
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorBasico,
      ),
      ShowcaseExample(
        title: 'Grupos de opções',
        description:
            'Cada grupo liga e desliga com permitPast, permitCurrent, permitFuture, permitAll e allowCustomPeriod. Marque as caixas para ver a lista mudar.',
        preview:
            // #region sg-period-selector-grupos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Passados'),
                      selected: _passados,
                      onSelected: (v) => setState(() => _passados = v),
                    ),
                    FilterChip(
                      label: const Text('Atuais'),
                      selected: _atuais,
                      onSelected: (v) => setState(() => _atuais = v),
                    ),
                    FilterChip(
                      label: const Text('Futuros'),
                      selected: _futuros,
                      onSelected: (v) => setState(() => _futuros = v),
                    ),
                    FilterChip(
                      label: const Text('Todos'),
                      selected: _todos,
                      onSelected: (v) => setState(() => _todos = v),
                    ),
                    FilterChip(
                      label: const Text('Período'),
                      selected: _periodo,
                      onSelected: (v) => setState(() => _periodo = v),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SgPeriodSelector(
                  id: 'grupos',
                  label: 'Período',
                  permitPast: _passados,
                  permitCurrent: _atuais,
                  permitFuture: _futuros,
                  permitAll: _todos,
                  allowCustomPeriod: _periodo,
                ),
              ],
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorGrupos,
      ),
      ShowcaseExample(
        title: 'Período personalizado com limites',
        description:
            'Escolha "Periodo" para informar duas datas. minDate e maxDate limitam o calendário e fazem clamp nos períodos prontos. Enquanto o ano está incompleto, a data sai vazia.',
        preview:
            // #region sg-period-selector-personalizado
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPeriodSelector(
                  id: 'personalizado',
                  label: 'Período',
                  minDate: DateTime(2024, 1, 1),
                  maxDate: DateTime(2024, 12, 31),
                  referenceDate: DateTime(2024, 6, 15),
                  onChange: (p) => setState(
                    () => _personalizado =
                        '${p.label}: ${p.startDate?.toIso8601String().substring(0, 10) ?? '-'} a ${p.endDate?.toIso8601String().substring(0, 10) ?? '-'}',
                  ),
                ),
                const SizedBox(height: 8),
                Text(_personalizado),
              ],
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorPersonalizado,
      ),
      ShowcaseExample(
        title: 'Idioma e data de referência',
        description:
            'locale troca rótulos e grupos (pt-BR, en-US, es, pt-PT, fr). referenceDate fixa o "hoje" usado para resolver os presets.',
        preview:
            // #region sg-period-selector-idioma
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPeriodSelector(
                  id: 'ingles',
                  label: 'Period',
                  locale: 'en-US',
                  referenceDate: DateTime(2024, 2, 29),
                  onChange: (p) => setState(
                    () => _ingles =
                        '${p.label}: ${p.startDate?.toIso8601String().substring(0, 10) ?? '-'} to ${p.endDate?.toIso8601String().substring(0, 10) ?? '-'}',
                  ),
                ),
                const SizedBox(height: 8),
                Text(_ingles),
              ],
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorIdioma,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control + rules, como no react-hook-form. O formulário guarda o texto do preset (por exemplo THIS_MONTH).',
        preview:
            // #region sg-period-selector-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPeriodSelector(
                  id: 'periodo-form',
                  name: 'periodo',
                  control: _form,
                  label: 'Período do relatório',
                  rules: const SgRules(required: 'Escolha um período'),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) =>
                        setState(() => _enviado = '${values['periodo']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgPeriodSelector',
      description:
          'Seletor de períodos prontos (hoje, esta semana, mês passado...) ou de um intervalo personalizado; entrega as datas já resolvidas.',
      examples: examples,
      propSpecs: sgPropSpecs['SgPeriodSelector']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgPeriodSelector']!
            .where(
              (s) => const {'disabled', 'required', 'locale'}.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgPeriodSelector(
          id: 'pg',
          label: 'Período',
          disabled: v['disabled'] as bool?,
          required: v['required'] as bool?,
          locale: (v['locale'] as String?) ?? 'pt-BR',
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "label: 'Período'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgPeriodSelector(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
