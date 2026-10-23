// Porte de SgWhistle.ts (React): armazenamento global de whistles e a API imperativa `sgWhistle`.
//   React:  sgWhistle.success({ message: 'Salvo', duration: 3000 })
//   Dart:   sgWhistle.success(SgWhistleOptions(message: 'Salvo', duration: 3000))
import 'dart:async';

import 'package:flutter/widgets.dart';

import '../i18n/i18n.dart';

typedef SgWhistleId = String;

/// `SgWhistleSeverity` do React. `default` e palavra reservada do Dart: `defaultValue`.
enum SgWhistleSeverity {
  defaultValue('default'),
  success('success'),
  info('info'),
  warning('warning'),
  error('error'),
  loading('loading');

  const SgWhistleSeverity(this.value);
  final String value;
}

enum SgWhistleBorderStyle {
  solid('solid'),
  soft('soft'),
  leftAccent('left-accent'),
  fullAccent('full-accent'),
  none('none');

  const SgWhistleBorderStyle(this.value);
  final String value;
}

class SgWhistleAction {
  const SgWhistleAction({required this.label, required this.onClick});
  final String label;
  final VoidCallback onClick;
}

/// `SgWhistleOptions` do React (sem `className`/`style`, ADR 50). `message` e obrigatorio.
class SgWhistleOptions {
  const SgWhistleOptions({
    this.id,
    this.severity,
    this.title,
    required this.message,
    this.icon,
    this.duration,
    this.dismissible,
    this.borderStyle,
    this.opacity,
    this.action,
    this.onClose,
  });

  final String? id;
  final SgWhistleSeverity? severity;
  final String? title;
  final String message;
  final Widget? icon;

  /// Milissegundos; sobrescreve o `duration` do whistler. `<= 0` nao some sozinho.
  final num? duration;
  final bool? dismissible;
  final SgWhistleBorderStyle? borderStyle;
  final double? opacity;
  final SgWhistleAction? action;
  final VoidCallback? onClose;

  SgWhistleCustomOptions toCustom() => SgWhistleCustomOptions(
    id: id,
    severity: severity,
    title: title,
    message: message,
    icon: icon,
    duration: duration,
    dismissible: dismissible,
    borderStyle: borderStyle,
    opacity: opacity,
    action: action,
    onClose: onClose,
  );
}

/// `SgWhistleCustomOptions` / `Partial<SgWhistleOptions>`: tudo opcional (usado em `custom`, `update`).
class SgWhistleCustomOptions {
  const SgWhistleCustomOptions({
    this.id,
    this.severity,
    this.title,
    this.message,
    this.icon,
    this.duration,
    this.dismissible,
    this.borderStyle,
    this.opacity,
    this.action,
    this.onClose,
  });

  final String? id;
  final SgWhistleSeverity? severity;
  final String? title;
  final String? message;
  final Widget? icon;
  final num? duration;
  final bool? dismissible;
  final SgWhistleBorderStyle? borderStyle;
  final double? opacity;
  final SgWhistleAction? action;
  final VoidCallback? onClose;
}

class SgWhistleRecord {
  const SgWhistleRecord({
    required this.id,
    required this.severity,
    required this.createdAt,
    this.title,
    this.message,
    this.icon,
    this.duration,
    this.dismissible,
    this.borderStyle,
    this.opacity,
    this.action,
    this.onClose,
    this.renderer,
  });

  final SgWhistleId id;
  final SgWhistleSeverity severity;
  final DateTime createdAt;
  final String? title;
  final String? message;
  final Widget? icon;
  final num? duration;
  final bool? dismissible;
  final SgWhistleBorderStyle? borderStyle;
  final double? opacity;
  final SgWhistleAction? action;
  final VoidCallback? onClose;

  /// Conteudo proprio (`custom`); quando existe, substitui titulo e mensagem.
  final Widget? renderer;

  /// `{...atual, ...novo}` do React: campos nao nulos de [o] vencem; `id` e `createdAt` ficam.
  SgWhistleRecord patched(
    SgWhistleCustomOptions o, {
    Widget? renderer,
    SgWhistleSeverity? severity,
  }) => SgWhistleRecord(
    id: id,
    severity: severity ?? o.severity ?? this.severity,
    createdAt: createdAt,
    title: o.title ?? title,
    message: o.message ?? message,
    icon: o.icon ?? icon,
    duration: o.duration ?? duration,
    dismissible: o.dismissible ?? dismissible,
    borderStyle: o.borderStyle ?? borderStyle,
    opacity: o.opacity ?? opacity,
    action: o.action ?? action,
    onClose: o.onClose ?? onClose,
    renderer: renderer ?? this.renderer,
  );
}

typedef SgWhistleListener = void Function(List<SgWhistleRecord> whistles);

final Set<SgWhistleListener> _listeners = {};
List<SgWhistleRecord> _whistles = const [];
int _counter = 0;

void _emit() {
  final snapshot = List<SgWhistleRecord>.of(_whistles);
  for (final l in List.of(_listeners)) {
    l(snapshot);
  }
}

SgWhistleId _createId() =>
    'sg-whistle-${DateTime.now().millisecondsSinceEpoch}-${++_counter}';

SgWhistleId _upsert(SgWhistleRecord next) {
  final i = _whistles.indexWhere((w) => w.id == next.id);
  if (i < 0) {
    _whistles = [..._whistles, next];
    _emit();
    return next.id;
  }
  final cur = _whistles[i];
  // O merge mantem o createdAt do original.
  final merged = SgWhistleRecord(
    id: cur.id,
    severity: next.severity,
    createdAt: cur.createdAt,
    title: next.title ?? cur.title,
    message: next.message ?? cur.message,
    icon: next.icon ?? cur.icon,
    duration: next.duration ?? cur.duration,
    dismissible: next.dismissible ?? cur.dismissible,
    borderStyle: next.borderStyle ?? cur.borderStyle,
    opacity: next.opacity ?? cur.opacity,
    action: next.action ?? cur.action,
    onClose: next.onClose ?? cur.onClose,
    renderer: next.renderer ?? cur.renderer,
  );
  _whistles = [..._whistles.sublist(0, i), merged, ..._whistles.sublist(i + 1)];
  _emit();
  return merged.id;
}

void _remove(bool Function(SgWhistleRecord) test) {
  final removed = _whistles.where(test).toList();
  if (removed.isEmpty) return;
  _whistles = _whistles.where((w) => !test(w)).toList();
  _emit();
  for (final w in removed) {
    w.onClose?.call();
  }
}

SgWhistleRecord _record(
  SgWhistleCustomOptions o,
  SgWhistleSeverity severity,
  SgWhistleId id, {
  Widget? renderer,
}) => SgWhistleRecord(
  id: id,
  severity: o.severity ?? severity,
  createdAt: DateTime.now(),
  title: o.title,
  message: o.message,
  icon: o.icon,
  duration: o.duration,
  dismissible: o.dismissible,
  borderStyle: o.borderStyle,
  opacity: o.opacity,
  action: o.action,
  onClose: o.onClose,
  renderer: renderer,
);

SgWhistleId _show(SgWhistleOptions o, SgWhistleSeverity severity) {
  final c = o.toCustom();
  return _upsert(_record(c, c.severity ?? severity, c.id ?? _createId()));
}

/// Remove o whistle [id] (chama o `onClose` dele); sem [id], remove todos.
void dismissSgWhistle([SgWhistleId? id]) {
  if (id == null || id.isEmpty) {
    _remove((_) => true);
    return;
  }
  _remove((w) => w.id == id);
}

/// Assina as mudancas (chama [listener] na hora com o estado atual). Devolve o cancelamento.
VoidCallback subscribeSgWhistles(SgWhistleListener listener) {
  _listeners.add(listener);
  listener(List.of(_whistles));
  return () => _listeners.remove(listener);
}

/// Estados de `sgWhistle.promise`. `success` e `error` aceitam [SgWhistleOptions] ou uma funcao
/// `SgWhistleOptions Function(T)` / `SgWhistleOptions Function(Object)`.
class SgWhistlePromiseStates<T> {
  const SgWhistlePromiseStates({this.loading, this.success, this.error});

  final SgWhistleOptions? loading;
  final Object? success;
  final Object? error;
}

/// O `sgWhistle` do React.
class SgWhistleApi {
  const SgWhistleApi._();

  SgWhistleId show(SgWhistleOptions options) =>
      _show(options, options.severity ?? SgWhistleSeverity.defaultValue);
  SgWhistleId success(SgWhistleOptions options) =>
      _showAs(options, SgWhistleSeverity.success);
  SgWhistleId info(SgWhistleOptions options) =>
      _showAs(options, SgWhistleSeverity.info);
  SgWhistleId warning(SgWhistleOptions options) =>
      _showAs(options, SgWhistleSeverity.warning);
  SgWhistleId error(SgWhistleOptions options) =>
      _showAs(options, SgWhistleSeverity.error);
  SgWhistleId loading(SgWhistleOptions options) =>
      _showAs(options, SgWhistleSeverity.loading);

  void dismiss([SgWhistleId? id]) => dismissSgWhistle(id);

  /// Atualiza o whistle [id] com os campos nao nulos de [options]. Se nao existe, nao faz nada e devolve [id].
  SgWhistleId update(SgWhistleId id, SgWhistleCustomOptions options) {
    final i = _whistles.indexWhere((w) => w.id == id);
    if (i < 0) return id;
    return _upsert(_whistles[i].patched(options));
  }

  /// [renderer]: Widget ou `Widget Function(String id)`.
  SgWhistleId custom(
    Object renderer, [
    SgWhistleCustomOptions options = const SgWhistleCustomOptions(),
  ]) {
    final id = options.id ?? _createId();
    final node = renderer is Widget Function(String)
        ? renderer(id)
        : renderer as Widget;
    return _upsert(
      _record(
        options,
        options.severity ?? SgWhistleSeverity.defaultValue,
        id,
        renderer: node,
      ),
    );
  }

  /// [promiseOrFactory]: `Future<T>` ou `Future<T> Function()`. Mostra "loading" e troca, no mesmo
  /// id, por success/error (ou some, se o estado nao foi informado). Relanca o erro.
  Future<T> promise<T>(
    Object promiseOrFactory,
    SgWhistlePromiseStates<T> states, [
    SgWhistleCustomOptions options = const SgWhistleCustomOptions(),
  ]) async {
    final run = promiseOrFactory is Future<T> Function()
        ? promiseOrFactory()
        : promiseOrFactory as Future<T>;
    final loadingState =
        states.loading ??
        SgWhistleOptions(message: t(null, 'components.toast.loading'));
    final loadingId = _showAs(
      _mergeOpts(options, loadingState),
      SgWhistleSeverity.loading,
    );
    try {
      final value = await run;
      final s = states.success;
      final state = s is SgWhistleOptions Function(T)
          ? s(value)
          : s as SgWhistleOptions?;
      if (state != null) {
        update(
          loadingId,
          _asPatch(_mergeOpts(options, state), SgWhistleSeverity.success),
        );
      } else {
        dismiss(loadingId);
      }
      return value;
    } catch (e) {
      final s = states.error;
      final state = s is SgWhistleOptions Function(Object)
          ? s(e)
          : s as SgWhistleOptions?;
      if (state != null) {
        update(
          loadingId,
          _asPatch(_mergeOpts(options, state), SgWhistleSeverity.error),
        );
      } else {
        dismiss(loadingId);
      }
      rethrow;
    }
  }
}

// `success`, `info`... forcam a severidade (o React faz `{...options, severity: 'success'}`).
SgWhistleId _showAs(SgWhistleOptions o, SgWhistleSeverity severity) => _upsert(
  _record(
    o.toCustom(),
    severity,
    o.id ?? _createId(),
  ).patched(const SgWhistleCustomOptions(), severity: severity),
);

/// `{...options, ...state}`: o estado vence, o resto vem das opcoes base.
SgWhistleOptions _mergeOpts(
  SgWhistleCustomOptions base,
  SgWhistleOptions state,
) => SgWhistleOptions(
  id: state.id ?? base.id,
  severity: state.severity ?? base.severity,
  title: state.title ?? base.title,
  message: state.message,
  icon: state.icon ?? base.icon,
  duration: state.duration ?? base.duration,
  dismissible: state.dismissible ?? base.dismissible,
  borderStyle: state.borderStyle ?? base.borderStyle,
  opacity: state.opacity ?? base.opacity,
  action: state.action ?? base.action,
  onClose: state.onClose ?? base.onClose,
);

SgWhistleCustomOptions _asPatch(
  SgWhistleOptions o,
  SgWhistleSeverity severity,
) => SgWhistleCustomOptions(
  title: o.title,
  message: o.message,
  icon: o.icon,
  duration: o.duration,
  dismissible: o.dismissible,
  borderStyle: o.borderStyle,
  opacity: o.opacity,
  action: o.action,
  onClose: o.onClose,
  severity: severity,
);

/// API imperativa de whistles (`sgWhistle` do React).
const SgWhistleApi sgWhistle = SgWhistleApi._();
