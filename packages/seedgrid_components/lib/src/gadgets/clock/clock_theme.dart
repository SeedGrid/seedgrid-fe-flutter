// Porte de src/gadgets/clock/themes/{types,registry,provider,search,renderTheme,useDarkFlag}.
// DECISAO DO DONO (ADR 51, D8): so temas embutidos. Tema por URL (`url`) e aceito, mas NAO e desenhado:
// reporta [SgClockUrlThemeUnsupportedError] (FlutterError) e nao pinta nada, no lugar do `fetch` + SVG livre.
import 'dart:convert';

import 'package:flutter/material.dart';

import 'clock_builtin_themes.g.dart';
import 'clock_ops.dart';

/// Argumentos que o tema recebe ao desenhar: `size` em px e se o modo e escuro.
class SgClockThemeRenderArgs {
  const SgClockThemeRenderArgs({required this.size, required this.dark});
  final double size;
  final bool dark;
}

/// Desenho livre de um tema no espaco 100x100 (equivale a `render` do React).
typedef SgClockThemePaint =
    void Function(Canvas canvas, SgClockThemeRenderArgs args);

/// Erro de tema por URL (SVG livre): nao portado. Mensagem clara e testada.
class SgClockUrlThemeUnsupportedError implements Exception {
  SgClockUrlThemeUnsupportedError(this.themeId, this.url);

  final String themeId;
  final String url;

  @override
  String toString() =>
      'SgClockUrlThemeUnsupportedError: o tema "$themeId" usa url ($url). Temas por URL/SVG livre nao '
      'existem no Flutter (ADR 51, D8): use um tema embutido ou defina o tema em JSON (sg-clock-theme/1) / com paint.';
}

/// Tema do relogio. `ops` (JSON proprio) e/ou `paint` (desenho livre) fazem o papel de `render` do React.
class SgClockTheme {
  const SgClockTheme({
    required this.id,
    this.label,
    this.tags,
    this.ops,
    this.paint,
    this.url,
    this.order,
  });

  final String id;
  final String? label;
  final List<String>? tags;
  final List<SgClockOp>? ops;
  final SgClockThemePaint? paint;

  /// Aceito para cumprir o contrato; desenhar um tema com `url` reporta [SgClockUrlThemeUnsupportedError].
  final String? url;
  final int? order;

  /// Tema a partir do JSON `sg-clock-theme/1` (um item de `temas`).
  factory SgClockTheme.fromJson(Map<String, dynamic> j) => SgClockTheme(
    id: j['id'] as String,
    label: j['label'] as String?,
    tags: (j['tags'] as List?)?.cast<String>(),
    order: (j['order'] as num?)?.toInt(),
    ops: [
      for (final o in (j['ops'] as List).cast<Map<String, dynamic>>())
        SgClockOp.fromJson(o),
    ],
  );

  /// Pinta o tema (sem a URL) no canvas ja escalado para o espaco 100x100.
  void paintOn(Canvas canvas, SgClockThemeRenderArgs args) {
    for (final op in ops ?? const <SgClockOp>[]) {
      op.paint(canvas, args.dark);
    }
    paint?.call(canvas, args);
  }
}

/// Os temas embutidos (equivale a `sgClockThemesBuiltIn`), lidos do JSON gerado a partir do React.
/// Como no React, NAO sao registrados sozinhos: chame [registerSgClockBuiltInThemes] ou passe-os em
/// `SgClockThemeProvider(value: SgClockThemeProviderValue(themes: sgClockThemesBuiltIn))`.
List<SgClockTheme> get sgClockThemesBuiltIn =>
    _builtIns ??= parseSgClockThemesJson(kSgClockBuiltInThemesJson);
List<SgClockTheme>? _builtIns;

/// Interpreta um documento `sg-clock-theme/1` (`{formato, viewBox, temas: [...]}`).
List<SgClockTheme> parseSgClockThemesJson(String json) {
  final doc = jsonDecode(json) as Map<String, dynamic>;
  if (doc['formato'] != 'sg-clock-theme/1') {
    throw FormatException('formato de tema desconhecido: ${doc['formato']}');
  }
  if ((doc['viewBox'] as num?) != 100) {
    throw FormatException('viewBox deve ser 100, veio ${doc['viewBox']}');
  }
  return [
    for (final t in (doc['temas'] as List).cast<Map<String, dynamic>>())
      SgClockTheme.fromJson(t),
  ];
}

// ---------------------------------------------------------------- registro global (registry.ts)

final Map<String, SgClockTheme> _globalMap = {};

void registerTheme(SgClockTheme theme) {
  if (theme.id.isEmpty) {
    throw ArgumentError('registerTheme: theme.id is required');
  }
  _globalMap[theme.id] = theme;
}

void registerThemes(Iterable<SgClockTheme> themes) {
  for (final t in themes) {
    registerTheme(t);
  }
}

/// Atalho: `registerThemes(sgClockThemesBuiltIn)`.
void registerSgClockBuiltInThemes() => registerThemes(sgClockThemesBuiltIn);

SgClockTheme? getTheme(String id) => _globalMap[id];

bool hasTheme(String id) => _globalMap.containsKey(id);

List<SgClockTheme> listThemes() => _sorted(_globalMap.values);

void unregisterTheme(String id) => _globalMap.remove(id);

void clearThemes() => _globalMap.clear();

List<SgClockTheme> _sorted(Iterable<SgClockTheme> themes) {
  final list = themes.toList();
  // Ordenacao estavel pela ordem (padrao 999), como Array.sort do JS.
  final indexed = [for (var i = 0; i < list.length; i++) (i, list[i])];
  indexed.sort((a, b) {
    final c = (a.$2.order ?? 999).compareTo(b.$2.order ?? 999);
    return c != 0 ? c : a.$1.compareTo(b.$1);
  });
  return [for (final e in indexed) e.$2];
}

// ---------------------------------------------------------------- resolvedor (provider.tsx)

enum SgClockThemeResolveMode { strict, fallback }

abstract class SgClockThemeResolver {
  SgClockTheme? resolve(String id);
  List<SgClockTheme> list();
  void registerLocal(SgClockTheme theme);
  void registerManyLocal(Iterable<SgClockTheme> themes);
}

class _Resolver implements SgClockThemeResolver {
  _Resolver(this.mode, this.fallbackThemeId, Iterable<SgClockTheme> local) {
    for (final t in local) {
      _local[t.id] = t;
    }
  }

  final SgClockThemeResolveMode mode;
  final String fallbackThemeId;
  final Map<String, SgClockTheme> _local = {};

  SgClockTheme? _strict(String id) => _local[id] ?? getTheme(id);

  @override
  SgClockTheme? resolve(String id) {
    final found = _strict(id);
    if (found != null) return found;
    if (mode == SgClockThemeResolveMode.strict) return null;
    if (id != fallbackThemeId) return _strict(fallbackThemeId);
    return null;
  }

  @override
  List<SgClockTheme> list() {
    final merged = <String, SgClockTheme>{};
    for (final g in listThemes()) {
      merged[g.id] = g;
    }
    merged.addAll(_local);
    return _sorted(merged.values);
  }

  @override
  void registerLocal(SgClockTheme theme) {
    if (theme.id.isEmpty) {
      throw ArgumentError('registerLocal: theme.id is required');
    }
    _local[theme.id] = theme;
  }

  @override
  void registerManyLocal(Iterable<SgClockTheme> themes) {
    for (final t in themes) {
      registerLocal(t);
    }
  }
}

SgClockThemeResolver createThemeResolver({
  SgClockThemeResolveMode mode = SgClockThemeResolveMode.fallback,
  String fallbackThemeId = 'classic',
  Iterable<SgClockTheme> localThemes = const [],
}) => _Resolver(mode, fallbackThemeId, localThemes);

/// `value` do `SgClockThemeProvider`.
class SgClockThemeProviderValue {
  const SgClockThemeProviderValue({
    this.mode,
    this.fallbackThemeId,
    this.themes,
  });

  final SgClockThemeResolveMode? mode;
  final String? fallbackThemeId;
  final List<SgClockTheme>? themes;
}

class SgClockThemeScope extends InheritedWidget {
  const SgClockThemeScope({
    super.key,
    required this.resolver,
    required super.child,
  });

  final SgClockThemeResolver resolver;

  @override
  bool updateShouldNotify(SgClockThemeScope old) =>
      !identical(old.resolver, resolver);
}

/// `useSgClockThemeResolver`: o resolvedor do `SgClockThemeProvider` mais proximo, ou nulo.
SgClockThemeResolver? useSgClockThemeResolver(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<SgClockThemeScope>()?.resolver;

// ---------------------------------------------------------------- busca e selecao (search.ts)

List<SgClockTheme> filterClockThemes(List<SgClockTheme> themes, String query) {
  final s = query.trim().toLowerCase();
  if (s.isEmpty) return themes;
  return themes.where((t) {
    final hay = '${t.id} ${t.label ?? ''} ${(t.tags ?? const []).join(' ')}'
        .toLowerCase();
    return hay.contains(s);
  }).toList();
}

SgClockTheme? resolveClockThemeSelection({
  SgClockThemeResolver? resolver,
  required List<SgClockTheme> allThemes,
  required String value,
  required String fallbackThemeId,
}) {
  SgClockTheme? byId(String id) {
    for (final t in allThemes) {
      if (t.id == id) return t;
    }
    return null;
  }

  return resolver?.resolve(value) ??
      byId(value) ??
      resolver?.resolve(fallbackThemeId) ??
      byId(fallbackThemeId);
}

/// `resolveTheme` de renderTheme.tsx.
SgClockTheme? resolveTheme(
  SgClockThemeResolver? resolver,
  String themeId,
  String fallbackThemeId,
) {
  final t = resolver?.resolve(themeId);
  if (t != null) return t;
  if (themeId != fallbackThemeId) return resolver?.resolve(fallbackThemeId);
  return null;
}

// ---------------------------------------------------------------- modo escuro (useDarkFlag.ts)

/// Equivale a `useDarkFlag`: o brilho do tema do Flutter (que o `SeedThemeProvider` mantem em dia).
bool sgClockIsDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

// ---------------------------------------------------------------- camada de tema (ThemeLayer)

/// Camada do tema: pinta `ops`/`paint` no espaco 100x100 escalado para [size]. Se o tema tem `url`,
/// reporta [SgClockUrlThemeUnsupportedError] (uma vez por montagem/troca de tema) e nao desenha a URL.
class SgClockThemeLayer extends StatefulWidget {
  const SgClockThemeLayer({
    super.key,
    required this.theme,
    required this.size,
    required this.dark,
    this.extra,
  });

  final SgClockTheme theme;
  final double size;
  final bool dark;

  /// Desenho por cima do tema, no espaco 100x100 (ponteiros).
  final void Function(Canvas canvas)? extra;

  @override
  State<SgClockThemeLayer> createState() => _SgClockThemeLayerState();
}

class _SgClockThemeLayerState extends State<SgClockThemeLayer> {
  @override
  void initState() {
    super.initState();
    _reportUrl();
  }

  @override
  void didUpdateWidget(SgClockThemeLayer old) {
    super.didUpdateWidget(old);
    if (old.theme.url != widget.theme.url || old.theme.id != widget.theme.id) {
      _reportUrl();
    }
  }

  void _reportUrl() {
    final url = widget.theme.url;
    if (url == null || url.isEmpty) return;
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: SgClockUrlThemeUnsupportedError(widget.theme.id, url),
        library: 'seedgrid_components',
        context: ErrorDescription(
          'while painting the clock theme "${widget.theme.id}"',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final args = SgClockThemeRenderArgs(size: widget.size, dark: widget.dark);
    return CustomPaint(
      size: Size.square(widget.size),
      painter: _ThemePainter(theme, args, widget.extra),
    );
  }
}

class _ThemePainter extends CustomPainter {
  _ThemePainter(this.theme, this.args, this.extra);

  final SgClockTheme theme;
  final SgClockThemeRenderArgs args;
  final void Function(Canvas canvas)? extra;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);
    theme.paintOn(canvas, args);
    extra?.call(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ThemePainter old) => true;
}
