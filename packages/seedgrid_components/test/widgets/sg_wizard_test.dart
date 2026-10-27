import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

Widget host(Widget child) => MaterialApp(
  theme: SgTheme.fromInput(defaultSeedTheme, Brightness.light).toThemeData(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  ),
);

List<SgWizardPage> pages([int n = 3]) => [
  for (var i = 1; i <= n; i++)
    SgWizardPage(title: 'Titulo $i', child: Text('conteudo $i')),
];

Finder next() => find.byKey(const ValueKey('wizard-next'));
Finder previous() => find.byKey(const ValueKey('wizard-previous'));
Finder finish() => find.byKey(const ValueKey('wizard-finish'));
Finder step(int i) => find.byKey(ValueKey('wizard-step-$i'));

bool disabled(WidgetTester t, Finder f) =>
    t.widget<SgButton>(f).disabled ?? false;

void main() {
  setUp(resetComponentsI18n);

  group('logica pura (igual a logic.ts)', () {
    test('clampWizardStep', () {
      expect(clampWizardStep(null, 3), 0);
      expect(clampWizardStep(1, 3), 1);
      expect(clampWizardStep(9, 3), 2);
      expect(clampWizardStep(-4, 3), 0);
      expect(clampWizardStep(2, 0), 0);
    });

    test('canNavigateToWizardStep: none, previous, previous-and-next', () {
      bool can(int target, SgWizardStepNavigation nav) =>
          canNavigateToWizardStep(
            currentStep: 1,
            targetStep: target,
            pageCount: 4,
            stepNavigation: nav,
          );
      expect(can(0, SgWizardStepNavigation.none), isFalse);
      expect(can(0, SgWizardStepNavigation.previous), isTrue);
      expect(can(2, SgWizardStepNavigation.previous), isFalse);
      expect(can(0, SgWizardStepNavigation.previousAndNext), isTrue);
      expect(can(2, SgWizardStepNavigation.previousAndNext), isTrue);
      expect(
        can(3, SgWizardStepNavigation.previousAndNext),
        isFalse,
        reason: 'so a proxima etapa',
      );
      expect(
        can(1, SgWizardStepNavigation.previousAndNext),
        isFalse,
        reason: 'a atual',
      );
      expect(can(-1, SgWizardStepNavigation.previousAndNext), isFalse);
      expect(can(4, SgWizardStepNavigation.previousAndNext), isFalse);
      expect(
        canNavigateToWizardStep(currentStep: 0, targetStep: 1, pageCount: 3),
        isTrue,
        reason: 'padrao previous-and-next',
      );
    });

    test(
      'canProceedWizardAction: ordem pagina, validateStep, beforeAction e para no primeiro que falha',
      () async {
        final log = <String>[];
        Future<bool> run({bool page = true, bool? validate, bool? before}) =>
            canProceedWizardAction(
              validateCurrentPage: () {
                log.add('page');
                return page;
              },
              validateStep: validate == null
                  ? null
                  : (i) {
                      log.add('validate$i');
                      return validate;
                    },
              beforeAction: before == null
                  ? null
                  : (i) {
                      log.add('before$i');
                      return before;
                    },
              step: 2,
            );
        expect(await run(validate: true, before: true), isTrue);
        expect(log, ['page', 'validate2', 'before2']);
        log.clear();
        expect(await run(page: false, validate: true, before: true), isFalse);
        expect(log, ['page']);
        log.clear();
        expect(await run(validate: false, before: true), isFalse);
        expect(log, ['page', 'validate2']);
        log.clear();
        expect(await run(before: false), isFalse);
      },
    );
  });

  group('SgWizardPage', () {
    testWidgets(
      'renderiza o filho; title e icon ficam disponiveis para o stepper',
      (t) async {
        const page = SgWizardPage(
          title: 'T',
          icon: Icon(Icons.star),
          child: Text('corpo'),
        );
        expect(page.title, 'T');
        expect(page.icon, isA<Icon>());
        expect(page.fields, isNull);
        await t.pumpWidget(host(page));
        expect(find.text('corpo'), findsOneWidget);
      },
    );
  });

  group('SgWizard navegacao', () {
    testWidgets(
      'mostra so a etapa atual; Proximo e Anterior; Finalizar na ultima',
      (t) async {
        var finished = 0;
        await t.pumpWidget(
          host(SgWizard(onFinish: () => finished++, children: pages())),
        );
        expect(find.text('conteudo 1'), findsOneWidget);
        expect(find.text('conteudo 2'), findsNothing);
        expect(
          previous(),
          findsNothing,
          reason: 'primeira etapa nao tem Anterior',
        );
        expect(find.text('Next'), findsOneWidget);
        await t.tap(next());
        await t.pump();
        await t.pump();
        expect(find.text('conteudo 2'), findsOneWidget);
        expect(previous(), findsOneWidget);
        await t.tap(previous());
        await t.pump();
        expect(find.text('conteudo 1'), findsOneWidget);
        await t.tap(next());
        await t.pump();
        await t.pump();
        await t.tap(next());
        await t.pump();
        await t.pump();
        expect(find.text('conteudo 3'), findsOneWidget);
        expect(next(), findsNothing);
        expect(find.text('Finish'), findsOneWidget);
        await t.tap(finish());
        await t.pump();
        await t.pump();
        expect(finished, 1);
      },
    );

    testWidgets('initialStep (com clamp)', (t) async {
      await t.pumpWidget(
        host(SgWizard(onFinish: () {}, initialStep: 1, children: pages())),
      );
      expect(find.text('conteudo 2'), findsOneWidget);
      await t.pumpWidget(
        host(
          SgWizard(
            key: const ValueKey('b'),
            onFinish: () {},
            initialStep: 99,
            children: pages(),
          ),
        ),
      );
      expect(find.text('conteudo 3'), findsOneWidget);
    });

    testWidgets('labels: padrao do i18n, pt-BR e override parcial', (t) async {
      setComponentsI18n(const SgComponentsI18nInput(locale: 'pt-BR'));
      await t.pumpWidget(
        host(SgWizard(onFinish: () {}, initialStep: 1, children: pages())),
      );
      expect(find.text('Próximo'), findsOneWidget);
      expect(find.text('Anterior'), findsOneWidget);
      await t.pumpWidget(
        host(
          SgWizard(
            key: const ValueKey('l'),
            onFinish: () {},
            initialStep: 1,
            labels: const SgWizardLabels(next: 'Avancar'),
            children: pages(),
          ),
        ),
      );
      expect(find.text('Avancar'), findsOneWidget);
      expect(
        find.text('Anterior'),
        findsOneWidget,
        reason: 'o que nao foi dado vem do i18n',
      );
      await t.pumpWidget(
        host(
          SgWizard(
            key: const ValueKey('f'),
            onFinish: () {},
            initialStep: 2,
            labels: const SgWizardLabels(finish: 'Concluir'),
            children: pages(),
          ),
        ),
      );
      expect(find.text('Concluir'), findsOneWidget);
    });

    testWidgets(
      'onStepChange: etapa inicial depois da montagem e a cada mudanca',
      (t) async {
        final steps = <int>[];
        await t.pumpWidget(
          host(
            SgWizard(
              onFinish: () {},
              onStepChange: steps.add,
              initialStep: 1,
              children: pages(),
            ),
          ),
        );
        await t.pump();
        expect(steps, [1]);
        await t.tap(next());
        await t.pump();
        await t.pump();
        await t.tap(previous());
        await t.pump();
        expect(steps, [1, 2, 1]);
      },
    );

    testWidgets('o contrato gerado: child empilha as etapas', (t) async {
      final w = SgWizard(onFinish: () {}, children: pages(2));
      expect(w.child, isA<Column>());
      expect((w.child as Column).children.length, 2);
    });
  });

  group('SgWizard guardas', () {
    testWidgets('onBeforeNext false bloqueia; true avanca; recebe o indice', (
      t,
    ) async {
      var allow = false;
      final seen = <int>[];
      await t.pumpWidget(
        host(
          SgWizard(
            onFinish: () {},
            onBeforeNext: (i) {
              seen.add(i);
              return allow;
            },
            children: pages(),
          ),
        ),
      );
      await t.tap(next());
      await t.pump();
      await t.pump();
      expect(find.text('conteudo 1'), findsOneWidget);
      allow = true;
      await t.tap(next());
      await t.pump();
      await t.pump();
      expect(find.text('conteudo 2'), findsOneWidget);
      expect(seen, [0, 0]);
    });

    testWidgets('validateStep roda antes de onBeforeNext e aceita async', (
      t,
    ) async {
      final log = <String>[];
      await t.pumpWidget(
        host(
          SgWizard(
            onFinish: () {},
            validateStep: (i) async {
              log.add('validate');
              return true;
            },
            onBeforeNext: (i) {
              log.add('before');
              return true;
            },
            children: pages(),
          ),
        ),
      );
      await t.tap(next());
      await t.pump();
      await t.pump();
      expect(log, ['validate', 'before']);
      expect(find.text('conteudo 2'), findsOneWidget);
    });

    testWidgets(
      'durante a validacao assincrona o Proximo fica desabilitado (sem duplo clique)',
      (t) async {
        final gate = Completer<bool>();
        var calls = 0;
        await t.pumpWidget(
          host(
            SgWizard(
              onFinish: () {},
              onBeforeNext: (i) {
                calls++;
                return gate.future;
              },
              children: pages(),
            ),
          ),
        );
        await t.tap(next());
        await t.pump();
        expect(disabled(t, next()), isTrue);
        await t.tap(next(), warnIfMissed: false);
        await t.pump();
        expect(calls, 1);
        gate.complete(true);
        await t.pump();
        await t.pump();
        expect(find.text('conteudo 2'), findsOneWidget);
        expect(disabled(t, next()), isFalse);
      },
    );

    testWidgets('onBeforeFinish false impede onFinish; true chama', (t) async {
      var allow = false;
      var finished = 0;
      await t.pumpWidget(
        host(
          SgWizard(
            onFinish: () => finished++,
            onBeforeFinish: (i) => allow,
            initialStep: 2,
            children: pages(),
          ),
        ),
      );
      await t.tap(finish());
      await t.pump();
      await t.pump();
      expect(finished, 0);
      allow = true;
      await t.tap(finish());
      await t.pump();
      await t.pump();
      expect(finished, 1);
    });

    testWidgets(
      'onFinish assincrono: Finalizar fica desabilitado ate terminar',
      (t) async {
        final gate = Completer<void>();
        var calls = 0;
        await t.pumpWidget(
          host(
            SgWizard(
              onFinish: () {
                calls++;
                return gate.future;
              },
              initialStep: 2,
              children: pages(),
            ),
          ),
        );
        await t.tap(finish());
        await t.pump();
        await t.pump();
        expect(disabled(t, finish()), isTrue);
        await t.tap(finish(), warnIfMissed: false);
        await t.pump();
        expect(calls, 1);
        gate.complete();
        await t.pump();
        await t.pump();
        expect(disabled(t, finish()), isFalse);
      },
    );

    testWidgets(
      'nextDisabled desabilita o Proximo e o stepper nao oferece etapas seguintes; nao afeta Finalizar',
      (t) async {
        await t.pumpWidget(
          host(
            SgWizard(
              onFinish: () {},
              nextDisabled: true,
              stepper: SgWizardStepper.numbered,
              children: pages(),
            ),
          ),
        );
        expect(disabled(t, next()), isTrue);
        await t.tap(next(), warnIfMissed: false);
        await t.pump();
        expect(find.text('conteudo 1'), findsOneWidget);
        // tocar na etapa 2 do stepper tambem nao avanca
        await t.tap(
          find.byKey(const ValueKey('wizard-step-circle-1')),
          warnIfMissed: false,
        );
        await t.pump();
        await t.pump();
        expect(find.text('conteudo 1'), findsOneWidget);
        await t.pumpWidget(
          host(
            SgWizard(
              key: const ValueKey('u'),
              onFinish: () {},
              nextDisabled: true,
              initialStep: 2,
              children: pages(),
            ),
          ),
        );
        expect(disabled(t, finish()), isFalse);
      },
    );
  });

  group('SgWizard stepper', () {
    testWidgets('none (padrao): sem stepper', (t) async {
      await t.pumpWidget(host(SgWizard(onFinish: () {}, children: pages())));
      expect(find.byKey(const ValueKey('wizard-step-circle-0')), findsNothing);
      expect(
        const SgWizard(onFinish: _noop, children: []).stepper,
        SgWizardStepper.none,
      );
    });

    testWidgets(
      'numbered: numeros, titulos, "Etapa N" quando nao ha titulo, check nas concluidas',
      (t) async {
        await t.pumpWidget(
          host(
            SgWizard(
              onFinish: () {},
              stepper: SgWizardStepper.numbered,
              initialStep: 1,
              children: const [
                SgWizardPage(title: 'Dados', child: Text('a')),
                SgWizardPage(child: Text('b')),
                SgWizardPage(title: 'Fim', child: Text('c')),
              ],
            ),
          ),
        );
        expect(find.text('Dados'), findsOneWidget);
        expect(
          find.text('Step 2'),
          findsOneWidget,
          reason: 'sem titulo: Etapa N do i18n (en-US: Step N)',
        );
        expect(find.text('Fim'), findsOneWidget);
        expect(
          find.byIcon(Icons.check),
          findsOneWidget,
          reason: 'a etapa 1 esta concluida',
        );
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(
          find.text('1'),
          findsNothing,
          reason: 'concluida mostra o check no lugar do numero',
        );
      },
    );

    testWidgets('icons: mostra o icone da pagina; sem icone cai no numero', (
      t,
    ) async {
      await t.pumpWidget(
        host(
          SgWizard(
            onFinish: () {},
            stepper: SgWizardStepper.icons,
            children: const [
              SgWizardPage(
                title: 'A',
                icon: Icon(Icons.person),
                child: Text('a'),
              ),
              SgWizardPage(title: 'B', child: Text('b')),
            ],
          ),
        ),
      );
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets(
      'stepNavigation: previous-and-next (padrao) deixa tocar na etapa seguinte e nas anteriores',
      (t) async {
        await t.pumpWidget(
          host(
            SgWizard(
              onFinish: () {},
              stepper: SgWizardStepper.numbered,
              children: pages(4),
            ),
          ),
        );
        await t.tap(find.byKey(const ValueKey('wizard-step-circle-1')));
        await t.pump();
        await t.pump();
        expect(find.text('conteudo 2'), findsOneWidget);
        await t.tap(
          find.byKey(const ValueKey('wizard-step-circle-3')),
          warnIfMissed: false,
        );
        await t.pump();
        expect(
          find.text('conteudo 2'),
          findsOneWidget,
          reason: 'so a proxima etapa',
        );
        await t.tap(find.byKey(const ValueKey('wizard-step-circle-0')));
        await t.pump();
        expect(find.text('conteudo 1'), findsOneWidget);
      },
    );

    testWidgets('stepNavigation previous: so volta; none: nenhuma', (t) async {
      await t.pumpWidget(
        host(
          SgWizard(
            onFinish: () {},
            stepper: SgWizardStepper.numbered,
            stepNavigation: SgWizardStepNavigation.previous,
            initialStep: 1,
            children: pages(),
          ),
        ),
      );
      await t.tap(
        find.byKey(const ValueKey('wizard-step-circle-2')),
        warnIfMissed: false,
      );
      await t.pump();
      expect(find.text('conteudo 2'), findsOneWidget);
      await t.tap(find.byKey(const ValueKey('wizard-step-circle-0')));
      await t.pump();
      expect(find.text('conteudo 1'), findsOneWidget);
      await t.pumpWidget(
        host(
          SgWizard(
            key: const ValueKey('n'),
            onFinish: () {},
            stepper: SgWizardStepper.numbered,
            stepNavigation: SgWizardStepNavigation.none,
            initialStep: 1,
            children: pages(),
          ),
        ),
      );
      await t.tap(
        find.byKey(const ValueKey('wizard-step-circle-0')),
        warnIfMissed: false,
      );
      await t.pump();
      expect(find.text('conteudo 2'), findsOneWidget);
    });

    testWidgets(
      'tocar na etapa seguinte passa pelas mesmas guardas do Proximo',
      (t) async {
        var allow = false;
        await t.pumpWidget(
          host(
            SgWizard(
              onFinish: () {},
              stepper: SgWizardStepper.numbered,
              onBeforeNext: (i) => allow,
              children: pages(),
            ),
          ),
        );
        await t.tap(find.byKey(const ValueKey('wizard-step-circle-1')));
        await t.pump();
        await t.pump();
        expect(find.text('conteudo 1'), findsOneWidget);
        allow = true;
        await t.tap(find.byKey(const ValueKey('wizard-step-circle-1')));
        await t.pump();
        await t.pump();
        expect(find.text('conteudo 2'), findsOneWidget);
      },
    );
  });

  group('SgWizard validacao por etapa com SgForm', () {
    Widget formWizard(
      SgFormController form, {
      bool restrictFields = false,
      VoidCallback? onFinish,
    }) => host(
      SgWizard(
        control: form,
        onFinish: onFinish ?? () {},
        children: [
          SgWizardPage(
            title: 'Dados',
            fields: restrictFields ? const ['nome'] : null,
            child: SgInputText(
              id: 'nome',
              name: 'nome',
              control: form,
              labelText: 'Nome',
              required: true,
              requiredMessage: 'Informe o nome',
            ),
          ),
          SgWizardPage(
            title: 'Contato',
            child: SgInputText(
              id: 'email',
              name: 'email',
              control: form,
              labelText: 'E-mail',
              required: true,
              requiredMessage: 'Informe o e-mail',
            ),
          ),
        ],
      ),
    );

    testWidgets('campo obrigatorio vazio bloqueia o Proximo e mostra o erro', (
      t,
    ) async {
      final form = SgFormController();
      await t.pumpWidget(formWizard(form));
      await t.tap(next());
      await t.pump();
      await t.pump();
      expect(find.text('Informe o nome'), findsOneWidget);
      expect(find.text('E-mail'), findsNothing, reason: 'continua na etapa 1');
    });

    testWidgets(
      'preenchendo o campo, avanca; a etapa 2 valida o proprio campo e o Finalizar so chama onFinish se valido',
      (t) async {
        final form = SgFormController();
        var finished = 0;
        await t.pumpWidget(formWizard(form, onFinish: () => finished++));
        await t.enterText(find.byKey(const ValueKey('input-nome')), 'Ana');
        await t.tap(next());
        await t.pump();
        await t.pump();
        expect(find.text('E-mail'), findsOneWidget);
        await t.tap(finish());
        await t.pump();
        await t.pump();
        expect(finished, 0);
        expect(find.text('Informe o e-mail'), findsOneWidget);
        await t.enterText(find.byKey(const ValueKey('input-email')), 'a@b.co');
        await t.tap(finish());
        await t.pump();
        await t.pump();
        expect(finished, 1);
        expect(
          form.getValue('nome'),
          'Ana',
          reason: 'valor da etapa anterior continua no formulario',
        );
      },
    );

    testWidgets('fields restringe a validacao aos campos da etapa', (t) async {
      final form = SgFormController();
      // 'email' ja foi registrado e esta invalido, mas nao pertence a etapa 1.
      form.registerField(
        'email',
        rules: const SgRules(required: 'Informe o e-mail'),
      );
      await t.pumpWidget(formWizard(form, restrictFields: true));
      await t.enterText(find.byKey(const ValueKey('input-nome')), 'Ana');
      await t.tap(next());
      await t.pump();
      await t.pump();
      expect(
        find.text('E-mail'),
        findsOneWidget,
        reason: 'avancou: so o campo nome foi validado',
      );
    });

    testWidgets('usa o SgForm mais proximo quando nao ha control', (t) async {
      await t.pumpWidget(
        host(
          SgForm(
            child: SgWizard(
              onFinish: () {},
              children: const [
                SgWizardPage(
                  child: SgInputText(
                    id: 'nome',
                    name: 'nome',
                    labelText: 'Nome',
                    required: true,
                    requiredMessage: 'Informe o nome',
                  ),
                ),
                SgWizardPage(child: Text('fim')),
              ],
            ),
          ),
        ),
      );
      await t.tap(next());
      await t.pump();
      await t.pump();
      expect(find.text('Informe o nome'), findsOneWidget);
      expect(find.text('fim'), findsNothing);
    });

    testWidgets('sem formulario a pagina e considerada valida', (t) async {
      await t.pumpWidget(host(SgWizard(onFinish: () {}, children: pages(2))));
      await t.tap(next());
      await t.pump();
      await t.pump();
      expect(find.text('conteudo 2'), findsOneWidget);
    });
  });

  group('campos fora de formulario barram o avanco (como o React)', () {
    Widget wizard() => host(
      SgWizard(
        onFinish: () {},
        children: [
          const SgWizardPage(
            title: 'Dados',
            child: SgInputText(
              id: 'nome',
              required: true,
              requiredMessage: 'Informe o nome',
            ),
          ),
          SgWizardPage(title: 'Fim', child: const Text('conteudo fim')),
        ],
      ),
    );

    testWidgets(
      'obrigatorio vazio bloqueia e mostra o erro; preenchido avanca',
      (t) async {
        await t.pumpWidget(wizard());
        await t.tap(next());
        await t.pumpAndSettle();
        expect(find.text('Informe o nome'), findsOneWidget);
        expect(find.text('conteudo fim'), findsNothing);

        await t.enterText(find.byKey(const ValueKey('input-nome')), 'Ana');
        await t.tap(next());
        await t.pumpAndSettle();
        expect(find.text('conteudo fim'), findsOneWidget);
      },
    );

    for (final (nome, campo) in <(String, Widget)>[
      ('SgInputTextArea', const SgInputTextArea(id: 'a', required: true)),
      ('SgInputNumber', const SgInputNumber(id: 'b', required: true)),
      ('SgToggleSwitch', const SgToggleSwitch(id: 'c', required: true)),
      ('SgInputEmail', const SgInputEmail(id: 'd', required: true)),
    ]) {
      testWidgets('$nome obrigatorio vazio bloqueia o Proximo', (t) async {
        await t.pumpWidget(
          host(
            SgWizard(
              onFinish: () {},
              children: [
                SgWizardPage(title: 'Dados', child: campo),
                const SgWizardPage(title: 'Fim', child: Text('conteudo fim')),
              ],
            ),
          ),
        );
        await t.tap(next());
        await t.pumpAndSettle();
        expect(find.text('conteudo fim'), findsNothing);
      });
    }

    testWidgets('campo desabilitado nao bloqueia', (t) async {
      await t.pumpWidget(
        host(
          SgWizard(
            onFinish: () {},
            children: [
              const SgWizardPage(
                title: 'Dados',
                child: SgInputText(id: 'x', required: true, disabled: true),
              ),
              SgWizardPage(title: 'Fim', child: const Text('conteudo fim')),
            ],
          ),
        ),
      );
      await t.tap(next());
      await t.pumpAndSettle();
      expect(find.text('conteudo fim'), findsOneWidget);
    });
  });
}

void _noop() {}
