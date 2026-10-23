import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';

import 'masked_support.dart';

TextEditingValue v(String text, [int? cursor]) => TextEditingValue(
  text: text,
  selection: TextSelection.collapsed(offset: cursor ?? text.length),
);

void main() {
  const cpf = SgMaskFormatter(maskCpf);
  const phone = SgMaskFormatter(maskPhone);

  group('SgMaskFormatter (unidade)', () {
    test('digitar no fim aplica a mascara e deixa o cursor no fim', () {
      final r = cpf.formatEditUpdate(v('123.4'), v('123.45'));
      expect(r.text, '123.45');
      expect(r.selection.baseOffset, 6);
    });

    test(
      'digitar o primeiro digito depois de um separador pula o separador',
      () {
        final r = cpf.formatEditUpdate(v('123'), v('1234'));
        expect(r.text, '123.4');
        expect(r.selection.baseOffset, 5);
      },
    );

    test('inserir no meio mantem o cursor logo depois do digito digitado', () {
      final r = cpf.formatEditUpdate(
        v('123.456.789-01', 2),
        v('1293.456.789-01', 3),
      );
      expect(r.text, '129.345.678-90');
      expect(r.selection.baseOffset, 3);
    });

    test('backspace sobre o separador apaga tambem o digito anterior', () {
      // "123.4" com o cursor depois do ponto; o backspace remove o ponto -> "1234", cursor 3
      final r = cpf.formatEditUpdate(v('123.4', 4), v('1234', 3));
      expect(r.text, '124');
      expect(r.selection.baseOffset, 2);
    });

    test('backspace comum (digito) nao apaga mais nada', () {
      final r = cpf.formatEditUpdate(v('123.45', 6), v('123.4', 5));
      expect(r.text, '123.4');
      expect(r.selection.baseOffset, 5);
    });

    test(
      'colar/substituir por texto sem mascara NAO e tratado como apagar separador',
      () {
        final r = cpf.formatEditUpdate(v('529.982.247-25'), v('52998224725'));
        expect(r.text, '529.982.247-25');
      },
    );

    test('apagar tudo', () {
      final r = cpf.formatEditUpdate(v('1'), v(''));
      expect(r.text, '');
      expect(r.selection.baseOffset, 0);
    });

    test('letras sao descartadas e o cursor nao passa do texto', () {
      final r = cpf.formatEditUpdate(v('123'), v('123abc'));
      expect(r.text, '123');
      expect(r.selection.baseOffset, 3);
    });

    test('telefone: parenteses e espaco entram sozinhos', () {
      expect(phone.formatEditUpdate(v(''), v('1')).text, '(1');
      final r = phone.formatEditUpdate(v('(11'), v('(119'));
      expect(r.text, '(11) 9');
      expect(r.selection.baseOffset, 6);
    });

    test('selecao invalida cai no fim do texto', () {
      final r = cpf.formatEditUpdate(
        v(''),
        const TextEditingValue(text: '1234'),
      );
      expect(r.text, '123.4');
      expect(r.selection.baseOffset, 5);
    });
  });
}
