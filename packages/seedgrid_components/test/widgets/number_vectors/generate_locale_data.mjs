// Gera lib/src/inputs/number/currency_data.g.dart a partir do Intl do Node (o mesmo ICU que o React
// usa nos testes), para os locales dos 5 idiomas do pacote + de-DE (usado no exemplo `locale` do React).
// O Dart nao tem ICU: sem esta tabela nao daria para repetir simbolo, posicao e separadores iguais.
// Uso: node packages/seedgrid_components/test/widgets/number_vectors/generate_locale_data.mjs
// Deterministico para a mesma versao do Node/ICU (registrada no cabecalho do arquivo gerado).
import fs from "node:fs";
import path from "node:path";

const LOCALES = ["pt-BR", "pt-PT", "en-US", "es", "fr", "de-DE", "en-GB", "en-CA", "en-AU", "es-MX", "es-AR", "fr-CA", "de-AT", "de-CH", "it-IT", "nl-NL", "ja-JP", "zh-CN", "ko-KR", "ru-RU", "pl-PL", "sv-SE", "tr-TR", "da-DK", "nb-NO", "fi-FI", "cs-CZ", "hu-HU", "uk-UA", "el-GR"];
const DISPLAYS = ["symbol", "narrowSymbol", "code", "name"];
const CURRENCIES = Intl.supportedValuesOf("currency");
const dir = path.resolve(path.dirname(new URL(import.meta.url).pathname.replace(/^\//, "")), "../../../lib/src/inputs/number");

// getSeparators do React (SgInputNumber): Intl.NumberFormat(locale).formatToParts(1000.1), com os mesmos fallbacks.
function numberSeparators(locale) {
  const parts = new Intl.NumberFormat(locale).formatToParts(1000.1);
  return {
    group: parts.find((p) => p.type === "group")?.value ?? ",",
    decimal: parts.find((p) => p.type === "decimal")?.value ?? ".",
  };
}

const esc = (s) => s.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\$/g, "\\$").replace(/[^\x20-\x7e]/g, (c) => "\\u{" + c.codePointAt(0).toString(16) + "}");
const q = (s) => `'${esc(s)}'`;

let out = `// GERADO por test/widgets/number_vectors/generate_locale_data.mjs (Node ${process.version}, ICU ${process.versions.icu}). NAO EDITE A MAO.\n// Tabela do Intl.NumberFormat usada por SgInputNumber/SgInputCurrency (React: getSeparators e resolveCurrencyMeta).\n// dart format off\n\nclass SgNumberLocaleData {\n  const SgNumberLocaleData({required this.numberDecimal, required this.numberGroup, required this.currencyDecimal, required this.currencyGroup, required this.placement, required this.symbols});\n\n  /// \`new Intl.NumberFormat(locale).formatToParts(1000.1)\` (group ausente = ','; decimal ausente = '.').\n  final String numberDecimal;\n  final String numberGroup;\n\n  /// Idem com \`style: 'currency'\`.\n  final String currencyDecimal;\n  final String currencyGroup;\n\n  /// Posicao do simbolo com \`currencySymbolPlacement: 'auto'\`, por \`currencyDisplay\`.\n  final Map<String, String> placement;\n\n  /// Moeda -> [symbol, narrowSymbol, name]; \`code\` e o proprio codigo. Moeda fora da tabela: o codigo.\n  final Map<String, List<String>> symbols;\n}\n\n`;

// casas decimais por moeda (resolvedOptions().maximumFractionDigits), so as que nao sao 2
const minor = {};
for (const c of CURRENCIES) {
  const d = new Intl.NumberFormat("en-US", { style: "currency", currency: c }).resolvedOptions().maximumFractionDigits;
  if (d !== 2) minor[c] = d;
}
out += `/// Casas decimais da moeda quando diferentes de 2 (\`resolvedOptions().maximumFractionDigits\`).\nconst Map<String, int> kCurrencyMinorUnits = <String, int>{\n${Object.entries(minor).map(([c, d]) => `  '${c}': ${d},`).join("\n")}\n};\n\n`;

const problems = [];
out += `const Map<String, SgNumberLocaleData> kNumberLocaleData = <String, SgNumberLocaleData>{\n`;
for (const loc of LOCALES) {
  const ns = numberSeparators(loc);
  const placement = {};
  let curDec, curGroup;
  const symbols = {};
  for (const display of DISPLAYS) {
    const seen = new Set();
    for (const c of CURRENCIES) {
      const parts = new Intl.NumberFormat(loc, { style: "currency", currency: c, currencyDisplay: display, useGrouping: true }).formatToParts(1000.1);
      const ii = parts.findIndex((p) => p.type === "integer");
      const ci = parts.findIndex((p) => p.type === "currency");
      seen.add(ci > -1 && ci < ii ? "prefix" : "suffix");
      const dec = parts.find((p) => p.type === "decimal")?.value ?? ".";
      const grp = parts.find((p) => p.type === "group")?.value ?? ",";
      // Moeda sem casas (JPY...): o Intl nao devolve parte decimal e o React cai no '.' (fallback). O grupo e o mesmo.
      if (minor[c] === 0) {
        if (dec !== "." || (curGroup !== undefined && grp !== curGroup)) problems.push(`${loc} ${c} ${display}: moeda sem casas fora do padrao (${dec}|${grp})`);
      } else {
        curDec ??= dec; curGroup ??= grp;
        if (dec !== curDec || grp !== curGroup) problems.push(`${loc} ${c} ${display}: separadores variam (${dec}|${grp} x ${curDec}|${curGroup})`);
      }
      const sym = parts.find((p) => p.type === "currency")?.value ?? c;
      (symbols[c] ??= {})[display] = sym;
    }
    if (seen.size !== 1) problems.push(`${loc} ${display}: posicao varia por moeda (${[...seen]})`);
    placement[display] = [...seen][0];
  }
  const rows = [];
  for (const c of CURRENCIES) {
    const s = symbols[c];
    if (s.symbol === c && s.narrowSymbol === c && s.name === c) continue;
    rows.push(`      '${c}': [${q(s.symbol)}, ${q(s.narrowSymbol)}, ${q(s.name)}],`);
  }
  out += `  '${loc}': SgNumberLocaleData(\n    numberDecimal: ${q(ns.decimal)},\n    numberGroup: ${q(ns.group)},\n    currencyDecimal: ${q(curDec)},\n    currencyGroup: ${q(curGroup)},\n    placement: <String, String>{${DISPLAYS.map((d) => `'${d}': '${placement[d]}'`).join(", ")}},\n    symbols: <String, List<String>>{\n${rows.join("\n")}\n    },\n  ),\n`;
}
out += `};\n`;
if (problems.length) {
  console.error("AVISOS (a tabela assume uniformidade):\n  " + problems.slice(0, 20).join("\n  "));
  if (process.argv.includes("--strict")) process.exit(1);
}
fs.writeFileSync(path.join(dir, "currency_data.g.dart"), out);
console.log(`currency_data.g.dart: ${LOCALES.length} locales, ${CURRENCIES.length} moedas, ${Object.keys(minor).length} com casas != 2, ${problems.length} aviso(s), ${(out.length / 1024).toFixed(0)} KB`);
