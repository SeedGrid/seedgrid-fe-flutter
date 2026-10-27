// Showcase do SgYearPartSelector. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_year_part_selector_page.snippets.g.dart';

class SgYearPartSelectorPage extends StatefulWidget {
  const SgYearPartSelectorPage({super.key});

  @override
  State<SgYearPartSelectorPage> createState() => _SgYearPartSelectorPageState();
}

class _SgYearPartSelectorPageState extends State<SgYearPartSelectorPage> {
  String _basico = 'Nenhum recorte escolhido';
  String _trimestres = 'Nenhum recorte escolhido';
  String _ingles = 'No part chosen';
  YearPartValue _controlado = const YearPartValue(
    year: 2024,
    kind: YearPartKind.quarter,
    part: 1,
  );
  String _controladoTexto = '';

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Escolha ano, recorte (semestre, trimestre ou bimestre) e fatia: o intervalo de datas sai resolvido. Abre no ano corrente, no primeiro recorte e na fatia em que hoje cai, sem disparar onChange.',
        preview:
            // #region sg-year-part-selector-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgYearPartSelector(
                  label: 'Recorte do ano',
                  onChange: (r) => setState(
                    () => _basico =
                        '${r.value.year} - ${r.label}: ${r.startDate.toIso8601String().substring(0, 10)} a ${r.endDate.toIso8601String().substring(0, 10)}',
                  ),
                ),
                const SizedBox(height: 8),
                Text(_basico),
              ],
            ),
        // #endregion
        code: SgYearPartSelectorPageSnippets.sgYearPartSelectorBasico,
      ),
      ShowcaseExample(
        title: 'Só trimestres',
        description:
            'allowedKinds restringe os recortes. Com um único recorte permitido, o combo de recorte some.',
        preview:
            // #region sg-year-part-selector-trimestres
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgYearPartSelector(
                  id: 'trimestres',
                  allowedKinds: const [YearPartKind.quarter],
                  onChange: (r) => setState(
                    () => _trimestres =
                        '${r.label}: ${r.startDate.toIso8601String().substring(0, 10)} a ${r.endDate.toIso8601String().substring(0, 10)}',
                  ),
                ),
                const SizedBox(height: 8),
                Text(_trimestres),
              ],
            ),
        // #endregion
        code: SgYearPartSelectorPageSnippets.sgYearPartSelectorTrimestres,
      ),
      ShowcaseExample(
        title: 'Faixa de anos e idioma',
        description:
            'minYear e maxYear limitam a lista de anos (do mais novo para o mais velho). locale troca rótulos e siglas: em en-US o trimestre é "Q", em es, fr e pt-PT é "T".',
        preview:
            // #region sg-year-part-selector-faixa
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgYearPartSelector(
                  id: 'faixa',
                  locale: 'en-US',
                  minYear: 2020,
                  maxYear: 2026,
                  onChange: (r) => setState(
                    () => _ingles =
                        '${r.value.year} - ${r.label}: ${r.startDate.toIso8601String().substring(0, 10)} to ${r.endDate.toIso8601String().substring(0, 10)}',
                  ),
                ),
                const SizedBox(height: 8),
                Text(_ingles),
              ],
            ),
        // #endregion
        code: SgYearPartSelectorPageSnippets.sgYearPartSelectorFaixa,
      ),
      ShowcaseExample(
        title: 'Valor controlado',
        description:
            'Com value, o pai manda: escolher emite onChange e o campo só muda quando o value muda. Fatia que não existe no recorte cai na primeira.',
        preview:
            // #region sg-year-part-selector-controlado
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgYearPartSelector(
                  id: 'controlado',
                  value: _controlado,
                  onChange: (r) => setState(() {
                    _controlado = r.value;
                    _controladoTexto = r.label;
                  }),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: const Text('1º trimestre de 2024'),
                      appearance: SgAppearance.outline,
                      onClick: () => setState(
                        () => _controlado = const YearPartValue(
                          year: 2024,
                          kind: YearPartKind.quarter,
                          part: 1,
                        ),
                      ),
                    ),
                    SgButton(
                      label: const Text('2º bimestre de 2023'),
                      appearance: SgAppearance.outline,
                      onClick: () => setState(
                        () => _controlado = const YearPartValue(
                          year: 2023,
                          kind: YearPartKind.bimester,
                          part: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Valor: $_controlado ${_controladoTexto.isEmpty ? '' : '($_controladoTexto)'}',
                ),
              ],
            ),
        // #endregion
        code: SgYearPartSelectorPageSnippets.sgYearPartSelectorControlado,
      ),
      ShowcaseExample(
        title: 'Rótulo, obrigatório e desabilitado',
        preview:
            // #region sg-year-part-selector-estados
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgYearPartSelector(
                  id: 'obrigatorio',
                  label: 'Período do relatório',
                  required: true,
                ),
                SizedBox(height: 16),
                SgYearPartSelector(
                  id: 'desabilitado',
                  label: 'Desabilitado',
                  disabled: true,
                ),
              ],
            ),
        // #endregion
        code: SgYearPartSelectorPageSnippets.sgYearPartSelectorEstados,
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
                'disabled',
                'required',
                'label',
                'locale',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgYearPartSelector(
          id: 'pg',
          label: v['label'] as String?,
          disabled: v['disabled'] as bool?,
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
