// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_date_time_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputDateTimePageSnippets {
  /// Region `sg-input-date-time-basico`.
  static const String sgInputDateTimeBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputDateTime(
      id: 'demo-basic',
      labelText: context.tx('Quando'),
      onChange: (value, local) => _instante.value = value,
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<String?>(
      valueListenable: _instante,
      builder: (context, instante, _) => Text(
        context.txf('Valor: {valor}', {'valor': instante ?? '-'}),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-date-time-eventos`.
  static const String sgInputDateTimeEventos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputDateTime(
      id: 'demo-events',
      labelText: context.tx('Quando'),
      onChange: (value, local) =>
          _evento.value = 'onChange: ${value ?? local}',
      onEnter: () => _evento.value = 'onEnter',
      onExit: () => _evento.value = 'onExit',
    ),
    const SizedBox(height: 8),
    ValueListenableBuilder<String>(
      valueListenable: _evento,
      builder: (context, evento, _) => Text(
        context.txf('Último evento: {evento}', {'evento': evento}),
      ),
    ),
  ],
)
''';

  /// Region `sg-input-date-time-formulario`.
  static const String sgInputDateTimeFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputDateTime(
      id: 'demo-form',
      name: 'consulta',
      control: _form,
      labelText: context.tx('Agendamento'),
      timeZone: '-03:00',
      required: true,
      requiredMessage: context.tx('Informe a data e a hora'),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => _enviado.value = '${values['consulta']}',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _enviado,
      builder: (context, enviado, _) => enviado.isEmpty
          ? const SizedBox.shrink()
          : Text(
              context.txf('Enviado: {valor}', {'valor': enviado}),
            ),
    ),
  ],
)
''';

  /// Region `sg-input-date-time-fusos`.
  static const String sgInputDateTimeFusos = r'''
ValueListenableBuilder<String>(
  valueListenable: _fuso,
  builder: (context, fuso, _) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgInputDateTime(
        id: 'demo-zone-utc',
        labelText: 'UTC',
        timeZone: 'UTC',
        value: fuso,
        // Campo incompleto (null) não mexe nos outros: só um instante válido atualiza.
        onChange: (value, local) {
          if (value != null) _fuso.value = value;
        },
      ),
      const SizedBox(height: 12),
      SgInputDateTime(
        id: 'demo-zone-sp',
        labelText: '-03:00',
        timeZone: '-03:00',
        value: fuso,
        onChange: (value, local) {
          if (value != null) _fuso.value = value;
        },
      ),
      const SizedBox(height: 12),
      SgInputDateTime(
        id: 'demo-zone-in',
        labelText: '+05:30',
        timeZone: '+05:30',
        value: fuso,
        onChange: (value, local) {
          if (value != null) _fuso.value = value;
        },
      ),
      const SizedBox(height: 8),
      Text(context.txf('Valor: {valor}', {'valor': fuso})),
    ],
  ),
)
''';

  /// Region `sg-input-date-time-idioma`.
  static const String sgInputDateTimeIdioma = r'''
SgComponentsI18nProvider(
  locale: 'fr',
  messages: {
    'components.inputs.datetime.min': context.tx(
      'Escolha uma data a partir de {min}.',
    ),
  },
  child: SgInputDateTime(
    id: 'demo-i18n',
    labelText: context.tx('Agendamento'),
    timeZone: 'UTC',
    minDate: '2026-11-01T08:00:00Z',
    defaultValue: '2026-10-01T10:00:00Z',
    required: true,
  ),
)
''';

  /// Region `sg-input-date-time-limites`.
  static const String sgInputDateTimeLimites = r'''
SgInputDateTime(
  id: 'demo-limits',
  labelText: context.tx('Agendamento'),
  timeZone: 'UTC',
  minDate: '2026-11-01T08:00:00Z',
  maxDate: '2026-11-30T18:00:00Z',
  minuteStep: 15,
  required: true,
)
''';

  /// Region `sg-input-date-time-rotulo`.
  static const String sgInputDateTimeRotulo = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  children: [
    SizedBox(
      width: 280,
      child: SgInputDateTime(
        id: 'sg-input-date-time-label-float',
        labelText: context.tx('Flutuante'),
        labelPosition: SgInputDateTimeLabelPosition.float,
      ),
    ),
    SizedBox(
      width: 280,
      child: SgInputDateTime(
        id: 'sg-input-date-time-label-top',
        labelText: context.tx('Acima'),
        labelPosition: SgInputDateTimeLabelPosition.top,
      ),
    ),
    SizedBox(
      width: 360,
      child: SgInputDateTime(
        id: 'sg-input-date-time-label-left',
        labelText: context.tx('Esquerda'),
        labelPosition: SgInputDateTimeLabelPosition.left,
        labelWidth: 140,
        labelAlign: SgInputDateTimeLabelAlign.end,
      ),
    ),
  ],
)
''';

  /// Region `sg-input-date-time-segundos`.
  static const String sgInputDateTimeSegundos = r'''
SgInputDateTime(
  id: 'demo-seconds',
  labelText: context.tx('Evento'),
  timeZone: 'UTC',
  defaultValue: '2026-11-03T17:30:45Z',
  showSeconds: true,
)
''';
}
