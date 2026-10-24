// Contrato de formulario proprio (ADR 49): equivale ao `useForm()` do react-hook-form.
//   React:  const { control, handleSubmit, watch, reset, setValue, formState } = useForm();
//           <SgInputText name="email" control={control} rules={{ required: true }} />
//   Dart:   final form = SgFormController(defaultValues: {...});
//           SgInputText(id: 'email', name: 'email', control: form, rules: SgRules(required: true))
// `register` do RHF nao existe: todo campo Flutter e controlado.
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'sg_rules.dart';

typedef SgSubmitValid = FutureOr<void> Function(Map<String, Object?> values);
typedef SgSubmitInvalid =
    FutureOr<void> Function(Map<String, SgFieldError> errors);

/// Controlador do formulario (o `control` do RHF). Notifica quando valor, erro ou estado muda.
class SgFormController extends ChangeNotifier {
  SgFormController({Map<String, Object?> defaultValues = const {}})
    : _defaults = Map.of(defaultValues),
      _values = Map.of(defaultValues);

  Map<String, Object?> _defaults;
  final Map<String, Object?> _values;
  final Map<String, SgRules> _rules = {};
  final Map<String, SgFieldError> _errors = {};
  final Set<String> _touched = {};
  final Set<String> _dirty = {};
  bool _submitting = false;
  int _submitCount = 0;
  int _resetCount = 0;

  /// `getValues(name)` do RHF.
  Object? getValue(String name) => _values[name];

  /// `getValues()` do RHF.
  Map<String, Object?> getValues() => Map.unmodifiable(_values);

  /// `watch(name)` do RHF: valor atual. Para reagir a mudancas, ouca o controlador
  /// (`ListenableBuilder(listenable: form, ...)`).
  Object? watch(String name) => _values[name];

  /// Erros atuais por campo (`formState.errors`).
  Map<String, SgFieldError> get errors => Map.unmodifiable(_errors);
  SgFieldError? errorOf(String name) => _errors[name];

  bool get isSubmitting => _submitting;
  bool get isValid => _errors.isEmpty;
  bool get isDirty => _dirty.isNotEmpty;
  int get submitCount => _submitCount;

  /// Quantas vezes `reset` foi chamado. Os campos comparam este numero para saber que o valor voltou
  /// ao padrao (e limpar erros proprios) mesmo quando o texto nao muda.
  int get resetCount => _resetCount;
  bool isTouched(String name) => _touched.contains(name);

  /// Declara o campo e suas regras (chamado pelo componente; idempotente). Valor inicial vem de
  /// `defaultValues`; sem ele o campo existe com `null`.
  void registerField(String name, {SgRules? rules, Object? initialValue}) {
    if (rules != null) {
      _rules[name] = rules;
    } else {
      _rules.remove(name);
    }
    if (!_values.containsKey(name)) {
      _values[name] = initialValue;
      _defaults[name] = initialValue;
    }
  }

  /// `setValue` do RHF. `shouldValidate` valida o campo logo em seguida.
  Future<void> setValue(
    String name,
    Object? value, {
    bool shouldValidate = false,
    bool shouldTouch = false,
    bool shouldDirty = true,
  }) async {
    _values[name] = value;
    if (shouldDirty) {
      if (value == _defaults[name]) {
        _dirty.remove(name);
      } else {
        _dirty.add(name);
      }
    }
    if (shouldTouch) _touched.add(name);
    notifyListeners();
    if (shouldValidate) await trigger([name]);
  }

  void markTouched(String name) {
    if (_touched.add(name)) notifyListeners();
  }

  /// `trigger` do RHF: valida os campos (todos, se `names` for nulo). Devolve `true` se todos validos.
  Future<bool> trigger([List<String>? names]) async {
    final targets = names ?? _rules.keys.toList();
    var ok = true;
    for (final n in targets) {
      final rules = _rules[n];
      final err = rules == null ? null : await validateRules(rules, _values[n]);
      if (err == null) {
        _errors.remove(n);
      } else {
        _errors[n] = err;
        ok = false;
      }
    }
    notifyListeners();
    return ok;
  }

  /// `setError` do RHF.
  void setError(String name, String message, {String type = 'manual'}) {
    _errors[name] = SgFieldError(type, message);
    notifyListeners();
  }

  /// `clearErrors` do RHF.
  void clearErrors([List<String>? names]) {
    if (names == null) {
      _errors.clear();
    } else {
      names.forEach(_errors.remove);
    }
    notifyListeners();
  }

  /// `reset` do RHF: volta aos `defaultValues` (ou aos [values] informados, que viram os novos padroes).
  void reset([Map<String, Object?>? values]) {
    if (values != null) _defaults = Map.of(values);
    _values
      ..clear()
      ..addAll(_defaults);
    _errors.clear();
    _touched.clear();
    _dirty.clear();
    _submitCount = 0;
    _resetCount++;
    notifyListeners();
  }

  /// `handleSubmit` do RHF: valida tudo; se valido chama [onValid] com os valores, senao [onInvalid].
  /// Ignora chamadas enquanto `isSubmitting` (bloqueia duplo envio).
  Future<void> handleSubmit(
    SgSubmitValid onValid, [
    SgSubmitInvalid? onInvalid,
  ]) async {
    if (_submitting) return;
    _submitting = true;
    _submitCount++;
    notifyListeners();
    try {
      final ok = await trigger();
      if (ok) {
        await onValid(getValues());
      } else {
        await onInvalid?.call(errors);
      }
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }
}

/// Mantem um [SgFormController] acessivel aos campos filhos (opcional: o campo tambem aceita
/// `control:` explicito, como no React) e dono do ciclo de vida do controlador quando ele e criado aqui.
class SgForm extends StatefulWidget {
  const SgForm({
    super.key,
    this.controller,
    this.defaultValues = const {},
    this.onValid,
    this.onInvalid,
    required this.child,
  });

  /// Controlador externo (o `control`); se nulo o `SgForm` cria um com [defaultValues].
  final SgFormController? controller;
  final Map<String, Object?> defaultValues;

  /// Chamado com os valores quando o envio passa na validacao (o 'onSubmit' do 'handleSubmit').
  final SgSubmitValid? onValid;

  /// Chamado com os erros quando o envio falha na validacao.
  final SgSubmitInvalid? onInvalid;
  final Widget child;

  /// Controlador do `SgForm` mais proximo. Lanca se nao houver.
  static SgFormController of(BuildContext context) {
    final c = maybeOf(context);
    assert(
      c != null,
      'Nenhum SgForm acima deste widget; passe control: ou envolva em SgForm.',
    );
    return c!;
  }

  static SgFormController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SgFormScope>()?.controller;

  /// Dispara o envio do SgForm mais proximo (botao 'type: submit'). Nulo se nao houver SgForm.
  static VoidCallback? submitOf(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<_SgFormScope>();
    if (scope == null) return null;
    return () =>
        scope.controller.handleSubmit(scope.onValid ?? (_) {}, scope.onInvalid);
  }

  @override
  State<SgForm> createState() => _SgFormState();
}

class _SgFormState extends State<SgForm> {
  SgFormController? _own;

  SgFormController get _controller =>
      widget.controller ??
      (_own ??= SgFormController(defaultValues: widget.defaultValues));

  @override
  void dispose() {
    _own?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _SgFormScope(
    controller: _controller,
    onValid: widget.onValid,
    onInvalid: widget.onInvalid,
    child: widget.child,
  );
}

class _SgFormScope extends InheritedWidget {
  const _SgFormScope({
    required this.controller,
    this.onValid,
    this.onInvalid,
    required super.child,
  });
  final SgFormController controller;
  final SgSubmitValid? onValid;
  final SgSubmitInvalid? onInvalid;

  @override
  bool updateShouldNotify(_SgFormScope old) =>
      old.controller != controller ||
      old.onValid != onValid ||
      old.onInvalid != onInvalid;
}
