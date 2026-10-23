// Porte de SgToast.ts (React): armazenamento global de toasts e a API imperativa `toast`.
//   React:  toast.success('Salvo', { description: 'ok', duration: 3000 })
//   Dart:   toast.success('Salvo', SgToastOptions(description: 'ok', duration: 3000))
// `title`, `description` e `label` aceitam String ou Widget (equivale a React.ReactNode).
import 'dart:async';

import 'package:flutter/widgets.dart';

import '../i18n/i18n.dart';

/// Converte String (ou qualquer valor) em Widget; Widget passa direto; null vira null.
Widget? sgToNode(Object? value) {
  if (value == null) return null;
  if (value is Widget) return value;
  return Text('$value');
}

typedef SgToastId = String;

/// `SgToastType` do React. `default` e palavra reservada do Dart: `defaultValue`.
enum SgToastType {
  defaultValue('default'),
  success('success'),
  info('info'),
  warning('warning'),
  error('error'),
  loading('loading');

  const SgToastType(this.value);

  /// String equivalente no React.
  final String value;
}

class SgToastAction {
  const SgToastAction({required this.label, this.onClick});

  /// String ou Widget.
  final Object label;
  final VoidCallback? onClick;
}

/// `SgToastOptions` do React (sem `className`/`style`, ADR 50).
class SgToastOptions {
  const SgToastOptions({
    this.id,
    this.description,
    this.duration,
    this.action,
    this.closeButton,
  });

  final SgToastId? id;

  /// String ou Widget.
  final Object? description;

  /// Milissegundos; sobrescreve o `duration` do toaster. `<= 0` nao some sozinho.
  final num? duration;
  final SgToastAction? action;
  final bool? closeButton;

  SgToastOptions copyWith({SgToastId? id}) => SgToastOptions(
    id: id ?? this.id,
    description: description,
    duration: duration,
    action: action,
    closeButton: closeButton,
  );
}

class SgToastRecord {
  const SgToastRecord({
    required this.id,
    required this.type,
    this.title,
    this.description,
    this.duration,
    this.action,
    this.closeButton,
    required this.createdAt,
  });

  final SgToastId id;
  final SgToastType type;
  final Object? title;
  final Object? description;
  final num? duration;
  final SgToastAction? action;
  final bool? closeButton;
  final DateTime createdAt;

  /// `{...atual, ...proximo}` do React: campos nao nulos do novo vencem, `title`, `type` e
  /// `createdAt` vem sempre do novo.
  SgToastRecord mergedWith(SgToastRecord next) => SgToastRecord(
    id: id,
    type: next.type,
    title: next.title,
    description: next.description ?? description,
    duration: next.duration ?? duration,
    action: next.action ?? action,
    closeButton: next.closeButton ?? closeButton,
    createdAt: next.createdAt,
  );
}

typedef SgToastListener = void Function(List<SgToastRecord> toasts);

final Set<SgToastListener> _listeners = {};
List<SgToastRecord> _toasts = const [];
int _counter = 0;

void _emit() {
  final snapshot = List<SgToastRecord>.of(_toasts);
  for (final l in List.of(_listeners)) {
    l(snapshot);
  }
}

SgToastId _createId() =>
    'sg-toast-${DateTime.now().millisecondsSinceEpoch}-${++_counter}';

SgToastId _upsert(SgToastRecord next) {
  final i = _toasts.indexWhere((t) => t.id == next.id);
  if (i < 0) {
    _toasts = [..._toasts, next];
  } else {
    _toasts = [
      ..._toasts.sublist(0, i),
      _toasts[i].mergedWith(next),
      ..._toasts.sublist(i + 1),
    ];
  }
  _emit();
  return next.id;
}

SgToastId _show(SgToastType type, Object? title, SgToastOptions? o) {
  final id = o?.id ?? _createId();
  return _upsert(
    SgToastRecord(
      id: id,
      type: type,
      title: title,
      description: o?.description,
      duration: o?.duration,
      action: o?.action,
      closeButton: o?.closeButton,
      createdAt: DateTime.now(),
    ),
  );
}

/// Remove o toast [id]; sem [id], remove todos.
void dismissSgToast([SgToastId? id]) {
  if (id == null || id.isEmpty) {
    _toasts = const [];
    _emit();
    return;
  }
  final before = _toasts.length;
  _toasts = _toasts.where((t) => t.id != id).toList();
  if (_toasts.length != before) _emit();
}

/// Assina as mudancas (chama [listener] na hora com o estado atual). Devolve o cancelamento.
VoidCallback subscribeSgToasts(SgToastListener listener) {
  _listeners.add(listener);
  listener(List.of(_toasts));
  return () => _listeners.remove(listener);
}

/// Textos de `toast.promise`. `success` e `error` aceitam o valor (String/Widget) ou uma funcao
/// `Object? Function(T)` / `Object? Function(Object)`.
class SgToastPromiseMessages<T> {
  const SgToastPromiseMessages({this.loading, this.success, this.error});

  final Object? loading;
  final Object? success;
  final Object? error;
}

/// O `toast` do React: chamavel (`toast('x')`) e com `.success`, `.error` etc.
class SgToastFn {
  const SgToastFn._();

  SgToastId call([Object? title, SgToastOptions? options]) =>
      _show(SgToastType.defaultValue, title, options);
  SgToastId message([Object? title, SgToastOptions? options]) =>
      _show(SgToastType.defaultValue, title, options);
  SgToastId success([Object? title, SgToastOptions? options]) =>
      _show(SgToastType.success, title, options);
  SgToastId info([Object? title, SgToastOptions? options]) =>
      _show(SgToastType.info, title, options);
  SgToastId warning([Object? title, SgToastOptions? options]) =>
      _show(SgToastType.warning, title, options);
  SgToastId error([Object? title, SgToastOptions? options]) =>
      _show(SgToastType.error, title, options);
  SgToastId loading([Object? title, SgToastOptions? options]) =>
      _show(SgToastType.loading, title, options);

  /// [renderer]: Widget ou `Widget Function(String id)`.
  SgToastId custom(Object renderer, [SgToastOptions? options]) {
    final id = options?.id ?? _createId();
    final title = renderer is Widget Function(String) ? renderer(id) : renderer;
    return _show(
      SgToastType.defaultValue,
      title,
      (options ?? const SgToastOptions()).copyWith(id: id),
    );
  }

  void dismiss([SgToastId? id]) => dismissSgToast(id);

  /// [promiseOrFactory]: `Future<T>` ou `Future<T> Function()`. Mostra "loading" e troca, no mesmo
  /// id, por success/error (ou some, se a mensagem nao foi informada). Relanca o erro.
  Future<T> promise<T>(
    Object promiseOrFactory,
    SgToastPromiseMessages<T> messages, [
    SgToastOptions? options,
  ]) async {
    final run = promiseOrFactory is Future<T> Function()
        ? promiseOrFactory()
        : promiseOrFactory as Future<T>;
    final loadingId = loading(
      messages.loading ?? t(null, 'components.toast.loading'),
      options,
    );
    try {
      final value = await run;
      if (messages.success != null) {
        final s = messages.success;
        final title = s is Object? Function(T) ? s(value) : s;
        success(
          title,
          (options ?? const SgToastOptions()).copyWith(id: loadingId),
        );
      } else {
        dismiss(loadingId);
      }
      return value;
    } catch (e) {
      if (messages.error != null) {
        final s = messages.error;
        final title = s is Object? Function(Object) ? s(e) : s;
        error(
          title,
          (options ?? const SgToastOptions()).copyWith(id: loadingId),
        );
      } else {
        dismiss(loadingId);
      }
      rethrow;
    }
  }
}

/// API imperativa de toasts (`toast` do React).
const SgToastFn toast = SgToastFn._();
