// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_wizard_page_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgWizardPagePageSnippets {
  /// Region `sg-wizard-page-fields`.
  static const String sgWizardPageFields = r'''
SgWizard(
  control: _form,
  onFinish: () {},
  children: [
    SgWizardPage(
      fields: const ['cidade'],
      child: SgInputText(
        id: 'wp-cidade',
        name: 'cidade',
        control: _form,
        labelText: 'Cidade',
        required: true,
        requiredMessage: 'Informe a cidade',
      ),
    ),
    SgWizardPage(child: Text(context.tx('Pronto!'))),
  ],
)
''';

  /// Region `sg-wizard-page-sem-titulo`.
  static const String sgWizardPageSemTitulo = r'''
SgWizard(
  stepper: SgWizardStepper.numbered,
  onFinish: () {},
  children: [
    SgWizardPage(child: Text(context.tx('Primeira'))),
    SgWizardPage(child: Text(context.tx('Segunda'))),
  ],
)
''';

  /// Region `sg-wizard-page-titulo`.
  static const String sgWizardPageTitulo = r'''
SgWizard(
  stepper: SgWizardStepper.icons,
  onFinish: () {},
  children: [
    SgWizardPage(
      title: context.tx('Perfil'),
      icon: Icon(Icons.person),
      child: Text(context.tx('Conteúdo do perfil')),
    ),
    SgWizardPage(
      title: context.tx('Segurança'),
      icon: Icon(Icons.lock),
      child: Text(context.tx('Conteúdo de segurança')),
    ),
  ],
)
''';
}
