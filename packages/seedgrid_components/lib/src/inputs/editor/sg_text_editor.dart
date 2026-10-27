// Porte de SgTextEditor (React: src/inputs/SgTextEditor.tsx, TipTap). Motor nativo: flutter_quill (MIT).
// Mesmas props, valores, padroes e eventos do React (`valueHtml`, `defaultValueHtml`, `onChangeHtml`,
// `cssText`, `onCssTextChange`, `fileName`, `onSave`, `onLoad`, `height`, `placeholder`, `disabled`,
// `borderRadius`, `showCssEditor`, `cssEditorLabel`, `error`, `name`+`control`+`rules`). O conteudo trafega
// como HTML do corpo (o mesmo de `editor.getHTML()`); veja sg_text_editor_html.dart.
// Pegadinhas herdadas do React:
//  - o valor so chega ao formulario/`onChangeHtml` quando o usuario edita; carregar um arquivo HTML
//    (`setContent(.., false)`) e mudar `valueHtml` por fora NAO disparam `onChangeHtml`;
//  - documento vazio vale `<p></p>`: a regra `required` (string nao vazia) passa depois que o usuario
//    digitou e apagou tudo;
//  - o link sem protocolo (`exemplo.com`) e gravado como esta (relativo);
//  - `Salvar`/`Carregar HTML` ficam sempre na barra, mesmo sem `onSave`/`onLoad`.
// Extras Dart (lista fechada, ADR 50): `htmlFilePicker` (substitui o seletor de arquivo padrao).
import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

import '../../buttons/sg_button.dart';
import '../../form/sg_form.dart';
import '../../form/sg_rules.dart';
import '../../generated/enums.g.dart';
import '../../generated/sg_text_editor.g.dart';
import '../../i18n/i18n.dart';
import '../../theme_access.dart';
import '../sg_input_text.dart';
import 'sg_text_editor_commands.dart';
import 'sg_text_editor_html.dart';
import 'sg_text_editor_toolbar.dart';

/// Arquivo gerado por `onSave` (equivale ao `File` do navegador).
class SgTextEditorFile {
  const SgTextEditorFile({
    required this.name,
    required this.mimeType,
    required this.bytes,
  });
  final String name;
  final String mimeType;
  final Uint8List bytes;

  /// Conteudo como texto UTF-8.
  String get text => utf8.decode(bytes);
}

/// `SgTextEditorSaveMeta` do React.
class SgTextEditorSaveMeta {
  const SgTextEditorSaveMeta({
    required this.htmlDocument,
    required this.contentHtml,
    required this.cssText,
  });
  final String htmlDocument;
  final String contentHtml;
  final String cssText;
}

/// Seletor de arquivo HTML (devolve nulo se o usuario cancelar).
typedef SgTextEditorHtmlFilePicker = Future<SgTextEditorFile?> Function();

Future<SgTextEditorFile?> _defaultPicker() async {
  final r = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['html', 'htm'],
    withData: true,
  );
  final f = r?.files.single;
  if (f == null || f.bytes == null) return null;
  return SgTextEditorFile(name: f.name, mimeType: 'text/html', bytes: f.bytes!);
}

class SgTextEditor extends StatefulWidget implements SgTextEditorProps {
  const SgTextEditor({
    super.key,
    required this.id,
    this.borderRadius,
    this.control,
    this.cssEditorLabel,
    this.cssText = '',
    this.defaultValueHtml,
    this.disabled,
    this.error,
    this.fileName,
    this.height = 320,
    this.name,
    this.onChangeHtml,
    this.onCssTextChange,
    this.onLoad,
    this.onSave,
    this.placeholder,
    this.rules,
    this.showCssEditor = false,
    this.valueHtml,
    this.htmlFilePicker,
  });

  @override
  final String id;

  /// Numero (px) ou texto CSS em `px`/`rem`. Padrao: 8 (rounded-lg).
  @override
  final Object? borderRadius;
  @override
  final SgFormController? control;
  @override
  final String? cssEditorLabel;
  @override
  final String? cssText;
  @override
  final String? defaultValueHtml;
  @override
  final bool? disabled;
  @override
  final String? error;
  @override
  final String? fileName;
  @override
  final num? height;
  @override
  final String? name;

  /// Recebe o HTML do corpo (`editor.getHTML()`) a cada edicao do usuario.
  @override
  final ValueChanged<String>? onChangeHtml;
  @override
  final ValueChanged<String>? onCssTextChange;
  @override
  final ValueChanged<SgTextEditorSaveMeta>? onLoad;
  @override
  final void Function(SgTextEditorFile file, SgTextEditorSaveMeta meta)? onSave;
  @override
  final String? placeholder;
  @override
  final SgRules? rules;
  @override
  final bool? showCssEditor;
  @override
  final String? valueHtml;

  /// Dart: seletor do botao "Carregar HTML" (padrao: seletor de arquivos do sistema).
  final SgTextEditorHtmlFilePicker? htmlFilePicker;

  @override
  State<SgTextEditor> createState() => _SgTextEditorState();
}

class _SgTextEditorState extends State<SgTextEditor> {
  late final QuillController _c = QuillController(
    document: Document.fromDelta(SgTextEditorHtml.toDelta(_initialHtml())),
    selection: const TextSelection.collapsed(offset: 0),
    readOnly: widget.disabled ?? false,
  );
  final FocusNode _focus = FocusNode();
  final ScrollController _scroll = ScrollController();
  late final TextEditingController _css = TextEditingController(
    text: widget.cssText ?? '',
  );
  StreamSubscription<DocChange>? _sub;
  SgFormController? _form;

  bool get _bound => widget.name != null && _form != null;

  String _initialHtml() {
    final v = widget.valueHtml;
    if (v != null) return v;
    return widget.defaultValueHtml ?? '';
  }

  String get _html => SgTextEditorHtml.fromDelta(_c.document.toDelta());

  @override
  void initState() {
    super.initState();
    _focus.canRequestFocus = !(widget.disabled ?? false);
    _sub = _c.document.changes.listen(_onDocChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final f = widget.control ?? SgForm.maybeOf(context);
    if (f != _form) {
      _form?.removeListener(_syncFromForm);
      _form = f;
      _form?.addListener(_syncFromForm);
    }
    _register();
  }

  void _register() {
    if (!_bound) return;
    _form!.registerField(widget.name!, rules: widget.rules);
    _syncFromForm();
  }

  /// Valor controlado: do formulario quando ligado, senao `valueHtml`.
  String? get _controlled {
    if (_bound) {
      final v = _form!.getValue(widget.name!);
      return v is String ? v : null;
    }
    return widget.valueHtml;
  }

  /// Ja houve valor vindo do formulario (string)? Se ele some (reset sem padrao, setValue(null)), o editor limpa
  /// em vez de ficar com o texto antigo (o React deixaria o ultimo texto, pois passa `undefined`).
  bool _hadFormValue = false;

  void _syncFromForm() {
    final v = _controlled;
    if (v != null && v != _html) _setContent(v);
    if (v == null && _bound && _hadFormValue) _setContent('');
    if (_bound) _hadFormValue = v != null;
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(SgTextEditor old) {
    super.didUpdateWidget(old);
    _c.readOnly = widget.disabled ?? false;
    _focus.canRequestFocus = !(widget.disabled ?? false);
    if (old.valueHtml != widget.valueHtml && !_bound) {
      final v = widget.valueHtml;
      if (v != null && v != _html) _setContent(v);
      // `valueHtml` voltou a nulo: o pai limpou o campo.
      if (v == null && old.valueHtml != null) _setContent('');
    }
    if (old.cssText != widget.cssText && (widget.cssText ?? '') != _css.text) {
      _css.text = widget.cssText ?? '';
    }
    _register();
  }

  @override
  void dispose() {
    _form?.removeListener(_syncFromForm);
    _sub?.cancel();
    _c.dispose();
    _focus.dispose();
    _scroll.dispose();
    _css.dispose();
    super.dispose();
  }

  /// `editor.commands.setContent(html, false)`: troca o conteudo sem emitir `onChangeHtml`.
  void _setContent(String html) {
    _sub?.cancel();
    _c.document = Document.fromDelta(SgTextEditorHtml.toDelta(html));
    _sub = _c.document.changes.listen(_onDocChange);
  }

  void _onDocChange(DocChange change) {
    if (change.source != ChangeSource.local) return;
    final html = _html;
    widget.onChangeHtml?.call(html);
    if (_bound) {
      final revalidate =
          _form!.errorOf(widget.name!) != null || _form!.submitCount > 0;
      _form!.setValue(widget.name!, html, shouldValidate: revalidate);
    }
  }

  // ---- acoes da barra
  Widget _shell(String title, Widget content, List<Widget> actions) => Dialog(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            content,
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  actions[i],
                ],
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Future<String?> _prompt(String title, String initial) {
    final i18n = useComponentsI18n(context);
    var value = initial;
    return showDialog<String>(
      context: context,
      builder: (ctx) => _shell(
        title,
        SgInputText(
          id: 'texteditor-${widget.id}-prompt',
          labelText: title,
          initialValue: initial,
          autofocus: true,
          onChange: (v) => value = v,
        ),
        [
          SgButton(
            key: ValueKey('texteditor-${widget.id}-prompt-cancel'),
            severity: SgSeverity.secondary,
            appearance: SgAppearance.outline,
            label: Text(t(i18n, 'components.actions.cancel')),
            onClick: () => Navigator.of(ctx).pop(),
          ),
          SgButton(
            key: ValueKey('texteditor-${widget.id}-prompt-ok'),
            label: Text(t(i18n, 'components.actions.confirm')),
            onClick: () => Navigator.of(ctx).pop(value),
          ),
        ],
      ),
    );
  }

  Future<void> _link() async {
    final i18n = useComponentsI18n(context);
    final prev = SgTextEditorCommands.linkHref(_c);
    final url = await _prompt(
      t(i18n, 'components.textEditor.prompt.url'),
      prev ?? 'https://',
    );
    if (!mounted || url == null) return;
    if (url.isEmpty) {
      SgTextEditorCommands.unsetLink(_c);
    } else {
      SgTextEditorCommands.setLink(_c, url);
    }
    _focus.requestFocus();
  }

  Future<void> _image() async {
    final i18n = useComponentsI18n(context);
    final src = await _prompt(
      t(i18n, 'components.textEditor.prompt.imageUrl'),
      '',
    );
    if (!mounted || src == null || src.isEmpty) return;
    SgTextEditorCommands.insertImage(_c, src);
    _focus.requestFocus();
  }

  static const _palette = [
    '#000000', '#434343', '#666666', '#999999', '#cccccc', '#ffffff', //
    '#ff0000', '#ff9900', '#ffff00', '#00ff00', '#00ffff', '#0000ff',
    '#9900ff', '#ff00ff', '#e6b8af', '#fce5cd', '#d9ead3', '#cfe2f3',
  ];

  Future<void> _pickColor(bool highlight) async {
    final i18n = useComponentsI18n(context);
    final title = t(
      i18n,
      highlight
          ? 'components.textEditor.toolbar.highlightColor'
          : 'components.textEditor.toolbar.textColor',
    );
    var hex = '';
    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) => _shell(
        title,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in _palette)
                  Semantics(
                    button: true,
                    label: c,
                    child: InkWell(
                      key: ValueKey(
                        'texteditor-${widget.id}-swatch-${c.substring(1)}',
                      ),
                      onTap: () => Navigator.of(ctx).pop(c),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse('ff${c.substring(1)}', radix: 16),
                          ),
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SgInputText(
              id: 'texteditor-${widget.id}-hex',
              labelText: '#rrggbb',
              initialValue: '',
              onChange: (v) => hex = v,
            ),
          ],
        ),
        [
          SgButton(
            key: ValueKey('texteditor-${widget.id}-color-cancel'),
            severity: SgSeverity.secondary,
            appearance: SgAppearance.outline,
            label: Text(t(i18n, 'components.actions.cancel')),
            onClick: () => Navigator.of(ctx).pop(),
          ),
          SgButton(
            key: ValueKey('texteditor-${widget.id}-color-ok'),
            label: Text(t(i18n, 'components.actions.confirm')),
            onClick: () => Navigator.of(ctx).pop(hex),
          ),
        ],
      ),
    );
    if (!mounted || picked == null) return;
    final color = sgCssColorToHex(picked.startsWith('#') ? picked : '#$picked');
    if (color == null) return;
    if (highlight) {
      SgTextEditorCommands.toggleHighlight(_c, color);
    } else {
      SgTextEditorCommands.setColor(_c, color);
    }
    _focus.requestFocus();
  }

  void _save() {
    final i18n = useComponentsI18n(context);
    final content = _html;
    final css = _css.text.isNotEmpty || (widget.cssText ?? '').isEmpty
        ? _css.text
        : widget.cssText ?? '';
    final doc = SgTextEditorHtml.buildDocument(content, css, i18n.locale);
    final file = SgTextEditorFile(
      name: widget.fileName ?? '${widget.id}.html',
      mimeType: 'text/html;charset=utf-8',
      bytes: Uint8List.fromList(utf8.encode(doc)),
    );
    widget.onSave?.call(
      file,
      SgTextEditorSaveMeta(
        htmlDocument: doc,
        contentHtml: content,
        cssText: css,
      ),
    );
  }

  Future<void> _load() async {
    final file = await (widget.htmlFilePicker ?? _defaultPicker)();
    if (!mounted || file == null) return;
    loadFromHtmlString(file.text);
  }

  /// `loadFromHtmlString` do React: separa `<style>` do `<head>` e o corpo.
  @visibleForTesting
  void loadFromHtmlString(String htmlDoc) {
    final parsed = SgTextEditorHtml.parseDocument(htmlDoc);
    if (parsed.cssText.isNotEmpty && parsed.cssText != (widget.cssText ?? '')) {
      widget.onCssTextChange?.call(parsed.cssText);
      _css.text = parsed.cssText;
    }
    _setContent(parsed.bodyHtml);
    widget.onLoad?.call(
      SgTextEditorSaveMeta(
        htmlDocument: htmlDoc,
        contentHtml: parsed.bodyHtml,
        cssText: parsed.cssText,
      ),
    );
  }

  // ---- visual
  double _radius() {
    final r = widget.borderRadius;
    if (r is num) return r.toDouble();
    if (r is String) {
      final m = RegExp(
        r'^\s*([0-9]*\.?[0-9]+)\s*(px|rem|em)?\s*$',
      ).firstMatch(r);
      if (m != null) {
        final n = double.parse(m.group(1)!);
        return m.group(2) == 'rem' || m.group(2) == 'em' ? n * 16 : n;
      }
    }
    return 8;
  }

  DefaultStyles _styles(SgTheme theme) {
    TextStyle base(double size, [FontWeight? w]) => TextStyle(
      fontSize: size,
      height: 1.5,
      color: theme.inputFg,
      fontWeight: w,
    );
    DefaultTextBlockStyle block(
      TextStyle s, [
      double top = 0,
      double bottom = 8,
    ]) => DefaultTextBlockStyle(
      s,
      HorizontalSpacing.zero,
      VerticalSpacing(top, bottom),
      VerticalSpacing.zero,
      null,
    );
    return DefaultStyles(
      paragraph: block(base(16), 0, 8),
      h1: block(base(32, FontWeight.bold).copyWith(height: 1.2), 8, 8),
      h2: block(base(24, FontWeight.bold).copyWith(height: 1.25), 8, 8),
      h3: block(base(19, FontWeight.bold).copyWith(height: 1.3), 8, 6),
      h4: block(base(16, FontWeight.bold), 6, 6),
      h5: block(base(14, FontWeight.bold), 6, 6),
      h6: block(base(13, FontWeight.bold), 6, 6),
      link: TextStyle(
        color: theme.primary600,
        decoration: TextDecoration.underline,
      ),
      placeHolder: block(
        base(16).copyWith(color: theme.inputPlaceholder),
        0,
        0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = sgThemeOf(context);
    final i18n = useComponentsI18n(context);
    final disabled = widget.disabled ?? false;
    final radius = _radius();
    final formError = _bound ? _form!.errorOf(widget.name!)?.message : null;
    final error = resolveFieldError(widget.error, formError);
    final placeholder =
        widget.placeholder ?? t(i18n, 'components.textEditor.placeholder');
    final height = (widget.height ?? 320).toDouble();

    final editor = Opacity(
      opacity: disabled ? 0.6 : 1,
      child: Semantics(
        label: t(i18n, 'components.textEditor.editorAriaLabel'),
        textField: true,
        multiline: true,
        readOnly: disabled,
        child: QuillEditor(
          key: ValueKey('texteditor-${widget.id}'),
          controller: _c,
          focusNode: _focus,
          scrollController: _scroll,
          config: QuillEditorConfig(
            placeholder: placeholder,
            padding: const EdgeInsets.all(12),
            expands: true,
            scrollable: true,
            customStyles: _styles(theme),
            embedBuilders: const [_ImageEmbedBuilder(), _HrEmbedBuilder()],
            customLeadingBlockBuilder: _orderedStartLeading,
            customShortcuts: const {
              SingleActivator(LogicalKeyboardKey.enter, shift: true):
                  _SoftBreakIntent(),
            },
            customActions: {_SoftBreakIntent: _SoftBreakAction(_c)},
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SgTextEditorToolbar(
          id: widget.id,
          controller: _c,
          disabled: disabled,
          radius: radius,
          onPickColor: _pickColor,
          onLink: _link,
          onImage: _image,
          onSave: _save,
          onLoad: _load,
        ),
        Container(
          key: ValueKey('texteditor-box-${widget.id}'),
          height: height,
          decoration: BoxDecoration(
            color: theme.inputBg,
            border: Border.all(
              color: error != null ? theme.error500 : theme.inputBorder,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(radius),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: editor,
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              error,
              key: ValueKey('texteditor-error-${widget.id}'),
              style: TextStyle(fontSize: 12, color: theme.error500),
            ),
          ),
        if (widget.showCssEditor ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cssEditorLabel ??
                      t(i18n, 'components.textEditor.cssEditorLabel'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.text,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  key: ValueKey('texteditor-css-${widget.id}'),
                  controller: _css,
                  minLines: 8,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: theme.inputFg,
                  ),
                  onChanged: (v) => widget.onCssTextChange?.call(v),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: theme.inputBg,
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius),
                      borderSide: BorderSide(color: theme.inputBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius),
                      borderSide: BorderSide(color: theme.inputBorder),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t(i18n, 'components.textEditor.help.cssEmbedded'),
                  style: TextStyle(fontSize: 12, color: theme.muted),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Shift+Enter = quebra de linha suave (`<br>`), como o hardBreak do TipTap.
class _SoftBreakIntent extends Intent {
  const _SoftBreakIntent();
}

class _SoftBreakAction extends Action<_SoftBreakIntent> {
  _SoftBreakAction(this.c);
  final QuillController c;

  @override
  Object? invoke(_SoftBreakIntent intent) {
    final s = c.selection;
    c.replaceText(
      s.start,
      s.end - s.start,
      sgSoftBreak,
      TextSelection.collapsed(offset: s.start + 1),
    );
    return null;
  }
}

/// Numero das listas ordenadas que comecam depois de 1 (`<ol start="3">`): o flutter_quill sempre conta a partir de 1.
/// O inicio fica no atributo `sg-start` da primeira linha da lista; so o primeiro nivel e ajustado (devolver nulo usa o
/// desenho padrao).
Widget? _orderedStartLeading(Node node, LeadingConfig config) {
  if (config.attribute != Attribute.ol) return null;
  if (config.attrs.containsKey(Attribute.indent.key)) return null;
  final parent = node.parent;
  final first = parent is Block && parent.childCount > 0 ? parent.first : null;
  final start = first is Line
      ? first.style.attributes['sg-start']?.value
      : null;
  if (start is! int || start == 1) return null;
  final n = int.tryParse(config.getIndexNumberByIndent ?? '');
  if (n == null) return null;
  return QuillNumberPoint(
    index: '${n + start - 1}',
    indentLevelCounts: config.indentLevelCounts,
    count: config.count,
    style: config.style!,
    attrs: config.attrs,
    width: config.width!,
    padding: config.padding!,
  );
}

class _ImageEmbedBuilder extends EmbedBuilder {
  const _ImageEmbedBuilder();

  @override
  String get key => sgImageEmbed;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final raw = embedContext.node.value.data;
    String src = '', alt = '';
    try {
      final m = jsonDecode('$raw') as Map;
      src = '${m['src'] ?? ''}';
      alt = '${m['alt'] ?? ''}';
    } catch (_) {}
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        image: true,
        label: alt,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Image.network(
            src,
            fit: BoxFit.contain,
            errorBuilder: (_, e, s) => Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.broken_image_outlined, size: 18),
                  const SizedBox(width: 6),
                  Flexible(child: Text(alt.isEmpty ? src : alt)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HrEmbedBuilder extends EmbedBuilder {
  const _HrEmbedBuilder();

  @override
  String get key => sgHrEmbed;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) =>
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Divider(height: 1, thickness: 1),
      );
}
