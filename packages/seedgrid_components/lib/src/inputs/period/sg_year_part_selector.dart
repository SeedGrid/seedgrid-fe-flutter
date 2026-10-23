// Porte de SgYearPartSelector (React: src/inputs/SgYearPartSelector.tsx): o usuario escolhe ANO + RECORTE
// (semestre/trimestre/bimestre) + FATIA e o componente entrega o intervalo de datas ja resolvido.
// Irmao do SgPeriodSelector (recorte absoluto: "o 1o semestre DE 2024"). Como ele, NAO dispara onChange na
// montagem. A aritmetica esta em year_part.dart; aqui so ha UI (3 SgCombobox).
import 'package:flutter/material.dart';

import '../../generated/sg_year_part_selector.g.dart';
import '../select/select_support.dart';
import '../select/sg_combobox.dart';
import 'year_part.dart';

const Map<String, String> _yearLabel = {
  'pt-BR': 'Ano',
  'en-US': 'Year',
  'es': 'Ano',
  'pt-PT': 'Ano',
  'fr': 'Annee',
};
const Map<String, String> _kindLabel = {
  'pt-BR': 'Recorte',
  'en-US': 'Breakdown',
  'es': 'Recorte',
  'pt-PT': 'Recorte',
  'fr': 'Decoupage',
};
const Map<String, String> _partLabel = {
  'pt-BR': 'Fatia',
  'en-US': 'Part',
  'es': 'Parte',
  'pt-PT': 'Fatia',
  'fr': 'Partie',
};

const List<YearPartKind> _allKinds = [
  YearPartKind.semester,
  YearPartKind.quarter,
  YearPartKind.bimester,
];

/// Largura (px) a partir da qual os tres combos ficam na mesma linha (o `sm:` do Tailwind).
const double kSgYearPartRowWidth = 640;

class SgYearPartSelector extends StatefulWidget
    implements SgYearPartSelectorProps {
  const SgYearPartSelector({
    super.key,
    this.id = 'sg-year-part-selector',
    this.label,
    this.value,
    this.onChange,
    this.allowedKinds,
    this.minYear,
    this.maxYear,
    this.locale = 'pt-BR',
    this.disabled,
    this.required,
    this.today,
  });

  /// Prefixo dos ids dos tres controles internos.
  @override
  final String id;

  /// Rotulo do grupo, acima da linha. Cada controle ainda tem o seu proprio rotulo.
  @override
  final String? label;

  /// Valor controlado. Nulo = o componente guarda o proprio estado.
  @override
  final YearPartValue? value;

  /// Recebe o recorte ja resolvido, com startDate/endDate preenchidos.
  @override
  final ValueChanged<ResolvedYearPart>? onChange;

  /// Recortes oferecidos. Com um unico item o combo de recorte some. Padrao: os tres.
  @override
  final List<YearPartKind>? allowedKinds;

  /// Primeiro ano da lista. Padrao: ano corrente - 30.
  @override
  final int? minYear;

  /// Ultimo ano da lista. Padrao: ano corrente + 10.
  @override
  final int? maxYear;

  /// Locale dos rotulos. Padrao "pt-BR".
  @override
  final String locale;
  @override
  final bool? disabled;
  @override
  final bool? required;

  /// "Hoje" para o estado inicial e para a faixa de anos (padrao: agora). Extra do Flutter, para testes e
  /// showcase (no React o componente le `new Date()`).
  final DateTime? today;

  @override
  State<SgYearPartSelector> createState() => _SgYearPartSelectorState();
}

class _SgYearPartSelectorState extends State<SgYearPartSelector> {
  late YearPartValue _internal;

  DateTime get _now => widget.today ?? DateTime.now();

  List<YearPartKind> get _kinds =>
      widget.allowedKinds != null && widget.allowedKinds!.isNotEmpty
      ? widget.allowedKinds!
      : _allKinds;

  @override
  void initState() {
    super.initState();
    // "Hoje" e lido uma vez: ano corrente, primeiro recorte permitido e a fatia em que hoje cai.
    _internal = yearPartOf(_now, _kinds.first);
  }

  /// Normaliza antes de usar: um value controlado inconsistente nao pode derrubar a tela. Recorte fora de
  /// `allowedKinds` cai no primeiro permitido; a fatia que nao existe no recorte cai na primeira.
  YearPartValue get _current {
    final raw = widget.value ?? _internal;
    final kind = _kinds.contains(raw.kind) ? raw.kind : _kinds.first;
    return YearPartValue(
      year: raw.year,
      kind: kind,
      part: clampYearPart(kind, raw.part),
    );
  }

  void _commit(YearPartValue next) {
    // clamp aqui: e o unico ponto por onde toda mudanca passa.
    final safe = next.copyWith(part: clampYearPart(next.kind, next.part));
    if (widget.value == null) setState(() => _internal = safe);
    widget.onChange?.call(resolveYearPart(safe, widget.locale));
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final current = _current;
    final currentYear = _now.year;
    final firstYear = w.minYear ?? currentYear - 30;
    final lastYear = w.maxYear ?? currentYear + 10;
    final from = firstYear < lastYear ? firstYear : lastYear;
    final to = firstYear > lastYear ? firstYear : lastYear;

    // Do mais novo para o mais velho: o ano procurado costuma ser o do topo da lista.
    final yearItems = [
      for (var i = 0; i <= to - from; i++)
        SgAutocompleteItem(id: to - i, label: '${to - i}'),
    ];
    final kindItems = [
      for (final k in _kinds)
        SgAutocompleteItem(id: k.value, label: yearPartKindLabel(k, w.locale)),
    ];
    final partItems = [
      for (final o in yearPartOptions(current.kind, w.locale))
        SgAutocompleteItem(id: o.value, label: o.label),
    ];
    final showKind = _kinds.length > 1;

    final yearBox = SgCombobox<SgAutocompleteItem>(
      id: '${w.id}-year',
      label: pickLocaleLabel(_yearLabel, w.locale),
      source: yearItems,
      value: current.year,
      openOnFocus: true,
      disabled: w.disabled,
      required: w.required,
      onValueChange: (v) {
        if (v == null) return;
        _commit(current.copyWith(year: int.parse('$v')));
      },
    );
    final kindBox = showKind
        ? SgCombobox<SgAutocompleteItem>(
            id: '${w.id}-kind',
            label: pickLocaleLabel(_kindLabel, w.locale),
            source: kindItems,
            value: current.kind.value,
            openOnFocus: true,
            disabled: w.disabled,
            required: w.required,
            onValueChange: (raw) {
              if (raw == null) return;
              final kind = YearPartKind.fromValue('$raw');
              if (kind == null) return;
              // A fatia pode nao existir no recorte novo (estava no Q4 e virou semestre): o clamp do commit reajusta.
              _commit(current.copyWith(kind: kind));
            },
          )
        : null;
    final partBox = SgCombobox<SgAutocompleteItem>(
      id: '${w.id}-part',
      label: pickLocaleLabel(_partLabel, w.locale),
      source: partItems,
      value: current.part,
      openOnFocus: true,
      disabled: w.disabled,
      required: w.required,
      onValueChange: (raw) {
        if (raw == null) return;
        _commit(current.copyWith(part: int.parse('$raw')));
      },
    );
    final boxes = <Widget>[yearBox, ?kindBox, partBox];

    // Linha na tela larga (sm:flex-row, gap 12); coluna no celular (gap 8).
    final row = MediaQuery.sizeOf(context).width >= kSgYearPartRowWidth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (w.label != null && w.label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${w.label}${w.required == true ? ' *' : ''}',
              key: ValueKey('${w.id}-label'),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        if (row)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < boxes.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(child: boxes[i]),
              ],
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < boxes.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                boxes[i],
              ],
            ],
          ),
      ],
    );
  }
}
