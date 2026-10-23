// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_wizard_demo_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgWizardDemoPageSnippets {
  /// Region `sg-wizard-basico`.
  static const String sgWizardBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgWizard(
      onFinish: () => setState(() => _resultado = 'finalizado'),
      children: const [
        SgWizardPage(child: Text('Etapa 1: dados pessoais')),
        SgWizardPage(child: Text('Etapa 2: endereço')),
        SgWizardPage(child: Text('Etapa 3: revisão')),
      ],
    ),
    const SizedBox(height: 12),
    Text('Resultado: $_resultado'),
  ],
)
''';

  /// Region `sg-wizard-formulario`.
  static const String sgWizardFormulario = r'''
SgWizard(
  control: _form,
  stepper: SgWizardStepper.numbered,
  onFinish: () {},
  children: [
    SgWizardPage(
      title: 'Nome',
      fields: const ['nome'],
      child: SgInputText(
        id: 'wz-nome',
        name: 'nome',
        control: _form,
        labelText: 'Nome',
        required: true,
        requiredMessage: 'Informe o nome',
      ),
    ),
    SgWizardPage(
      title: 'E-mail',
      fields: const ['email'],
      child: SgInputText(
        id: 'wz-email',
        name: 'email',
        control: _form,
        labelText: 'E-mail',
        rules: SgRules(
          required: 'Informe o e-mail',
          pattern: SgRuleValue(
            RegExp(r'.+@.+\..+'),
            'E-mail inválido',
          ),
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-wizard-guardas`.
  static const String sgWizardGuardas = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    FilterChip(
      label: const Text('nextDisabled'),
      selected: _bloqueado,
      onSelected: (v) => setState(() => _bloqueado = v),
    ),
    const SizedBox(height: 12),
    SgWizard(
      nextDisabled: _bloqueado,
      stepper: SgWizardStepper.numbered,
      onStepChange: (i) => setState(() => _log = 'etapa ${i + 1}'),
      onBeforeNext: (i) async {
        await Future<void>.delayed(
          const Duration(milliseconds: 400),
        );
        return true;
      },
      onFinish: () {},
      children: const [
        SgWizardPage(title: 'Um', child: Text('Primeira etapa')),
        SgWizardPage(title: 'Dois', child: Text('Segunda etapa')),
        SgWizardPage(title: 'Três', child: Text('Terceira etapa')),
      ],
    ),
    const SizedBox(height: 12),
    Text('onStepChange: $_log'),
  ],
)
''';

  /// Region `sg-wizard-stepper`.
  static const String sgWizardStepper = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    FilterChip(
      label: const Text('Ícones'),
      selected: _icones,
      onSelected: (v) => setState(() => _icones = v),
    ),
    const SizedBox(height: 12),
    SgWizard(
      stepper: _icones
          ? SgWizardStepper.icons
          : SgWizardStepper.numbered,
      onFinish: () {},
      children: const [
        SgWizardPage(
          title: 'Conta',
          icon: Icon(Icons.person),
          child: Text('Dados da conta'),
        ),
        SgWizardPage(
          title: 'Endereço',
          icon: Icon(Icons.home),
          child: Text('Onde você mora'),
        ),
        SgWizardPage(child: Text('Sem título nem ícone')),
      ],
    ),
  ],
)
''';
}
