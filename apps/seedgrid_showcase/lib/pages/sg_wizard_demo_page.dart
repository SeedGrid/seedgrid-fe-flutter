// showcase-name: SgWizard
// Showcase do SgWizard. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// Nome do arquivo/classe: `SgWizardPage` ja e o widget da etapa, entao a pagina do SgWizard se chama
// SgWizardDemoPage (o extrator de paginas deriva o nome do menu do nome da classe).
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_wizard_demo_page.snippets.g.dart';

class SgWizardDemoPage extends StatefulWidget {
  const SgWizardDemoPage({super.key});

  @override
  State<SgWizardDemoPage> createState() => _SgWizardDemoPageState();
}

class _SgWizardDemoPageState extends State<SgWizardDemoPage> {
  String _resultado = 'ainda não finalizado';
  bool _icones = false;
  bool _bloqueado = false;
  String _log = 'nenhuma etapa';
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
        title: 'Básico',
        description: 'Três etapas, Anterior/Próximo e Finalizar na última.',
        preview:
            // #region sg-wizard-basico
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
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardBasico,
      ),
      ShowcaseExample(
        title: 'Stepper numerado ou com ícones',
        description:
            'stepper: numbered ou icons; o título padrão da etapa é "Etapa N".',
        preview:
            // #region sg-wizard-stepper
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
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardStepper,
      ),
      ShowcaseExample(
        title: 'Validação por etapa com SgForm',
        description:
            'O Próximo valida os campos da etapa (fields) no formulário e só avança se estiverem válidos.',
        preview:
            // #region sg-wizard-formulario
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
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardFormulario,
      ),
      ShowcaseExample(
        title: 'Guardas e nextDisabled',
        description:
            'onBeforeNext pode ser assíncrono; nextDisabled bloqueia o avanço de forma declarativa. onStepChange avisa a etapa.',
        preview:
            // #region sg-wizard-guardas
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
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardGuardas,
      ),
    ];

    return SgShowcasePage(
      name: 'SgWizard',
      description:
          'Assistente em etapas com stepper numerado ou de ícones, navegação por etapas, guardas assíncronas e validação por etapa no formulário.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgWizard']!,
        const SgPropSpec(
          name: 'children',
          reactName: 'children',
          type: 'List<SgWizardPage>',
          tsType: 'ReactNode',
          required: true,
          description:
              'As etapas, na ordem. O contrato gerado chama de child (Widget); aqui é a lista.',
        ),
        const SgPropSpec(
          name: 'control',
          reactName: '-',
          type: 'SgFormController?',
          tsType: '-',
          required: false,
          description:
              'Extra do Flutter: formulário usado para validar a etapa (senão, o SgForm mais próximo). No React a validação varre os inputs da página.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgWizard']!
            .where(
              (s) => const {
                'stepper',
                'stepNavigation',
                'nextDisabled',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgWizard(
          key: ValueKey(
            'pg-${v['stepper']}-${v['stepNavigation']}-${v['nextDisabled']}',
          ),
          stepper:
              SgWizardStepper.fromValue(v['stepper'] as String?) ??
              SgWizardStepper.none,
          stepNavigation:
              SgWizardStepNavigation.fromValue(
                v['stepNavigation'] as String?,
              ) ??
              SgWizardStepNavigation.previousAndNext,
          nextDisabled: (v['nextDisabled'] as bool?) ?? false,
          onFinish: () {},
          children: const [
            SgWizardPage(title: 'Um', child: Text('Etapa 1')),
            SgWizardPage(title: 'Dois', child: Text('Etapa 2')),
            SgWizardPage(title: 'Três', child: Text('Etapa 3')),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>['onFinish: () {}'];
          if (v['stepper'] != null)
            args.add(
              'stepper: SgWizardStepper.${SgWizardStepper.fromValue(v['stepper'] as String)!.name}',
            );
          if (v['stepNavigation'] != null) {
            args.add(
              'stepNavigation: SgWizardStepNavigation.${SgWizardStepNavigation.fromValue(v['stepNavigation'] as String)!.name}',
            );
          }
          if (v['nextDisabled'] == true) args.add('nextDisabled: true');
          return 'SgWizard(\n  ${args.join(',\n  ')},\n  children: [...],\n)';
        },
      ),
    );
  }
}
