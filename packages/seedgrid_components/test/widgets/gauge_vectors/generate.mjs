// Vetores de paridade dos gauges (SgRadialGauge, SgLinearGauge) e do SgQRCode. A verdade e o CODIGO DO REACT,
// executado de verdade:
//   - math.ts e a geometria pura de SgRadialGauge.tsx (toSweep, polar, arcPath) sao transpilados e chamados;
//   - os componentes SgRadialGauge, SgLinearGauge e SgQRCode (qrcode.react) sao empacotados com esbuild e
//     renderizados com react-dom/server; o SVG resultante e lido (path, line, circle, polygon, rect, text) e
//     vira a "cena" que o Dart precisa reproduzir elemento a elemento.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/gauge_vectors/generate.mjs <pasta do pacote react>
// Gera gauge_vectors/vectors.json e lib/src/gadgets/gauges/qr_tables.g.dart (tabelas de capacidade do QR, tiradas
// do proprio qrcode.react). Deterministico.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { createRequire } from "node:module";
import { pathToFileURL } from "node:url";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.join(root, "packages/seedgrid_components/test/widgets/gauge_vectors/vectors.json");
const tablesOut = path.join(root, "packages/seedgrid_components/lib/src/gadgets/gauges/qr_tables.g.dart");
const gaugeDir = path.join(pkg, "src", "gadgets", "gauge");
if (!fs.existsSync(path.join(gaugeDir, "math.ts"))) {
  console.error("math.ts nao encontrado em " + gaugeDir);
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
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-gauge-"));

// ---------------------------------------------------------------- 1) matematica pura e geometria do radial
async function loadTs(name, source) {
  const r = await esbuild.transform(source, { loader: "ts", format: "esm", target: "es2022" });
  const file = path.join(tmp, name);
  fs.writeFileSync(file, r.code);
  return import(pathToFileURL(file).href);
}
const mathSrc = fs.readFileSync(path.join(gaugeDir, "math.ts"), "utf8");
const radialSrc = fs.readFileSync(path.join(gaugeDir, "SgRadialGauge.tsx"), "utf8");
const a = radialSrc.indexOf("function toSweep");
const b = radialSrc.indexOf("export type SgRadialGaugeRange");
if (a < 0 || b < 0 || b < a) throw new Error("marcadores do SgRadialGauge.tsx nao encontrados");
const M = await loadTs("math.mjs", mathSrc + "\n" + radialSrc.slice(a, b) + "\nexport { toSweep, polar, arcPath };\n");

const nums = [-720, -361, -360, -180, -90, -1, 0, 1, 45, 90, 135, 180, 270, 359, 360, 361, 405, 720, 1e3 + 0.5];
const vectors = { react: JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8")).version, math: {} };

vectors.math.normalizeAngle = nums.map((x) => ({ in: x, out: M.normalizeAngle(x) }));
vectors.math.clamp = [[5, 0, 10], [-5, 0, 10], [15, 0, 10], [0, 0, 0], [5, 10, 0], [3.5, -2.5, 3.5]].map(([v, lo, hi]) => ({ v, lo, hi, out: M.clampGaugeValue(v, lo, hi) }));
vectors.math.normalizeRange = [[0, 100], [10, 10], [10, 5], [NaN, 100], [0, NaN], [-50, 50], [Infinity, 5], [0, Infinity], [3, 3.5]].map(([min, max]) => ({ min: Number.isNaN(min) ? "NaN" : String(min), max: Number.isNaN(max) ? "NaN" : String(max), out: M.normalizeGaugeRange(min, max) }));
const rangesForRatio = [[0, 100], [-50, 50], [10, 20], [0, 1]];
vectors.math.valueToRatio = [];
vectors.math.ratioToValue = [];
for (const [min, max] of rangesForRatio) {
  for (const inv of [false, true]) {
    for (const v of [min - 10, min, min + (max - min) * 0.25, (min + max) / 2, max - 1e-9, max, max + 10]) {
      vectors.math.valueToRatio.push({ raw: v, min, max, inv, out: M.valueToGaugeRatio(v, min, max, inv) });
    }
    for (const r of [-0.5, 0, 0.1, 0.5, 0.999, 1, 1.5]) {
      vectors.math.ratioToValue.push({ ratio: r, min, max, inv, out: M.ratioToGaugeValue(r, min, max, inv) });
    }
  }
}
vectors.math.angleToRadial = [];
for (const [startAngle, sweep] of [[135, 270], [180, 180], [0, 360], [270, 90], [-45, 90]]) {
  for (const rawAngle of [0, 45, 90, 135, 180, 225, 270, 315, 359, -45]) {
    for (const inv of [false, true]) {
      vectors.math.angleToRadial.push({ rawAngle, startAngle, sweep, min: 0, max: 100, inv, out: M.angleToRadialGaugeValue({ rawAngle, startAngle, sweep, min: 0, max: 100, isAxisInversed: inv }) });
    }
  }
}
vectors.math.pointToLinear = [];
for (const [orientation, axisStart, axisEnd] of [["horizontal", { x: 16, y: 80 }, { x: 344, y: 80 }], ["vertical", { x: 100, y: 344 }, { x: 100, y: 16 }], ["horizontal", { x: 20, y: 5 }, { x: 20, y: 5 }]]) {
  for (const [x, y] of [[0, 0], [16, 80], [180, 40], [344, 80], [400, 400], [100, 100], [20, 5]]) {
    for (const inv of [false, true]) {
      vectors.math.pointToLinear.push({ x, y, axisStart, axisEnd, orientation, min: 0, max: 200, inv, out: M.pointToLinearGaugeValue({ x, y, axisStart, axisEnd, orientation, min: 0, max: 200, isAxisInversed: inv }) });
    }
  }
}
vectors.math.pointToAngle = [[10, 0, 0, 0], [0, 10, 0, 0], [-10, 0, 0, 0], [0, -10, 0, 0], [3, 4, 0, 0], [150, 150, 150, 150], [100, 200, 150, 150]].map(([x, y, cx, cy]) => ({ x, y, cx, cy, out: M.pointToRadialGaugeAngle({ x, y, cx, cy }) }));
vectors.math.clientRadial = [];
for (const [clientX, clientY] of [[0, 0], [150, 20], [280, 150], [150, 280], [20, 150], [200, 200], [40, 260]]) {
  for (const inv of [false, true]) {
    const p = { clientX: clientX + 10, clientY: clientY + 20, rect: { left: 10, top: 20, width: 300, height: 300 }, totalWidth: 300, totalHeight: 300, cx: 150, cy: 150, startAngle: 135, sweep: 270, min: 0, max: 100, isAxisInversed: inv };
    vectors.math.clientRadial.push({ clientX: p.clientX, clientY: p.clientY, inv, out: M.clientPointToRadialGaugeValue(p) });
  }
}
vectors.math.clientRadialSemRect = M.clientPointToRadialGaugeValue({ clientX: 1, clientY: 1, rect: { left: 0, top: 0, width: 0, height: 10 }, totalWidth: 300, totalHeight: 300, cx: 150, cy: 150, startAngle: 135, sweep: 270, min: 0, max: 100, isAxisInversed: false });
vectors.math.clientLinear = [];
for (const [clientX, clientY] of [[0, 0], [100, 80], [200, 50], [380, 90], [500, 500]]) {
  const p = { clientX: clientX + 5, clientY: clientY + 7, rect: { left: 5, top: 7, width: 360, height: 120 }, totalWidth: 360, totalHeight: 120, axisStart: { x: 16, y: 80 }, axisEnd: { x: 344, y: 80 }, orientation: "horizontal", min: -10, max: 90, isAxisInversed: false };
  vectors.math.clientLinear.push({ clientX: p.clientX, clientY: p.clientY, out: M.clientPointToLinearGaugeValue(p) });
}
vectors.math.toSweep = [];
for (const s of [0, 45, 135, 180, 270, 360, -90, 725]) for (const e of [0, 45, 90, 135, 180, 270, 359, 360, -45]) vectors.math.toSweep.push({ start: s, end: e, out: M.toSweep(s, e) });
vectors.math.polar = [[150, 150, 100, 0], [150, 150, 100, 90], [150, 150, 100, 135], [150, 150, 0, 77], [0, 0, 1, 33.3], [10, 20, 30, -120]].map(([cx, cy, r, ang]) => ({ cx, cy, r, ang, out: M.polar(cx, cy, r, ang) }));
const parseNumbers = (d) => (d.match(/-?\d+(?:\.\d+)?(?:e[+-]?\d+)?/gi) ?? []).map(Number);
vectors.math.arcPath = [];
for (const [cx, cy, r] of [[150, 150, 100], [100, 80, 40.5]]) {
  for (const [s, e] of [[135, 45], [0, 180], [0, 360], [0, 0], [270, 90], [10, 20], [180, 179], [-45, 200]]) {
    vectors.math.arcPath.push({ cx, cy, r, start: s, end: e, nums: parseNumbers(M.arcPath(cx, cy, r, s, e)) });
  }
}

// ---------------------------------------------------------------- 2) render dos componentes (react-dom/server)
async function bundleRender(entryName, contents) {
  const file = path.join(tmp, entryName);
  await esbuild.build({
    stdin: { contents, resolveDir: pkg, loader: "tsx", sourcefile: entryName + ".tsx" },
    bundle: true,
    platform: "node",
    format: "cjs",
    outfile: file,
    jsx: "automatic",
    logLevel: "error",
    absWorkingDir: pkg,
    define: { "process.env.NODE_ENV": '"production"' },
  });
  return createRequire(import.meta.url)(file);
}
const R = await bundleRender(
  "render.cjs",
  `
import * as React from "react";
import { renderToStaticMarkup } from "react-dom/server";
import { SgRadialGauge } from "./src/gadgets/gauge/SgRadialGauge";
import { SgLinearGauge } from "./src/gadgets/gauge/SgLinearGauge";
import { SgQRCode } from "./src/gadgets/qr-code/SgQRCode";
import { QRCodeSVG } from "qrcode.react";
export const radial = (p: any) => renderToStaticMarkup(React.createElement(SgRadialGauge, p));
export const linear = (p: any) => renderToStaticMarkup(React.createElement(SgLinearGauge, p));
export const qrWrapper = (p: any) => renderToStaticMarkup(React.createElement(SgQRCode, p));
export const qrSvg = (p: any) => renderToStaticMarkup(React.createElement(QRCodeSVG, p));
`,
);

// Le o SVG em uma lista ordenada de primitivas normalizadas.
function attrs(s) {
  const o = {};
  for (const m of s.matchAll(/([a-zA-Z0-9:-]+)="([^"]*)"/g)) o[m[1]] = m[2];
  return o;
}
const num = (v) => (v === undefined ? undefined : Number(v));
const decode = (s) => s.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g, '"').replace(/&#x27;/g, "'");
function parseScene(markup) {
  const scene = [];
  const re = /<(path|line|circle|polygon|rect)\b([^>]*?)\/?>|<text\b([^>]*)>([\s\S]*?)<\/text>/g;
  for (const m of markup.matchAll(re)) {
    if (m[1] === "path") {
      const at = attrs(m[2]);
      scene.push({ t: "path", n: parseNumbers(at.d), stroke: at.stroke, sw: num(at["stroke-width"]), so: num(at["stroke-opacity"]), cap: at["stroke-linecap"] ?? null });
    } else if (m[1] === "line") {
      const at = attrs(m[2]);
      scene.push({ t: "line", x1: num(at.x1), y1: num(at.y1), x2: num(at.x2), y2: num(at.y2), stroke: at.stroke, sw: num(at["stroke-width"]), so: num(at["stroke-opacity"]), cap: at["stroke-linecap"] ?? null });
    } else if (m[1] === "circle") {
      const at = attrs(m[2]);
      scene.push({ t: "circle", cx: num(at.cx), cy: num(at.cy), r: num(at.r), fill: at.fill });
    } else if (m[1] === "polygon") {
      const at = attrs(m[2]);
      scene.push({ t: "polygon", n: parseNumbers(at.points.replace(/,/g, " ")), fill: at.fill });
    } else if (m[1] === "rect") {
      const at = attrs(m[2]);
      scene.push({ t: "rect", x: num(at.x), y: num(at.y), w: num(at.width), h: num(at.height), rx: num(at.rx), fill: at.fill });
    } else {
      const at = attrs(m[3]);
      const cls = at.class ?? "";
      scene.push({ t: "text", x: num(at.x), y: num(at.y), anchor: at["text-anchor"], text: decode(m[4]), tone: cls.includes("fill-muted-foreground") ? "muted" : cls.includes("fill-foreground") ? "foreground" : "?" });
    }
  }
  return scene;
}
// Anotacoes (divs absolutos com left/top em %) e texto do centro.
function parseOverlays(markup) {
  const ann = [];
  for (const m of markup.matchAll(/<div class="pointer-events-none absolute" style="left:([\d.eE+-]+)%;top:([\d.eE+-]+)%;transform:translate\(-50%, -50%\)">([\s\S]*?)<\/div>/g)) {
    ann.push({ left: Number(m[1]), top: Number(m[2]), content: decode(m[3].replace(/<[^>]*>/g, "")) });
  }
  const center = /<div class="pointer-events-none absolute inset-0 flex items-center justify-center">([\s\S]*?)<\/div><\/div>$/.exec(markup);
  const centerTexts = center ? [...center[1].matchAll(/>([^<>]+)</g)].map((x) => decode(x[1])) : [];
  const meter = attrs((/<div class="[^"]*" role="meter"([^>]*)>/.exec(markup) ?? [])[1] ?? "");
  return { annotations: ann, centerTexts, meter: { label: meter["aria-label"], min: num(meter["aria-valuemin"]), max: num(meter["aria-valuemax"]), now: num(meter["aria-valuenow"]) } };
}
const svgRoot = (markup) => attrs((/<svg\b([^>]*)>/.exec(markup) ?? [])[1] ?? "");

// "formatadores" nomeados: o mesmo no JS e no Dart
const FORMATTERS = { hash: (v) => "#" + Math.round(v), plain: undefined };
function withFormatter(props) {
  const p = { ...props };
  if (p.labelFormatter) p.labelFormatter = FORMATTERS[p.labelFormatter];
  return p;
}

const radialCases = [];
const R_BASE = {};
const addRadial = (name, props) => {
  const markup = R.radial(withFormatter({ animate: false, ...props }));
  radialCases.push({ name, props, root: svgRoot(markup), scene: parseScene(markup), ...parseOverlays(markup) });
};
addRadial("padrao", {});
addRadial("valor 37.5", { value: 37.5 });
addRadial("defaultValue", { defaultValue: 80 });
addRadial("min max negativos", { min: -50, max: 50, value: -20 });
addRadial("max <= min cai em +100", { min: 10, max: 5, value: 12 });
addRadial("valor fora da faixa", { value: 250 });
addRadial("invertido", { value: 25, isAxisInversed: true });
addRadial("angulos 180 a 0", { startAngle: 180, endAngle: 0, value: 40 });
addRadial("angulos iguais = 360", { startAngle: 90, endAngle: 90, value: 60 });
addRadial("angulos 270 a 90", { startAngle: 270, endAngle: 90, value: 10 });
addRadial("sem ticks nem rotulos", { showTicks: false, showLabels: false, value: 50 });
addRadial("ticks maiores e menores", { majorTickCount: 10, minorTicksPerInterval: 4, value: 70 });
addRadial("majorTickCount 0 vira 1", { majorTickCount: 0, minorTicksPerInterval: -3 });
addRadial("labelFormatter", { labelFormatter: "hash", value: 33 });
addRadial("axisWidth e radiusFactor", { axisWidth: 20, radiusFactor: 0.6, value: 45 });
addRadial("ringThickness vence axisWidth", { ringThickness: 6, axisWidth: 30 });
addRadial("radiusFactor invalido", { radiusFactor: 0, value: 20 });
addRadial("tamanho pequeno vira 160", { width: 100, height: 120, value: 50 });
addRadial("retangular", { width: 420, height: 240.7, value: 50 });
addRadial("cores", { axisColor: "#112233", primaryPointerColor: "rgb(255 0 0)", value: 65 });
addRadial("ponteiro primario escondido", { showPrimaryPointer: false, value: 50 });
addRadial("primario marker circulo", { primaryPointerType: "marker", primaryPointerSize: 18, value: 60 });
for (const shape of ["circle", "diamond", "triangle", "square"]) addRadial("primario marker " + shape, { primaryPointerType: "marker", primaryPointerShape: shape, value: 35 });
addRadial("primario range", { primaryPointerType: "range", primaryPointerWidth: 10, value: 55 });
addRadial("primario needle largo e rotulo", { primaryPointerWidth: 6, primaryPointerSize: 20, primaryPointerLabel: "ok", value: 90 });
addRadial("ranges", { ranges: [{ start: 0, end: 30, color: "#00ff00" }, { start: 80, end: 40, width: 5, opacity: 0.9 }, { start: -10, end: 500 }], value: 50 });
addRadial("ponteiros extras", {
  pointers: [
    { id: "a", value: 20, type: "marker", shape: "diamond", color: "#abcdef", size: 14 },
    { value: 75, type: "needle", width: 2, size: 8, label: "L" },
    { id: "r", value: 40, type: "range", color: "#ff00ff", width: 5 },
    { value: 150, type: "marker" },
  ],
  value: 60,
});
addRadial("anotacoes", { annotations: [{ content: "A" }, { value: 25, content: "B", radiusFactor: 0.4 }, { angle: 200, content: "C" }], value: 80 });
addRadial("tudo junto", { min: 0, max: 200, value: 120, startAngle: 150, endAngle: 30, majorTickCount: 8, minorTicksPerInterval: 2, labelFormatter: "hash", ranges: [{ start: 0, end: 100, color: "#22c55e" }], pointers: [{ id: "p", value: 30, type: "marker", shape: "square" }], annotations: [{ content: "x", value: 100 }], axisWidth: 18, radiusFactor: 0.8 });
addRadial("aria", { ariaLabel: "Velocidade", value: 5 });

const linearCases = [];
const addLinear = (name, props) => {
  const markup = R.linear(withFormatter({ animate: false, ...props }));
  linearCases.push({ name, props, root: svgRoot(markup), scene: parseScene(markup), ...parseOverlays(markup) });
};
addLinear("padrao", {});
addLinear("valor", { value: 42 });
addLinear("vertical", { orientation: "vertical", value: 70 });
addLinear("invertido", { isAxisInversed: true, value: 30 });
addLinear("vertical invertido", { orientation: "vertical", isAxisInversed: true, value: 30 });
addLinear("min max", { min: -20, max: 80, value: 10 });
addLinear("max <= min", { min: 5, max: 5, value: 5 });
addLinear("sem barra", { barPointer: false, value: 60 });
addLinear("barra grossa", { barThickness: 16, barColor: "#ff8800", axisThickness: 18, axisColor: "#333", value: 80 });
addLinear("sem ticks nem rotulos", { showTicks: false, showLabels: false, value: 50 });
addLinear("so ticks", { showLabels: false, value: 50 });
addLinear("so rotulos", { showTicks: false, value: 50 });
addLinear("ticks", { majorTickCount: 10, minorTicksPerInterval: 3, value: 50 });
addLinear("majorTickCount 0", { majorTickCount: 0, minorTicksPerInterval: -1 });
addLinear("labelFormatter", { labelFormatter: "hash", value: 12 });
addLinear("tamanho minimo", { width: 50, height: 40, value: 20 });
addLinear("vertical tamanho", { orientation: "vertical", width: 200, height: 420, value: 90 });
for (const shape of ["triangle", "inverted-triangle", "circle", "diamond", "rect"]) {
  addLinear("primario " + shape + " horizontal", { primaryPointerShape: shape, primaryPointerSize: 14, value: 55 });
  addLinear("primario " + shape + " vertical", { orientation: "vertical", primaryPointerShape: shape, primaryPointerSize: 14, value: 55 });
}
addLinear("sem ponteiro primario", { showPrimaryPointer: false, value: 50 });
addLinear("cor do ponteiro", { primaryPointerColor: "#ff0000", value: 33 });
addLinear("ranges", { ranges: [{ start: 0, end: 30, color: "#00ff00" }, { start: 90, end: 50, thickness: 6, opacity: 0.8 }, { start: -5, end: 400 }], value: 50 });
addLinear("ponteiros extras", {
  pointers: [{ id: "a", value: 20, shape: "diamond", color: "#abcdef", size: 14 }, { value: 80, label: "L" }, { value: 150, shape: "rect", size: 6 }],
  value: 60,
});
addLinear("ponteiros extras vertical", { orientation: "vertical", pointers: [{ value: 20, label: "Q" }, { value: 80, shape: "inverted-triangle" }], value: 60 });
addLinear("aria", { ariaLabel: "Nivel", value: 5 });

// ---------------------------------------------------------------- 3) QR: matriz de modulos do qrcode.react
function parseQr(markup) {
  const root = attrs((/<svg\b([^>]*)>/.exec(markup) ?? [])[1] ?? "");
  const vb = (root.viewBox ?? "0 0 0 0").split(" ").map(Number);
  const n = vb[2];
  const paths = [...markup.matchAll(/<path\b([^>]*)>/g)].map((m) => attrs(m[1]));
  const fg = paths[1];
  const rows = Array.from({ length: n }, () => Array(n).fill(0));
  for (const m of fg.d.matchAll(/M(\d+)[,\s](\d+)\s*h(\d+)v1H\d+z/g)) {
    const x = Number(m[1]), y = Number(m[2]), w = Number(m[3]);
    for (let i = 0; i < w; i++) rows[y][x + i] = 1;
  }
  return { n, size: Number(root.width), bg: paths[0].fill, fg: fg.fill, rows: rows.map((r) => r.join("")) };
}
const qrCases = [];
const TEXTS = [
  "A",
  "12345678901234567890",
  "HELLO WORLD",
  "HTTPS://SEEDGRID.COM.BR/ABC",
  "https://seedgrid.com.br",
  "Olá, SeedGrid! ção",
  "SeedGrid 🌱 中文",
  "WIFI:S:minha-rede;T:WPA;P:senha123;;",
  "x".repeat(120),
  "0".repeat(300),
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
];
for (const text of TEXTS) {
  for (const level of ["L", "M", "Q", "H"]) {
    for (const margin of [0, 2]) {
      const markup = R.qrSvg({ value: text, size: 220, marginSize: margin, level });
      qrCases.push({ text, level, margin, ...parseQr(markup) });
    }
  }
}
// exemplos que forcam a elevacao do nivel (boostLevel) e versoes altas
for (const text of ["a".repeat(200), "b".repeat(500), "Z".repeat(700)]) {
  for (const level of ["L", "H"]) {
    const markup = R.qrSvg({ value: text, size: 300, marginSize: 1, level });
    qrCases.push({ text, level, margin: 1, ...parseQr(markup) });
  }
}

// Wrapper SgQRCode (div externo e tamanho do SVG)
const qrWrapperCases = [];
const addWrap = (name, props) => {
  const markup = R.qrWrapper(props);
  const outer = attrs((/^<div\b([^>]*)>/.exec(markup) ?? [])[1] ?? "");
  const svg = attrs((/<svg\b([^>]*)>/.exec(markup) ?? [])[1] ?? "");
  qrWrapperCases.push({
    name,
    props,
    empty: markup === "",
    outerStyle: outer.style ?? null,
    svgSize: svg.width ? Number(svg.width) : null,
    viewBox: svg.viewBox ?? null,
    title: (/<title>([^<]*)<\/title>/.exec(markup) ?? [])[1] ?? null,
    hasLogo: markup.includes("<img"),
    logoStyle: (/<span class="absolute[^"]*" style="([^"]*)">/.exec(markup) ?? [])[1] ?? null,
    imgSize: (/<img[^>]* width="(\d+)"/.exec(markup) ?? [])[1] ?? null,
    fallback: markup.includes(">FB<"),
  });
};
addWrap("padrao", { value: "https://seedgrid.com.br" });
addWrap("vazio sem fallback", { value: "" });
addWrap("so espacos", { value: "   " });
addWrap("vazio com fallback", { value: "", emptyFallback: "FB", size: 120 });
addWrap("undefined", {});
addWrap("trim", { value: "  abc  " });
addWrap("tamanho minimo 64", { value: "abc", size: 10 });
addWrap("tamanho fracionario", { value: "abc", size: 100.6 });
addWrap("margem", { value: "abc", margin: 5.4 });
addWrap("margem negativa", { value: "abc", margin: -3 });
addWrap("nivel", { value: "abc", errorCorrectionLevel: "L" });
addWrap("logo padrao", { value: "abc", logoSrc: "x.png" });
addWrap("logo custom", { value: "abc", logoSrc: "x.png", logoSize: 40, logoPadding: 3.4, logoBorderRadius: 4, logoBackgroundColor: "#eee", size: 200 });
addWrap("logo minimo 18", { value: "abc", logoSrc: "x.png", logoSize: 2 });
addWrap("logo maior que o QR", { value: "abc", logoSrc: "x.png", logoSize: 999, size: 100 });
addWrap("logo padding negativo", { value: "abc", logoSrc: "x.png", logoPadding: -4 });

// ---------------------------------------------------------------- 4) tabelas de capacidade do QR (do proprio qrcode.react)
const qrLib = fs.readFileSync(
  (() => {
    const pnpm = path.join(pkg, "..", "..", "node_modules", ".pnpm");
    const dir = fs.readdirSync(pnpm).filter((n) => n.startsWith("qrcode.react@")).sort().pop();
    return path.join(pnpm, dir, "node_modules", "qrcode.react", "lib", "index.js");
  })(),
  "utf8",
);
function table(name) {
  const re = new RegExp(`_QrCode\\.${name} = (\\[[\\s\\S]*?\\n  \\]);`);
  const m = re.exec(qrLib);
  if (!m) throw new Error("tabela nao encontrada: " + name);
  return JSON.parse(m[1].replace(/\/\/[^\n]*/g, "").replace(/,\s*\]/g, "]"));
}
const ecc = table("ECC_CODEWORDS_PER_BLOCK");
const blocks = table("NUM_ERROR_CORRECTION_BLOCKS");
// ordem das linhas no qrcode.react: Low, Medium, Quartile, High
let dart = "// dart format off\n// GERADO por packages/seedgrid_components/test/widgets/gauge_vectors/generate.mjs. NAO EDITE A MAO.\n// Tabelas de capacidade do QR (ISO/IEC 18004), tiradas do qrcode.react (Nayuki, MIT): linhas Low, Medium, Quartile, High;\n// coluna 0 = versao 0 (sem uso).\n\n";
dart += "const List<List<int>> kQrEccCodewordsPerBlock = <List<int>>[\n" + ecc.map((r) => "  [" + r.join(", ") + "],").join("\n") + "\n];\n\n";
dart += "const List<List<int>> kQrNumErrorCorrectionBlocks = <List<int>>[\n" + blocks.map((r) => "  [" + r.join(", ") + "],").join("\n") + "\n];\n";
fs.writeFileSync(tablesOut, dart);

// ---------------------------------------------------------------- 5) QR nas bordas de cada versao (capacidade cheia, modo bytes)
// Cobre alinhamentos, informacao de versao (>= 7), o passo especial da versao 32 e a versao 15 nivel H (a que o pacote `qr` erra).
const rawModules = (v) => {
  let r = (16 * v + 128) * v + 64;
  if (v >= 2) {
    const a = Math.floor(v / 7) + 2;
    r -= (25 * a - 10) * a - 55;
    if (v >= 7) r -= 36;
  }
  return r;
};
const LEVEL_INDEX = { L: 0, M: 1, Q: 2, H: 3 };
const byteCapacity = (v, lv) => {
  const cw = Math.floor(rawModules(v) / 8) - ecc[LEVEL_INDEX[lv]][v] * blocks[LEVEL_INDEX[lv]][v];
  const cc = v <= 9 ? 8 : 16;
  return Math.floor((cw * 8 - 4 - cc) / 8);
};
for (const v of [2, 6, 7, 10, 14, 15, 16, 22, 27, 32, 40]) {
  for (const lv of v === 15 ? ["L", "M", "Q", "H"] : ["L", "H"]) {
    const text = "x".repeat(byteCapacity(v, lv));
    const markup = R.qrSvg({ value: text, size: 200, marginSize: 0, level: lv });
    const parsed = parseQr(markup);
    if (parsed.n !== 4 * v + 17) throw new Error(`versao esperada ${v}, veio ${(parsed.n - 17) / 4} (${lv})`);
    qrCases.push({ text, level: lv, margin: 0, ...parsed });
  }
}

vectors.radial = radialCases;
vectors.linear = linearCases;
vectors.qr = qrCases;
vectors.qrWrapper = qrWrapperCases;
fs.mkdirSync(path.dirname(out), { recursive: true });
fs.writeFileSync(out, JSON.stringify(vectors, null, 1) + "\n");
const total = Object.values(vectors.math).reduce((s, v) => s + (Array.isArray(v) ? v.length : 1), 0);
console.log(`gauges: math ${total} casos, radial ${radialCases.length} cenas, linear ${linearCases.length} cenas; qr ${qrCases.length} matrizes, ${qrWrapperCases.length} wrappers -> ${path.relative(root, out)}`);
