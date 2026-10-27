// Dados de locale e vetores de paridade do SgCalendar. A verdade e o Intl.DateTimeFormat do Node, com as
// MESMAS chamadas do SgCalendar.tsx (formatSelectedDate, formatMonthYear, weekdayLabels, capitalizeFirst).
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/calendar_vectors/generate.mjs
// Gera:
//   packages/seedgrid_components/lib/src/gadgets/calendar/calendar_locale_data.g.dart  (dados usados pelo widget)
//   packages/seedgrid_components/test/widgets/calendar_vectors/vectors.json            (saidas esperadas, formatadas direto)
// Deterministico: mesma versao do ICU do Node, mesmo resultado. Nao depende do repositorio React.
import fs from "node:fs";
import path from "node:path";

const root = process.cwd();
const dataOut = path.join(root, "packages/seedgrid_components/lib/src/gadgets/calendar/calendar_locale_data.g.dart");
const vecOut = path.join(root, "packages/seedgrid_components/test/widgets/calendar_vectors/vectors.json");

// Locales com dados proprios. O React aceita qualquer locale; fora desta lista o widget cai em en-US.
const LOCALES = ["pt-BR", "pt-PT", "pt", "en-US", "en", "es", "fr", "de-DE", "de", "en-GB", "en-AU", "en-CA", "es-MX", "es-AR", "fr-CA", "de-AT", "de-CH", "it", "nl", "ja", "zh", "ko", "ru", "pl", "sv", "tr", "da", "nb", "fi", "cs", "hu", "uk", "el"];
const FORMATS = ["narrow", "short", "long"];

// Igual ao React: capitalizeFirst(value, locale)
const capitalizeFirst = (value, locale) => (value ? value.charAt(0).toLocaleUpperCase(locale) + value.slice(1) : value);
const addDays = (d, n) => { const x = new Date(d.getFullYear(), d.getMonth(), d.getDate()); x.setDate(x.getDate() + n); return new Date(x.getFullYear(), x.getMonth(), x.getDate()); };

const selectedFmt = (loc) => new Intl.DateTimeFormat(loc, { weekday: "long", day: "numeric", month: "long" });
const monthYearFmt = (loc) => new Intl.DateTimeFormat(loc, { month: "long", year: "numeric" });
const sundayAnchor = new Date(2026, 2, 1); // domingo
const weekdayLabels = (loc, fmt, weekStartsOn) => {
  const f = new Intl.DateTimeFormat(loc, { weekday: fmt });
  return Array.from({ length: 7 }, (_, i) => capitalizeFirst(f.format(addDays(sundayAnchor, (weekStartsOn + i) % 7)), loc));
};

// Molde a partir de formatToParts: {weekday} {day} {month} {year} + literais.
function template(fmt, sample) {
  // V8 devolve U+202F em formatToParts mas U+0020 em format() (o que o React usa): normaliza para o de format().
  return fmt.formatToParts(sample).map((p) => (["weekday", "day", "month", "year"].includes(p.type) ? "{" + p.type + "}" : p.value)).join("").replace(/ /g, " ");
}
const dartStr = (s) => "'" + s.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\$/g, "\\$") + "'";
const dartList = (a) => "[" + a.map(dartStr).join(", ") + "]";

let dart = "// dart format off\n// GERADO por packages/seedgrid_components/test/widgets/calendar_vectors/generate.mjs. NAO EDITE A MAO.\n";
dart += "// Nomes de mes e de dia e a ordem das partes, tirados do Intl.DateTimeFormat do Node (mesmas chamadas do\n// SgCalendar.tsx). Cada locale: moldes {weekday} {day} {month} {year}, 12 meses e 7 dias (domingo=0).\n\n";
dart += "class SgCalendarLocaleData {\n  const SgCalendarLocaleData({required this.selectedTemplate, required this.monthYearTemplate, required this.selectedMonths, required this.monthYearMonths, required this.selectedWeekdays, required this.weekdayNames});\n\n  /// Molde da data selecionada (weekday long, day numeric, month long).\n  final String selectedTemplate;\n\n  /// Molde do titulo do mes (month long, year numeric).\n  final String monthYearTemplate;\n  final List<String> selectedMonths;\n  final List<String> monthYearMonths;\n  final List<String> selectedWeekdays;\n\n  /// weekdayFormat (narrow, short, long) -> 7 nomes, domingo=0.\n  final Map<String, List<String>> weekdayNames;\n}\n\n";
dart += "const Map<String, SgCalendarLocaleData> kSgCalendarLocaleData = <String, SgCalendarLocaleData>{\n";
const vectors = { icu: process.versions.icu, locales: {} };
for (const loc of LOCALES) {
  const sf = selectedFmt(loc);
  const mf = monthYearFmt(loc);
  const sample = new Date(2026, 2, 1);
  const monthsOf = (f) => Array.from({ length: 12 }, (_, m) => f.formatToParts(new Date(2026, m, 15)).find((p) => p.type === "month").value);
  const selectedWeekdays = Array.from({ length: 7 }, (_, d) => sf.formatToParts(addDays(sundayAnchor, d)).find((p) => p.type === "weekday").value);
  const names = {};
  for (const fmt of FORMATS) names[fmt] = Array.from({ length: 7 }, (_, d) => new Intl.DateTimeFormat(loc, { weekday: fmt }).format(addDays(sundayAnchor, d)));
  dart += `  ${dartStr(loc)}: SgCalendarLocaleData(\n    selectedTemplate: ${dartStr(template(sf, sample))},\n    monthYearTemplate: ${dartStr(template(mf, sample))},\n    selectedMonths: ${dartList(monthsOf(sf))},\n    monthYearMonths: ${dartList(monthsOf(mf))},\n    selectedWeekdays: ${dartList(selectedWeekdays)},\n    weekdayNames: <String, List<String>>{\n${FORMATS.map((f) => `      ${dartStr(f)}: ${dartList(names[f])},`).join("\n")}\n    },\n  ),\n`;

  // vetores: saidas formatadas direto, como o React faz
  const v = { monthYear: [], selected: [], weekdays: {} };
  for (let i = 0; i < 14; i++) { const d = new Date(2026, i, 1); v.monthYear.push({ date: "2026-" + String(d.getMonth() + 1).padStart(2, "0") + "-01", year: d.getFullYear(), label: capitalizeFirst(mf.format(d), loc) }); }
  for (const [y, m, d] of [[2026, 0, 1], [2026, 2, 1], [2026, 2, 8], [2026, 5, 30], [2026, 9, 24], [2026, 11, 31], [2027, 1, 28], [2028, 1, 29], [2026, 6, 4], [2026, 7, 15]]) {
    v.selected.push({ date: `${y}-${String(m + 1).padStart(2, "0")}-${String(d).padStart(2, "0")}`, label: capitalizeFirst(sf.format(new Date(y, m, d)), loc) });
  }
  for (const fmt of FORMATS) for (const ws of [0, 1, 2, 6]) v.weekdays[`${fmt}-${ws}`] = weekdayLabels(loc, fmt, ws);
  vectors.locales[loc] = v;
}
dart += "};\n";
fs.mkdirSync(path.dirname(dataOut), { recursive: true });
fs.writeFileSync(dataOut, dart);
fs.writeFileSync(vecOut, JSON.stringify(vectors, null, 1) + "\n");
console.log(`calendar: ${LOCALES.length} locales (ICU ${process.versions.icu}) -> ${path.relative(root, dataOut)} e vectors.json`);
