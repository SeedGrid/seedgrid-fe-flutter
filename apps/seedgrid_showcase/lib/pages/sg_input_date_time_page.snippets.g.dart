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
      id: 'quando',
      labelText: 'Quando',
      onChange: (value, local) => setState(() => _instante = value),
    ),
    const SizedBox(height: 8),
    Text('Valor atual: ${_instante ?? '-'}'),
  ],
)
''';

  /// Region `sg-input-date-time-eventos`.
  static const String sgInputDateTimeEventos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputDateTime(
      id: 'eventos',
      labelText: 'Quando',
      onChange: (value, local) =>
          setState(() => _evento = 'onChange: ${value ?? local}'),
      onEnter: () => setState(() => _evento = 'onEnter'),
      onExit: () => setState(() => _evento = 'onExit'),
    ),
    const SizedBox(height: 8),
    Text('Último evento: $_evento'),
  ],
)
''';

  /// Region `sg-input-date-time-formulario`.
  static const String sgInputDateTimeFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputDateTime(
      id: 'consulta',
      name: 'consulta',
      control: _form,
      labelText: 'Consulta',
      timeZone: '-03:00',
      required: true,
      requiredMessage: 'Informe a data e a hora',
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) =>
            setState(() => _enviado = '${values['consulta']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-input-date-time-fusos`.
  static const String sgInputDateTimeFusos = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputDateTime(
      id: 'fuso-utc',
      labelText: 'UTC',
      timeZone: 'UTC',
      value: _fuso,
      // Campo incompleto (null) nao mexe nos outros: so um instante valido atualiza.
      onChange: (value, local) {
        if (value != null) setState(() => _fuso = value);
      },
    ),
    const SizedBox(height: 12),
    SgInputDateTime(
      id: 'fuso-sp',
      labelText: '-03:00',
      timeZone: '-03:00',
      value: _fuso,
      // Campo incompleto (null) nao mexe nos outros: so um instante valido atualiza.
      onChange: (value, local) {
        if (value != null) setState(() => _fuso = value);
      },
    ),
    const SizedBox(height: 12),
    SgInputDateTime(
      id: 'fuso-in',
      labelText: '+05:30',
      timeZone: '+05:30',
      value: _fuso,
      // Campo incompleto (null) nao mexe nos outros: so um instante valido atualiza.
      onChange: (value, local) {
        if (value != null) setState(() => _fuso = value);
      },
    ),
    const SizedBox(height: 8),
    Text('Valor atual: $_fuso'),
  ],
)
''';

  /// Region `sg-input-date-time-idioma`.
  static const String sgInputDateTimeIdioma = r'''
const SgComponentsI18nProvider(
  locale: 'fr',
  messages: {
    'components.inputs.datetime.min':
        'Escolha uma data a partir de {min}.',
  },
  child: SgInputDateTime(
    id: 'idioma',
    labelText: 'Agendamento',
    timeZone: 'UTC',
    minDate: '2026-11-01T08:00:00Z',
    defaultValue: '2026-10-01T10:00:00Z',
    required: true,
  ),
)
''';

  /// Region `sg-input-date-time-limites`.
  static const String sgInputDateTimeLimites = r'''
const SgInputDateTime(
  id: 'limites',
  labelText: 'Agendamento',
  timeZone: 'UTC',
  minDate: '2026-11-01T08:00:00Z',
  maxDate: '2026-11-30T18:00:00Z',
  minuteStep: 15,
  required: true,
)
''';

  /// Region `sg-input-date-time-segundos`.
  static const String sgInputDateTimeSegundos = r'''
const SgInputDateTime(
  id: 'segundos',
  labelText: 'Evento',
  timeZone: 'UTC',
  defaultValue: '2026-11-03T17:30:45Z',
  showSeconds: true,
)
''';
}
