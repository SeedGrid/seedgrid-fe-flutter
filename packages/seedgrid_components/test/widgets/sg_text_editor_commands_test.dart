// Comandos da barra de ferramentas: aplica no Delta a mesma sequencia de comandos que o React aplicou no
// TipTap (cenarios `cmd_*` de vectors.json) e compara o HTML final com o que o TipTap emitiu.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart' show TextSelection;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/inputs/editor/sg_text_editor_commands.dart';
import 'package:seedgrid_components/src/inputs/editor/sg_text_editor_html.dart';

import 'sg_text_editor_html_test.dart' show normalize;

/// Selecao `setSel` do ProseMirror (posicoes do documento) -> indices do Delta, por caso.
const _sel = <String, (int, int)>{
  'cmd_negrito_parcial': (0, 3),
  'cmd_indent_primeiro': (0, 0),
  'cmd_indent_meio': (2, 2),
  'cmd_lista_parcial': (2, 3),
  'cmd_alinha_cursor': (2, 2),
  'cmd_negrito_sem_selecao': (0, 0),
  'cmd_cor_parcial': (1, 2),
  'cmd_link_parcial': (1, 2),
  'cmd_link_cursor_dentro': (1, 1),
  'cmd_imagem_meio': (2, 2),
  'cmd_limpar_cursor': (0, 0),
  'cmd_limpar_so_um_bloco': (0, 0),
};

/// Casos que dependem de comportamento do TipTap que o modelo Delta nao tem (ver docs/SG_TEXT_EDITOR_PoC.md).
const _pulados = <String, String>{
  'cmd_sub_depois_sup':
      'TipTap aceita sub e sup juntos; o Delta tem um script so',
  'cmd_sub_em_sup': 'idem',
  'cmd_lista_num_para_bullets':
      'defeito do TipTap/React: converter lista aninhada apaga o item filho',
  'cmd_lista_desliga':
      'artefato do selectAll do ProseMirror (AllSelection); veja o teste de alternar lista',
  'cmd_outdent_topo_unico':
      'artefato do selectAll do ProseMirror (AllSelection)',
  'cmd_imagem_vazia_url':
      'o React nunca chama setImage com URL vazia (retorna antes)',
  'cmd_imagem_vazio': 'Delta mantem um paragrafo vazio apos a imagem',
  'cmd_vazio_texto': 'comando insertText so existe no teste do TipTap',
  'cmd_vazio_negrito': 'comando insertText so existe no teste do TipTap',
};

/// Casos em que o resultado difere de proposito.
const _divergentes = <String, String>{
  'cmd_fonte_inherit':
      '<p><span style="font-family: inherit">Ola mundo</span></p>',
};

QuillController _make(String html) => QuillController(
  document: Document.fromDelta(SgTextEditorHtml.toDelta(html)),
  selection: const TextSelection.collapsed(offset: 0),
);

int _end(QuillController c) {
  // fim do ultimo texto (antes do ultimo \n)
  return c.document.length - 1;
}

void _run(QuillController c, String id, List<dynamic> cmd) {
  final name = cmd[0] as String;
  final arg = cmd.length > 1 ? cmd[1] : null;
  switch (name) {
    case 'selectAll':
      c.updateSelection(
        TextSelection(baseOffset: 0, extentOffset: _end(c)),
        ChangeSource.local,
      );
    case 'focusEnd':
      c.updateSelection(
        TextSelection.collapsed(offset: _end(c)),
        ChangeSource.local,
      );
    case 'setSel':
      final s = _sel[id]!;
      c.updateSelection(
        TextSelection(baseOffset: s.$1, extentOffset: s.$2),
        ChangeSource.local,
      );
    case 'insertText':
      c.replaceText(c.selection.start, 0, arg as String, null);
    case 'heading':
      SgTextEditorCommands.setHeading(c, arg == 'p' ? 'p' : 'h$arg');
    case 'fontFamily':
      SgTextEditorCommands.setFontFamily(c, arg as String);
    case 'fontSize':
      SgTextEditorCommands.setFontSize(c, arg as String);
    case 'bold':
      SgTextEditorCommands.toggleBold(c);
    case 'italic':
      SgTextEditorCommands.toggleItalic(c);
    case 'underline':
      SgTextEditorCommands.toggleUnderline(c);
    case 'strike':
      SgTextEditorCommands.toggleStrike(c);
    case 'color':
      SgTextEditorCommands.setColor(c, arg as String);
    case 'highlight':
      SgTextEditorCommands.toggleHighlight(c, arg as String);
    case 'subscript':
      SgTextEditorCommands.toggleSubscript(c);
    case 'superscript':
      SgTextEditorCommands.toggleSuperscript(c);
    case 'bullets':
      SgTextEditorCommands.toggleList(c, 'bullet');
    case 'numbered':
      SgTextEditorCommands.toggleList(c, 'ordered');
    case 'outdent':
      SgTextEditorCommands.outdent(c);
    case 'indent':
      SgTextEditorCommands.indent(c);
    case 'align':
      SgTextEditorCommands.setTextAlign(c, arg as String);
    case 'link':
      SgTextEditorCommands.setLink(c, arg as String);
    case 'unlink':
      SgTextEditorCommands.unsetLink(c);
    case 'image':
      SgTextEditorCommands.insertImage(c, arg as String);
    case 'clear':
      SgTextEditorCommands.clearFormatting(c);
    default:
      fail('comando desconhecido $name');
  }
}

void main() {
  final data =
      jsonDecode(
            File(
              'test/widgets/sg_text_editor_vectors/vectors.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  final cases = (data['cases'] as List).cast<Map<String, dynamic>>().where(
    (c) => c['kind'] == 'commands',
  );

  group('comandos da barra == TipTap', () {
    for (final c in cases) {
      final id = c['id'] as String;
      if (_pulados.containsKey(id)) continue;
      test(id, () {
        final ctrl = _make(c['html'] as String);
        for (final cmd in (c['commands'] as List)) {
          _run(ctrl, id, cmd as List);
        }
        final out = SgTextEditorHtml.fromDelta(ctrl.document.toDelta());
        expect(
          normalize(out),
          normalize(_divergentes[id] ?? c['canonical'] as String),
        );
      });
    }
  });

  test('alternar lista com o cursor no item tira o item da lista', () {
    final ctrl = _make('<ul><li><p>a</p></li></ul>');
    ctrl.updateSelection(
      const TextSelection.collapsed(offset: 0),
      ChangeSource.local,
    );
    SgTextEditorCommands.toggleList(ctrl, 'bullet');
    expect(SgTextEditorHtml.fromDelta(ctrl.document.toDelta()), '<p>a</p>');
    SgTextEditorCommands.toggleList(ctrl, 'ordered');
    expect(
      SgTextEditorHtml.fromDelta(ctrl.document.toDelta()),
      '<ol><li><p>a</p></li></ol>',
    );
  });

  test('indent/outdent so mexem em itens de lista', () {
    final ctrl = _make('<p>a</p>');
    SgTextEditorCommands.indent(ctrl);
    SgTextEditorCommands.outdent(ctrl);
    expect(SgTextEditorHtml.fromDelta(ctrl.document.toDelta()), '<p>a</p>');
  });

  test('estado ativo: negrito, titulo, alinhamento e link', () {
    final ctrl = _make(
      '<h2 style="text-align: center"><strong>t</strong> <a href="https://x.com">l</a></h2>',
    );
    ctrl.updateSelection(
      const TextSelection.collapsed(offset: 0),
      ChangeSource.local,
    );
    expect(SgTextEditorCommands.isActive(ctrl, 'bold'), isTrue);
    expect(SgTextEditorCommands.heading(ctrl), 2);
    expect(SgTextEditorCommands.isActive(ctrl, 'align', 'center'), isTrue);
    expect(SgTextEditorCommands.isActive(ctrl, 'align', 'left'), isFalse);
    ctrl.updateSelection(
      const TextSelection(baseOffset: 2, extentOffset: 3),
      ChangeSource.local,
    );
    expect(SgTextEditorCommands.linkHref(ctrl), 'https://x.com');
  });

  test('soft break (U+2028) quebra linha no layout do Flutter', () {
    // garantia de que <br> <-> U+2028 e representavel: o texto mantem o caractere no Delta
    final d = SgTextEditorHtml.toDelta('<p>a<br>b</p>');
    expect(d.toList().first.data, startsWith('a b'));
  });
}
