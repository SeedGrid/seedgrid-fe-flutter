// Porte de @seedgrid/fe-components src/i18n/index.ts. Mesmos nomes e mesma interpolacao `{param}`.
// Os mapas de mensagens sao GERADOS (messages_*.dart) por tools/export_i18n/export.mjs.

import 'package:flutter/widgets.dart';

import 'messages_en_us.dart';
import 'messages_es.dart';
import 'messages_fr.dart';
import 'messages_pt_br.dart';
import 'messages_pt_pt.dart';

export 'messages_en_us.dart' show componentsMessagesEnUs;
export 'messages_es.dart' show componentsMessagesEs;
export 'messages_fr.dart' show componentsMessagesFr;
export 'messages_pt_br.dart' show componentsMessagesPtBr;
export 'messages_pt_pt.dart' show componentsMessagesPtPt;

/// No TypeScript e `"pt-BR" | "pt-PT" | "en-US" | "en" | "es" | "fr" | string`.
typedef SgComponentsLocale = String;
typedef SgComponentsMessages = Map<String, String>;

/// Igual aos exports `componentsMessagesEn` do React (alias de en-US).
const Map<String, String> componentsMessagesEn = componentsMessagesEnUs;

class SgComponentsI18n {
  const SgComponentsI18n({required this.locale, required this.messages});

  final SgComponentsLocale locale;
  final SgComponentsMessages messages;
}

const SgComponentsI18n _defaultI18n = SgComponentsI18n(
  locale: 'en-US',
  messages: componentsMessagesEnUs,
);

SgComponentsLocale normalizeComponentsLocale([SgComponentsLocale? locale]) {
  if (locale == null || locale.isEmpty) return 'en-US';
  if (locale == 'en') return 'en-US';
  return locale;
}

SgComponentsMessages getBuiltInComponentsMessages([
  SgComponentsLocale? locale,
]) {
  switch (normalizeComponentsLocale(locale)) {
    case 'pt-BR':
      return componentsMessagesPtBr;
    case 'pt-PT':
      return componentsMessagesPtPt;
    case 'es':
      return componentsMessagesEs;
    case 'fr':
      return componentsMessagesFr;
    case 'en-US':
    default:
      return componentsMessagesEnUs;
  }
}

/// Equivale a `SgComponentsMessages | SgComponentsMessagesByNamespace`: se houver a chave
/// `components` com um mapa, usa-o; senao usa o proprio mapa de mensagens.
SgComponentsMessages _resolveMessages(Map<String, Object?>? messages) {
  if (messages == null) return const {};
  final ns = messages['components'];
  if (ns is Map) return ns.map((k, v) => MapEntry(k.toString(), v.toString()));
  return messages.map((k, v) => MapEntry(k, v.toString()));
}

/// Entrada de `setComponentsI18n`/`resolveComponentsI18n` (todos os campos opcionais).
class SgComponentsI18nInput {
  const SgComponentsI18nInput({this.locale, this.messages});

  final SgComponentsLocale? locale;
  final Map<String, Object?>? messages;
}

SgComponentsI18n? _runtime;

/// Equivale a `setComponentsI18n`: grava o estado global (em TS, `globalThis.__seedgridComponentsI18n`).
void setComponentsI18n(SgComponentsI18nInput input) {
  final current = _runtime ?? _defaultI18n;
  final nextLocale = normalizeComponentsLocale(input.locale ?? current.locale);
  final preserve = normalizeComponentsLocale(current.locale) == nextLocale;
  _runtime = SgComponentsI18n(
    locale: nextLocale,
    messages: {
      ...getBuiltInComponentsMessages(nextLocale),
      if (preserve) ...current.messages,
      ..._resolveMessages(input.messages),
    },
  );
}

/// Volta ao estado inicial (nao existe no React; serve para isolar testes).
void resetComponentsI18n() => _runtime = null;

SgComponentsI18n getComponentsI18n() {
  final runtime = _runtime;
  if (runtime == null) return _defaultI18n;
  final locale = normalizeComponentsLocale(runtime.locale);
  return SgComponentsI18n(
    locale: locale,
    messages: {...getBuiltInComponentsMessages(locale), ...runtime.messages},
  );
}

SgComponentsI18n resolveComponentsI18n([SgComponentsI18nInput? input]) {
  final base = getComponentsI18n();
  if (input == null) return base;
  final locale = normalizeComponentsLocale(input.locale ?? base.locale);
  final preserve = normalizeComponentsLocale(base.locale) == locale;
  return SgComponentsI18n(
    locale: locale,
    messages: {
      ...getBuiltInComponentsMessages(locale),
      if (preserve) ...base.messages,
      ..._resolveMessages(input.messages),
    },
  );
}

final RegExp _placeholder = RegExp(r'\{(\w+)\}');

/// Igual a `formatMessage`: so troca `{nome}` quando o parametro existe; senao deixa o texto.
String formatMessage(String template, [Map<String, Object?>? params]) {
  if (params == null) return template;
  return template.replaceAllMapped(_placeholder, (m) {
    final value = params[m.group(1)];
    return value == null ? m.group(0)! : value.toString();
  });
}

/// Igual a `t(i18n, key, params)`: mensagem do contexto, depois do idioma embutido, depois en-US, depois a propria chave.
String t(SgComponentsI18n? i18n, String key, [Map<String, Object?>? params]) {
  final resolved = i18n ?? getComponentsI18n();
  final template =
      resolved.messages[key] ??
      getBuiltInComponentsMessages(resolved.locale)[key] ??
      _defaultI18n.messages[key] ??
      key;
  return formatMessage(template, params);
}

/// Equivale a `SgComponentsI18nProvider`: widgets abaixo leem o idioma com `useComponentsI18n(context)`.
/// Trocar `locale` ou `messages` reconstroi quem depende dele.
class SgComponentsI18nProvider extends StatelessWidget {
  const SgComponentsI18nProvider({
    super.key,
    this.locale,
    this.messages,
    required this.child,
  });

  final SgComponentsLocale? locale;
  final Map<String, Object?>? messages;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final loc = normalizeComponentsLocale(locale ?? _defaultI18n.locale);
    final value = SgComponentsI18n(
      locale: loc,
      messages: {
        ...getBuiltInComponentsMessages(loc),
        ..._resolveMessages(messages),
      },
    );
    return _SgI18nScope(value: value, child: child);
  }
}

class _SgI18nScope extends InheritedWidget {
  const _SgI18nScope({required this.value, required super.child});

  final SgComponentsI18n value;

  @override
  bool updateShouldNotify(_SgI18nScope old) =>
      old.value.locale != value.locale ||
      !_sameMessages(old.value.messages, value.messages);

  static bool _sameMessages(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final e in a.entries) {
      if (b[e.key] != e.value) return false;
    }
    return true;
  }
}

/// Equivale a `useComponentsI18n()`: o do provider mais proximo ou, sem provider, o global.
SgComponentsI18n useComponentsI18n(BuildContext context) {
  final scope = context.dependOnInheritedWidgetOfExactType<_SgI18nScope>();
  return scope?.value ?? getComponentsI18n();
}

extension SgComponentsI18nContext on BuildContext {
  /// Atalho: `context.sgI18n`.
  SgComponentsI18n get sgI18n => useComponentsI18n(this);
}
