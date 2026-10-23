import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

void main() {
  group('validateRules (ordem e semantica do RHF)', () {
    test(
      'required: null, vazio, lista vazia e false falham; texto e usado como mensagem',
      () async {
        const r = SgRules(required: 'Informe');
        for (final v in [null, '', <Object>[], false]) {
          final e = await validateRules(r, v);
          expect(e?.type, 'required', reason: '$v');
          expect(e?.message, 'Informe');
        }
        expect(await validateRules(r, 'x'), isNull);
        expect(await validateRules(r, 0), isNull, reason: '0 e valor valido');
        expect(
          (await validateRules(const SgRules(required: true), ''))?.message,
          '',
        );
      },
    );

    test('demais regras so rodam com valor preenchido', () async {
      expect(await validateRules(const SgRules(minLength: 3), ''), isNull);
    });

    test('min/max/minLength/maxLength/pattern com e sem mensagem', () async {
      expect((await validateRules(const SgRules(min: 5), 3))?.type, 'min');
      expect(
        (await validateRules(
          const SgRules(max: SgRuleValue(5, 'grande')),
          9,
        ))?.message,
        'grande',
      );
      expect(
        (await validateRules(const SgRules(minLength: 3), 'ab'))?.type,
        'minLength',
      );
      expect(
        (await validateRules(const SgRules(maxLength: 2), 'abc'))?.type,
        'maxLength',
      );
      expect(await validateRules(const SgRules(maxLength: 3), 'abc'), isNull);
      expect(
        (await validateRules(
          SgRules(pattern: SgRuleValue(RegExp(r'^\d+$'), 'so numeros')),
          'a1',
        ))?.message,
        'so numeros',
      );
      expect(
        await validateRules(SgRules(pattern: RegExp(r'^\d+$')), '12'),
        isNull,
      );
    });

    test(
      'validate: true/null ok, false sem mensagem, texto vira mensagem, aceita async',
      () async {
        expect(
          await validateRules(SgRules(validate: (v) => true), 'x'),
          isNull,
        );
        expect(
          await validateRules(SgRules(validate: (v) => null), 'x'),
          isNull,
        );
        expect(
          (await validateRules(SgRules(validate: (v) => false), 'x'))?.message,
          '',
        );
        expect(
          (await validateRules(
            SgRules(validate: (v) async => 'ja existe'),
            'x',
          ))?.message,
          'ja existe',
        );
      },
    );

    test(
      'validate roda ate com valor vazio (como no RHF); as demais regras nao',
      () async {
        final e = await validateRules(
          SgRules(minLength: 3, validate: (v) => 'sempre'),
          '',
        );
        expect(e?.type, 'validate');
        expect(e?.message, 'sempre');
        expect(
          await validateRules(SgRules(minLength: 3, validate: (v) => true), ''),
          isNull,
        );
      },
    );

    test('ordem: required antes de min', () async {
      final e = await validateRules(const SgRules(required: 'r', min: 5), null);
      expect(e?.type, 'required');
    });
  });

  group('mergeRequiredRule e resolveFieldError (iguais ao React)', () {
    test('required vira regra com mensagem, sem sobrescrever a existente', () {
      expect(mergeRequiredRule(null, false, 'm'), isNull);
      expect(mergeRequiredRule(null, true, 'm')!.required, 'm');
      expect(
        mergeRequiredRule(const SgRules(required: 'meu'), true, 'm')!.required,
        'meu',
      );
      expect(
        mergeRequiredRule(
          const SgRules(required: false, minLength: 2),
          true,
          'm',
        )!.required,
        'm',
      );
    });
    test('primeira mensagem nao vazia', () {
      expect(resolveFieldError(null, '  ', 'x'), 'x');
      expect(resolveFieldError('a', 'b'), 'a');
      expect(resolveFieldError('', null), isNull);
    });
  });

  group('SgFormController (useForm do RHF)', () {
    test('defaultValues, setValue, getValues, watch, reset', () async {
      final f = SgFormController(defaultValues: {'a': '1'});
      expect(f.getValue('a'), '1');
      await f.setValue('a', '2');
      expect(f.watch('a'), '2');
      expect(f.isDirty, isTrue);
      await f.setValue('a', '1');
      expect(f.isDirty, isFalse, reason: 'voltou ao padrao');
      await f.setValue('a', '9');
      f.reset();
      expect(f.getValue('a'), '1');
      expect(f.isDirty, isFalse);
      f.reset({'a': 'novo'});
      await f.setValue('a', 'x');
      f.reset();
      expect(
        f.getValue('a'),
        'novo',
        reason: 'reset(values) vira o novo padrao',
      );
    });

    test('registerField nao sobrescreve valor existente', () {
      final f = SgFormController(defaultValues: {'a': 'x'});
      f.registerField('a', initialValue: 'y');
      f.registerField('b', initialValue: 'z');
      expect(f.getValue('a'), 'x');
      expect(f.getValue('b'), 'z');
    });

    test(
      'trigger valida e preenche errors; setValue(shouldValidate) valida o campo',
      () async {
        final f = SgFormController();
        f.registerField('n', rules: const SgRules(required: 'obrigatorio'));
        expect(await f.trigger(), isFalse);
        expect(f.errorOf('n')?.message, 'obrigatorio');
        expect(f.isValid, isFalse);
        await f.setValue('n', 'ok', shouldValidate: true);
        expect(f.errorOf('n'), isNull);
        expect(f.isValid, isTrue);
      },
    );

    test('setError e clearErrors', () {
      final f = SgFormController();
      f.setError('x', 'falhou');
      expect(f.errors['x']!.message, 'falhou');
      f.clearErrors(['x']);
      expect(f.errors, isEmpty);
    });

    test('dependencia entre campos via validate', () async {
      final f = SgFormController(
        defaultValues: {'senha': 'abc', 'confirma': 'abd'},
      );
      f.registerField(
        'confirma',
        rules: SgRules(
          validate: (v) => v == f.getValue('senha') ? true : 'diferente',
        ),
      );
      expect(await f.trigger(['confirma']), isFalse);
      expect(f.errorOf('confirma')!.message, 'diferente');
    });

    test(
      'handleSubmit: valido chama onValid, invalido chama onInvalid, bloqueia duplo envio',
      () async {
        final f = SgFormController(defaultValues: {'n': ''});
        f.registerField('n', rules: const SgRules(required: 'r'));
        var valid = 0;
        Map<String, SgFieldError>? invalid;
        await f.handleSubmit((_) => valid++, (e) => invalid = e);
        expect(valid, 0);
        expect(invalid!['n']!.type, 'required');
        expect(f.submitCount, 1);

        await f.setValue('n', 'x');
        var calls = 0;
        Map<String, Object?>? got;
        final gate = Future<void>.delayed(const Duration(milliseconds: 20));
        final first = f.handleSubmit((v) async {
          calls++;
          got = v;
          await gate;
        });
        // segunda chamada enquanto a primeira roda: ignorada
        final second = f.handleSubmit((_) => calls++);
        expect(f.isSubmitting, isTrue);
        await Future.wait([first, second]);
        expect(calls, 1);
        expect(got, {'n': 'x'});
        expect(f.isSubmitting, isFalse);
      },
    );

    test('notifica ouvintes', () async {
      final f = SgFormController();
      var n = 0;
      f.addListener(() => n++);
      await f.setValue('a', 1);
      f.setError('a', 'x');
      expect(n, greaterThanOrEqualTo(2));
    });
  });
}
