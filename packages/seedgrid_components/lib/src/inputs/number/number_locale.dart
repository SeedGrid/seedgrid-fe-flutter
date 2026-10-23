// Separadores e moeda por locale. O React usa `Intl.NumberFormat` (ICU); o Dart nao tem ICU, entao
// os valores vem de `currency_data.g.dart`, gerado do Intl do Node para pt-BR, pt-PT, en-US, es, fr e
// de-DE. Locale fora da tabela cai em en-US (o Intl tambem cai no locale padrao quando nao conhece o
// locale pedido). LIMITE: locales alem desses 6 nao tem simbolo/separador proprio.
import 'currency_data.g.dart';

/// Separadores usados pelo `SgInputNumber` (React: `getSeparators`).
class SgNumberSeparators {
  const SgNumberSeparators(this.decimal, this.group);
  final String decimal;
  final String group;
}

/// Metadados da moeda (React: `CurrencyMeta`).
class SgCurrencyMeta {
  const SgCurrencyMeta({
    required this.decimalSep,
    required this.groupSep,
    required this.symbol,
    required this.placement,
    required this.minorUnit,
  });

  final String decimalSep;
  final String groupSep;
  final String symbol;

  /// `prefix` ou `suffix`.
  final String placement;
  final int minorUnit;
}

/// Acha o locale da tabela: troca `_` por `-`, tenta exato, depois pelo idioma, senao `en-US`.
String resolveNumberLocale(String? locale) {
  final l = (locale ?? 'en-US').replaceAll('_', '-');
  if (kNumberLocaleData.containsKey(l)) return l;
  final lang = l.split('-').first.toLowerCase();
  const byLang = {
    'pt': 'pt-BR',
    'en': 'en-US',
    'es': 'es',
    'fr': 'fr',
    'de': 'de-DE',
  };
  return byLang[lang] ?? 'en-US';
}

/// Equivale a `getSeparators(locale)` do React, INCLUINDO a esquisitice dele: em es e pt-PT o ICU nao
/// agrupa 1000.1 (minimo de 2 digitos), a parte `group` some e o React cai em `","`, que colide com o
/// decimal `","` (sai "12,345,00"). Mantido por paridade; ver o relatorio de defeitos.
SgNumberSeparators numberSeparators(String? locale) {
  final d = kNumberLocaleData[resolveNumberLocale(locale)]!;
  return SgNumberSeparators(d.numberDecimal, d.numberGroup);
}

final RegExp _wellFormedCurrency = RegExp(r'^[A-Z]{3}$');

/// Equivale a `resolveCurrencyMeta` do React. [currency] ja em maiusculas.
SgCurrencyMeta resolveCurrencyMeta({
  required String? locale,
  required String currency,
  required String currencyDisplay,
  required String? currencySymbolOverride,
  required String currencySymbolPlacement,
  required bool useGrouping,
}) {
  // `new Intl.NumberFormat` lanca RangeError para codigo mal formado; o React cai neste fallback.
  if (!_wellFormedCurrency.hasMatch(currency)) {
    return SgCurrencyMeta(
      decimalSep: '.',
      groupSep: ',',
      symbol: currencySymbolOverride ?? currency.toUpperCase(),
      placement: currencySymbolPlacement == 'suffix' ? 'suffix' : 'prefix',
      minorUnit: 2,
    );
  }
  final data = kNumberLocaleData[resolveNumberLocale(locale)]!;
  final minor = kCurrencyMinorUnits[currency] ?? 2;
  final row = data.symbols[currency];
  final part = row == null
      ? currency
      : switch (currencyDisplay) {
          'narrowSymbol' => row[1],
          'name' => row[2],
          'code' => currency,
          _ => row[0],
        };
  final placement = currencySymbolPlacement == 'auto'
      ? (data.placement[currencyDisplay] ?? 'prefix')
      : currencySymbolPlacement;
  return SgCurrencyMeta(
    // moeda sem casas: o Intl nao devolve parte decimal e o React cai no '.'
    decimalSep: minor > 0 ? data.currencyDecimal : '.',
    groupSep: useGrouping ? data.currencyGroup : ',',
    symbol: currencySymbolOverride ?? part,
    placement: placement,
    minorUnit: minor,
  );
}
