// Tabela de locales de numero/moeda: gerada do Intl do Node; confere o que o ICU devolve.
import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_components/src/inputs/number/currency_data.g.dart';
import 'package:seedgrid_components/src/inputs/number/number_locale.dart';

void main() {
  test('30 locales na tabela', () {
    expect(kNumberLocaleData.length, 30);
  });

  test('separadores de numero iguais ao Intl.NumberFormat', () {
    final it = numberSeparators('it-IT');
    // ICU nao agrupa 1000,1 em it (minimo de 2 digitos): o React cai em ',' como em es e pt-PT
    expect((it.decimal, it.group), (',', ','));
    final ru = numberSeparators('ru-RU');
    expect(ru.decimal, ',');
    expect(ru.group.trim().isEmpty, isTrue, reason: 'espaco fino/rigido');
    final ch = numberSeparators('de-CH');
    expect((ch.decimal, ch.group), ('.', '’'));
    final ja = numberSeparators('ja-JP');
    expect((ja.decimal, ja.group), ('.', ','));
  });

  test('moeda: simbolo e posicao por locale', () {
    final jp = resolveCurrencyMeta(
      locale: 'ja-JP',
      currency: 'JPY',
      currencyDisplay: 'symbol',
      currencySymbolOverride: null,
      currencySymbolPlacement: 'auto',
      useGrouping: true,
    );
    expect(jp.minorUnit, 0);
    expect(jp.placement, 'prefix');
    final pl = resolveCurrencyMeta(
      locale: 'pl-PL',
      currency: 'PLN',
      currencyDisplay: 'symbol',
      currencySymbolOverride: null,
      currencySymbolPlacement: 'auto',
      useGrouping: true,
    );
    expect(pl.placement, 'suffix');
    expect(pl.decimalSep, ',');
  });

  test('locale fora da tabela cai no idioma, depois em en-US', () {
    expect(resolveNumberLocale('it'), 'it-IT');
    expect(resolveNumberLocale('it_CH'), 'it-IT');
    expect(resolveNumberLocale('no'), 'nb-NO');
    expect(resolveNumberLocale('es-ES'), 'es');
    expect(resolveNumberLocale('pt-BR'), 'pt-BR');
    expect(resolveNumberLocale('ar-EG'), 'en-US');
    expect(resolveNumberLocale(null), 'en-US');
  });
}
