// Showcase do SgWizardPage (a etapa do SgWizard). O codigo exibido em cada exemplo e o trecho entre
// `// #region` e `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_wizard_page_page.snippets.g.dart';

class SgWizardPagePage extends StatefulWidget {
  const SgWizardPagePage({super.key});

  @override
  State<SgWizardPagePage> createState() => _SgWizardPagePageState();
}

class _SgWizardPagePageState extends State<SgWizardPagePage> {
  final SgFormController _form = SgFormController();

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Título e ícone no stepper',
        description:
            'title aparece sob o círculo do stepper; icon só aparece no modo icons.',
        preview:
            // #region sg-wizard-page-titulo
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
            ),
        // #endregion
        code: SgWizardPagePageSnippets.sgWizardPageTitulo,
      ),
      ShowcaseExample(
        title: 'Sem título',
        description: 'Sem title o stepper mostra "Etapa N" (do i18n).',
        preview:
            // #region sg-wizard-page-sem-titulo
            SgWizard(
              stepper: SgWizardStepper.numbered,
              onFinish: () {},
              children: [
                SgWizardPage(child: Text(context.tx('Primeira'))),
                SgWizardPage(child: Text(context.tx('Segunda'))),
              ],
            ),
        // #endregion
        code: SgWizardPagePageSnippets.sgWizardPageSemTitulo,
      ),
      ShowcaseExample(
        title: 'fields: campos da etapa',
        description:
            'No React a validação varre os inputs da página; aqui fields lista os campos do formulário que a etapa valida.',
        preview:
            // #region sg-wizard-page-fields
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
            ),
        // #endregion
        code: SgWizardPagePageSnippets.sgWizardPageFields,
      ),
    ];

    return SgShowcasePage(
      name: 'SgWizardPage',
      description:
          'Uma etapa do SgWizard: título e ícone do stepper e o conteúdo da etapa.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgWizardPage']!,
        const SgPropSpec(
          name: 'fields',
          reactName: '-',
          type: 'List<String>?',
          tsType: '-',
          required: false,
          description:
              'Extra do Flutter: nomes dos campos do formulário validados nesta etapa. Nulo valida todos os campos registrados.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgWizardPage']!
            .where((s) => s.name == 'title')
            .toList(),
        builder: (context, v) => SgWizard(
          key: ValueKey('pgp-${v['title']}'),
          stepper: SgWizardStepper.numbered,
          onFinish: () {},
          children: [
            SgWizardPage(
              title: v['title'] as String?,
              child: const Text('Conteúdo da etapa'),
            ),
            const SgWizardPage(title: 'Outra', child: Text('Outra etapa')),
          ],
        ),
        codeBuilder: (v) =>
            "SgWizardPage(${v['title'] == null ? '' : "\n  title: '${v['title']}',"}\n  child: Text('Conteúdo da etapa'),\n)",
      ),
    );
  }
}
