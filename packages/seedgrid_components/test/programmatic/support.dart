// Apoio da matriz de valor programatico: le os vetores gerados do React (vectors/*.json), monta o widget
// Flutter equivalente, executa os mesmos passos (setValue, reset, trigger, rerender com `value`, digitar,
// foco/blur, limpar...) e devolve as divergencias contra o que o React fez.
// Veja docs/VALOR_PROGRAMATICO.md: onde o React e defeituoso o oraculo do grupo diz o que o Dart deve fazer.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: Center(child: SizedBox(width: 400, child: child)),
  ),
);

List<Map<String, dynamic>> loadScenarios(String file) {
  final doc =
      jsonDecode(File('test/programmatic/vectors/$file').readAsStringSync())
          as Map<String, dynamic>;
  return (doc['scenarios'] as List).cast<Map<String, dynamic>>();
}

Object? decodeValue(Object? v) =>
    v is Map && v.containsKey(r'$undef') ? null : v;

/// Instantaneo do campo, no mesmo formato do que o React gravou.
class Snap {
  Snap({
    required this.display,
    required this.error,
    required this.emitted,
    required this.validations,
    required this.form,
    required this.formError,
    required this.searched,
  });
  final String display;
  final String? error;
  final List<Object?> emitted;
  final List<String?> validations;
  final Object? form;
  final String? formError;
  final List<String> searched;
}

/// Quanto a comparacao e exata. Cada grupo diz o que e verdade quando o React e defeituoso.
abstract class Rules {
  const Rules();

  /// Texto que o Dart deve exibir, dado o que o React exibiu (`reactDisplay`) e o ultimo valor "cru"
  /// recebido por fora (`raw`, antes de qualquer digitacao).
  String display(
    Map<String, dynamic> s,
    String reactDisplay,
    Object? raw,
    bool typed,
  );

  /// A digitacao de [text] sobre [before] nao muda o texto exibido (mascara cheia): o Flutter nao dispara
  /// `onChanged` quando o texto formatado e igual ao anterior, o React dispara um evento sem efeito.
  bool typedRejected(Map<String, dynamic> s, String before, String text) =>
      false;

  /// O que o campo mostra, na forma comparavel com o que o oraculo devolve em [display] (data: ISO).
  String shown(Map<String, dynamic> s, String text) => text;

  /// O valor cru recebido de fora e tratado pelo Dart de um jeito que o React nao faz (ex.: telefone com
  /// DDI): validacao e erro do React nao servem de referencia enquanto ninguem digitar.
  bool deviates(Map<String, dynamic> s, Object? raw) => false;

  /// O formulario guarda o que `onChange` entregou depois de digitar (mascarado), nao o texto cru do
  /// React com `control`.
  bool get formFollowsEmitted => false;

  /// O React nao entrega `onChange` do componente quando ele esta ligado a um formulario (so o
  /// `field.onChange`); o Dart entrega nos dois casos.
  bool ignoreEmitted(Map<String, dynamic> s) => false;
}

class StrictRules extends Rules {
  const StrictRules();
  @override
  String display(
    Map<String, dynamic> s,
    String reactDisplay,
    Object? raw,
    bool typed,
  ) => reactDisplay;
}

typedef Emit = void Function(Object?);

/// Controles de tela de um cenario em execucao.
class Bench {
  Bench(this.t, this.s) {
    emitted = [];
    validations = [];
    searched = [];
    final mode = s['mode'] as String;
    if (mode == 'form') {
      form = SgFormController(
        defaultValues: {
          for (final e
              in ((s['defaultValues'] ?? <String, dynamic>{})
                      as Map<String, dynamic>)
                  .entries)
            e.key: decodeValue(e.value),
        },
      );
    }
    final init = (s['initial'] as Map<String, dynamic>?) ?? {};
    value = Map.of(init);
  }

  final WidgetTester t;
  final Map<String, dynamic> s;
  late final List<Object?> emitted;
  late final List<String?> validations;
  late final List<String> searched;
  SgFormController? form;
  late Map<String, dynamic> value;
  final ValueNotifier<int> rebuild = ValueNotifier(0);

  String get comp => s['component'] as String;
  Map<String, dynamic> get props => (s['props'] as Map<String, dynamic>?) ?? {};

  Finder get field => switch (comp) {
    'textarea' => find.byKey(const ValueKey('textarea-x')),
    _ => find.byKey(const ValueKey('input-x')),
  };

  Future<void> mount() async {
    await t.pumpWidget(const SizedBox());
    await t.pumpWidget(
      host(
        ValueListenableBuilder<int>(
          valueListenable: rebuild,
          builder: (_, _, _) => buildComponent(this),
        ),
      ),
    );
    await settle();
  }

  Future<void> settle() async {
    await t.pump();
    await t.pump();
  }

  String get shown => t.widget<TextField>(field).controller!.text;

  String? get visibleError {
    switch (comp) {
      case 'number' || 'currency' || 'stepper':
        final f = find.byKey(const ValueKey('error-x'));
        if (f.evaluate().isEmpty) return null;
        return t.widget<Text>(f).data;
      case 'textarea':
        final f = find.byKey(const ValueKey('textarea-error-x'));
        if (f.evaluate().isEmpty) return null;
        return t.widget<Text>(f).data;
      default:
        return t.widget<TextField>(field).decoration!.errorText;
    }
  }

  Snap snap() {
    final out = Snap(
      display: shown,
      error: visibleError,
      emitted: List.of(emitted),
      validations: List.of(validations),
      form: form?.getValue('f'),
      formError: form?.errorOf('f')?.message,
      searched: List.of(searched),
    );
    emitted.clear();
    validations.clear();
    searched.clear();
    return out;
  }

  bool reactFocused = false;

  Future<void> act(Map<String, dynamic> a) async {
    if (a.containsKey('setValue')) {
      final opts = (a['opts'] as Map<String, dynamic>?) ?? {};
      await form!.setValue(
        'f',
        decodeValue(a['setValue']),
        shouldValidate: opts['shouldValidate'] == true,
      );
    } else if (a.containsKey('reset')) {
      final r = a['reset'];
      if (r == null) {
        form!.reset();
      } else {
        form!.reset({
          for (final e in (r as Map<String, dynamic>).entries)
            e.key: decodeValue(e.value),
        });
      }
    } else if (a.containsKey('trigger')) {
      await form!.trigger(['f']);
    } else if (a.containsKey('rerender')) {
      value = {...value, ...(a['rerender'] as Map<String, dynamic>)};
      rebuild.value++;
    } else if (a.containsKey('typeText')) {
      reactFocused = true;
      await t.showKeyboard(field);
      for (final ch in (a['typeText'] as String).split('')) {
        await t.enterText(field, shown + ch);
        await settle();
      }
    } else if (a.containsKey('input')) {
      var text = a['input'] as String;
      if (comp == 'date' || comp == 'birth') {
        text = sgDisplayDate(text, 'pt-BR');
      }
      await t.enterText(field, text);
    } else if (a.containsKey('focus')) {
      reactFocused = true;
      await t.showKeyboard(field);
    } else if (a.containsKey('blur')) {
      // No jsdom `input` nao da foco: um blur sem foco previo nao dispara nada. O Dart (enterText) foca.
      final dateLike = comp == 'date' || comp == 'birth';
      if (reactFocused || !dateLike) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
      reactFocused = false;
    } else if (a.containsKey('key')) {
      await t.showKeyboard(field);
      final k = a['key'] as String;
      final cur = shown;
      if (k == 'Backspace' || k == 'Delete') {
        if (cur.isNotEmpty)
          await t.enterText(field, cur.substring(0, cur.length - 1));
      } else {
        await t.enterText(field, cur + k);
      }
    } else if (a.containsKey('clear')) {
      final key = comp == 'textarea' ? 'textarea-clear-x' : 'clear-x';
      await t.tap(find.byKey(ValueKey(key)));
    } else if (a.containsKey('up')) {
      await t.tap(find.byKey(const ValueKey('stepper-up-x')));
    } else if (a.containsKey('down')) {
      await t.tap(find.byKey(const ValueKey('stepper-down-x')));
    } else if (a.containsKey('wait')) {
      await t.pump(Duration(milliseconds: a['wait'] as int));
    } else {
      throw StateError('acao desconhecida: $a');
    }
    await settle();
  }
}

// ----------------------------------------------------------------------------- construcao do widget

/// `rules` do cenario (JSON) -> SgRules. `validate` usa os validadores nomeados do generate.mjs.
SgRules? buildRules(Object? spec) {
  if (spec == null) return null;
  final m = spec as Map<String, dynamic>;
  Object? validate;
  return SgRules(
    required: m['required'],
    validate: m['validate'] == null
        ? null
        : (v) {
            switch (m['validate']) {
              case 'noA':
                return (v is String && v.contains('A')) ? 'sem A' : true;
              case 'evenLen':
                return ('${v ?? ''}'.length % 2 == 0) ? true : 'tamanho impar';
              case 'positive':
                return ((num.tryParse('$v') ?? 0) > 0) ? true : 'so positivo';
            }
            return validate;
          },
  );
}

T? _enum<T>(T? Function(String?) from, Object? v) =>
    v == null ? null : from(v as String);

/// Monta o widget Flutter de `bench.comp` com as props do cenario e os callbacks do bench.
Widget buildComponent(Bench b) {
  final p = b.props;
  final form = b.form;
  final name = form == null ? null : 'f';
  final init = b.value;
  final disabled = p['enabled'] == false ? true : null;
  final Object? vValue = init.containsKey('value')
      ? decodeValue(init['value'])
      : null;
  final Object? vDefault = init.containsKey('defaultValue')
      ? decodeValue(init['defaultValue'])
      : null;
  String? sv(Object? o) => o == null ? null : '$o';
  void onVal(String? m) => b.validations.add(m);
  void onChange(String v) => b.emitted.add(v);
  final required = p['required'] as bool?;
  final rules = buildRules(b.s['rules']);
  final maxLength = p['maxLength'] as num?;
  final minLength = p['minLength'] as num?;
  final prefixText = p['prefixText'] as String?;
  final suffixText = p['suffixText'] as String?;

  switch (b.comp) {
    case 'text':
      return SgInputText(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        maxLength: maxLength,
        minLength: minLength,
        prefixText: prefixText,
        suffixText: suffixText,
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'email':
      return SgInputEmail(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'password':
      return SgInputPassword(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        hidePassword: false,
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'textarea':
      return SgInputTextArea(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        maxLength: maxLength,
        minLength: minLength,
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'search':
      return SgInputTextSearch(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        onChange: onChange,
        onValidation: onVal,
        onSearchChange: b.searched.add,
      );
    case 'cpf':
      return SgInputCPF(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'cnpj':
      return SgInputCNPJ(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'cpfcnpj':
      return SgInputCPFCNPJ(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'phone':
      return SgInputPhone(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'postal':
      return SgInputPostalCode(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        country: _enum(SgInputPostalCodeCountry.fromValue, p['country']),
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'date':
      return SgInputDate(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        minDate: p['minDate'],
        maxDate: p['maxDate'],
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'birth':
      return SgInputBirthDate(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        minAge: p['minAge'] as num?,
        maxAge: p['maxAge'] as num?,
        initialValue: sv(vDefault),
        value: sv(vValue),
        onChange: onChange,
        onValidation: onVal,
      );
    case 'number':
      return SgInputNumber(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        decimals: p['decimals'] as num?,
        allowNegative: p['allowNegative'] as bool?,
        emptyValue: _enum(SgInputNumberEmptyValue.fromValue, p['emptyValue']),
        minValue: p['minValue'] as num?,
        maxValue: p['maxValue'] as num?,
        initialValue: vDefault,
        value: vValue,
        onChange: onChange,
        onValidation: onVal,
      );
    case 'currency':
      return SgInputCurrency(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        required: required,
        currency: p['currency'] as String?,
        locale: p['locale'] as String?,
        decimals: p['decimals'] as num?,
        allowNegative: p['allowNegative'] as bool?,
        emptyValue: _enum(SgInputCurrencyEmptyValue.fromValue, p['emptyValue']),
        minValue: p['minValue'] as num?,
        maxValue: p['maxValue'] as num?,
        initialValue: vDefault,
        value: vValue,
        onChange: onChange,
        onValidation: onVal,
      );
    case 'stepper':
      return SgStepperInput(
        id: 'x',
        name: name,
        control: form,
        rules: rules,
        disabled: disabled,
        minValue: p['minValue'] as num,
        maxValue: p['maxValue'] as num,
        step: p['step'] as num?,
        defaultValue: _numOrNull(vDefault),
        value: _numOrNull(vValue),
        onChange: (v) => b.emitted.add(v),
      );
  }
  throw StateError('componente desconhecido ${b.comp}');
}

num? _numOrNull(Object? v) =>
    v is num ? v : (v is String ? (v.isEmpty ? 0 : num.tryParse(v)) : null);

// ----------------------------------------------------------------------------- comparacao

bool sameValue(Object? a, Object? b) {
  if (a is num && b is num) return a == b || (a.isNaN && b.isNaN);
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!sameValue(a[i], b[i])) return false;
    }
    return true;
  }
  return a == b;
}

/// Executa o cenario e devolve as divergencias. `skip` decide passos que o Dart nao reproduz.
Future<List<String>> runAndCompare(
  WidgetTester t,
  Map<String, dynamic> s,
  Rules rules,
) async {
  final fails = <String>[];
  setComponentsI18n(SgComponentsI18nInput(locale: s['locale'] as String));
  final b = Bench(t, s);
  await b.mount();
  final react = (s['steps'] as List).cast<Map<String, dynamic>>();
  final actions = (s['actions'] as List).cast<Map<String, dynamic>>();
  String where(int i) =>
      '${s['id']} passo $i ${i == 0 ? '(inicial)' : jsonEncode(actions[i - 1])}';

  // estado do oraculo
  Object? raw = b.form != null
      ? decodeValue(
          ((s['defaultValues'] as Map<String, dynamic>?) ??
              <String, dynamic>{})['f'],
        )
      : ((s['initial'] as Map<String, dynamic>?)?['value'] ??
            (s['initial'] as Map<String, dynamic>?)?['defaultValue']);
  raw = decodeValue(raw);
  var typed = false;
  var typedAny =
      false; // houve digitacao (aceita ou nao) desde o ultimo valor vindo de fora
  var junk =
      false; // digitacao rejeitada pela mascara: o estado do React nao vale mais ate o proximo valor de fora
  var stale = false; // erro proprio do React ainda e do valor anterior
  Object? expectedForm = decodeValue(react[0]['form']);

  void compare(int i, Map<String, dynamic> r, Snap d, String before) {
    final a = i == 0 ? const <String, dynamic>{} : actions[i - 1];
    final rejected =
        a.containsKey('typeText') &&
        rules.typedRejected(s, before, a['typeText'] as String);
    final programmatic =
        a.containsKey('setValue') ||
        a.containsKey('reset') ||
        a.containsKey('rerender');
    final rhfFresh =
        (a.containsKey('setValue') &&
            ((a['opts'] as Map?)?['shouldValidate'] == true)) ||
        a.containsKey('trigger');
    final reactEmitted = rejected
        ? const <Object?>[]
        : (r['emitted'] as List).cast<Object?>();
    final reactVal = rejected
        ? const <String?>[]
        : (r['validations'] as List).cast<String?>();
    final typing =
        a.containsKey('typeText') ||
        a.containsKey('input') ||
        a.containsKey('key') ||
        a.containsKey('clear');
    if (typing) typedAny = true;
    if (rejected) junk = true;
    if (programmatic) {
      stale = true;
      typed = false;
      typedAny = false;
      junk = false;
      if (a.containsKey('setValue')) raw = decodeValue(a['setValue']);
      if (a.containsKey('reset')) {
        final rr = a['reset'];
        raw = rr == null
            ? decodeValue(react[i]['form'])
            : decodeValue((rr as Map)['f']);
      }
      if (a.containsKey('rerender'))
        raw = decodeValue((a['rerender'] as Map)['value']);
      expectedForm = decodeValue(r['form']);
    }
    if (reactEmitted.isNotEmpty) {
      typed = true;
      if (rules.formFollowsEmitted) expectedForm = reactEmitted.last;
    }
    if (!(rules.formFollowsEmitted && typedAny)) {
      expectedForm = decodeValue(r['form']);
    }
    if (reactVal.isNotEmpty) stale = false;

    final exp = rules.display(s, r['display'] as String, raw, typed);
    final got = rules.shown(s, d.display);
    if (got != exp) {
      fails.add(
        '${where(i)}: display "$got" != "$exp" (react "${r['display']}")',
      );
    }
    if (!rules.ignoreEmitted(s) && !sameValue(d.emitted, reactEmitted)) {
      fails.add(
        '${where(i)}: emitido ${jsonEncode(d.emitted)} != ${jsonEncode(reactEmitted)}',
      );
    }
    final skipVal = junk || (!typedAny && rules.deviates(s, raw));
    if (!programmatic && !skipVal && !sameValue(d.validations, reactVal)) {
      fails.add(
        '${where(i)}: onValidation ${jsonEncode(d.validations)} != ${jsonEncode(reactVal)}',
      );
    }
    if (b.form != null && !sameValue(d.form, expectedForm)) {
      fails.add(
        '${where(i)}: form ${jsonEncode(d.form)} != ${jsonEncode(expectedForm)} (react ${jsonEncode(decodeValue(r['form']))})',
      );
    }
    final reactFe = r['formError'] as String?;
    // Decisao do dono (2026-10-25, docs/DIVERGENCIAS_DO_REACT.md): trigger/handleSubmit/setValue com
    // shouldValidate tambem rodam o validador do PROPRIO componente (CPF, e-mail, datas...), que no React so
    // roda no blur. Entao, sem erro de `rules` no React, o Dart pode ter um erro do componente no formulario.
    // Tem de ser uma mensagem de verdade e a mesma que o campo mostra; erro de `rules` continua exato.
    final componentError =
        b.form != null &&
        rhfFresh &&
        reactFe == null &&
        d.formError != null &&
        d.formError!.isNotEmpty;
    if (componentError) {
      if (d.error != d.formError) {
        fails.add(
          '${where(i)}: erro do componente no formulario "${d.formError}" nao e o visivel "${d.error}"',
        );
      }
    } else if (b.form != null && rhfFresh && d.formError != reactFe) {
      fails.add(
        '${where(i)}: erro do formulario "${d.formError}" != "$reactFe"',
      );
    }
    final visibleOk =
        !componentError &&
        (rhfFresh ? (reactFe != null || !stale) : (!stale && reactFe == null));
    if (visibleOk && !skipVal && d.error != r['error']) {
      fails.add('${where(i)}: erro visivel "${d.error}" != "${r['error']}"');
    }
    if (s['component'] == 'search') {
      final rs = (r['searched'] as List).cast<Object?>();
      if (!sameValue(d.searched, rs))
        fails.add(
          '${where(i)}: busca ${jsonEncode(d.searched)} != ${jsonEncode(rs)}',
        );
    }
  }

  compare(0, react[0], b.snap(), '');
  for (var i = 0; i < actions.length; i++) {
    final before = b.shown;
    await b.act(actions[i]);
    compare(i + 1, react[i + 1], b.snap(), before);
  }
  await t.pumpWidget(const SizedBox());
  return fails.map((e) => e.replaceAll('\n', '⏎')).toList();
}

/// Agrupa as divergencias por componente|variante|bateria + tipo (display, emitido, form...), com contagem.
String summarize(List<String> fails) {
  final counts = <String, int>{};
  final sample = <String, String>{};
  for (final f in fails) {
    final m = RegExp(
      r'^(\w+)\|([^|]+)\|([^|:]+)[^ ]* passo \d+ .*?: (\w+)',
    ).firstMatch(f);
    final key = m == null ? 'outro' : '${m[1]}|${m[2]}|${m[3]}|${m[4]}';
    counts[key] = (counts[key] ?? 0) + 1;
    sample.putIfAbsent(key, () => f);
  }
  final keys = counts.keys.toList()..sort();
  return [
    for (final k in keys)
      '${counts[k].toString().padLeft(4)} $k   ex: ${sample[k]}',
  ].join('\n');
}

void expectNoFails(List<String> fails) {
  final out = Platform.environment['PROG_OUT'];
  if (out != null) {
    File(
      out,
    ).writeAsStringSync('${summarize(fails)}\n----\n${fails.join('\n')}\n');
  }
  expect(fails.length, 0, reason: summarize(fails));
}
