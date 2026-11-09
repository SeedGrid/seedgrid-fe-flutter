// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_period_selector_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgPeriodSelectorPageSnippets {
  /// Region `sg-period-selector-basico`.
  static const String sgPeriodSelectorBasico = r'''
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
)
''';

  /// Region `sg-period-selector-clamp`.
  static const String sgPeriodSelectorClamp = r'''
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
)
''';

  /// Region `sg-period-selector-estados`.
  static const String sgPeriodSelectorEstados = r'''
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
)
''';

  /// Region `sg-period-selector-formulario`.
  static const String sgPeriodSelectorFormulario = r'''
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
)
''';

  /// Region `sg-period-selector-grupos`.
  static const String sgPeriodSelectorGrupos = r'''
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
)
''';

  /// Region `sg-period-selector-idioma`.
  static const String sgPeriodSelectorIdioma = r'''
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
)
''';

  /// Region `sg-period-selector-personalizado`.
  static const String sgPeriodSelectorPersonalizado = r'''
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
)
''';
}
