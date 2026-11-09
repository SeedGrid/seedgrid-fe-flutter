// Showcase do SgPeriodSelector. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_period_selector_page.snippets.g.dart';

class SgPeriodSelectorPage extends StatefulWidget {
  const SgPeriodSelectorPage({super.key});

  @override
  State<SgPeriodSelectorPage> createState() => _SgPeriodSelectorPageState();
}

class _SgPeriodSelectorPageState extends State<SgPeriodSelectorPage> {
  final SgFormController _form = SgFormController();
  final ValueNotifier<String> _basico = ValueNotifier<String>(
    'Nenhum período escolhido',
  );
  final ValueNotifier<String> _personalizado = ValueNotifier<String>(
    'Nenhum período escolhido',
  );
  final ValueNotifier<String> _limitado = ValueNotifier<String>(
    'Nenhum período escolhido',
  );
  final ValueNotifier<String> _ingles = ValueNotifier<String>(
    'No period chosen',
  );
  final ValueNotifier<String> _enviado = ValueNotifier<String>('');
  // permitPast, permitCurrent, permitFuture
  final ValueNotifier<List<bool>> _grupos = ValueNotifier<List<bool>>(
    const [true, true, false],
  );

  @override
  void dispose() {
    _form.dispose();
    _basico.dispose();
    _personalizado.dispose();
    _limitado.dispose();
    _ingles.dispose();
    _enviado.dispose();
    _grupos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Flags padrão: grupos atuais e passados, mais período customizado.',
        preview:
            // #region sg-period-selector-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPeriodSelector(
                  id: 'ps-basic',
                  label: context.tx('Período'),
                  onChange: (p) =>
                      _basico.value =
                          context.txf('{label}: {inicio} a {fim}', {
                            'label': p.label,
                            'inicio': p.startDate?.toIso8601String().substring(0, 10) ?? '-',
                            'fim': p.endDate?.toIso8601String().substring(0, 10) ?? '-',
                          }),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String>(
                  valueListenable: _basico,
                  builder: (context, resumo, _) => Text(resumo),
                ),
              ],
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorBasico,
      ),
      ShowcaseExample(
        title: 'Todos os grupos',
        description:
            'Ligue e desligue permitPast, permitCurrent e permitFuture para ver cada grupo entrar e sair da lista (permitAll fica desligado).',
        preview:
            // #region sg-period-selector-grupos
            ValueListenableBuilder<List<bool>>(
              valueListenable: _grupos,
              builder: (context, grupos, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      SgToggleSwitch(
                        id: 'ps-flag-past',
                        label: 'permitPast',
                        checked: grupos[0],
                        onChange: (v) =>
                            _grupos.value = [v, grupos[1], grupos[2]],
                      ),
                      SgToggleSwitch(
                        id: 'ps-flag-current',
                        label: 'permitCurrent',
                        checked: grupos[1],
                        onChange: (v) =>
                            _grupos.value = [grupos[0], v, grupos[2]],
                      ),
                      SgToggleSwitch(
                        id: 'ps-flag-future',
                        label: 'permitFuture',
                        checked: grupos[2],
                        onChange: (v) =>
                            _grupos.value = [grupos[0], grupos[1], v],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SgPeriodSelector(
                    id: 'ps-flags',
                    label: context.tx('Período'),
                    permitPast: grupos[0],
                    permitCurrent: grupos[1],
                    permitFuture: grupos[2],
                    permitAll: false,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorGrupos,
      ),
      ShowcaseExample(
        title: 'Período customizado',
        description:
            'Escolha Período para informar um intervalo de data inicial e final.',
        preview:
            // #region sg-period-selector-personalizado
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPeriodSelector(
                  id: 'ps-custom',
                  label: context.tx('Período'),
                  allowCustomPeriod: true,
                  permitCurrent: false,
                  permitPast: false,
                  onChange: (p) =>
                      _personalizado.value =
                          context.txf('{label}: {inicio} a {fim}', {
                            'label': p.label,
                            'inicio': p.startDate?.toIso8601String().substring(0, 10) ?? '-',
                            'fim': p.endDate?.toIso8601String().substring(0, 10) ?? '-',
                          }),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String>(
                  valueListenable: _personalizado,
                  builder: (context, resumo, _) => Text(resumo),
                ),
              ],
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorPersonalizado,
      ),
      ShowcaseExample(
        title: 'Estados',
        description: 'Estados desabilitado e obrigatório.',
        preview:
            // #region sg-period-selector-estados
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPeriodSelector(
                  id: 'ps-disabled',
                  label: context.tx('Período'),
                  enabled: false,
                ),
                const SizedBox(height: 12),
                SgPeriodSelector(
                  id: 'ps-required',
                  label: context.tx('Período'),
                  required: true,
                ),
              ],
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorEstados,
      ),
      ShowcaseExample(
        title: 'Clamp com minDate / maxDate',
        description:
            'O intervalo resolvido é limitado pelos limites min/max (aqui restrito ao mês atual).',
        preview:
            // #region sg-period-selector-clamp
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPeriodSelector(
                  id: 'ps-clamped',
                  label: context.tx('Período'),
                  permitPast: true,
                  permitCurrent: true,
                  permitFuture: true,
                  minDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
                  maxDate: DateTime(
                    DateTime.now().year,
                    DateTime.now().month + 1,
                    0,
                  ),
                  onChange: (p) =>
                      _limitado.value =
                          context.txf('{label}: {inicio} a {fim}', {
                            'label': p.label,
                            'inicio': p.startDate?.toIso8601String().substring(0, 10) ?? '-',
                            'fim': p.endDate?.toIso8601String().substring(0, 10) ?? '-',
                          }),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String>(
                  valueListenable: _limitado,
                  builder: (context, resumo, _) => Text(resumo),
                ),
              ],
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorClamp,
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
                  id: 'ps-english',
                  label: 'Period',
                  locale: 'en-US',
                  referenceDate: DateTime(2024, 2, 29),
                  onChange: (p) =>
                      _ingles.value =
                          '${p.label}: ${p.startDate?.toIso8601String().substring(0, 10) ?? '-'} to ${p.endDate?.toIso8601String().substring(0, 10) ?? '-'}',
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String>(
                  valueListenable: _ingles,
                  builder: (context, resumo, _) => Text(resumo),
                ),
              ],
            ),
        // #endregion
        code: SgPeriodSelectorPageSnippets.sgPeriodSelectorIdioma,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control: o formulário guarda o texto do preset (por exemplo THIS_MONTH).',
        preview:
            // #region sg-period-selector-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgPeriodSelector(
                  id: 'periodo-form',
                  name: 'periodo',
                  control: _form,
                  label: context.tx('Período do relatório'),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => _enviado.value = '${values['periodo']}',
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: _enviado,
                  builder: (context, enviado, _) =>
                      enviado.isEmpty ? const SizedBox() : Text(context.txf('Enviado: {valor}', {'valor': enviado})),
                ),
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
              (s) => const {'enabled', 'required', 'locale'}.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgPeriodSelector(
          id: 'pg',
          label: 'Período',
          enabled: v['enabled'] as bool?,
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
