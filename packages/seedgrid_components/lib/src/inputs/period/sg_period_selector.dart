// Porte de SgPeriodSelector (React: src/inputs/SgPeriodSelector.tsx): combo de presets temporais
// (hoje, esta semana, mes passado...) que entrega o intervalo de datas ja resolvido. Compoe SgCombobox
// (agrupado) e, no preset "Periodo", dois SgInputDate. A aritmetica esta em period_logic.dart.
//
// Diferencas assumidas (parcial): `control`/`name`/`rules` ligam ao SgFormController (ADR 49) e o formulario
// guarda o texto do preset (`"THIS_WEEK"`), como o React; `value` nulo vale "nao controlado" (o Dart nao
// distingue `null` de "indefinido"); o campo de data do "Periodo" e o SgInputDate do Flutter (mascara
// dd/MM/yyyy com calendario proprio, nao o <input type="date"> nativo).
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_period_selector.g.dart';
import '../../theme_access.dart';
import '../masked/sg_input_date.dart';
import '../select/sg_combobox.dart';
import '../select/select_support.dart';
import 'period_logic.dart';

class SgPeriodSelector extends StatefulWidget implements SgPeriodSelectorProps {
  const SgPeriodSelector({
    super.key,
    this.id = 'sg-period-selector',
    this.label,
    this.value,
    this.onChange,
    this.permitPast = true,
    this.permitCurrent = true,
    this.permitFuture = true,
    this.permitAll = true,
    this.allowCustomPeriod = true,
    this.locale = 'pt-BR',
    this.disabled,
    this.required,
    this.minDate,
    this.maxDate,
    this.referenceDate,
    this.error,
    this.control,
    this.name,
    this.rules,
  });

  @override
  final String id;
  @override
  final String? label;

  /// Preset escolhido. Nulo = nao controlado (o componente guarda o proprio estado).
  @override
  final SgPeriodSelectorValue? value;

  /// Recebe o periodo ja resolvido. Como no React, NAO dispara na montagem: so quando o usuario escolhe.
  @override
  final ValueChanged<ResolvedPeriod>? onChange;

  /// Grupo de periodos passados (LAST_*). Padrao true.
  @override
  final bool permitPast;

  /// Grupo de periodos atuais (THIS_*, TODAY, YESTERDAY). Padrao true.
  @override
  final bool permitCurrent;

  /// Grupo de periodos futuros (TOMORROW, NEXT_*). Padrao true.
  @override
  final bool permitFuture;

  /// Opcao "Todos" (sem limites de data). Padrao true.
  @override
  final bool permitAll;

  /// Opcao "Periodo" (intervalo customizado). Padrao true.
  @override
  final bool allowCustomPeriod;

  /// Locale dos rotulos. Padrao "pt-BR".
  @override
  final String locale;
  @override
  final bool? disabled;
  @override
  final bool? required;
  @override
  final DateTime? minDate;
  @override
  final DateTime? maxDate;

  /// Data de referencia para resolver os presets (padrao: agora). Util em testes.
  @override
  final DateTime? referenceDate;
  @override
  final String? error;
  @override
  final SgFormController? control;
  @override
  final String? name;
  @override
  final SgRules? rules;

  @override
  State<SgPeriodSelector> createState() => _SgPeriodSelectorState();
}

class _SgPeriodSelectorState extends State<SgPeriodSelector> {
  SgPeriodSelectorValue? _internal;
  // Texto cru do campo de data (ISO ou vazio): preserva o que foi digitado ao trocar de preset e voltar.
  String _customStart = '';
  String _customEnd = '';
  SgFormController? _form;

  bool get _bound => widget.name != null && _form != null;

  @override
  void initState() {
    super.initState();
    _internal = widget.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = widget.name == null
        ? null
        : (widget.control ?? SgForm.maybeOf(context));
    if (f != _form) {
      _form?.removeListener(_onForm);
      _form = f;
      _form?.addListener(_onForm);
    }
    _register();
  }

  @override
  void didUpdateWidget(SgPeriodSelector old) {
    super.didUpdateWidget(old);
    _register();
  }

  void _register() {
    if (_bound) {
      _form!.registerField(
        widget.name!,
        rules: widget.rules,
        initialValue: widget.value?.value,
      );
    }
  }

  @override
  void dispose() {
    _form?.removeListener(_onForm);
    super.dispose();
  }

  void _onForm() {
    if (mounted) setState(() {});
  }

  /// Preset em vigor: do formulario (se ligado e preenchido), senao o `value`, senao o estado proprio.
  SgPeriodSelectorValue? get _selected {
    if (_bound) {
      final v = _form!.getValue(widget.name!);
      final fromForm = v is String ? SgPeriodSelectorValue.fromValue(v) : null;
      if (fromForm != null) return fromForm;
    }
    return widget.value ?? _internal;
  }

  ResolvePeriodOptions get _resolveOptions => ResolvePeriodOptions(
    minDate: widget.minDate,
    maxDate: widget.maxDate,
    locale: widget.locale,
  );

  void _emit(ResolvedPeriod period) {
    if (_bound) {
      final name = widget.name!;
      final hadError = _form!.errorOf(name) != null || _form!.submitCount > 0;
      _form!.setValue(name, period.preset.value, shouldValidate: hadError);
    }
    widget.onChange?.call(period);
  }

  void _emitCustom(String startIso, String endIso) {
    // Enquanto a data estiver incompleta o parse devolve nulo: melhor emitir "sem limite" do que uma data
    // de ano 0002 no meio da digitacao.
    final s = parseIsoDate(startIso);
    final e = parseIsoDate(endIso);
    _emit(
      ResolvedPeriod(
        preset: PeriodPreset.custom,
        label: periodPresetLabel(PeriodPreset.custom, widget.locale),
        startDate: s == null ? null : DateTime(s.year, s.month, s.day),
        endDate: e == null
            ? null
            : DateTime(e.year, e.month, e.day, 23, 59, 59, 999),
      ),
    );
  }

  void _onValueChange(Object? raw) {
    if (raw == null || '$raw'.isEmpty) {
      setState(() => _internal = null);
      return;
    }
    final preset = SgPeriodSelectorValue.fromValue('$raw');
    if (preset == null) return;
    setState(() => _internal = preset);
    if (preset == PeriodPreset.custom) {
      // Emite CUSTOM com o que houver preenchido no mini intervalo (pode ser nulo).
      _emitCustom(_customStart, _customEnd);
      return;
    }
    _emit(
      resolvePeriod(
        preset,
        widget.referenceDate ?? DateTime.now(),
        _resolveOptions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final t = sgThemeOf(context);
    final formError = _bound ? _form!.errorOf(w.name!)?.message : null;
    final error = resolveFieldError(w.error, formError);
    final options = buildPeriodOptions(
      permitAll: w.permitAll,
      allowCustomPeriod: w.allowCustomPeriod,
      permitCurrent: w.permitCurrent,
      permitFuture: w.permitFuture,
      permitPast: w.permitPast,
      locale: w.locale,
    );
    final selected = _selected;
    final showCustomRange =
        w.allowCustomPeriod && selected == PeriodPreset.custom;

    return Align(
      alignment: Alignment.centerLeft,
      // w-full max-w-[18rem]
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 288),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SgCombobox<SgAutocompleteItem>(
              id: w.id,
              label: w.label,
              source: options,
              value: selected?.value,
              grouped: true,
              openOnFocus: true,
              disabled: w.disabled,
              required: w.required,
              error: error,
              renderGroupHeader: (group) => group.isEmpty
                  ? const SizedBox.shrink()
                  : Container(
                      key: ValueKey('sg-period-group-$group'),
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: t.border)),
                      ),
                      child: Text(
                        group.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: t.muted,
                        ),
                      ),
                    ),
              onValueChange: _onValueChange,
            ),
            if (showCustomRange) ...[
              const SizedBox(height: 8),
              SgInputDate(
                key: ValueKey('${w.id}-custom-start'),
                id: '${w.id}-custom-start',
                initialValue: _customStart,
                minDate: w.minDate,
                maxDate: w.maxDate,
                disabled: w.disabled,
                onChange: (next) {
                  setState(() => _customStart = next);
                  _emitCustom(next, _customEnd);
                },
              ),
              const SizedBox(height: 8),
              SgInputDate(
                key: ValueKey('${w.id}-custom-end'),
                id: '${w.id}-custom-end',
                initialValue: _customEnd,
                minDate: w.minDate,
                maxDate: w.maxDate,
                disabled: w.disabled,
                onChange: (next) {
                  setState(() => _customEnd = next);
                  _emitCustom(_customStart, next);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
