// Gera (1) vetores de paridade do tema e (2) os getters tipados de tokens do SgTheme em Dart.
// Uso: node tools/parity_vectors/generate_theme.mjs <pasta do pacote seedgrid-fe-theme> [saida_vetores.json] [saida_tokens.dart]
// Empacota (esbuild) src/theme/colorUtils.ts, themeGenerator.ts e componentTokens.ts do React e executa as funcoes.
// Deterministico: mesma entrada, mesmos arquivos.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const pkg = path.resolve(process.argv[2] ?? "");
const outJson = path.resolve(process.argv[3] ?? "packages/seedgrid_theme/test/parity/theme_vectors.json");
const outDart = path.resolve(process.argv[4] ?? "packages/seedgrid_theme/lib/src/sg_theme_tokens.g.dart");
const src = path.join(pkg, "src");
if (!fs.existsSync(path.join(src, "theme", "themeGenerator.ts"))) {
  console.error("src/theme/themeGenerator.ts nao encontrado em " + pkg);
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

const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-theme-parity-"));
const bundle = async (entry, name) => {
  const outfile = path.join(tmp, name);
  await esbuild.build({ entryPoints: [path.join(src, "theme", entry)], bundle: true, format: "esm", platform: "node", outfile, logLevel: "error" });
  return import(pathToFileURL(outfile).href);
};
const cu = await bundle("colorUtils.ts", "colorUtils.mjs");
const tg = await bundle("themeGenerator.ts", "themeGenerator.mjs");
const ct = await bundle("componentTokens.ts", "componentTokens.mjs");
fs.rmSync(tmp, { recursive: true, force: true });
const pj = JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8"));

// Igual ao que o SeedThemeProvider faz: variaveis base + tokens de componente.
const themeVars = (input, mode) => {
  const base = tg.generateThemeVars(input, mode);
  return { ...base, ...ct.generateComponentTokens(base) };
};

const seeds = [
  "#000000", "#FFFFFF", "#808080", "#16803D", "#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF",
  "#123456", "#ABCDEF", "#fedcba", "#7F7F7F", "#010101", "#FEFEFE", "#2563EB", "#F59E0B", "#8B5CF6", "#EF4444",
  "#14B8A6", "#6B7280", "#0B0B0C", "  #16803d  ", "16803D", "#C0FFEE", "#BADA55", "#FF8800",
];
const modes = ["light", "dark"];
const sample = ["#16803D", "#000000", "#FFFFFF", "#808080", "#2563EB", "#F59E0B", "#FF00FF", "#123456"];

const hexCases = ["#16803D", "16803D", "  #ABCDEF ", "#abcdef", "#fff", "#12345", "#GGGGGG", "", "#1234567", "##16803D"].map((i) => {
  try { return { in: i, out: cu.hexToRgb(i) }; } catch (e) { return { in: i, error: String(e.message) }; }
});

const doc = {
  fonte: "@seedgrid/fe-theme src/theme (esbuild)",
  versaoReact: pj.version,
  gerador: "tools/parity_vectors/generate_theme.mjs",
  hexToRgb: hexCases,
  rgbToHsl: [[0, 0, 0], [255, 255, 255], [128, 128, 128], [255, 0, 0], [0, 255, 0], [0, 0, 255], [255, 255, 0], [22, 128, 61], [18, 52, 86], [250, 10, 200], [200, 100, 50], [1, 2, 3], [255, 254, 253]]
    .map(([r, g, b]) => ({ in: [r, g, b], out: cu.rgbToHsl(r, g, b) })),
  hslToHex: [[0, 0, 0], [0, 100, 50], [120, 100, 50], [240, 100, 50], [359.9, 50, 50], [60, 100, 25], [180.5, 33.3, 66.6], [145, 80, 56], [5, 85, 48], [210, 80, 56], [45, 85, 48], [300, 100, 100], [30, 20, 10], [270, 55, 75]]
    .map(([h, s, l]) => ({ in: [h, s, l], out: cu.hslToHex(h, s, l) })),
  pickOnColor: ["#000000", "#FFFFFF", "#808080", "#16803D", "#FFFF00", "#7F7F7F", "#FF0000", "#0000FF", "#00FF00", "#BCBCBC", "#8F8F8F"]
    .map((i) => ({ in: i, out: cu.pickOnColor(i), luminance: cu.relativeLuminance(i) })),
  toRgbVarValue: ["#16803D", "#000000", "#FFFFFF"].map((i) => ({ in: i, out: cu.toRgbVarValue(i) })),
  shiftHue: sample.flatMap((s) => [
    { in: [s, 35, 72, 48], out: cu.shiftHue(s, 35, 72, 48) },
    { in: [s, 210, 62, 60], out: cu.shiftHue(s, 210, 62, 60) },
    { in: [s, 0, 10, 98], out: cu.shiftHue(s, 0, 10, 98) },
    { in: [s, -50], out: cu.shiftHue(s, -50) },
    { in: [s, 400, null, 20], out: cu.shiftHue(s, 400, undefined, 20) },
  ]),
  buildScaleFromHex: sample.flatMap((s) => modes.flatMap((m) => [
    { in: [s, m], out: cu.buildScaleFromHex(s, m) },
    { in: [s, m, 4, null], boostS: 4, out: cu.buildScaleFromHex(s, m, { boostS: 4 }) },
    { in: [s, m, null, -7], biasL: -7, out: cu.buildScaleFromHex(s, m, { biasL: -7 }) },
    { in: [s, m, 30, 20], boostS: 30, biasL: 20, out: cu.buildScaleFromHex(s, m, { boostS: 30, biasL: 20 }) },
  ])),
  themes: [],
};

for (const seed of seeds) for (const mode of modes) {
  doc.themes.push({ input: { seed }, mode, vars: themeVars({ seed }, mode) });
}
// Variacoes: raio, cores semanticas e customVars (so alguns seeds, para o JSON nao crescer demais).
for (const seed of ["#16803D", "#2563EB", "#000000"]) for (const mode of modes) {
  const variants = [
    { seed, radius: 8 },
    { seed, radius: 8.5 },
    { seed, radius: 0 },
    { seed, warning: "#FFAA00", error: "#CC0000", info: "#0099FF", success: "#00AA55" },
    { seed, customVars: { "--sg-primary-500": "1 2 3", "--meu-token": "x", "--sg-bg": "9 9 9" } },
  ];
  for (const input of variants) doc.themes.push({ input, mode, vars: themeVars(input, mode) });
}

fs.mkdirSync(path.dirname(outJson), { recursive: true });
fs.writeFileSync(outJson, JSON.stringify(doc, null, 1) + "\n");

// ---- getters tipados em Dart ----
// Regra de nome: tira "--"; tira "sg-" quando existe; camelCase por "-"; segmento numerico gruda
// ("--sg-primary-600" -> primary600, "--sg-btn-primary-hover-bg" -> btnPrimaryHoverBg).
// So tokens "--sg-*" ganham getter. Aliases legados ("--background", "--primary", ...) ficam em `vars`
// e saem por SgTheme.color('--background'). "--sg-mode" e "--sg-radius" viram `mode` e `radius` a mao.
const keys = [];
for (const mode of modes) for (const k of Object.keys(themeVars({ seed: "#16803D" }, mode))) if (!keys.includes(k)) keys.push(k);
const camel = (k) => {
  const parts = k.replace(/^--sg-/, "").split("-");
  return parts.map((p, i) => (i === 0 ? p : p[0].toUpperCase() + p.slice(1))).join("");
};
const getters = [];
const seen = new Map();
for (const k of keys) {
  if (!k.startsWith("--sg-") || k === "--sg-mode" || k === "--sg-radius") continue;
  const name = camel(k);
  if (seen.has(name)) throw new Error(`colisao de nome ${name}: ${seen.get(name)} e ${k}`);
  seen.set(name, k);
  getters.push(`  /// \`${k}\`\n  Color get ${name} => color('${k}');`);
}
fs.mkdirSync(path.dirname(outDart), { recursive: true });
fs.writeFileSync(outDart, `// GERADO por tools/parity_vectors/generate_theme.mjs a partir de @seedgrid/fe-theme ${pj.version}. Nao edite a mao.
// Regra de nome: "--sg-btn-primary-bg" vira btnPrimaryBg (tira "--sg-", camelCase; segmento numerico gruda: primary600).
import 'dart:ui' show Color;

import 'sg_theme.dart';

/// Getters tipados dos tokens \`--sg-*\` (${getters.length}).
extension SgThemeTokens on SgTheme {
${getters.join("\n\n")}
}
`);
console.log(`temas: ${doc.themes.length} (x ${Object.keys(doc.themes[0].vars).length} variaveis) -> ${outJson}`);
console.log(`tokens tipados: ${getters.length} -> ${outDart}`);
