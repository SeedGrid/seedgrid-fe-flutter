// Logica compartilhada do multiselect (porte de useSgMultiSelect.ts), sem widgets.
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show KeyEventResult;
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/inputs/multi/multi_select_core.dart';

const _opts = [
  SgMultiSelectOption(label: 'Alpha', value: 'a'),
  SgMultiSelectOption(label: 'Beta', value: 'b', chipLabel: 'B'),
  SgMultiSelectOption(label: 'Gamma', value: 'c'),
  SgMultiSelectOption(label: 'Delta', value: 'd', disabled: true),
];

KeyDownEvent down(LogicalKeyboardKey k) => KeyDownEvent(
  logicalKey: k,
  physicalKey: PhysicalKeyboardKey.keyA,
  timeStamp: Duration.zero,
);

SgMultiSelectController make({
  List<Object>? value,
  bool searchable = false,
  int? maxSelected,
  bool disabled = false,
  void Function(List<Object>)? onChange,
  List<SgMultiSelectOption> options = _opts,
}) {
  final c = SgMultiSelectController();
  c.update(
    options: options,
    value: value,
    searchable: searchable,
    maxSelected: maxSelected,
    isDisabled: disabled,
    onChange: onChange,
  );
  return c;
}

void main() {
  group('valueEquals e jsString', () {
    test('compara por String(valor), como o JavaScript', () {
      expect(valueEquals(1, '1'), isTrue);
      expect(valueEquals(5.0, 5), isTrue);
      expect(valueEquals(5.0, '5'), isTrue);
      expect(valueEquals(1.5, '1.5'), isTrue);
      expect(valueEquals('a', 'b'), isFalse);
      expect(valueEquals(1, 2), isFalse);
    });
    test('jsString de inteiro dado como double nao leva o ".0"', () {
      expect(jsString(3.0), '3');
      expect(jsString(3.25), '3.25');
      expect(jsString('x'), 'x');
    });
  });

  group('selecao', () {
    test('nao controlado guarda a selecao internamente e avisa onChange', () {
      final changes = <List<Object>>[];
      final c = make(onChange: changes.add);
      c.toggleOption(_opts[0]);
      c.toggleOption(_opts[2]);
      expect(c.resolvedValue, ['a', 'c']);
      expect(changes.last, ['a', 'c']);
      c.toggleOption(_opts[0]);
      expect(c.resolvedValue, ['c']);
    });

    test('controlado nao guarda nada: so avisa, quem manda e o value', () {
      final changes = <List<Object>>[];
      final c = make(value: const ['a'], onChange: changes.add);
      c.toggleOption(_opts[1]);
      expect(changes.last, ['a', 'b']);
      expect(c.resolvedValue, ['a']);
    });

    test('opcao disabled nao muda nada, nem para desmarcar', () {
      final changes = <List<Object>>[];
      final c = make(value: const ['d'], onChange: changes.add);
      c.toggleOption(_opts[3]);
      expect(changes, isEmpty);
    });

    test('maxSelected impede adicionar mas permite remover', () {
      final changes = <List<Object>>[];
      final c = make(maxSelected: 1, onChange: changes.add);
      c.toggleOption(_opts[0]);
      c.toggleOption(_opts[1]);
      expect(c.resolvedValue, ['a']);
      c.toggleOption(_opts[0]);
      expect(c.resolvedValue, isEmpty);
    });

    test('removeValue e clearSelection', () {
      final changes = <List<Object>>[];
      final c = make(value: const ['a', 'b', 'c'], onChange: changes.add);
      c.removeValue('b');
      expect(changes.last, ['a', 'c']);
      c.removeValue(1); // nao existe: continua tudo
      expect(changes.last, ['a', 'b', 'c']);
      c.clearSelection();
      expect(changes.last, isEmpty);
    });

    test(
      'selectedLabels e selectedOptions seguem a ordem do value e pulam valores desconhecidos',
      () {
        final c = make(value: const ['c', 'zzz', 'b']);
        expect(c.selectedLabels, ['Gamma', 'B']);
        expect(c.selectedOptions.map((o) => o.value), ['c', 'b']);
      },
    );
  });

  group('busca e abertura', () {
    test(
      'visibleOptions: sem searchable ignora a busca; com searchable filtra sem caixa e com trim',
      () {
        final c = make();
        c.setQuery('alp');
        expect(c.visibleOptions.length, 4);
        c.update(
          options: _opts,
          value: null,
          searchable: true,
          maxSelected: null,
          isDisabled: false,
          onChange: null,
        );
        expect(c.visibleOptions.map((o) => o.value), ['a']);
        c.setQuery('  ');
        expect(c.visibleOptions.length, 4);
      },
    );

    test(
      'abrir seleciona o primeiro item (ou -1 sem itens); fechar zera busca e indice',
      () {
        final c = make(searchable: true);
        c.openDropdown();
        expect(c.open, isTrue);
        expect(c.activeIndex, 0);
        c.setQuery('zzz');
        expect(c.activeIndex, -1, reason: 'sem resultado nao ha item ativo');
        c.closeDropdown();
        expect(c.open, isFalse);
        expect(c.query, '');
        expect(c.activeIndex, -1);
        final empty = make(options: const []);
        empty.openDropdown();
        expect(empty.activeIndex, -1);
      },
    );

    test('desabilitado nao abre', () {
      final c = make(disabled: true);
      c.openDropdown();
      expect(c.open, isFalse);
    });

    test('update corta o indice ativo quando a lista encolhe', () {
      final c = make();
      c.openDropdown();
      c.setActiveIndex(3);
      c.update(
        options: _opts.sublist(0, 2),
        value: null,
        searchable: false,
        maxSelected: null,
        isDisabled: false,
        onChange: null,
      );
      expect(c.activeIndex, 1);
    });

    test('notifica ouvintes ao abrir, buscar e selecionar', () {
      final c = make();
      var n = 0;
      c.addListener(() => n++);
      c.openDropdown();
      c.toggleOption(_opts[0]);
      c.closeDropdown();
      expect(n, 3);
    });
  });

  group('teclado (handleListKey)', () {
    test('setas movem e param nas pontas; Enter e Espaco marcam o ativo', () {
      final changes = <List<Object>>[];
      final c = make(onChange: changes.add);
      c.openDropdown();
      expect(
        c.handleListKey(down(LogicalKeyboardKey.arrowDown)),
        KeyEventResult.handled,
      );
      expect(c.activeIndex, 1);
      c.handleListKey(down(LogicalKeyboardKey.arrowDown));
      c.handleListKey(down(LogicalKeyboardKey.arrowDown));
      c.handleListKey(down(LogicalKeyboardKey.arrowDown));
      expect(c.activeIndex, 3, reason: 'para no ultimo');
      c.handleListKey(down(LogicalKeyboardKey.arrowUp));
      expect(c.activeIndex, 2);
      expect(
        c.handleListKey(down(LogicalKeyboardKey.enter)),
        KeyEventResult.handled,
      );
      expect(changes.last, ['c']);
      c.handleListKey(down(LogicalKeyboardKey.arrowUp));
      c.handleListKey(down(LogicalKeyboardKey.arrowUp));
      c.handleListKey(down(LogicalKeyboardKey.arrowUp));
      expect(c.activeIndex, 0, reason: 'para no primeiro');
      c.handleListKey(down(LogicalKeyboardKey.space));
      expect(changes.last, ['c', 'a']);
    });

    test(
      'Escape fecha e pede o foco de volta; Tab fecha e deixa o foco seguir',
      () {
        var refocus = 0;
        final c = make();
        c.focusTrigger = () => refocus++;
        c.openDropdown();
        expect(
          c.handleListKey(down(LogicalKeyboardKey.escape)),
          KeyEventResult.handled,
        );
        expect(c.open, isFalse);
        expect(refocus, 1);
        c.openDropdown();
        expect(
          c.handleListKey(down(LogicalKeyboardKey.tab)),
          KeyEventResult.ignored,
        );
        expect(c.open, isFalse);
        expect(refocus, 1);
      },
    );

    test(
      'Enter sem item ativo e teclas soltas nao fazem nada; desabilitado ignora tudo',
      () {
        final changes = <List<Object>>[];
        final c = make(options: const [], onChange: changes.add);
        c.openDropdown();
        expect(
          c.handleListKey(down(LogicalKeyboardKey.enter)),
          KeyEventResult.ignored,
        );
        expect(
          c.handleListKey(down(LogicalKeyboardKey.keyA)),
          KeyEventResult.ignored,
        );
        expect(
          c.handleListKey(
            const KeyUpEvent(
              logicalKey: LogicalKeyboardKey.arrowDown,
              physicalKey: PhysicalKeyboardKey.arrowDown,
              timeStamp: Duration.zero,
            ),
          ),
          KeyEventResult.ignored,
        );
        expect(changes, isEmpty);
        final off = make(disabled: true);
        expect(
          off.handleListKey(down(LogicalKeyboardKey.arrowDown)),
          KeyEventResult.ignored,
        );
      },
    );
  });
}
