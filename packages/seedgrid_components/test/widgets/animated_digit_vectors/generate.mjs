// Vetores de paridade dos digitos animados (SgFlipDigit, SgRoller3DDigit, SgDiscardDigit).
// A verdade e o codigo REAL do React e do @pqina/flip:
//   - easing: as funcoes do flip.js (ease-out-bounce, ease-out-cubic, ease-out-sine), extraidas do fonte e executadas;
//   - roller e discard: os componentes React renderizados no servidor (react-dom/server), de onde se le
//     largura, altura, deslocamento do tambor, folhas da pilha e posicao do cartao.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/animated_digit_vectors/generate.mjs <pacote react>
//   (<pacote react> = ../seedgrid-fe-components/packages/seedgrid-fe-components)
// Deterministico: mesma entrada, mesmo JSON.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { createRequire } from "node:module";
import { pathToFileURL } from "node:url";

const pkg = path.resolve(process.argv[2] ?? "");
const out = path.resolve("packages/seedgrid_components/test/widgets/animated_digit_vectors/vectors.json");
if (!fs.existsSync(path.join(pkg, "src", "digits"))) {
  console.error("src/digits nao encontrado em " + pkg);
  process.exit(2);
}

function findPnpm(start, prefix, rel) {
  let dir = start;
  for (let i = 0; i < 8; i++) {
    const pnpm = path.join(dir, "node_modules", ".pnpm");
    if (fs.existsSync(pnpm)) {
      const hit = fs.readdirSync(pnpm).filter((n) => n.startsWith(prefix)).sort().pop();
      if (hit) return path.join(pnpm, hit, "node_modules", ...rel);
    }
    dir = path.dirname(dir);
  }
  throw new Error(prefix + " nao encontrado");
}

// ------------------------------------------------------------------ easing do flip.js real
const flipJs = fs.readFileSync(findPnpm(pkg, "@pqina+flip@", ["@pqina", "flip", "dist", "flip.js"]), "utf8");
const grab = (name) => {
  const m = new RegExp("var " + name + " = function " + name + "\\(t\\) \\{[\\s\\S]*?\\n\\};").exec(flipJs);
  if (!m) throw new Error("funcao nao encontrada: " + name);
  return m[0];
};
const ease = new Function(
  [grab("easeOutBounce"), grab("easeOutCubic"), grab("easeOutSine"), "return { easeOutBounce, easeOutCubic, easeOutSine };"].join("\n"),
)();
const ts = Array.from({ length: 101 }, (_, i) => i / 100);
const easing = {
  easeOutBounce: ts.map((t) => ease.easeOutBounce(t)),
  easeOutCubic: ts.map((t) => ease.easeOutCubic(t)),
  easeOutSine: ts.map((t) => ease.easeOutSine(t)),
};
const flipDefaults = /flipDuration: (\d+),\s*flipEasing: '([^']+)'/.exec(flipJs);

// ------------------------------------------------------------------ componentes React renderizados
const esbuild = await import(pathToFileURL(findPnpm(pkg, "esbuild@", ["esbuild", "lib", "main.js"])).href);
const requireFromPkg = createRequire(path.join(pkg, "package.json"));
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-digits-"));
// Empacota o componente junto com react e react-dom/server (mesma instancia de React) e devolve render(props).
async function load(rel, exportName) {
  const outfile = path.join(tmp, exportName + ".cjs");
  const entry = path.join(pkg, "src", rel).split(path.sep).join("/");
  await esbuild.build({
    stdin: {
      contents: "import * as React from \"react\"; import { renderToStaticMarkup } from \"react-dom/server\"; import { " + exportName + " } from \"" + entry + "\"; export const render = (props) => renderToStaticMarkup(React.createElement(" + exportName + ", props));",
      resolveDir: pkg,
      loader: "tsx",
    },
    bundle: true,
    format: "cjs",
    platform: "node",
    outfile,
    logLevel: "error",
  });
  return requireFromPkg(outfile).render;
}
const renderRoller = await load("digits/roller3d-digit/SgRoller3DDigit.tsx", "SgRoller3DDigit");
const renderDiscard = await load("digits/discard-digit/SgDiscardDigit.tsx", "SgDiscardDigit");
const px = (s, re) => {
  const m = re.exec(s);
  return m ? Number(m[1]) : null;
};

const MINUTES = Array.from({ length: 60 }, (_, i) => String(i).padStart(2, "0"));
const ALPHA = Array.from("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
const DIGITS = Array.from("0123456789");
const rollerCases = [];
for (const fontSize of [12, 16, 22, 24, 32, 40, 72, 17.5]) {
  for (const [name, items, values] of [
    ["digitos", undefined, ["0", "3", "9", "x"]],
    ["minutos", MINUTES, ["00", "42", "59"]],
    ["alfabeto", ALPHA, ["A", "M", "Z"]],
    ["curtos", DIGITS, ["5"]],
  ]) {
    for (const value of values) {
      const html = renderRoller({ value, items, fontSize });
      rollerCases.push({
        grupo: name,
        value,
        items: items ?? null,
        fontSize,
        width: px(html, /^<div[^>]*style="width:(-?[\d.]+)px/),
        height: px(html, /^<div[^>]*style="[^"]*height:(-?[\d.]+)px/),
        translateY: px(html, /translateY\((-?[\d.]+)px\)/),
        itemHeight: px(html, /style="height:(-?[\d.]+)px;font-size/),
      });
    }
  }
}
// transitionMs padrao e defaults de fontSize
const rollerDefault = renderRoller({ value: "7" });
const rollerDefaults = {
  fontSize: px(rollerDefault, /font-size:(-?[\d.]+)px/),
  transitionMs: px(rollerDefault, /transition-duration:(-?[\d.]+)ms/),
};

const discardCases = [];
for (const fontSize of [20, 40, 64, 72, 100, 18.5]) {
  for (const [stackDepth, totalNumberPages] of [[20, undefined], [2, undefined], [30, undefined], [5, undefined], [99, undefined], [0, undefined], [20, 8], [20, 1], [20, 100]]) {
    const html = renderDiscard({ value: "7", fontSize, stackDepth, totalNumberPages });
    const root = /^<div[^>]*style="[^"]*width:(-?[\d.]+)px;height:(-?[\d.]+)px/.exec(html);
    const sheets = [...html.matchAll(/<div aria-hidden="true" style="position:absolute;top:(-?[\d.]+)px;left:(-?[\d.]+)px;width:(-?[\d.]+)px;height:(-?[\d.]+)px;border-radius:(-?[\d.]+)px;[^"]*opacity:(-?[\d.]+);z-index:(\d+)/g)].map((m) => ({
      top: Number(m[1]), left: Number(m[2]), width: Number(m[3]), height: Number(m[4]), radius: Number(m[5]), opacity: Number(m[6]), zIndex: Number(m[7]),
    }));
    const main = /<div style="position:absolute;top:(-?[\d.]+)px;left:(-?[\d.]+)px;width:(-?[\d.]+)px;height:(-?[\d.]+)px;border-radius:(-?[\d.]+)px;[^"]*z-index:(\d+)/.exec(html);
    const textSize = px(html, /<span style="position:relative;z-index:1;[^"]*font-size:(-?[\d.]+)px/);
    discardCases.push({
      fontSize,
      stackDepth,
      totalNumberPages: totalNumberPages ?? null,
      width: Number(root[1]),
      height: Number(root[2]),
      sheets,
      main: main ? { top: Number(main[1]), left: Number(main[2]), width: Number(main[3]), height: Number(main[4]), radius: Number(main[5]), zIndex: Number(main[6]) } : null,
      textSize,
    });
  }
}
const discardDefaultHtml = renderDiscard({ value: "7" });
const discardDefaults = {
  width: Number(/^<div[^>]*style="[^"]*width:(-?[\d.]+)px/.exec(discardDefaultHtml)[1]),
  sheets: (discardDefaultHtml.match(/<div aria-hidden="true" style="position:absolute;top:/g) ?? []).length,
  textSize: px(discardDefaultHtml, /<span style="position:relative;z-index:1;[^"]*font-size:(-?[\d.]+)px/),
  fontWeight: px(discardDefaultHtml, /font-weight:(\d+)/),
  color: /color:([^;]+);font-size/.exec(discardDefaultHtml)?.[1] ?? null,
};

fs.rmSync(tmp, { recursive: true, force: true });
const doc = {
  fonte: "@pqina/flip 1.8.4 (flip.js) e src/digits do @seedgrid/fe-components renderizado com react-dom/server",
  versaoReact: JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8")).version,
  flip: { duracaoMs: Number(flipDefaults[1]), easing: flipDefaults[2], ts, easing_vals: easing },
  roller: { defaults: rollerDefaults, casos: rollerCases },
  discard: { defaults: discardDefaults, casos: discardCases },
};
fs.mkdirSync(path.dirname(out), { recursive: true });
fs.writeFileSync(out, JSON.stringify(doc, null, 1) + "\n");
console.log(`vetores: easing ${ts.length}x3, roller ${rollerCases.length}, discard ${discardCases.length} -> ${path.relative(process.cwd(), out)}`);
