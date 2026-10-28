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
      children: [
        SgWizardPage(
          child: Text(context.tx('Etapa 1: dados pessoais')),
        ),
        SgWizardPage(child: Text(context.tx('Etapa 2: endereço'))),
        SgWizardPage(child: Text(context.tx('Etapa 3: revisão'))),
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
      title: context.tx('Nome'),
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
      title: context.tx('E-mail'),
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
      label: Text(context.tx('nextDisabled')),
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
      children: [
        SgWizardPage(
          title: context.tx('Um'),
          child: Text(context.tx('Primeira etapa')),
        ),
        SgWizardPage(
          title: context.tx('Dois'),
          child: Text(context.tx('Segunda etapa')),
        ),
        SgWizardPage(
          title: context.tx('Três'),
          child: Text(context.tx('Terceira etapa')),
        ),
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
      label: Text(context.tx('Ícones')),
      selected: _icones,
      onSelected: (v) => setState(() => _icones = v),
    ),
    const SizedBox(height: 12),
    SgWizard(
      stepper: _icones
          ? SgWizardStepper.icons
          : SgWizardStepper.numbered,
      onFinish: () {},
      children: [
        SgWizardPage(
          title: context.tx('Conta'),
          icon: Icon(Icons.person),
          child: Text(context.tx('Dados da conta')),
        ),
        SgWizardPage(
          title: context.tx('Endereço'),
          icon: Icon(Icons.home),
          child: Text(context.tx('Onde você mora')),
        ),
        SgWizardPage(
          child: Text(context.tx('Sem título nem ícone')),
        ),
      ],
    ),
  ],
)
''';
}
