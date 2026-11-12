// Vetores de paridade do SgInputDateTime (P132): a verdade e o CODIGO DO REACT (dateTimeLogic.ts),
// transpilado com esbuild e executado de verdade. Cobre so fusos deterministicos: UTC e deslocamentos fixos
// (fuso "local" depende da maquina e fica fora; IANA entra so com zonas sem horario de verao em 2019-2045:
// America/Sao_Paulo e Asia/Tokyo).
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/datetime_vectors/generate.mjs <pasta do pacote react>
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.join(root, "packages/seedgrid_components/test/widgets/datetime_vectors/vectors.json");
const src = path.join(pkg, "src", "inputs", "dateTimeLogic.ts");
if (!fs.existsSync(src)) {
  console.error("dateTimeLogic.ts nao encontrado em " + src);
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
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-datetime-"));
const r = await esbuild.transform(fs.readFileSync(src, "utf8"), { loader: "ts", format: "esm", target: "es2022" });
fs.writeFileSync(path.join(tmp, "dateTimeLogic.mjs"), r.code);
const L = await import(pathToFileURL(path.join(tmp, "dateTimeLogic.mjs")).href);

const ZONES = ["UTC", "+03:00", "-03:00", "+05:30", "-0330", "+14:00", "America/Sao_Paulo", "Asia/Tokyo"];
const INSTANTS = [
  "2026-11-03T17:30:00.000Z",
  "2026-01-01T00:00:00.000Z",
  "2026-12-31T23:59:59.000Z",
  "2024-02-29T12:00:00.000Z",
  "2026-03-08T02:30:00.000Z",
  "nao-e-data",
  ""
];
const LOCALS = [
  "2026-11-03T14:30",
  "2026-11-03T14:30:45",
  "2026-02-30T10:00",
  "2026-13-01T10:00",
  "2026-11-03T24:00",
  "2026-11-03T10:60",
  "2024-02-29T23:59",
  "2026-11-03",
  "",
  "lixo"
];

const offsets = ["+03:00", "-03:00", "+5:30", "-0330", "+14:00", "+15:00", "+03:60", "UTC", "abc", ""].map((z) => ({
  input: z,
  out: L.parseFixedOffset(z)
}));

const toWall = [];
for (const z of ZONES) for (const i of INSTANTS) for (const s of [false, true])
  toWall.push({ instant: i, zone: z, seconds: s, out: L.instantToWallClock(i, z, s) });

const toInstant = [];
for (const z of ZONES) for (const l of LOCALS)
  toInstant.push({ local: l, zone: z, out: L.wallClockToInstant(l, z) });

const snap = [];
for (const l of ["2026-11-03T14:07", "2026-11-03T14:08", "2026-11-03T23:58", "2026-12-31T23:58", "2026-11-03T14:30:15", "lixo"])
  for (const step of [undefined, 1, 5, 10, 15, 30, 60, 90, 0])
    snap.push({ local: l, step: step ?? null, out: L.snapMinutes(l, step) });

const validate = [];
const cases = [
  { local: "", required: true },
  { local: "", required: false },
  { local: "lixo" },
  { local: "2026-11-03T14:30", min: "2026-11-03T14:30:00.000Z", zone: "UTC" },
  { local: "2026-11-03T14:29", min: "2026-11-03T14:30:00.000Z", zone: "UTC" },
  { local: "2026-11-03T14:31", max: "2026-11-03T14:30:00.000Z", zone: "UTC" },
  { local: "2026-11-03T14:31", min: "2026-11-03T10:00:00.000Z", max: "2026-11-03T14:30:00.000Z", zone: "UTC" },
  { local: "2026-11-03T09:00", min: "2026-11-03T10:00:00.000Z", max: "2026-11-03T14:30:00.000Z", zone: "UTC" },
  { local: "2026-11-03T12:00", min: "2026-11-03T10:00:00.000Z", max: "2026-11-03T14:30:00.000Z", zone: "UTC" },
  { local: "2026-11-03T12:00", min: "2026-11-03T10:00:00.000Z", zone: "-03:00" },
  { local: "2026-11-03T07:00", min: "2026-11-03T10:00:00.000Z", zone: "-03:00" }
];
for (const c of cases)
  validate.push({ ...c, out: L.validateDateTime(c.local, { required: c.required, min: c.min, max: c.max, timeZone: c.zone }) });

const format = [];
for (const l of ["2026-11-03T14:30", "2026-11-03T14:30:45", "2026-01-09T08:05", "2026-11-25T23:59:07", "lixo"])
  for (const loc of ["pt-BR", "pt-PT", "en-US", "es", "fr"])
    for (const s of [false, true])
      format.push({ local: l, locale: loc, seconds: s, out: L.formatWallClock(l, loc, s) });

const formatValue = [];
for (const z of ["UTC", "-03:00", "+05:30", "America/Sao_Paulo", "Asia/Tokyo"])
  for (const l of ["2026-01-15T10:30", "2026-01-15T10:30:15", "2026-07-01T00:00", "2026-02-30T10:00", "lixo", ""])
    for (const m of ["local", "utc", "offset"])
      formatValue.push({ local: l, mode: m, zone: z, out: L.formatDateTimeValue(l, m, z) });

const parseValue = [];
for (const z of ["UTC", "-03:00", "America/Sao_Paulo", "Asia/Tokyo"])
  for (const v of ["2026-01-15T10:30", "2026-01-15T10:30:15", "2026-01-15T13:30:00Z", "2026-01-15T13:30:00.000Z", "2026-01-15T10:30:00-03:00", "2026-01-15T10:30:00+09:00", "lixo", ""])
    for (const s of [false, true])
      parseValue.push({ value: v, zone: z, seconds: s, out: L.parseDateTimeValue(v, z, s) });

fs.writeFileSync(out, JSON.stringify({ offsets, toWall, toInstant, snap, validate, format, formatValue, parseValue }, null, 2) + "\n");
fs.rmSync(tmp, { recursive: true, force: true });
console.log("ok " + out);
