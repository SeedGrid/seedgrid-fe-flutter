// Showcase do SgYearPartSelector. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_year_part_selector_page.snippets.g.dart';

class SgYearPartSelectorPage extends StatefulWidget {
  const SgYearPartSelectorPage({super.key});

  @override
  State<SgYearPartSelectorPage> createState() => _SgYearPartSelectorPageState();
}

class _SgYearPartSelectorPageState extends State<SgYearPartSelectorPage> {
  // Resultado de cada exemplo: o seletor escreve no notifier e so o Text interessado reconstroi
  // (a pagina nao se reconstroi).
  final _basico = ValueNotifier<ResolvedYearPart?>(null);
  final _semestre = ValueNotifier<ResolvedYearPart?>(null);
  final _faixa = ValueNotifier<ResolvedYearPart?>(null);

  @override
  void dispose() {
    _basico.dispose();
    _semestre.dispose();
    _faixa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Os três controles: ano, recorte e fatia. Não há onChange na montagem: o intervalo resolvido aparece quando você mexe em algum deles.',
        preview:
            // #region sg-year-part-selector-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgYearPartSelector(
                  id: 'yps-basic',
                  label: context.tx('Recorte do ano'),
                  onChange: (r) => _basico.value = r,
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<ResolvedYearPart?>(
                  valueListenable: _basico,
                  builder: (context, r, _) => Text(
                    r == null
                        ? context.tx('Nenhum recorte confirmado ainda')
                        : '${r.label}: ${r.startDate.toIso8601String().substring(0, 10)} - ${r.endDate.toIso8601String().substring(0, 10)}',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgYearPartSelectorPageSnippets.sgYearPartSelectorBasico,
      ),
      ShowcaseExample(
        title: 'Só semestre',
        description:
            'Com allowedKinds de um item só, o combo de recorte some: sobram ano e fatia, que é o que um fechamento semestral realmente pergunta.',
        preview:
            // #region sg-year-part-selector-semestre
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgYearPartSelector(
                  id: 'yps-semester',
                  label: context.tx('Semestre de apuração'),
                  allowedKinds: const [YearPartKind.semester],
                  onChange: (r) => _semestre.value = r,
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<ResolvedYearPart?>(
                  valueListenable: _semestre,
                  builder: (context, r, _) => Text(
                    r == null
                        ? context.tx('Nenhum recorte confirmado ainda')
                        : r.label,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgYearPartSelectorPageSnippets.sgYearPartSelectorSemestre,
      ),
      ShowcaseExample(
        title: 'Faixa de anos',
        description:
            'minYear e maxYear estreitam a lista de anos. O padrão vai do ano corrente - 30 ao ano corrente + 10; ano sem movimento não deveria ser oferecido.',
        preview:
            // #region sg-year-part-selector-faixa
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgYearPartSelector(
                  id: 'yps-range',
                  label: context.tx('Exercício'),
                  minYear: 2020,
                  maxYear: 2026,
                  onChange: (r) => _faixa.value = r,
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<ResolvedYearPart?>(
                  valueListenable: _faixa,
                  builder: (context, r, _) => Text(
                    r == null
                        ? context.tx('Nenhum recorte confirmado ainda')
                        : r.label,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgYearPartSelectorPageSnippets.sgYearPartSelectorFaixa,
      ),
      ShowcaseExample(
        title: 'Estados',
        description:
            'Desabilitado e obrigatório valem para os três controles de uma vez.',
        preview:
            // #region sg-year-part-selector-estados
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgYearPartSelector(
                  id: 'yps-disabled',
                  label: context.tx('Recorte do ano'),
                  enabled: false,
                ),
                const SizedBox(height: 16),
                SgYearPartSelector(
                  id: 'yps-required',
                  label: context.tx('Recorte do ano'),
                  required: true,
                ),
              ],
            ),
        // #endregion
        code: SgYearPartSelectorPageSnippets.sgYearPartSelectorEstados,
      ),
      ShowcaseExample(
        title: 'Locale e as siglas',
        description:
            'A sigla entre parênteses acompanha o idioma e NÃO é a inicial do nome traduzido: Q1..Q4 em pt-BR e en-US, T1..T4 em es, fr e pt-PT; semestre é S no português e H (Half-year) no inglês; bimestre não tem sigla consagrada e sai sem parênteses.',
        preview:
            // #region sg-year-part-selector-locale
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgYearPartSelector(
                  id: 'yps-ptbr',
                  label: 'pt-BR',
                  locale: 'pt-BR',
                  allowedKinds: const [YearPartKind.quarter],
                ),
                const SizedBox(height: 16),
                SgYearPartSelector(
                  id: 'yps-enus',
                  label: 'en-US',
                  locale: 'en-US',
                  allowedKinds: const [YearPartKind.semester],
                ),
                const SizedBox(height: 16),
                SgYearPartSelector(
                  id: 'yps-es',
                  label: 'es',
                  locale: 'es',
                  allowedKinds: const [YearPartKind.quarter],
                ),
              ],
            ),
        // #endregion
        code: SgYearPartSelectorPageSnippets.sgYearPartSelectorLocale,
      ),
    ];

    return SgShowcasePage(
      name: 'SgYearPartSelector',
      description:
          'Seletor de recorte de ano: o usuário escolhe ano, recorte (semestre, trimestre ou bimestre) e fatia, e recebe o intervalo de datas resolvido.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgYearPartSelector']!,
        const SgPropSpec(
          name: 'today',
          reactName: '-',
          type: 'DateTime?',
          tsType: '-',
          required: false,
          description:
              'Extra do Flutter: "hoje" para o estado inicial e para a faixa de anos (padrão: agora). No React o componente lê new Date().',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgYearPartSelector']!
            .where(
              (s) => const {
                'enabled',
                'required',
                'label',
                'locale',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgYearPartSelector(
          id: 'pg',
          label: v['label'] as String?,
          enabled: v['enabled'] as bool?,
          required: v['required'] as bool?,
          locale: (v['locale'] as String?) ?? 'pt-BR',
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgYearPartSelector(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
