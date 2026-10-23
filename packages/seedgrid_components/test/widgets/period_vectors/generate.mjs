// Vetores de paridade de SgPeriodSelector (resolvePeriod, periodPresetLabel, buildPeriodOptions, parseIsoDate)
// e de yearPart (resolveYearPart e demais). A verdade e o CODIGO DO REACT, executado de verdade:
//   - yearPart.ts e transpilado inteiro (esbuild) e importado;
//   - de SgPeriodSelector.tsx usa-se so a parte pura (do `export enum PeriodPreset` ate o tipo
//     SgPeriodSelectorBaseProps), sem o componente nem seus imports de UI.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/period_vectors/generate.mjs <pasta do pacote react>
// Gera packages/seedgrid_components/test/widgets/period_vectors/vectors.json. Datas saem como texto local
// (yyyy-MM-ddTHH:mm:ss.SSS), lido pelos getters locais: nao depende do fuso. Deterministico.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.join(root, "packages/seedgrid_components/test/widgets/period_vectors/vectors.json");
const inputs = path.join(pkg, "src", "inputs");
if (!fs.existsSync(path.join(inputs, "yearPart.ts"))) {
  console.error("yearPart.ts nao encontrado em " + inputs);
  process.exit(2);
}

function findEsbuild(start) {
  let dir = start;
  for (let i = 0; i < 8; i++) {
    const pnpm = path.join(dir, "node_modules", ".pnpm");
    if (fs.existsSync(pnpm)) {
      const hit = fs.readdirSync(pnpm).filter((n) => /^esbuild@/.test(n)).sort().pop();
      if (hit) return path.join(pnpm, hit, "node_modules", "esbuild", "lib", "main.js");
    }
    dir = path.dirname(dir);
  }
  throw new Error("esbuild nao encontrado a partir de " + start);
}
const esbuild = await import(pathToFileURL(findEsbuild(pkg)).href);
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-period-"));
async function load(name, source) {
  const r = await esbuild.transform(source, { loader: "ts", format: "esm", target: "es2022" });
  const file = path.join(tmp, name);
  fs.writeFileSync(file, r.code);
  return import(pathToFileURL(file).href);
}

const yearPartSrc = fs.readFileSync(path.join(inputs, "yearPart.ts"), "utf8");
const yp = await load("yearPart.mjs", yearPartSrc);

const periodSrc = fs.readFileSync(path.join(inputs, "SgPeriodSelector.tsx"), "utf8");
const a = periodSrc.indexOf("export enum PeriodPreset");
const b = periodSrc.indexOf("type SgPeriodSelectorBaseProps");
if (a < 0 || b < 0 || b < a) throw new Error("marcadores do SgPeriodSelector.tsx nao encontrados");
// Os tipos importados (SgAutocompleteItem) so aparecem em anotacoes: o transform os apaga.
const ps = await load("period.mjs", periodSrc.slice(a, b) + "\nexport { parseIsoDate };\n");

const pad = (n, w = 2) => String(n).padStart(w, "0");
const iso = (d) =>
  d == null ? null : `${pad(d.getFullYear(), 4)}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}.${pad(d.getMilliseconds(), 3)}`;
const day = (y, m, d) => new Date(y, m - 1, d, 13, 30, 15, 250);

const PRESETS = Object.values(ps.PeriodPreset);
const LOCALES = ["pt-BR", "en-US", "es", "pt-PT", "fr", "xx-YY"];

// Datas de referencia: bissexto, fim de mes, virada de ano, virada de quinzena, segunda e domingo, meses de 31 dias.
const REFS = [
  [2024, 2, 29], [2023, 2, 28], [2024, 1, 1], [2024, 12, 31], [2024, 6, 15], [2024, 6, 16], [2024, 3, 31],
  [2023, 12, 15], [2024, 7, 1], [2024, 5, 31], [2024, 8, 31], [2025, 1, 15], [2024, 12, 16], [2024, 1, 16],
  [2024, 9, 1], [2024, 9, 2], [2024, 9, 8], [2021, 3, 1], [2100, 2, 28], [2000, 2, 29], [2026, 10, 24], [2024, 10, 31],
];

const periodResolve = [];
for (const [y, m, d] of REFS) {
  const ref = day(y, m, d);
  for (const preset of PRESETS) {
    const r = ps.resolvePeriod(preset, ref, { locale: "pt-BR" });
    periodResolve.push({ ref: iso(ref), preset, locale: "pt-BR", label: r.label, start: iso(r.startDate), end: iso(r.endDate) });
  }
}
// labels em todos os locales (inclusive um desconhecido) para todos os presets
const periodLabels = [];
for (const preset of PRESETS) for (const loc of LOCALES) periodLabels.push({ preset, locale: loc, label: ps.periodPresetLabel(preset, loc) });
// locale padrao e locale nas opcoes de resolvePeriod
const periodLocaleOpt = [];
for (const preset of ["TODAY", "THIS_MONTH", "ALL", "CUSTOM", "LAST_QUINZENA"]) {
  for (const loc of LOCALES) {
    const r = ps.resolvePeriod(preset, day(2024, 6, 15), { locale: loc });
    periodLocaleOpt.push({ preset, locale: loc, label: r.label });
  }
}
// sem options: locale padrao pt-BR
const periodDefaultLocale = ps.resolvePeriod("THIS_YEAR", day(2024, 6, 15)).label;

// clamp com minDate/maxDate
const CLAMPS = [
  { min: [2024, 6, 10], max: null }, { min: null, max: [2024, 6, 20] }, { min: [2024, 6, 10], max: [2024, 6, 20] },
  { min: [2020, 1, 1], max: [2030, 1, 1] }, { min: [2024, 6, 20], max: [2024, 6, 10] },
];
const periodClamp = [];
for (const c of CLAMPS) {
  for (const preset of ["TODAY", "THIS_WEEK", "THIS_MONTH", "THIS_QUARTER", "THIS_YEAR", "LAST_MONTH", "NEXT_YEAR", "ALL"]) {
    const ref = day(2024, 6, 15);
    const o = { locale: "pt-BR" };
    const minD = c.min ? new Date(c.min[0], c.min[1] - 1, c.min[2], 8, 0, 0, 0) : null;
    const maxD = c.max ? new Date(c.max[0], c.max[1] - 1, c.max[2], 18, 0, 0, 0) : null;
    if (minD) o.minDate = minD;
    if (maxD) o.maxDate = maxD;
    const r = ps.resolvePeriod(preset, ref, o);
    periodClamp.push({ ref: iso(ref), preset, min: iso(minD), max: iso(maxD), start: iso(r.startDate), end: iso(r.endDate) });
  }
}

// buildPeriodOptions
const FLAGS = ["permitAll", "allowCustomPeriod", "permitCurrent", "permitFuture", "permitPast"];
const configs = [{}, Object.fromEntries(FLAGS.map((f) => [f, true])), Object.fromEntries(FLAGS.map((f) => [f, false]))];
for (const f of FLAGS) configs.push({ [f]: true });
configs.push({ permitCurrent: true, permitPast: true });
configs.push({ permitAll: true, allowCustomPeriod: true, permitFuture: true });
const periodOptions = [];
for (const config of configs) for (const loc of ["pt-BR", "en-US", "es", "pt-PT", "fr", "xx-YY"]) {
  periodOptions.push({ config, locale: loc, options: ps.buildPeriodOptions(config, loc).map((o) => ({ id: o.id, label: o.label, group: o.group })) });
}
const periodOptionsDefaultLocale = ps.buildPeriodOptions({ permitAll: true, permitCurrent: true }).map((o) => ({ id: o.id, label: o.label, group: o.group }));

// parseIsoDate (a conversao do <input type=date>); datas parciais do input nativo e dias que nao existem
const ISO_INPUTS = ["2026-09-19", "0002-09-19", "0020-09-19", "0202-09-19", "1000-01-01", "999-01-01", "2026-13-01", "2026-00-10", "2026-02-31", "2026-04-31", "2024-02-30", "2026-01-32", "2026-01-00", "", "abc", "2026-9-19", "2026-09-19 ", " 2026-09-19", "9999-12-31", "2026-12-31", "2024-02-29", "2023-02-29"];
const parseIso = ISO_INPUTS.map((value) => ({ value, date: iso(ps.parseIsoDate(value)) }));

// ------------------------------------------------------------ yearPart
const KINDS = Object.values(yp.YearPartKind);
const YEARS = [1999, 2000, 2023, 2024, 2025, 2100, 2026];
const yearPart = {
  kinds: KINDS,
  count: Object.fromEntries(KINDS.map((k) => [k, yp.yearPartCount(k)])),
  months: Object.fromEntries(KINDS.map((k) => [k, yp.yearPartMonths(k)])),
  kindLabels: [],
  labels: [],
  options: [],
  valid: [],
  clamp: [],
  resolve: [],
  errors: [],
  of: [],
};
for (const k of KINDS) for (const loc of LOCALES) yearPart.kindLabels.push({ kind: k, locale: loc, label: yp.yearPartKindLabel(k, loc) });
for (const k of KINDS) for (const loc of LOCALES) for (let p = 0; p <= 8; p++) yearPart.labels.push({ kind: k, part: p, locale: loc, label: yp.yearPartLabel(k, p, loc) });
for (const k of KINDS) for (const loc of LOCALES) yearPart.options.push({ kind: k, locale: loc, options: yp.yearPartOptions(k, loc) });
yearPart.defaultLocale = { kindLabel: yp.yearPartKindLabel("QUARTER"), label: yp.yearPartLabel("QUARTER", 2), options: yp.yearPartOptions("SEMESTER") };
for (const k of KINDS) for (const p of [-1, 0, 1, 2, 3, 4, 5, 6, 7, 1.5, NaN]) {
  yearPart.valid.push({ kind: k, part: Number.isNaN(p) ? "NaN" : p, valid: yp.isValidYearPart(k, p) });
  yearPart.clamp.push({ kind: k, part: Number.isNaN(p) ? "NaN" : p, clamped: yp.clampYearPart(k, p) });
}
for (const y of YEARS) for (const k of KINDS) for (let p = 1; p <= yp.yearPartCount(k); p++) for (const loc of ["pt-BR", "en-US", "fr", "xx-YY"]) {
  const r = yp.resolveYearPart({ year: y, kind: k, part: p }, loc);
  yearPart.resolve.push({ year: y, kind: k, part: p, locale: loc, label: r.label, start: iso(r.startDate), end: iso(r.endDate), value: r.value });
}
const bad = [{ year: 2024, kind: "SEMESTER", part: 0 }, { year: 2024, kind: "SEMESTER", part: 3 }, { year: 2024, kind: "QUARTER", part: 5 }, { year: 2024, kind: "BIMESTER", part: 7 }, { year: 2024, kind: "BIMESTER", part: 1.5 }, { year: 2024.5, kind: "QUARTER", part: 1 }, { year: NaN, kind: "QUARTER", part: 1 }];
for (const v of bad) {
  try {
    yp.resolveYearPart(v);
    yearPart.errors.push({ input: { year: Number.isNaN(v.year) ? "NaN" : v.year, kind: v.kind, part: v.part }, error: null });
  } catch (e) {
    yearPart.errors.push({ input: { year: Number.isNaN(v.year) ? "NaN" : v.year, kind: v.kind, part: v.part }, error: e.constructor.name + ": " + e.message });
  }
}
const OF = [[2024, 1, 1], [2024, 1, 31], [2024, 2, 29], [2024, 3, 31], [2024, 4, 1], [2024, 6, 30], [2024, 7, 1], [2024, 8, 31], [2024, 9, 1], [2024, 10, 31], [2024, 11, 1], [2024, 12, 31], [2023, 5, 15]];
for (const [y, m, d] of OF) for (const k of KINDS) yearPart.of.push({ date: iso(day(y, m, d)), kind: k, value: yp.yearPartOf(day(y, m, d), k) });

const doc = {
  fonte: "@seedgrid/fe-components src/inputs/{SgPeriodSelector.tsx (parte pura), yearPart.ts} executados via esbuild",
  versaoReact: JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8")).version,
  presets: PRESETS,
  period: { resolve: periodResolve, labels: periodLabels, localeOpt: periodLocaleOpt, defaultLocaleLabel: periodDefaultLocale, clamp: periodClamp, options: periodOptions, optionsDefaultLocale: periodOptionsDefaultLocale, parseIso },
  yearPart,
};
fs.writeFileSync(out, JSON.stringify(doc, null, 1) + "\n");
fs.rmSync(tmp, { recursive: true, force: true });
const n = periodResolve.length + periodLabels.length + periodLocaleOpt.length + periodClamp.length + periodOptions.length + parseIso.length + yearPart.kindLabels.length + yearPart.labels.length + yearPart.options.length + yearPart.valid.length + yearPart.clamp.length + yearPart.resolve.length + yearPart.errors.length + yearPart.of.length;
console.log(`period/yearPart: ${n} casos -> ${path.relative(root, out)}`);
