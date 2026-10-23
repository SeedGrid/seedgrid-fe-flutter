// Ligacao dos multiselects ao formulario (ADR 49), igual ao `Controller` do React: com `name` +
// `control` (ou o SgForm mais proximo) o valor e a lista de valores do campo; o erro do formulario
// entra no `error`. Detalhe fiel ao React: `required` do componente NAO vira regra do formulario
// (so `rules` vai ao `Controller`).
import 'package:flutter/widgets.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import 'multi_select_core.dart';

mixin SgMultiFormBinding<T extends StatefulWidget> on State<T> {
  String? get bindingName;
  SgFormController? get bindingControl;
  SgRules? get bindingRules;

  SgFormController? _boundForm;

  bool get isBound => bindingName != null && _boundForm != null;

  /// Lista de valores do formulario (`field.value ?? []`); nula fora do formulario.
  List<SgMultiSelectOptionValue>? get boundValue {
    if (!isBound) return null;
    final v = _boundForm!.getValue(bindingName!);
    if (v is List) return List<SgMultiSelectOptionValue>.from(v.cast<Object>());
    return const [];
  }

  /// Mensagem de erro do campo no formulario (nula se nao ha erro ou fora do formulario).
  String? get boundErrorMessage =>
      isBound ? _boundForm!.errorOf(bindingName!)?.message : null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = bindingControl ?? SgForm.maybeOf(context);
    if (f != _boundForm) {
      _boundForm?.removeListener(_onFormChanged);
      _boundForm = f;
      _boundForm?.addListener(_onFormChanged);
    }
    registerBinding();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    registerBinding();
  }

  void registerBinding() {
    if (!isBound) return;
    _boundForm!.registerField(
      bindingName!,
      rules: bindingRules,
      initialValue: const <Object>[],
    );
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  /// `field.onChange(next)`: grava no formulario; revalida se ja havia erro ou envio.
  void pushToForm(List<SgMultiSelectOptionValue> next) {
    if (!isBound) return;
    final form = _boundForm!;
    final revalidate =
        form.errorOf(bindingName!) != null || form.submitCount > 0;
    form.setValue(bindingName!, next, shouldValidate: revalidate);
  }

  void disposeBinding() {
    _boundForm?.removeListener(_onFormChanged);
  }
}
