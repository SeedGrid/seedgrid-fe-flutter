// Layout de pagina de componente do showcase (convencao do AGENTS.md do front React):
//   1. cabecalho fixo: nome, descricao, 1 link por exemplo (#exemplo-N) e link para #props-reference;
//   2. exemplos numerados, cada um com o codigo exibido igual ao renderizado;
//   3. playground de props;
//   4. "Referencia de Props" (Prop | Tipo | Padrao | Descricao).
//
// Rolagem no container do conteudo (nunca no corpo da pagina): o cabecalho fica FORA da area que
// rola, entao nenhum exemplo vaza por tras dele. O alvo da ancora e calculado pela posicao real
// renderizada do titulo, com respiro minimo de [kAnchorGap], e ha correcao depois da rolagem.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:seedgrid_components/seedgrid_components.dart';
import 'showcase_i18n.dart';

/// Respiro minimo, em pixels, entre a borda superior da area de conteudo e o titulo da secao.
const double kAnchorGap = 12;

/// Local atual do showcase (pagina e ancora), fornecido por quem guarda a URL. A pagina le a
/// ancora inicial daqui (ao abrir a URL com #exemplo-3) e avisa [onAnchorChanged] quando o usuario toca num link.
class ShowcaseLocation extends InheritedWidget {
  const ShowcaseLocation({
    super.key,
    required this.anchor,
    required this.onAnchorChanged,
    required super.child,
  });

  /// Id da ancora da URL (exemplo-3, playground ou props-reference) ou nulo.
  final String? anchor;
  final ValueChanged<String> onAnchorChanged;

  static ShowcaseLocation? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ShowcaseLocation>();

  @override
  bool updateShouldNotify(ShowcaseLocation old) => old.anchor != anchor;
}

/// Um exemplo de componente. [code] deve vir de `Snippets` (extraido do mesmo fonte de [preview]).
class ShowcaseExample {
  const ShowcaseExample({
    required this.title,
    required this.preview,
    required this.code,
    this.description,
  });

  final String title;
  final String? description;
  final Widget preview;
  final String code;
}

class SgShowcasePage extends StatefulWidget {
  const SgShowcasePage({
    super.key,
    required this.name,
    required this.description,
    required this.examples,
    required this.propSpecs,
    this.playground,
  });

  final String name;
  final String description;
  final List<ShowcaseExample> examples;
  final List<SgPropSpec> propSpecs;
  final Widget? playground;

  @override
  State<SgShowcasePage> createState() => SgShowcasePageState();
}

class SgShowcasePageState extends State<SgShowcasePage> {
  final ScrollController _scroll = ScrollController();
  final GlobalKey _contentKey = GlobalKey(debugLabel: 'conteudo');
  final GlobalKey _headerKey = GlobalKey(debugLabel: 'cabecalho');
  late final List<GlobalKey> _exampleKeys = List.generate(
    widget.examples.length,
    (i) => GlobalKey(debugLabel: 'exemplo-${i + 1}'),
  );
  final GlobalKey _playgroundKey = GlobalKey(debugLabel: 'playground');
  final GlobalKey _propsKey = GlobalKey(debugLabel: 'props-reference');

  /// Altura real do bloco do cabecalho (container externo + paddings).
  double get headerHeight =>
      (_headerKey.currentContext?.findRenderObject() as RenderBox?)
          ?.size
          .height ??
      0;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  double? _titleTop(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final viewport =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || viewport == null) return null;
    return box.localToGlobal(Offset.zero, ancestor: viewport).dy;
  }

  /// Rola ate o titulo da secao ficar visivel com [kAnchorGap] de respiro, ja no primeiro toque.
  Future<void> scrollToKey(GlobalKey key, {bool animate = true}) async {
    final top = _titleTop(key);
    if (top == null || !_scroll.hasClients) return;
    final target = (_scroll.offset + top - kAnchorGap).clamp(
      0.0,
      _scroll.position.maxScrollExtent,
    );
    if (animate) {
      await _scroll.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _scroll.jumpTo(target);
    }
    // Correcao pos-rolagem pela posicao real renderizada do titulo.
    await WidgetsBinding.instance.endOfFrame;
    final after = _titleTop(key);
    if (after != null && after < kAnchorGap - 0.5 && _scroll.hasClients) {
      _scroll.jumpTo(
        (_scroll.offset + after - kAnchorGap).clamp(
          0.0,
          _scroll.position.maxScrollExtent,
        ),
      );
    }
  }

  Future<void> scrollToExample(int number) =>
      scrollToKey(_exampleKeys[number - 1]);
  Future<void> scrollToProps() => scrollToKey(_propsKey);

  /// Chave da secao pelo id da ancora (`exemplo-N`, `playground`, `props-reference`), ou nulo.
  GlobalKey? _keyForAnchor(String id) {
    if (id == 'props-reference') return _propsKey;
    if (id == 'playground') {
      return widget.playground == null ? null : _playgroundKey;
    }
    final m = RegExp(r'^exemplo-(\d+)$').firstMatch(id);
    if (m == null) return null;
    final n = int.parse(m.group(1)!);
    return n >= 1 && n <= _exampleKeys.length ? _exampleKeys[n - 1] : null;
  }

  /// Rola ate a ancora pelo id (usado ao abrir a pagina com `#exemplo-3` na URL).
  Future<void> scrollToAnchor(String id, {bool animate = true}) async {
    final key = _keyForAnchor(id);
    if (key != null) await scrollToKey(key, animate: animate);
  }

  /// Toque num link do cabecalho: rola e avisa quem guarda a URL (`ShowcaseLocation`).
  Future<void> _go(String id) async {
    ShowcaseLocation.maybeOf(context)?.onAnchorChanged(id);
    await scrollToAnchor(id);
  }

  bool _initialAnchorDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final anchor = ShowcaseLocation.maybeOf(context)?.anchor;
    if (_initialAnchorDone || anchor == null) return;
    _initialAnchorDone = true;
    // Depois do primeiro quadro (o conteudo ja tem tamanho) e sem animacao, para abrir ja no lugar.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) await scrollToAnchor(anchor, animate: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final links = <Widget>[
      for (var i = 0; i < widget.examples.length; i++)
        _AnchorLink(
          key: ValueKey('link-exemplo-${i + 1}'),
          label: '${context.tr('example')} ${i + 1}',
          onTap: () => _go('exemplo-${i + 1}'),
        ),
      if (widget.playground != null)
        _AnchorLink(
          key: const ValueKey('link-playground'),
          label: context.tr('playground'),
          onTap: () => _go('playground'),
        ),
      _AnchorLink(
        key: const ValueKey('link-props-reference'),
        label: context.tr('propsReference'),
        onTap: () => _go('props-reference'),
      ),
    ];

    return Column(
      children: [
        // Cabecalho fixo e opaco, fora da area que rola.
        Material(
          key: _headerKey,
          color: theme.colorScheme.surface,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.name, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(widget.description, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final l in links)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: l,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            key: _contentKey,
            builder: (context, constraints) => SingleChildScrollView(
              key: const ValueKey('conteudo-rolavel'),
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, kAnchorGap, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < widget.examples.length; i++)
                    _ExampleSection(
                      anchorKey: _exampleKeys[i],
                      id: 'exemplo-${i + 1}',
                      number: i + 1,
                      example: widget.examples[i],
                    ),
                  if (widget.playground != null) ...[
                    _SectionTitle(
                      key: _playgroundKey,
                      id: 'playground',
                      text: context.tr('playground'),
                    ),
                    widget.playground!,
                    const SizedBox(height: 32),
                  ],
                  _SectionTitle(
                    key: _propsKey,
                    id: 'props-reference',
                    text: context.tr('propsTitle'),
                  ),
                  SgPropsTable(specs: widget.propSpecs),
                  // Espaco final para a ultima secao poder chegar ao topo.
                  SizedBox(height: constraints.maxHeight),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnchorLink extends StatelessWidget {
  const _AnchorLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ActionChip(
    label: Text(label),
    onPressed: onTap,
    visualDensity: VisualDensity.compact,
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({super.key, required this.id, required this.text});

  final String id;
  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    identifier: id,
    header: true,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}

class _ExampleSection extends StatelessWidget {
  const _ExampleSection({
    required this.anchorKey,
    required this.id,
    required this.number,
    required this.example,
  });

  final GlobalKey anchorKey;
  final String id;
  final int number;
  final ShowcaseExample example;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            key: anchorKey,
            id: id,
            text: '${context.tr('example')} $number — ${example.title}',
          ),
          if (example.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(example.description!),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: example.preview,
          ),
          const SizedBox(height: 8),
          SgCodeBlock(code: example.code),
        ],
      ),
    );
  }
}

/// Bloco de codigo selecionavel. O texto vem de `Snippets` (extraido do fonte do exemplo renderizado).
class SgCodeBlock extends StatelessWidget {
  const SgCodeBlock({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('codigo-exemplo'),
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SelectableText(
        code,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      ),
    ),
  );
}

/// "Referencia de Props": todas as props publicas, geradas do React.
class SgPropsTable extends StatelessWidget {
  const SgPropsTable({super.key, required this.specs});

  final List<SgPropSpec> specs;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(context.tr('colProp'))),
          DataColumn(label: Text(context.tr('colType'))),
          DataColumn(label: Text(context.tr('colDefault'))),
          DataColumn(label: Text(context.tr('colDescription'))),
        ],
        rows: [
          for (final s in specs)
            DataRow(
              cells: [
                DataCell(Text(s.name)),
                DataCell(
                  Text(s.values != null ? s.values!.join(' | ') : s.type),
                ),
                DataCell(Text(s.defaultValue ?? '-')),
                DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Text(s.description ?? '-'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

typedef PlaygroundBuilder =
    Widget Function(BuildContext context, Map<String, Object?> values);
typedef PlaygroundCode = String Function(Map<String, Object?> values);

/// Playground de props gerado das especificacoes: enum vira lista, bool vira chave, String vira campo.
/// Props de tipo sem traducao exata (`exact: false`) nao sao editaveis e aparecem listadas.
class SgPlayground extends StatefulWidget {
  const SgPlayground({
    super.key,
    required this.specs,
    required this.builder,
    required this.codeBuilder,
  });

  final List<SgPropSpec> specs;
  final PlaygroundBuilder builder;
  final PlaygroundCode codeBuilder;

  @override
  State<SgPlayground> createState() => _SgPlaygroundState();
}

class _SgPlaygroundState extends State<SgPlayground> {
  final Map<String, Object?> _values = {};

  bool _editable(SgPropSpec s) =>
      s.values != null ||
      (s.exact &&
          (s.type.startsWith('bool') ||
              s.type.startsWith('num') ||
              s.type.startsWith('String')));

  @override
  Widget build(BuildContext context) {
    final editable = widget.specs.where(_editable).toList();
    final skipped = widget.specs
        .where((s) => !_editable(s))
        .map((s) => s.name)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            for (final s in editable) SizedBox(width: 220, child: _control(s)),
          ],
        ),
        if (skipped.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${context.tr('notEditable')}: ${skipped.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.builder(context, Map.unmodifiable(_values)),
        ),
        const SizedBox(height: 8),
        SgCodeBlock(code: widget.codeBuilder(Map.unmodifiable(_values))),
      ],
    );
  }

  /// Texto -> `num?`: vazio ou incompleto ('-', '.') = null; sem ponto = int.
  static num? _parseNum(String text) {
    final t = text.trim();
    if (t.isEmpty) return null;
    return int.tryParse(t) ?? double.tryParse(t);
  }

  Widget _control(SgPropSpec s) {
    if (s.values != null) {
      return DropdownButtonFormField<String?>(
        key: ValueKey('pg-${s.name}'),
        isExpanded: true,
        initialValue: _values[s.name] as String?,
        decoration: InputDecoration(labelText: s.name, isDense: true),
        items: [
          DropdownMenuItem<String?>(
            value: null,
            child: Text(context.tr('default')),
          ),
          for (final v in s.values!)
            DropdownMenuItem<String?>(value: v, child: Text(v)),
        ],
        onChanged: (v) => setState(() => _values[s.name] = v),
      );
    }
    if (s.type.startsWith('bool')) {
      return SwitchListTile(
        key: ValueKey('pg-${s.name}'),
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(s.name),
        // Sem toque do usuario o valor do mapa segue nulo (a pagina usa o padrao da prop); o switch
        // mostra esse padrao, vindo do meta do React (`defaultValue: 'true'`).
        value: (_values[s.name] as bool?) ?? s.defaultValue == 'true',
        onChanged: (v) => setState(() => _values[s.name] = v),
      );
    }
    if (s.type.startsWith('num')) {
      // Campo numerico opcional: vazio = null (prop nao informada); inteiro vira int, decimal double.
      return TextField(
        key: ValueKey('pg-${s.name}'),
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*$')),
        ],
        decoration: InputDecoration(
          labelText: s.name,
          isDense: true,
          hintText: s.defaultValue,
        ),
        onChanged: (v) => setState(() => _values[s.name] = _parseNum(v)),
      );
    }
    return TextField(
      key: ValueKey('pg-${s.name}'),
      decoration: InputDecoration(labelText: s.name, isDense: true),
      onChanged: (v) => setState(() => _values[s.name] = v.isEmpty ? null : v),
    );
  }
}
