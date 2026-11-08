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
)
''';

  /// Region `sg-year-part-selector-controlado`.
  static const String sgYearPartSelectorControlado = r'''
ValueListenableBuilder<YearPartValue>(
  valueListenable: _controlado,
  builder: (context, valor, _) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgYearPartSelector(
        id: 'yps-controlled',
        label: context.tx('Recorte do ano'),
        value: valor,
        onChange: (r) => _controlado.value = r.value,
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          SgButton(
            label: Text(context.tx('1º trimestre de 2024')),
            appearance: SgAppearance.outline,
            onClick: () => _controlado.value = const YearPartValue(
              year: 2024,
              kind: YearPartKind.quarter,
              part: 1,
            ),
          ),
          SgButton(
            label: Text(context.tx('2º bimestre de 2023')),
            appearance: SgAppearance.outline,
            onClick: () => _controlado.value = const YearPartValue(
              year: 2023,
              kind: YearPartKind.bimester,
              part: 2,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        '${context.tx('Valor')}: ${valor.year} - ${valor.kind.name} ${valor.part}',
      ),
    ],
  ),
)
''';

  /// Region `sg-year-part-selector-estados`.
  static const String sgYearPartSelectorEstados = r'''
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
)
''';

  /// Region `sg-year-part-selector-faixa`.
  static const String sgYearPartSelectorFaixa = r'''
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
)
''';

  /// Region `sg-year-part-selector-locale`.
  static const String sgYearPartSelectorLocale = r'''
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
)
''';

  /// Region `sg-year-part-selector-semestre`.
  static const String sgYearPartSelectorSemestre = r'''
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
)
''';
}
