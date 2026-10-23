// Logica pura de SgPickList e SgOrderList (porte das funcoes internas do React).
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/inputs/lists/list_logic.dart';

typedef I = ({String v, bool off});

I i(String v, {bool off = false}) => (v: v, off: off);

List<String> names(List<I> l) => l.map((e) => e.v).toList();

void main() {
  final a = i('a');
  final b = i('b');
  final c = i('c');
  final d = i('d');
  final e = i('e');
  final items = [a, b, c, d, e];

  bool sel(Set<String> s, I x) => s.contains(x.v) && !x.off;

  group('uniqueValues / sameIdentity / sameValues', () {
    test('uniqueValues mantem a ordem e mistura texto e numero', () {
      expect(uniqueValues(['a', 1, 'a', 2, 1]), ['a', 1, 2]);
    });
    test('sameIdentity compara objetos, nao conteudo', () {
      expect(sameIdentity([a, b], [a, b]), isTrue);
      expect(sameIdentity([a, b], [b, a]), isFalse);
      expect(sameIdentity([a], [a, b]), isFalse);
      expect(sameIdentity([i('a')], [i('a')]), isFalse);
    });
    test('sameValues compara valores', () {
      expect(sameValues(['a', 1], ['a', 1]), isTrue);
      expect(sameValues(['a', 1], ['a', 2]), isFalse);
      expect(sameValues(['a'], ['a', 'b']), isFalse);
    });
  });

  group('moveSingleItem (insere ANTES da posicao de destino)', () {
    test('pra frente e pra tras', () {
      expect(names(moveSingleItem(items, 0, 3)), ['b', 'c', 'a', 'd', 'e']);
      expect(names(moveSingleItem(items, 3, 1)), ['a', 'd', 'b', 'c', 'e']);
    });
    test('destino = tamanho manda para o fim', () {
      expect(names(moveSingleItem(items, 1, 5)), ['a', 'c', 'd', 'e', 'b']);
    });
    test('sem mudanca devolve a mesma lista', () {
      expect(identical(moveSingleItem(items, 2, 2), items), isTrue);
      expect(
        identical(moveSingleItem(items, 2, 3), items),
        isTrue,
        reason: 'soltar logo depois de si mesmo',
      );
      expect(identical(moveSingleItem(items, -1, 2), items), isTrue);
      expect(identical(moveSingleItem(items, 9, 2), items), isTrue);
      expect(identical(moveSingleItem(items, 1, 99), items), isTrue);
      expect(identical(moveSingleItem([a], 0, 1), items), isFalse);
      expect(identical(moveSingleItem(<I>[a], 0, 0), items), isFalse);
    });
  });

  group('PickList: sempre devolve lista nova quando ha selecao', () {
    test('top e bottom levam os selecionados juntos, na ordem original', () {
      final s = {'b', 'd'};
      expect(names(pickMoveTop(items, (x) => sel(s, x))), [
        'b',
        'd',
        'a',
        'c',
        'e',
      ]);
      expect(names(pickMoveBottom(items, (x) => sel(s, x))), [
        'a',
        'c',
        'e',
        'b',
        'd',
      ]);
    });
    test('sem selecionado movel devolve a mesma lista', () {
      expect(identical(pickMoveTop(items, (x) => false), items), isTrue);
      expect(identical(pickMoveBottom(items, (x) => false), items), isTrue);
    });
    test('desabilitado nao se move', () {
      final list = [a, i('b', off: true), c];
      final s = {'b', 'c'};
      expect(names(pickMoveTop(list, (x) => sel(s, x))), ['c', 'a', 'b']);
    });
    test('up e down trocam com o vizinho nao selecionado', () {
      final s = {'b', 'd'};
      expect(names(pickMoveUp(items, (x) => sel(s, x))), [
        'b',
        'a',
        'd',
        'c',
        'e',
      ]);
      expect(names(pickMoveDown(items, (x) => sel(s, x))), [
        'a',
        'c',
        'b',
        'e',
        'd',
      ]);
    });
    test('bloco selecionado encostado no topo nao anda; o resto anda', () {
      final s = {'a', 'b', 'd'};
      expect(names(pickMoveUp(items, (x) => sel(s, x))), [
        'a',
        'b',
        'd',
        'c',
        'e',
      ]);
    });
    test(
      'up/down no limite devolvem COPIA (o React dispara onChange mesmo sem mudar)',
      () {
        final s = {'a'};
        final up = pickMoveUp(items, (x) => sel(s, x));
        expect(identical(up, items), isFalse);
        expect(names(up), names(items));
        final s2 = {'e'};
        final down = pickMoveDown(items, (x) => sel(s2, x));
        expect(identical(down, items), isFalse);
        expect(names(down), names(items));
      },
    );
  });

  group('OrderList: devolve a MESMA lista quando nada muda', () {
    test('top e bottom', () {
      final s = {'b', 'd'};
      expect(names(orderMoveTop(items, (x) => s.contains(x.v))), [
        'b',
        'd',
        'a',
        'c',
        'e',
      ]);
      expect(names(orderMoveBottom(items, (x) => s.contains(x.v))), [
        'a',
        'c',
        'e',
        'b',
        'd',
      ]);
      final top = {'a', 'b'};
      expect(
        identical(orderMoveTop(items, (x) => top.contains(x.v)), items),
        isTrue,
      );
      final bottom = {'d', 'e'};
      expect(
        identical(orderMoveBottom(items, (x) => bottom.contains(x.v)), items),
        isTrue,
      );
    });
    test('up e down', () {
      final s = {'b', 'd'};
      expect(names(orderMoveUp(items, (x) => s.contains(x.v))), [
        'b',
        'a',
        'd',
        'c',
        'e',
      ]);
      expect(names(orderMoveDown(items, (x) => s.contains(x.v))), [
        'a',
        'c',
        'b',
        'e',
        'd',
      ]);
      final top = {'a'};
      expect(
        identical(orderMoveUp(items, (x) => top.contains(x.v)), items),
        isTrue,
      );
      final bottom = {'e'};
      expect(
        identical(orderMoveDown(items, (x) => bottom.contains(x.v)), items),
        isTrue,
      );
    });
    test('sem selecao ou com menos de 2 itens devolve a mesma lista', () {
      expect(identical(orderMoveUp(items, (x) => false), items), isTrue);
      final one = [a];
      expect(identical(orderMoveTop(one, (x) => true), one), isTrue);
      expect(identical(orderMoveDown(one, (x) => true), one), isTrue);
    });
  });
}
