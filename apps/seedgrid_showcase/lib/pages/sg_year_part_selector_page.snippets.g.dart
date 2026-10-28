// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_year_part_selector_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgYearPartSelectorPageSnippets {
  /// Region `sg-year-part-selector-basico`.
  static const String sgYearPartSelectorBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgYearPartSelector(
      label: context.tx('Recorte do ano'),
      onChange: (r) => setState(
        () => _basico =
            '${r.value.year} - ${r.label}: ${r.startDate.toIso8601String().substring(0, 10)} a ${r.endDate.toIso8601String().substring(0, 10)}',
      ),
    ),
    const SizedBox(height: 8),
    Text(_basico),
  ],
)
''';

  /// Region `sg-year-part-selector-controlado`.
  static const String sgYearPartSelectorControlado = r'''
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
          label: Text(context.tx('1º trimestre de 2024')),
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
          label: Text(context.tx('2º bimestre de 2023')),
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
)
''';

  /// Region `sg-year-part-selector-estados`.
  static const String sgYearPartSelectorEstados = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgYearPartSelector(
      id: 'obrigatorio',
      label: context.tx('Período do relatório'),
      required: true,
    ),
    SizedBox(height: 16),
    SgYearPartSelector(
      id: 'desabilitado',
      label: context.tx('Desabilitado'),
      disabled: true,
    ),
  ],
)
''';

  /// Region `sg-year-part-selector-faixa`.
  static const String sgYearPartSelectorFaixa = r'''
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
)
''';

  /// Region `sg-year-part-selector-trimestres`.
  static const String sgYearPartSelectorTrimestres = r'''
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
)
''';
}
