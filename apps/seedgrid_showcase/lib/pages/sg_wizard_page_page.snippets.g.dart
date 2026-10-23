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
    const SgWizardPage(child: Text('Pronto!')),
  ],
)
''';

  /// Region `sg-wizard-page-sem-titulo`.
  static const String sgWizardPageSemTitulo = r'''
SgWizard(
  stepper: SgWizardStepper.numbered,
  onFinish: () {},
  children: const [
    SgWizardPage(child: Text('Primeira')),
    SgWizardPage(child: Text('Segunda')),
  ],
)
''';

  /// Region `sg-wizard-page-titulo`.
  static const String sgWizardPageTitulo = r'''
SgWizard(
  stepper: SgWizardStepper.icons,
  onFinish: () {},
  children: const [
    SgWizardPage(
      title: 'Perfil',
      icon: Icon(Icons.person),
      child: Text('Conteúdo do perfil'),
    ),
    SgWizardPage(
      title: 'Segurança',
      icon: Icon(Icons.lock),
      child: Text('Conteúdo de segurança'),
    ),
  ],
)
''';
}
