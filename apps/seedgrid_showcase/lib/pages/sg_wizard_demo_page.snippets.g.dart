// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_wizard_demo_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgWizardDemoPageSnippets {
  /// Region `sg-wizard-before-next`.
  static const String sgWizardBeforeNext = r'''
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
)
''';

  /// Region `sg-wizard-enabled`.
  static const String sgWizardEnabled = r'''
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
)
''';

  /// Region `sg-wizard-labels`.
  static const String sgWizardLabels = r'''
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
)
''';

  /// Region `sg-wizard-next-disabled`.
  static const String sgWizardNextDisabled = r'''
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
)
''';

  /// Region `sg-wizard-step-navigation`.
  static const String sgWizardStepNavigation = r'''
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
)
''';

  /// Region `sg-wizard-stepper-icones`.
  static const String sgWizardStepperIcones = r'''
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
)
''';

  /// Region `sg-wizard-stepper-numerado`.
  static const String sgWizardStepperNumerado = r'''
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
)
''';

  /// Region `sg-wizard-validacao-automatica`.
  static const String sgWizardValidacaoAutomatica = r'''
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
)
''';

  /// Region `sg-wizard-validate-step`.
  static const String sgWizardValidateStep = r'''
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
)
''';
}
