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
      label: 'Período',
      onChange: (p) => setState(
        () => _basico =
            '${p.label}: ${p.startDate?.toIso8601String().substring(0, 10) ?? '-'} a ${p.endDate?.toIso8601String().substring(0, 10) ?? '-'}',
      ),
    ),
    const SizedBox(height: 8),
    Text(_basico),
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
)
''';

  /// Region `sg-period-selector-grupos`.
  static const String sgPeriodSelectorGrupos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Wrap(
      spacing: 8,
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
)
''';

  /// Region `sg-period-selector-idioma`.
  static const String sgPeriodSelectorIdioma = r'''
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
)
''';

  /// Region `sg-period-selector-personalizado`.
  static const String sgPeriodSelectorPersonalizado = r'''
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
)
''';
}
