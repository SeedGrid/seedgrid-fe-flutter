import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

void main() {
  group('required do formulario (registerField)', () {
    test(
      'required: null, vazio, lista vazia e false falham; 0 e texto passam; a mensagem e a registrada',
      () async {
        for (final v in <Object?>[null, '', false, <Object>[]]) {
          final f = SgFormController(defaultValues: {'n': v});
          f.registerField('n', required: 'Informe');
          expect(await f.trigger(['n']), isFalse, reason: '$v');
          expect(f.errorOf('n')?.type, 'required');
          expect(f.errorOf('n')?.message, 'Informe');
        }
        for (final v in <Object?>[
          'x',
          0,
          true,
          <Object>[1],
        ]) {
          final f = SgFormController(defaultValues: {'n': v});
          f.registerField('n', required: 'Informe');
          expect(await f.trigger(['n']), isTrue, reason: '$v');
        }
      },
    );

    test('sem required o campo vazio e valido', () async {
      final f = SgFormController(defaultValues: {'n': ''});
      f.registerField('n');
      expect(await f.trigger(['n']), isTrue);
    });

    test('required vence o validador do componente (ordem do RHF)', () async {
      final f = SgFormController(defaultValues: {'n': ''});
      f.registerField('n', required: 'obrigatorio', validator: (_) => 'outro');
      await f.trigger(['n']);
      expect(f.errorOf('n')?.message, 'obrigatorio');
      await f.setValue('n', 'x');
      await f.trigger(['n']);
      expect(f.errorOf('n')?.message, 'outro');
      expect(f.errorOf('n')?.type, 'validate');
    });
  });

  group('requiredMessageFor e resolveFieldError', () {
    test('requiredMessageFor: mensagem so quando required e true', () {
      expect(requiredMessageFor(null, 'm'), isNull);
      expect(requiredMessageFor(false, 'm'), isNull);
      expect(requiredMessageFor(true, 'm'), 'm');
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
        f.registerField('n', required: 'obrigatorio');
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
        validator: (v) => v == f.getValue('senha') ? null : 'diferente',
      );
      expect(await f.trigger(['confirma']), isFalse);
      expect(f.errorOf('confirma')!.message, 'diferente');
    });

    test(
      'handleSubmit: valido chama onValid, invalido chama onInvalid, bloqueia duplo envio',
      () async {
        final f = SgFormController(defaultValues: {'n': ''});
        f.registerField('n', required: 'r');
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
