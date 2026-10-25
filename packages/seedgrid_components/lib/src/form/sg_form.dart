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

/// Validador proprio do componente (o que o campo valida no blur: CPF, CNPJ, e-mail, telefone, CEP, datas,
/// limite de idade...). Recebe o valor do formulario e devolve a mensagem de erro, ou `null` se valido.
/// Decisao do dono (2026-10-25), diverge do React: `trigger`/`handleSubmit` tambem executam estes validadores
/// (no RHF so rodam as `rules`). Roda DEPOIS das `rules` (ordem de erros do RHF) e so se elas passaram.
typedef SgFieldValidator = FutureOr<String?> Function(Object? value);

/// Controlador do formulario (o `control` do RHF). Notifica quando valor, erro ou estado muda.
class SgFormController extends ChangeNotifier {
  SgFormController({Map<String, Object?> defaultValues = const {}})
    : _defaults = Map.of(defaultValues),
      _values = Map.of(defaultValues);

  Map<String, Object?> _defaults;
  final Map<String, Object?> _values;
  final Map<String, SgRules> _rules = {};
  final Map<String, SgFieldValidator> _validators = {};

  /// Campos cujo erro atual veio do validador do componente (nao das `rules`): mudar o valor por fora
  /// (`setValue`) revalida so o validador, como o campo faz com o erro proprio (o erro velho some).
  final Set<String> _componentErrors = {};
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
  ///
  /// [validator] e o validador proprio do componente (ver [SgFieldValidator]); fica ao lado das [rules] e
  /// roda em `trigger`/`handleSubmit`. Quem o registra deve chamar [unregisterValidator] ao sair da arvore.
  void registerField(
    String name, {
    SgRules? rules,
    Object? initialValue,
    SgFieldValidator? validator,
  }) {
    if (rules != null) {
      _rules[name] = rules;
    } else {
      _rules.remove(name);
    }
    if (validator != null) {
      _validators[name] = validator;
    } else {
      _validators.remove(name);
    }
    if (!_values.containsKey(name)) {
      _values[name] = initialValue;
      _defaults[name] = initialValue;
    }
  }

  /// Remove o validador registrado por [registerField], se ainda for [validator] (um campo novo com o mesmo
  /// nome nao e afetado). Nao notifica.
  void unregisterValidator(String name, SgFieldValidator validator) {
    if (_validators[name] == validator) _validators.remove(name);
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
    if (shouldValidate) {
      await trigger([name]);
    } else if (_componentErrors.contains(name)) {
      await _revalidateComponentError(name);
    }
  }

  Future<void> _revalidateComponentError(String name) async {
    final validator = _validators[name];
    if (validator == null) return;
    final message = await validator(_values[name]);
    if (!_componentErrors.contains(name)) return;
    if (message == null || message.isEmpty) {
      _errors.remove(name);
      _componentErrors.remove(name);
    } else {
      _errors[name] = SgFieldError('validate', message);
    }
    notifyListeners();
  }

  void markTouched(String name) {
    if (_touched.add(name)) notifyListeners();
  }

  /// `trigger` do RHF: valida os campos (todos, se `names` for nulo). Devolve `true` se todos validos.
  Future<bool> trigger([List<String>? names]) async {
    final targets = names ?? {..._rules.keys, ..._validators.keys}.toList();
    var ok = true;
    for (final n in targets) {
      final rules = _rules[n];
      var err = rules == null ? null : await validateRules(rules, _values[n]);
      var fromComponent = false;
      // Ordem do RHF: o erro das `rules` (required, min, ..., validate) vence; o validador do componente so
      // roda quando elas passam.
      if (err == null) {
        final validator = _validators[n];
        if (validator != null) {
          final message = await validator(_values[n]);
          if (message != null && message.isNotEmpty) {
            err = SgFieldError('validate', message);
            fromComponent = true;
          }
        }
      }
      if (err == null) {
        _errors.remove(n);
        _componentErrors.remove(n);
      } else {
        _errors[n] = err;
        if (fromComponent) {
          _componentErrors.add(n);
        } else {
          _componentErrors.remove(n);
        }
        ok = false;
      }
    }
    notifyListeners();
    return ok;
  }

  /// `setError` do RHF.
  void setError(String name, String message, {String type = 'manual'}) {
    _errors[name] = SgFieldError(type, message);
    _componentErrors.remove(name);
    notifyListeners();
  }

  /// `clearErrors` do RHF.
  void clearErrors([List<String>? names]) {
    if (names == null) {
      _errors.clear();
      _componentErrors.clear();
    } else {
      names.forEach(_errors.remove);
      names.forEach(_componentErrors.remove);
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
    _componentErrors.clear();
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
