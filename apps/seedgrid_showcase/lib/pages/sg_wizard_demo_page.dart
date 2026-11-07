// showcase-name: SgWizard
// Showcase do SgWizard. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
// Nome do arquivo/classe: `SgWizardPage` ja e o widget da etapa, entao a pagina do SgWizard se chama
// SgWizardDemoPage (o extrator de paginas deriva o nome do menu do nome da classe).
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_wizard_demo_page.snippets.g.dart';

class SgWizardDemoPage extends StatefulWidget {
  const SgWizardDemoPage({super.key});

  @override
  State<SgWizardDemoPage> createState() => _SgWizardDemoPageState();
}

class _SgWizardDemoPageState extends State<SgWizardDemoPage> {
  // Estado dos exemplos em notifiers/controllers: a pagina nao se reconstroi, so quem escuta.
  final SgFormController _form = SgFormController();
  final _etapa = ValueNotifier<int>(0);
  final _enviado = ValueNotifier<Map<String, Object?>?>(null);
  final _checando = ValueNotifier<bool>(false);
  final _jaUsado = ValueNotifier<bool>(false);
  String _codigo = '';

  @override
  void dispose() {
    _form.dispose();
    _etapa.dispose();
    _enviado.dispose();
    _checando.dispose();
    _jaUsado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Validação automática',
        description:
            'O wizard valida automaticamente os inputs da página antes de avançar. Por padrão, as etapas anteriores e o próximo passo imediato também podem ser clicados no stepper, com a mesma validação do botão Continuar.',
        preview:
            // #region sg-wizard-validacao-automatica
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgWizard(
                  control: _form,
                  stepper: SgWizardStepper.numbered,
                  initialStep: 0,
                  stepNavigation: SgWizardStepNavigation.previousAndNext,
                  onStepChange: (i) => _etapa.value = i,
                  onFinish: () async {
                    _enviado.value = null;
                    await Future<void>.delayed(
                      const Duration(milliseconds: 800),
                    );
                    _enviado.value = Map.of(_form.getValues());
                  },
                  children: [
                    SgWizardPage(
                      title: context.tx('Etapa 1 - Dados pessoais'),
                      fields: const ['nome', 'email'],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tx('Preencha nome e e-mail para avançar.'),
                          ),
                          const SizedBox(height: 12),
                          SgInputText(
                            id: 'wizard-name',
                            name: 'nome',
                            control: _form,
                            labelText: context.tx('Nome'),
                            required: true,
                            requiredMessage: context.tx('Informe o nome.'),
                          ),
                          const SizedBox(height: 12),
                          SgInputEmail(
                            id: 'wizard-email',
                            name: 'email',
                            control: _form,
                            labelText: context.tx('E-mail'),
                            required: true,
                            requiredMessage: context.tx('Informe o e-mail.'),
                            invalidMessage: context.tx('E-mail inválido.'),
                          ),
                        ],
                      ),
                    ),
                    SgWizardPage(
                      title: context.tx('Etapa 2 - Contato'),
                      fields: const ['telefone'],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.tx('Informe o telefone.')),
                          const SizedBox(height: 12),
                          SgInputPhone(
                            id: 'wizard-phone',
                            name: 'telefone',
                            control: _form,
                            labelText: context.tx('Telefone'),
                            required: true,
                            requiredMessage: context.tx(
                              'Informe o telefone.',
                            ),
                            lengthMessage: context.tx('Telefone inválido.'),
                          ),
                        ],
                      ),
                    ),
                    SgWizardPage(
                      title: context.tx('Etapa 3 - Confirmação'),
                      child: ListenableBuilder(
                        listenable: _form,
                        builder: (context, _) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tx('Revise os dados e finalize.'),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${context.tx('Nome')}: ${_form.getValue('nome') ?? '-'}',
                            ),
                            Text(
                              '${context.tx('E-mail')}: ${_form.getValue('email') ?? '-'}',
                            ),
                            Text(
                              '${context.tx('Telefone')}: ${_form.getValue('telefone') ?? '-'}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<int>(
                  valueListenable: _etapa,
                  builder: (context, etapa, _) => Text(
                    '${context.tx('Etapa atual')}: ${etapa + 1}',
                  ),
                ),
                ValueListenableBuilder<Map<String, Object?>?>(
                  valueListenable: _enviado,
                  builder: (context, dados, _) => dados == null
                      ? const SizedBox.shrink()
                      : Text('${context.tx('Dados enviados')}: $dados'),
                ),
              ],
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardValidacaoAutomatica,
      ),
      ShowcaseExample(
        title: 'stepNavigation',
        description:
            'Use stepNavigation para limitar o clique nas etapas. O padrão é previous-and-next; neste exemplo apenas as etapas anteriores aceitam clique.',
        preview:
            // #region sg-wizard-step-navigation
            SgWizard(
              stepper: SgWizardStepper.numbered,
              initialStep: 2,
              stepNavigation: SgWizardStepNavigation.previous,
              onFinish: () {},
              children: [
                SgWizardPage(
                  title: context.tx('Introdução'),
                  child: Text(
                    context.tx('Somente etapas anteriores podem ser clicadas.'),
                  ),
                ),
                SgWizardPage(
                  title: context.tx('Detalhes'),
                  child: Text(
                    context.tx('O usuário pode voltar clicando no stepper.'),
                  ),
                ),
                SgWizardPage(
                  title: context.tx('Revisão'),
                  child: Text(context.tx('A etapa atual não fica clicável.')),
                ),
                SgWizardPage(
                  title: context.tx('Confirmação'),
                  child: Text(
                    context.tx('Passos futuros continuam bloqueados.'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardStepNavigation,
      ),
      ShowcaseExample(
        title: 'Stepper com ícones',
        description:
            'stepper="icons" + icon em cada SgWizardPage: exibe o ícone no círculo em vez do número.',
        preview:
            // #region sg-wizard-stepper-icones
            SgWizard(
              stepper: SgWizardStepper.icons,
              onFinish: () {},
              children: [
                SgWizardPage(
                  title: context.tx('Posição'),
                  icon: const Icon(Icons.place_outlined),
                  child: Text(context.tx('Selecione a posição desejada.')),
                ),
                SgWizardPage(
                  title: context.tx('Categoria'),
                  icon: const Icon(Icons.sell_outlined),
                  child: Text(context.tx('Escolha a categoria.')),
                ),
                SgWizardPage(
                  title: context.tx('Enviar'),
                  icon: const Icon(Icons.send_outlined),
                  child: Text(context.tx('Revise e envie.')),
                ),
              ],
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardStepperIcones,
      ),
      ShowcaseExample(
        title: 'Stepper numerado',
        description:
            'stepper="numbered": círculos numerados com o título de cada passo.',
        preview:
            // #region sg-wizard-stepper-numerado
            SgWizard(
              stepper: SgWizardStepper.numbered,
              onFinish: () {},
              children: [
                SgWizardPage(
                  title: context.tx('Introdução'),
                  child: Text(context.tx('Conteúdo introdutório.')),
                ),
                SgWizardPage(
                  title: context.tx('Detalhes'),
                  child: Text(context.tx('Preencha os detalhes.')),
                ),
                SgWizardPage(
                  title: context.tx('Revisão'),
                  child: Text(context.tx('Revise as informações.')),
                ),
                SgWizardPage(
                  title: context.tx('Confirmação'),
                  child: Text(context.tx('Confirme e finalize.')),
                ),
              ],
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardStepperNumerado,
      ),
      ShowcaseExample(
        title: 'Labels customizados',
        description: 'Personalize os textos dos botões.',
        preview:
            // #region sg-wizard-labels
            SgWizard(
              labels: SgWizardLabels(
                next: context.tx('Continuar'),
                previous: context.tx('Voltar'),
                finish: context.tx('Concluir'),
              ),
              onFinish: () {},
              children: [
                SgWizardPage(
                  child: Text(
                    context.tx('Dados: ajuste os labels como quiser.'),
                  ),
                ),
                SgWizardPage(
                  child: Text(
                    context.tx('Fim: clique em Concluir para finalizar.'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardLabels,
      ),
      ShowcaseExample(
        title: 'onBeforeNext async',
        description:
            'Validação assíncrona antes de avançar (ex.: consultar uma API).',
        preview:
            // #region sg-wizard-before-next
            SgWizard(
              onBeforeNext: (i) async {
                await Future<void>.delayed(const Duration(milliseconds: 600));
                return true;
              },
              onFinish: () async {
                await Future<void>.delayed(const Duration(milliseconds: 400));
              },
              children: [
                SgWizardPage(
                  child: Text(
                    context.tx('Etapa 1: simula validação assíncrona (600ms).'),
                  ),
                ),
                SgWizardPage(
                  child: Text(context.tx('Etapa 2: pode finalizar.')),
                ),
              ],
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardBeforeNext,
      ),
      ShowcaseExample(
        title: 'validateStep',
        description:
            'Validação customizada por etapa, além da validação automática dos inputs.',
        preview:
            // #region sg-wizard-validate-step
            SgWizard(
              validateStep: (i) {
                if (i != 0) return true;
                final nome = (_form.getValue('nome') as String?) ?? '';
                final email = (_form.getValue('email') as String?) ?? '';
                return nome.trim().isNotEmpty && email.trim().isNotEmpty;
              },
              onFinish: () {},
              children: [
                SgWizardPage(
                  child: Text(
                    context.tx(
                      'Etapa 1: valida via validateStep (nome e e-mail do primeiro exemplo).',
                    ),
                  ),
                ),
                SgWizardPage(
                  child: Text(context.tx('Etapa 2: pode finalizar.')),
                ),
              ],
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardValidateStep,
      ),
      ShowcaseExample(
        title: 'Avanço bloqueado (nextDisabled)',
        description:
            'onBeforeNext só age no clique: o botão continua com aparência de habilitado e, quando ele recusa, nada acontece na tela. Quando o bloqueio já é conhecido (o resultado de uma checagem assíncrona que já terminou), nextDisabled deixa isso visível.',
        preview:
            // #region sg-wizard-next-disabled
            ValueListenableBuilder<bool>(
              valueListenable: _jaUsado,
              builder: (context, jaUsado, _) => SgWizard(
                nextDisabled: jaUsado,
                onFinish: () {},
                children: [
                  SgWizardPage(
                    title: context.tx('Convite'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SgInputText(
                          id: 'wizard-codigo-convite',
                          labelText: context.tx('Código do convite'),
                          error: jaUsado
                              ? context.tx('Este código já foi utilizado.')
                              : null,
                          onChange: (v) {
                            _codigo = v;
                            _jaUsado.value = false;
                          },
                          onExit: () async {
                            if (_codigo.trim().isEmpty) return;
                            _checando.value = true;
                            await Future<void>.delayed(
                              const Duration(milliseconds: 600),
                            );
                            if (!mounted) return;
                            _jaUsado.value =
                                _codigo.trim().toUpperCase() == 'SG-123';
                            _checando.value = false;
                          },
                        ),
                        const SizedBox(height: 8),
                        ValueListenableBuilder<bool>(
                          valueListenable: _checando,
                          builder: (context, checando, _) => Text(
                            checando
                                ? context.tx('Verificando o código...')
                                : context.tx(
                                    'Digite "SG-123" e saia do campo: o botão Próximo fica desabilitado.',
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SgWizardPage(
                    title: context.tx('Conclusão'),
                    child: Text(
                      context.tx(
                        'Código aceito: só se chega aqui com um código que a checagem liberou.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardNextDisabled,
      ),
      ShowcaseExample(
        title: 'Desabilitado (enabled)',
        description:
            'Com enabled: false o wizard inteiro fica desabilitado: Anterior, Próximo, Concluir e os passos do stepper não respondem; a etapa atual continua visível.',
        preview:
            // #region sg-wizard-enabled
            SgWizard(
              enabled: false,
              initialStep: 1,
              stepper: SgWizardStepper.numbered,
              onFinish: () {},
              children: [
                SgWizardPage(
                  title: context.tx('Dados'),
                  child: Text(context.tx('Primeira etapa')),
                ),
                SgWizardPage(
                  title: context.tx('Revisão'),
                  child: Text(context.tx('Segunda etapa')),
                ),
                SgWizardPage(
                  title: context.tx('Confirmação'),
                  child: Text(context.tx('Terceira etapa')),
                ),
              ],
            ),
        // #endregion
        code: SgWizardDemoPageSnippets.sgWizardEnabled,
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
          if (v['stepper'] != null) {
            args.add(
              'stepper: SgWizardStepper.${SgWizardStepper.fromValue(v['stepper'] as String)!.name}',
            );
          }
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
