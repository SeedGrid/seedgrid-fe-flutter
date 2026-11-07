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
  final ValueNotifier<String?> _instante = ValueNotifier<String?>(null);
  final ValueNotifier<String> _fuso = ValueNotifier<String>(
    '2026-11-03T17:30:00.000Z',
  );
  final ValueNotifier<String> _evento = ValueNotifier<String>('-');
  final ValueNotifier<String> _enviado = ValueNotifier<String>('');

  @override
  void dispose() {
    _form.dispose();
    _instante.dispose();
    _fuso.dispose();
    _evento.dispose();
    _enviado.dispose();
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
            SgInputDateTime(
              id: 'demo-limits',
              labelText: context.tx('Agendamento'),
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
            SgInputDateTime(
              id: 'demo-seconds',
              labelText: context.tx('Evento'),
              timeZone: 'UTC',
              defaultValue: '2026-11-03T17:30:45Z',
              showSeconds: true,
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeSegundos,
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
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeEventos,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'O formulário guarda o instante ISO 8601 UTC.',
        preview:
            // #region sg-input-date-time-formulario
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
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeFormulario,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-date-time-rotulo
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
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeRotulo,
      ),
      ShowcaseExample(
        title: 'Idioma e textos (i18n)',
        description:
            'Os textos internos vêm do dicionário components.inputs.datetime.*. Envolva o componente em SgComponentsI18nProvider (ou chame setComponentsI18n) para trocar o idioma e use messages para substituir uma chave.',
        preview:
            // #region sg-input-date-time-idioma
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
            ),
        // #endregion
        code: SgInputDateTimePageSnippets.sgInputDateTimeIdioma,
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
                'enabled',
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
          enabled: v['enabled'] as bool?,
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
