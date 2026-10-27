// Porte de SgWizard e SgWizardPage (React: src/wizard/SgWizard.tsx, logic.ts).
// Diferenca de design (ADR 49): o React valida a pagina atual focando e saindo de cada <input> e
// contando elementos `[data-sg-error]`. No Flutter a validacao da etapa roda no formulario:
// `SgFormController.trigger(fields)`, onde `fields` vem de `SgWizardPage.fields` (nomes dos campos da
// etapa; sem ele valida todos os campos registrados). Campos fora de formulario (SgInputText sem `name`)
// se registram no SgValidationScope da etapa e tambem barram o avanco. O controlador vem de `SgWizard.control` ou do
// SgForm mais proximo; sem nenhum dos dois a pagina e considerada valida (como uma pagina sem inputs).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../buttons/sg_button.dart';
import '../commons/commons_colors.dart' show tokenChain;
import '../form/sg_form.dart';
import '../form/sg_validation_scope.dart';
import '../generated/enums.g.dart';
import '../generated/sg_wizard.g.dart';
import '../generated/sg_wizard_page.g.dart';
import '../i18n/i18n.dart';
import '../theme_access.dart';

/// `SgWizardLabels` do React: textos dos botoes (`Partial`; o que faltar vem do i18n).
class SgWizardLabels {
  const SgWizardLabels({this.next, this.previous, this.finish});
  final String? next;
  final String? previous;
  final String? finish;
}

/// Uma etapa do [SgWizard].
class SgWizardPage extends StatelessWidget implements SgWizardPageProps {
  const SgWizardPage({
    super.key,
    this.title,
    this.icon,
    required this.child,
    this.fields,
  });

  /// Titulo da etapa no stepper; padrao: "Etapa N" (i18n).
  @override
  final String? title;

  /// Icone do stepper no modo `icons`.
  @override
  final Widget? icon;
  @override
  final Widget child;

  /// Extra do Flutter: nomes dos campos do formulario que pertencem a esta etapa (o que o React
  /// descobre varrendo os inputs da pagina). Nulo = valida todos os campos registrados.
  final List<String>? fields;

  @override
  Widget build(BuildContext context) => child;
}

/// Equivale a `clampWizardStep`.
int clampWizardStep(num? initialStep, int pageCount) {
  final step = (initialStep ?? 0).toInt();
  return step.clamp(0, pageCount - 1 < 0 ? 0 : pageCount - 1);
}

/// Equivale a `canNavigateToWizardStep`.
bool canNavigateToWizardStep({
  required int currentStep,
  required int targetStep,
  required int pageCount,
  SgWizardStepNavigation stepNavigation =
      SgWizardStepNavigation.previousAndNext,
}) {
  if (targetStep < 0 || targetStep >= pageCount || targetStep == currentStep) {
    return false;
  }
  if (targetStep < currentStep) {
    return stepNavigation == SgWizardStepNavigation.previous ||
        stepNavigation == SgWizardStepNavigation.previousAndNext;
  }
  return stepNavigation == SgWizardStepNavigation.previousAndNext &&
      targetStep == currentStep + 1;
}

/// Equivale a `canProceedWizardAction`: pagina valida, depois `validateStep`, depois `beforeAction`.
Future<bool> canProceedWizardAction({
  required FutureOr<bool> Function() validateCurrentPage,
  FutureOr<bool> Function(int index)? validateStep,
  FutureOr<bool> Function(int index)? beforeAction,
  required int step,
}) async {
  if (!await validateCurrentPage()) return false;
  if (validateStep != null && !await validateStep(step)) return false;
  if (beforeAction != null && !await beforeAction(step)) return false;
  return true;
}

class SgWizard extends StatefulWidget implements SgWizardProps {
  const SgWizard({
    super.key,
    required this.children,
    required this.onFinish,
    this.onStepChange,
    this.onBeforeNext,
    this.onBeforeFinish,
    this.validateStep,
    this.nextDisabled = false,
    this.initialStep,
    this.labels,
    this.stepper = SgWizardStepper.none,
    this.stepNavigation = SgWizardStepNavigation.previousAndNext,
    this.control,
  });

  /// As etapas (`SgWizardPage`), na ordem.
  final List<SgWizardPage> children;

  /// Contrato gerado (`children` no React): as etapas empilhadas.
  @override
  Widget get child => Column(children: children);
  @override
  final FutureOr<void> Function() onFinish;
  @override
  final ValueChanged<int>? onStepChange;
  @override
  final FutureOr<bool> Function(int index)? onBeforeNext;
  @override
  final FutureOr<bool> Function(int index)? onBeforeFinish;
  @override
  final FutureOr<bool> Function(int index)? validateStep;

  /// Desabilita o avanco de forma declarativa: o botao "Proximo" fica desabilitado e o stepper para
  /// de oferecer as etapas seguintes. Nao afeta o botao de conclusao (para esse existe `onBeforeFinish`).
  @override
  final bool nextDisabled;
  @override
  final int? initialStep;
  @override
  final SgWizardLabels? labels;
  @override
  final SgWizardStepper stepper;
  @override
  final SgWizardStepNavigation stepNavigation;

  /// Extra do Flutter: formulario usado para validar a etapa (senao, o SgForm mais proximo).
  final SgFormController? control;

  @override
  State<SgWizard> createState() => _SgWizardState();
}

class _SgWizardState extends State<SgWizard> {
  late int _step = clampWizardStep(widget.initialStep, widget.children.length);
  bool _finishing = false;
  bool _validating = false;
  SgFormController? _form;

  @override
  void initState() {
    super.initState();
    // Como o useEffect do React: avisa a etapa inicial depois da montagem.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onStepChange?.call(_step);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _form = widget.control ?? SgForm.maybeOf(context);
  }

  bool get _isFirst => _step <= 0;
  bool get _isLast => _step >= widget.children.length - 1;

  void _setStep(int next) {
    if (next == _step) return;
    setState(() => _step = next);
    widget.onStepChange?.call(next);
  }

  // Campos da etapa fora de um formulario (sem `name`) se registram aqui e tambem barram o avanco.
  final SgValidationRegistry _scope = SgValidationRegistry();

  Future<bool> _validateCurrentPage() async {
    if (widget.children.isEmpty) return true;
    final form = widget.control ?? _form;
    // Os dois sempre rodam (sem curto-circuito): cada campo mostra o proprio erro.
    final formOk = form == null
        ? true
        : await form.trigger(widget.children[_step].fields);
    final scopeOk = _scope.validateAll();
    return formOk && scopeOk;
  }

  Future<void> _goNext() async {
    if (_isLast) return;
    // Guarda aqui e nao so no botao: o avanco pelo stepper cai neste mesmo caminho.
    if (widget.nextDisabled) return;
    if (_validating) return;
    setState(() => _validating = true);
    try {
      final ok = await canProceedWizardAction(
        validateCurrentPage: _validateCurrentPage,
        validateStep: widget.validateStep,
        beforeAction: widget.onBeforeNext,
        step: _step,
      );
      if (!ok || !mounted) return;
      _setStep((_step + 1).clamp(0, widget.children.length - 1));
    } finally {
      if (mounted) setState(() => _validating = false);
    }
  }

  bool _canNavigateStep(int target) {
    // Com o avanco bloqueado o stepper nao oferece as etapas seguintes.
    if (widget.nextDisabled && target > _step) return false;
    return canNavigateToWizardStep(
      currentStep: _step,
      targetStep: target,
      pageCount: widget.children.length,
      stepNavigation: widget.stepNavigation,
    );
  }

  void _goPrevious() {
    if (_isFirst) return;
    _setStep((_step - 1).clamp(0, widget.children.length - 1));
  }

  Future<void> _navigateStep(int target) async {
    if (!_canNavigateStep(target)) return;
    if (target < _step) {
      _setStep(target);
      return;
    }
    await _goNext();
  }

  Future<void> _finish() async {
    if (_finishing || _validating) return;
    setState(() => _validating = true);
    try {
      final ok = await canProceedWizardAction(
        validateCurrentPage: _validateCurrentPage,
        validateStep: widget.validateStep,
        beforeAction: widget.onBeforeFinish,
        step: _step,
      );
      if (!ok) return;
    } finally {
      if (mounted) setState(() => _validating = false);
    }
    if (!mounted) return;
    setState(() => _finishing = true);
    try {
      await widget.onFinish();
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = useComponentsI18n(context);
    final l = widget.labels;
    final labels = (
      next: l?.next ?? t(i18n, 'components.wizard.next'),
      previous: l?.previous ?? t(i18n, 'components.wizard.previous'),
      finish: l?.finish ?? t(i18n, 'components.wizard.finish'),
    );
    final pages = widget.children;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.stepper != SgWizardStepper.none)
          _StepperBar(
            pages: pages,
            currentStep: _step,
            icons: widget.stepper == SgWizardStepper.icons,
            canNavigateStep: _canNavigateStep,
            onNavigateStep: _navigateStep,
          ),
        if (pages.isNotEmpty)
          KeyedSubtree(
            key: ValueKey('wizard-page-$_step'),
            child: SgValidationScope(registry: _scope, child: pages[_step]),
          ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 12,
          spacing: 12,
          children: [
            _isFirst
                ? const SizedBox.shrink()
                : SgButton(
                    key: const ValueKey('wizard-previous'),
                    label: Text(labels.previous),
                    appearance: SgAppearance.outline,
                    severity: SgSeverity.secondary,
                    shape: SgButtonShape.rounded,
                    onClick: _goPrevious,
                  ),
            if (!_isLast)
              SgButton(
                key: const ValueKey('wizard-next'),
                label: Text(labels.next),
                shape: SgButtonShape.rounded,
                disabled: _validating || widget.nextDisabled,
                onClick: _goNext,
              )
            else
              SgButton(
                key: const ValueKey('wizard-finish'),
                label: Text(labels.finish),
                shape: SgButtonShape.rounded,
                disabled: _finishing || _validating,
                onClick: _finish,
              ),
          ],
        ),
      ],
    );
  }
}

class _StepperBar extends StatelessWidget {
  const _StepperBar({
    required this.pages,
    required this.currentStep,
    required this.icons,
    required this.canNavigateStep,
    required this.onNavigateStep,
  });

  final List<SgWizardPage> pages;
  final int currentStep;
  final bool icons;
  final bool Function(int) canNavigateStep;
  final void Function(int) onNavigateStep;

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final primary = tokenChain(theme, ['--primary']);
    final onPrimary = tokenChain(theme, ['--primary-foreground']);
    final border = tokenChain(theme, ['--border']);
    final muted = tokenChain(theme, ['--muted-foreground']);
    final surface = theme.surface;

    final items = <Widget>[];
    for (var i = 0; i < pages.length; i++) {
      final page = pages[i];
      final completed = i < currentStep;
      final current = i == currentStep;
      final clickable = canNavigateStep(i);
      final title =
          page.title ?? t(i18n, 'components.wizard.step', {'step': i + 1});
      final last = i == pages.length - 1;

      final circle = Container(
        key: ValueKey('wizard-step-circle-$i'),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: completed ? primary : surface,
          border: Border.all(
            color: (completed || current) ? primary : border,
            width: 2,
          ),
        ),
        child: completed
            ? Icon(Icons.check, size: 20, color: onPrimary)
            : (icons && page.icon != null)
            ? IconTheme(
                data: IconThemeData(color: current ? primary : muted, size: 20),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: FittedBox(child: page.icon),
                ),
              )
            : Text(
                '${i + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: current ? primary : muted,
                ),
              ),
      );
      final label = Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.2,
              color: (completed || current) ? primary : muted,
            ),
          ),
        ),
      );
      final content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [circle, label],
      );

      final step = Semantics(
        key: ValueKey('wizard-step-$i'),
        selected: current,
        button: clickable,
        child: clickable
            ? InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => onNavigateStep(i),
                child: content,
              )
            : content,
      );

      items.add(step);
      if (!last) {
        items.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 19),
              child: Container(height: 2, color: completed ? primary : border),
            ),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Semantics(
        container: true,
        label: t(i18n, 'components.wizard.progress'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        ),
      ),
    );
  }
}
