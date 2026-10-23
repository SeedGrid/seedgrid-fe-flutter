// Pecas compartilhadas dos inputs de escolha (SgCheckboxGroup, SgRadioGroup, SgToggleSwitch,
// SgSlider, SgRating): ligacao a formulario (name + control) e a caixa com legenda.
import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../theme_access.dart';

import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';

/// Liga um campo ao SgFormController, como o `<Controller>` do React: valor e erro vem do
/// formulario, e mudancas voltam para ele. Cada State cria um e chama [bind] em
/// didChangeDependencies/didUpdateWidget e [dispose] no fim.
class ChoiceFieldBinding {
  ChoiceFieldBinding(this._notify);

  final VoidCallback _notify;
  SgFormController? form;
  String? name;

  bool get bound => name != null && form != null;
  Object? get value => bound ? form!.getValue(name!) : null;
  String? get errorMessage => bound ? form!.errorOf(name!)?.message : null;

  void bind(
    BuildContext context, {
    required SgFormController? control,
    required String? name,
    required SgRules? rules,
    Object? initialValue,
  }) {
    final f = control ?? SgForm.maybeOf(context);
    if (f != form) {
      form?.removeListener(_notify);
      form = f;
      form?.addListener(_notify);
    }
    this.name = name;
    if (bound) {
      form!.registerField(name!, rules: rules, initialValue: initialValue);
    }
  }

  /// Grava no formulario; depois de um envio (ou com erro) revalida a cada mudanca, como o RHF.
  Future<void> set(Object? v) async {
    if (!bound) return;
    final revalidate = form!.errorOf(name!) != null || form!.submitCount > 0;
    await form!.setValue(name!, v, shouldValidate: revalidate);
  }

  void dispose() => form?.removeListener(_notify);
}

/// Parte de `SgGroupBoxProps` usada por `groupBoxProps` (o SgGroupBox completo vem na T3.1).
class SgChoiceGroupBoxProps {
  const SgChoiceGroupBoxProps({this.title, this.width, this.height});

  final String? title;

  /// Numero (px) ou texto 'N%'; padrao 100%.
  final Object? width;
  final Object? height;
}

double? choiceDim(Object? v, double available) {
  if (v is num) return v.toDouble();
  if (v is String && v.trim().endsWith('%')) {
    final p = double.tryParse(v.trim().substring(0, v.trim().length - 1));
    if (p != null) return available * p / 100;
  }
  if (v is String && v.trim().endsWith('px')) {
    return double.tryParse(v.trim().substring(0, v.trim().length - 2));
  }
  return null;
}

/// Titulo com asterisco quando obrigatorio (igual ao React).
String choiceBoxTitle(
  String? title,
  SgChoiceGroupBoxProps? box,
  bool required,
) {
  final base = box?.title ?? title ?? '';
  if (!required || base.trim().isEmpty) return base;
  return base.contains('*') ? base : '$base *';
}

/// Equivale ao `<fieldset>` + `<legend>` do SgGroupBox: borda arredondada e legenda em maiusculas.
class SgChoiceBox extends StatelessWidget {
  const SgChoiceBox({
    super.key,
    required this.title,
    required this.child,
    this.width,
    this.height,
  });

  final String title;
  final Widget child;
  final Object? width;
  final Object? height;

  @override
  Widget build(BuildContext context) {
    final t = sgThemeOf(context);
    return LayoutBuilder(
      builder: (context, c) {
        final avail = c.maxWidth.isFinite ? c.maxWidth : 400.0;
        final w = choiceDim(width, avail);
        final h = choiceDim(height, c.maxHeight.isFinite ? c.maxHeight : 400.0);
        Widget box = Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              width: double.infinity,
              height: h,
              decoration: BoxDecoration(
                color: t.surface,
                border: Border.all(color: t.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: child,
            ),
            Positioned(
              left: 12,
              top: 0,
              child: Container(
                color: t.surface,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: t.text.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ],
        );
        if (w != null) {
          box = Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: w, child: box),
          );
        }
        return box;
      },
    );
  }
}

Widget choiceErrorText(
  BuildContext context,
  String? message, {
  double fontSize = 14,
  Key? key,
}) {
  if (message == null || message.isEmpty) return const SizedBox.shrink();
  final t = sgThemeOf(context);
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      message,
      key: key,
      style: TextStyle(fontSize: fontSize, color: t.error500),
    ),
  );
}
