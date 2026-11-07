// Showcase do SgCalendar. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_calendar_page.snippets.g.dart';

class SgCalendarPage extends StatefulWidget {
  const SgCalendarPage({super.key});

  @override
  State<SgCalendarPage> createState() => _SgCalendarPageState();
}

class _SgCalendarPageState extends State<SgCalendarPage> {
  DateTime _escolhida = DateTime(2026, 3, 18);
  DateTime _mes = DateTime(2026, 3, 1);
  DateTime _selecionado = DateTime(2026, 3, 10);
  String _locale = 'pt-BR';
  int _inicioSemana = 0;
  int _meses = 6;

  @override
  Widget build(BuildContext context) {
    String dd(int n) => n.toString().padLeft(2, '0');
    final selecionadoTexto =
        '${dd(_selecionado.day)}/${dd(_selecionado.month)}/${_selecionado.year}';
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico (mês atual)',
        description:
            'Configuração inicial com data selecionada e posição do cartão persistida.',
        preview:
            // #region sg-calendar-mes-atual
            const SgCalendar(
              locale: 'pt-BR',
              defaultValue: '2026-03-10',
              defaultViewDate: '2026-03-01',
              cardTitle: Text('Calendário base'),
              cardProps: SgCalendarCardProps(
                id: 'showcase-calendar-basic',
                dragPersistKey: 'showcase-calendar-basic',
              ),
            ),
        // #endregion
        code: SgCalendarPageSnippets.sgCalendarMesAtual,
      ),
      ShowcaseExample(
        title: 'Selecionado controlado + limite de datas',
        description:
            'Controle externo do valor, bloqueio de fins de semana e limite mínimo e máximo.',
        preview:
            // #region sg-calendar-selecionado-limite
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCalendar(
                  value: _selecionado,
                  onValueChange: (data) => setState(() => _selecionado = data),
                  locale: 'pt-BR',
                  minDate: DateTime(2026, 3, 5),
                  maxDate: DateTime(2026, 3, 25),
                  isDateDisabled: (data) =>
                      data.weekday == DateTime.saturday ||
                      data.weekday == DateTime.sunday,
                  cardTitle: const Text('Agenda de visitas'),
                  cardProps: const SgCalendarCardProps(
                    id: 'showcase-calendar-range',
                    dragPersistKey: 'showcase-calendar-range',
                  ),
                ),
                const SizedBox(height: 8),
                Text('${context.tx('Selecionado')}: $selecionadoTexto'),
              ],
            ),
        // #endregion
        code: SgCalendarPageSnippets.sgCalendarSelecionadoLimite,
      ),
      ShowcaseExample(
        title: 'Locale + múltiplos meses',
        description:
            'Alterna o locale, o primeiro dia da semana e a quantidade de meses (numberOfMonths, monthsPerLine = 3).',
        preview:
            // #region sg-calendar-locale-meses
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final l in const ['pt-BR', 'en-US', 'es'])
                      SgButton(
                        label: Text(l),
                        appearance: _locale == l
                            ? SgAppearance.solid
                            : SgAppearance.outline,
                        onClick: () => setState(() => _locale = l),
                      ),
                    SgButton(
                      label: Text(context.tx('Domingo primeiro')),
                      appearance: _inicioSemana == 0
                          ? SgAppearance.solid
                          : SgAppearance.outline,
                      onClick: () => setState(() => _inicioSemana = 0),
                    ),
                    SgButton(
                      label: Text(context.tx('Segunda primeiro')),
                      appearance: _inicioSemana == 1
                          ? SgAppearance.solid
                          : SgAppearance.outline,
                      onClick: () => setState(() => _inicioSemana = 1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final n in const [1, 3, 6, 12])
                      SgButton(
                        label: Text(
                          '$n ${context.tx(n == 1 ? 'mês' : 'meses')}',
                        ),
                        appearance: _meses == n
                            ? SgAppearance.solid
                            : SgAppearance.outline,
                        onClick: () => setState(() => _meses = n),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SgCalendar(
                  locale: _locale,
                  weekStartsOn: _inicioSemana,
                  numberOfMonths: _meses,
                  monthsPerLine: 3,
                  defaultValue: '2026-03-10',
                  defaultViewDate: '2026-03-01',
                  cardTitle: const Text('Calendário i18n + vários meses'),
                  cardProps: const SgCalendarCardProps(
                    id: 'showcase-calendar-i18n',
                    dragPersistKey: 'showcase-calendar-i18n',
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgCalendarPageSnippets.sgCalendarLocaleMeses,
      ),
      ShowcaseExample(
        title: 'Desabilitado (enabled)',
        description:
            'Com enabled: false os dias e os botões de mês e de hoje ficam desabilitados; a data e o mês atuais continuam legíveis.',
        preview:
            // #region sg-calendar-enabled
            const SgCalendar(
              defaultValue: '2026-11-10',
              defaultViewDate: '2026-11-01',
              enabled: false,
            ),
        // #endregion
        code: SgCalendarPageSnippets.sgCalendarEnabled,
      ),
      ShowcaseExample(
        title: 'Básico',
        description:
            'Calendário mensal em pt-BR, com o dia de hoje marcado e o atalho para voltar a ele.',
        preview:
            // #region sg-calendar-basico
            SgCalendar(onValueChange: (data) => debugPrint('Escolheu $data')),
        // #endregion
        code: SgCalendarPageSnippets.sgCalendarBasico,
      ),
      ShowcaseExample(
        title: 'Idioma e início da semana',
        description:
            'O locale muda os nomes; weekStartsOn escolhe o primeiro dia (0 = domingo, 1 = segunda); weekdayFormat: narrow, short ou long.',
        preview:
            // #region sg-calendar-idioma
            const SgCalendar(
              locale: 'en-US',
              weekStartsOn: 1,
              weekdayFormat: SgCalendarWeekdayFormat.short,
              defaultValue: '2026-07-04',
            ),
        // #endregion
        code: SgCalendarPageSnippets.sgCalendarIdioma,
      ),
      ShowcaseExample(
        title: 'Limites e dias bloqueados',
        description:
            'minDate e maxDate são inclusivos; isDateDisabled bloqueia o que quiser (aqui, fins de semana).',
        preview:
            // #region sg-calendar-limites
            SgCalendar(
              defaultValue: '2026-03-16',
              minDate: '2026-03-10',
              maxDate: '2026-03-27',
              isDateDisabled: (data) =>
                  data.weekday == DateTime.saturday ||
                  data.weekday == DateTime.sunday,
            ),
        // #endregion
        code: SgCalendarPageSnippets.sgCalendarLimites,
      ),
      ShowcaseExample(
        title: 'Vários meses',
        description:
            'numberOfMonths mostra de 1 a 12 meses; monthsPerLine define quantos por linha; showAdjacentMonths: false esconde os dias dos meses vizinhos.',
        preview:
            // #region sg-calendar-meses
            const SgCalendar(
              numberOfMonths: 3,
              monthsPerLine: 2,
              showAdjacentMonths: false,
              defaultViewDate: '2026-03-01',
            ),
        // #endregion
        code: SgCalendarPageSnippets.sgCalendarMeses,
      ),
      ShowcaseExample(
        title: 'Controlado',
        description:
            'value e viewDate vêm do estado do pai; o calendário só avisa, e quem muda é você.',
        preview:
            // #region sg-calendar-controlado
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCalendar(
                  value: _escolhida,
                  viewDate: _mes,
                  onValueChange: (data) => setState(() => _escolhida = data),
                  onViewDateChange: (mes) => setState(() => _mes = mes),
                ),
                const SizedBox(height: 8),
                Text(
                  'Escolhida: ${_escolhida.day}/${_escolhida.month}/${_escolhida.year}',
                ),
              ],
            ),
        // #endregion
        code: SgCalendarPageSnippets.sgCalendarControlado,
      ),
    ];

    const extras = <SgPropSpec>[
      SgPropSpec(
        name: 'defaultValue',
        reactName: 'defaultValue',
        type: 'Object?',
        tsType: 'string | Date',
        required: false,
        description:
            'Data inicial quando não há value (DateTime ou texto YYYY-MM-DD). Fica fora do contrato gerado porque o tipo do HTML tem a mesma prop.',
        exact: false,
      ),
      SgPropSpec(
        name: 'today',
        reactName: '-',
        type: 'DateTime?',
        tsType: '(só Flutter)',
        required: false,
        description:
            'Fixa o "hoje" (no React é new Date() no primeiro render). Útil em testes e demonstrações.',
      ),
    ];

    return SgShowcasePage(
      name: 'SgCalendar',
      description:
          'Calendário mensal em formato de gadget, com locale, vários meses, limites, dias bloqueados e cartão configurável.',
      examples: examples,
      propSpecs: [...sgPropSpecs['SgCalendar']!, ...extras],
      playground: SgPlayground(
        specs: sgPropSpecs['SgCalendar']!
            .where((s) => const {'weekdayFormat', 'locale'}.contains(s.name))
            .toList(),
        builder: (context, v) => SgCalendar(
          locale: (v['locale'] as String?) ?? 'pt-BR',
          weekdayFormat:
              SgCalendarWeekdayFormat.fromValue(
                v['weekdayFormat'] as String?,
              ) ??
              SgCalendarWeekdayFormat.narrow,
        ),
        codeBuilder: (v) {
          final args = <String>[];
          if (v['locale'] != null) args.add("locale: '${v['locale']}'");
          if (v['weekdayFormat'] != null) {
            args.add(
              'weekdayFormat: SgCalendarWeekdayFormat.${SgCalendarWeekdayFormat.fromValue(v['weekdayFormat'] as String)!.name}',
            );
          }
          return args.isEmpty
              ? 'const SgCalendar()'
              : 'SgCalendar(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
