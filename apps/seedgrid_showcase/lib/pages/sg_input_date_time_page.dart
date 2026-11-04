// Showcase do SgInputDateTime. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_date_time_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgInputDateTimePage extends StatefulWidget {
  const SgInputDateTimePage({super.key});

  @override
  State<SgInputDateTimePage> createState() => _SgInputDateTimePageState();
}

class _SgInputDateTimePageState extends State<SgInputDateTimePage> {
  final SgFormController _form = SgFormController();
  String? _instante;
  String _fuso = '2026-11-03T17:30:00.000Z';
  String _enviado = '';
  String _evento = '-';

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
            'O onChange entrega o instante em ISO 8601 UTC (ou null se o campo estiver incompleto).',
        preview:
            // #region sg-input-date-time-basico
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
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeBasico,
      ),
      ShowcaseExample(
        title: 'Fusos horários',
        description:
            'O mesmo instante exibido em UTC, -03:00 e +05:30; editar um campo atualiza os outros.',
        preview:
            // #region sg-input-date-time-fusos
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
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeFusos,
      ),
      ShowcaseExample(
        title: 'Limites e passo de minutos',
        description:
            'minDate/maxDate validam o intervalo e minuteStep arredonda os minutos ao sair do campo.',
        preview:
            // #region sg-input-date-time-limites
            const SgInputDateTime(
              id: 'limites',
              labelText: 'Agendamento',
              timeZone: 'UTC',
              minDate: '2026-11-01T08:00:00Z',
              maxDate: '2026-11-30T18:00:00Z',
              minuteStep: 15,
              required: true,
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeLimites,
      ),
      ShowcaseExample(
        title: 'Com segundos',
        description: 'showSeconds mostra e aceita os segundos.',
        preview:
            // #region sg-input-date-time-segundos
            const SgInputDateTime(
              id: 'segundos',
              labelText: 'Evento',
              timeZone: 'UTC',
              defaultValue: '2026-11-03T17:30:45Z',
              showSeconds: true,
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeSegundos,
      ),
      // Exemplo só do Flutter (depois dos que espelham o React).
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'O formulário guarda o instante ISO 8601 UTC.',
        preview:
            // #region sg-input-date-time-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputDateTime(
                  id: 'consulta',
                  name: 'consulta',
                  control: _form,
                  labelText: 'Consulta',
                  timeZone: '-03:00',
                  rules: const SgRules(required: 'Informe a data e a hora'),
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
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeFormulario,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description:
            'onChange (instante ou null), onEnter (foco) e onExit (saída) informam o que o usuário fez.',
        preview:
            // #region sg-input-date-time-eventos
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
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeEventos,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputDateTime',
      description:
          'Campo de data e hora que entrega e recebe instantes ISO 8601 em UTC, exibindo a hora no fuso escolhido.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputDateTime']!,
        const SgPropSpec(
          name: 'autofocus',
          reactName: 'inputProps.autoFocus',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
          description: 'Foca o campo ao abrir.',
        ),
        const SgPropSpec(
          name: 'focusNode',
          reactName: 'inputProps.ref',
          type: 'FocusNode?',
          tsType: 'Ref<HTMLInputElement>',
          required: false,
          description: 'Controle externo do foco.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputDateTime']!
            .where(
              (s) => const {
                'labelPosition',
                'filled',
                'disabled',
                'readOnly',
                'clearButton',
                'required',
                'showSeconds',
                'hintText',
                'validateOnBlur',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputDateTime(
          id: 'pg',
          labelText: 'Rótulo',
          timeZone: 'UTC',
          labelPosition: SgInputDateTimeLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          filled: v['filled'] as bool?,
          disabled: v['disabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          clearButton: v['clearButton'] as bool?,
          required: v['required'] as bool?,
          showSeconds: v['showSeconds'] as bool?,
          validateOnBlur: v['validateOnBlur'] as bool?,
          hintText: v['hintText'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            "labelText: 'Rótulo'",
            "timeZone: 'UTC'",
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputDateTimeLabelPosition.${SgInputDateTimeLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputDateTime(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
