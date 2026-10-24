// Vetores de paridade dos digitos simples (SgSevenSegmentDigit, SgSegmentDigit, SgMatrixDigit, SgNeonDigit,
// SgFadeDigit). A verdade e o CODIGO REAL dos componentes React: renderiza com react-dom/server (geometria,
// glifos, cores, sombras) e com react-dom/client + jsdom (fases da troca de valor do Neon e do Fade).
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/digit_vectors/generate.mjs <pasta do pacote react>
// Gera test/widgets/digit_vectors/vectors.json. A parte dinamica usa relogio real (amostras com folga
// de dezenas de ms), entao o JSON guarda o ESTADO ALVO de cada amostra, nao tempos medidos.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { createRequire } from "node:module";
import { pathToFileURL } from "node:url";

const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.resolve("packages/seedgrid_components/test/widgets/digit_vectors/vectors.json");
if (!fs.existsSync(path.join(pkg, "src", "digits"))) {
  console.error("src/digits nao encontrado em " + pkg);
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
const requireFromPkg = createRequire(path.join(pkg, "package.json"));
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-digits-"));

const comps = {
  SgSevenSegmentDigit: "seven-segment-digit/SgSevenSegmentDigit",
  SgSegmentDigit: "segment-digit/SgSegmentDigit",
  SgMatrixDigit: "matrix-digit/SgMatrixDigit",
  SgNeonDigit: "neon-digit/SgNeonDigit",
  SgFadeDigit: "fade-digit/SgFadeDigit",
};
const importLines = Object.entries(comps)
  .map(([n, p]) => `import { ${n} } from ${JSON.stringify(path.join(pkg, "src", "digits", p + ".tsx").replace(/\\/g, "/"))};`)
  .join("\n");

async function bundle(name, contents) {
  const res = await esbuild.build({
    stdin: { contents, resolveDir: pkg, loader: "tsx", sourcefile: name + ".tsx" },
    bundle: true,
    platform: "node",
    format: "cjs",
    jsx: "automatic",
    write: false,
    logLevel: "error",
    define: { "process.env.NODE_ENV": '"production"' },
  });
  const file = path.join(tmp, name + ".cjs");
  fs.writeFileSync(file, res.outputFiles[0].text);
  return file;
}

const serverFile = await bundle(
  "server",
  `import * as React from "react";\nimport { renderToStaticMarkup } from "react-dom/server";\n${importLines}\nexport { React, renderToStaticMarkup, ${Object.keys(comps).join(", ")} };`,
);
const clientFile = await bundle(
  "client",
  `import * as React from "react";\nimport { createRoot } from "react-dom/client";\n${importLines}\nexport { React, createRoot, ${Object.keys(comps).join(", ")} };`,
);
const server = createRequire(import.meta.url)(serverFile);
const reactVersion = JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8")).version;

// ------------------------------------------------------------------ parse do HTML
const decode = (s) => s.replace(/&quot;/g, '"').replace(/&#x27;/g, "'").replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">");
function tagsOf(html) {
  const list = [];
  for (const m of html.matchAll(/<(\w+)([^>]*?)\/?>/g)) {
    const attrs = {};
    for (const a of m[2].matchAll(/([\w:-]+)="([^"]*)"/g)) attrs[a[1]] = decode(a[2]);
    list.push({ tag: m[1], attrs, style: attrs.style ? styleOf(attrs.style) : {} });
  }
  return list;
}
function styleOf(s) {
  const map = {};
  // separa por ';' fora de parenteses
  let depth = 0, cur = "";
  const parts = [];
  for (const ch of s) {
    if (ch === "(") depth++;
    if (ch === ")") depth--;
    if (ch === ";" && depth === 0) { parts.push(cur); cur = ""; } else cur += ch;
  }
  if (cur) parts.push(cur);
  for (const p of parts) {
    const i = p.indexOf(":");
    if (i > 0) map[p.slice(0, i).trim()] = p.slice(i + 1).trim();
  }
  return map;
}
const px = (v) => (v === undefined ? null : Number.parseFloat(String(v).replace("px", "")));
function splitTop(s) {
  const parts = [];
  let depth = 0, cur = "";
  for (const ch of s) {
    if (ch === "(") depth++;
    if (ch === ")") depth--;
    if (ch === "," && depth === 0) { parts.push(cur.trim()); cur = ""; } else cur += ch;
  }
  if (cur.trim()) parts.push(cur.trim());
  return parts;
}
// "0 0 3px #fff, inset 0 0 14px rgba(0, 0, 0, 0.24)" -> [{inset, blur, color}]
function shadowsOf(s) {
  if (!s || s === "none") return [];
  return splitTop(s).map((layer) => {
    const m = /^(inset )?0 0 ([\d.]+)px (.+)$/.exec(layer);
    if (!m) throw new Error("sombra nao reconhecida: " + layer);
    return { inset: !!m[1], blur: Number(m[2]), color: m[3] };
  });
}

// ------------------------------------------------------------------ PRNG
let seed = 20261024;
const rnd = () => { seed |= 0; seed = (seed + 0x6d2b79f5) | 0; let t = Math.imul(seed ^ (seed >>> 15), 1 | seed); t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 4294967296; };
const pick = (list) => list[Math.floor(rnd() * list.length)];
const render = (Comp, props) => server.renderToStaticMarkup(server.React.createElement(server[Comp], props));

// ------------------------------------------------------------------ seven segment
const sevenValues = [" ", "-", "_", ..."0123456789".split(""), ..."ABCDEFHJLPUY".split(""), ..."abcdefhjlpuy".split(""), "G", "Z", "?", "@", "", "12", "ab", "é", "ß", "😀"];
const sevenPalettes = ["red", "blue", "yellow", "green", "white"];
const sevenSets = [{}];
for (const size of [40, 48, 49.5, 108, 200.4, 300, 47.5]) sevenSets.push({ size });
for (const width of [20, 28, 70.5, 150, 27.5]) sevenSets.push({ width });
for (const thickness of [1, 4, 14, 22.6, 40, 3.5]) sevenSets.push({ thickness });
for (const padding of [0, 2, 10, 30, 100, 1.5]) sevenSets.push({ padding });
for (const palette of sevenPalettes) sevenSets.push({ palette });
sevenSets.push({ color: "#ff00aa", offColor: "rgba(10, 10, 10, 0.5)", backgroundColor: "#000000" });
sevenSets.push({ palette: "blue", color: "#ffffff" });
for (const skew of [0, -8, 15, -20.5]) sevenSets.push({ skew });
sevenSets.push({ glow: false });
for (const rounded of [0, 12, 40]) sevenSets.push({ rounded });
for (const transitionMs of [0, 180, 500]) sevenSets.push({ transitionMs });
for (let i = 0; i < 70; i++) {
  const p = {};
  if (rnd() < 0.7) p.size = Math.round(rnd() * 25000) / 100 + 20;
  if (rnd() < 0.4) p.width = Math.round(rnd() * 12000) / 100 + 10;
  if (rnd() < 0.6) p.thickness = Math.round(rnd() * 3000) / 100;
  if (rnd() < 0.6) p.padding = Math.round(rnd() * 4000) / 100;
  if (rnd() < 0.5) p.palette = pick(sevenPalettes);
  if (rnd() < 0.3) p.glow = rnd() < 0.5;
  sevenSets.push(p);
}
const sevenSegment = [];
sevenSets.forEach((props, i) => {
  const values = i === 0 ? sevenValues : [pick(sevenValues), pick("0123456789ABCDEFHJLPUY-_ ".split(""))];
  for (const value of values) {
    const tags = tagsOf(render("SgSevenSegmentDigit", { value, ...props }));
    const [outer, inner, ...spans] = tags;
    const names = ["a", "b", "c", "d", "e", "f", "g"];
    sevenSegment.push({
      props: { value, ...props },
      panel: { width: px(outer.style.width), height: px(outer.style.height), radius: px(outer.style["border-radius"]), background: outer.style["background-color"], label: outer.attrs["aria-label"] },
      skew: inner.style.transform,
      segments: Object.fromEntries(spans.map((s, k) => [names[k], {
        left: px(s.style.left), top: px(s.style.top), width: px(s.style.width), height: px(s.style.height), radius: px(s.style["border-radius"]),
        color: s.style["background-color"], shadow: shadowsOf(s.style["box-shadow"]), transition: s.style.transition,
      }])),
    });
  }
});

// ------------------------------------------------------------------ segment digit
const segValues = [..."0123456789".split(""), "-", " ", ":", "a", "A", "?", ".", "", "12", ":9", "é", "😀"];
const segSizes = [undefined, 0, 1, 2, 4, 10, 16, 20.5, 33.3, 48, 100, 7.77];
const segmentDigit = [];
for (const value of segValues) for (const size of segSizes) {
  const props = size === undefined ? { value } : { value, size };
  const tags = tagsOf(render("SgSegmentDigit", props));
  const svg = tags[0];
  segmentDigit.push({
    props,
    width: Number(svg.attrs.width), height: Number(svg.attrs.height), viewBox: svg.attrs.viewBox, label: svg.attrs["aria-label"],
    rects: tags.slice(1).map((r) => ({ x: Number(r.attrs.x), y: Number(r.attrs.y), width: Number(r.attrs.width), height: Number(r.attrs.height), rx: Number(r.attrs.rx) })),
  });
}

// ------------------------------------------------------------------ matrix
const matrixValues = ["HELLO", "12:34", "a b", "ß", "straße", "ç", "ñ", "", "?!./", "-_", "@#", "😀A", "ABCDEFGHIJKLM", "NOPQRSTUVWXYZ", "0123456789", "i", "ı", "ǆ"];
const matrixSets = [{}, { dotSize: 4 }, { dotSize: 14 }, { dotSize: 5.5 }, { gap: 0 }, { gap: 8 }, { charGap: 0 }, { charGap: 20 }, { padding: 0 }, { padding: 20 }, { rounded: 0 }, { rounded: 30 }, { glow: false }, { color: "#ff0000", offColor: "#222222", backgroundColor: "#ffffff" }, { dotSize: 3, gap: 1 }];
const matrix = [];
matrixSets.forEach((props, i) => {
  const values = i === 0 ? matrixValues : [pick(matrixValues), pick(matrixValues)];
  for (const value of values) {
    const full = { value, color: "#22d3ee", offColor: "rgba(148, 163, 184, 0.22)", ...props };
    const tags = tagsOf(render("SgMatrixDigit", { value, ...props }));
    const [outerDiv, ...rest] = tags;
    const chars = [];
    let cur = null;
    for (const t of rest) {
      if (t.tag === "div") { cur = { grid: { columns: t.style["grid-template-columns"], rows: t.style["grid-template-rows"], gap: px(t.style.gap) }, bits: [], glowBlur: null }; chars.push(cur); }
      else if (t.tag === "span") {
        const active = t.style["background-color"] === full.color;
        cur.bits.push(active ? "1" : "0");
        if (active && t.style["box-shadow"] && t.style["box-shadow"] !== "none") cur.glowBlur = shadowsOf(t.style["box-shadow"])[0].blur;
      }
    }
    matrix.push({
      props: { value, ...props },
      outer: { gap: px(outerDiv.style.gap), padding: px(outerDiv.style.padding), radius: px(outerDiv.style["border-radius"]), background: outerDiv.style["background-color"], label: outerDiv.attrs["aria-label"] },
      chars: chars.map((c) => ({ ...c, rows: Array.from({ length: 7 }, (_, r) => c.bits.slice(r * 5, r * 5 + 5).join("")) })),
    });
  }
});

// ------------------------------------------------------------------ neon (estatico)
const neonSets = [{}];
for (const fontSize of [8, 12, 20, 46, 80, 120, 33.3]) neonSets.push({ fontSize });
for (const shadowStrength of [0, 0.1, 0.2, 0.5, 1, 2, 3.5]) neonSets.push({ shadowStrength });
neonSets.push({ color: "#ff00aa", shadowColor: "#00ffcc" });
neonSets.push({ color: "rgb(10, 200, 30)" });
neonSets.push({ backgroundColor: "#000000", padding: 0, rounded: 0 });
neonSets.push({ padding: 30, rounded: 40 });
neonSets.push({ letterSpacing: 4 });
neonSets.push({ fontWeight: 300 });
neonSets.push({ fontWeight: "bold" });
neonSets.push({ fontFamily: "Courier New" });
neonSets.push({ font: "Georgia", fontFamily: "Courier New" });
neonSets.push({ transitionMs: 0 });
neonSets.push({ transitionMs: 100 });
neonSets.push({ transitionMs: 1000 });
neonSets.push({ transitionMs: 61 });
for (let i = 0; i < 24; i++) neonSets.push({ fontSize: Math.round(rnd() * 11000) / 100 + 6, shadowStrength: Math.round(rnd() * 400) / 100, transitionMs: Math.round(rnd() * 900) });
const neonStatic = neonSets.map((props) => {
  const p = { value: "8", ...props };
  const [outer, span] = tagsOf(render("SgNeonDigit", p));
  return {
    props: p,
    outer: { padding: px(outer.style.padding), radius: px(outer.style["border-radius"]), background: outer.style["background-color"], shadows: shadowsOf(outer.style["box-shadow"]), transition: outer.style.transition, filter: outer.style.filter },
    text: { color: span.style.color, fontSize: px(span.style["font-size"]), fontWeight: span.style["font-weight"], lineHeight: span.style["line-height"], letterSpacing: px(span.style["letter-spacing"]), fontFamily: span.style["font-family"] ?? null, opacity: Number(span.style.opacity), shadows: shadowsOf(span.style["text-shadow"]), transition: span.style.transition, filter: span.style.filter },
  };
});

// ------------------------------------------------------------------ fade (estatico)
const fadeSets = [{}];
for (const fontSize of [8, 12, 20, 50, 70, 100, 12.5, 33.3, 5, 1]) fadeSets.push({ fontSize });
fadeSets.push({ color: "#ff0000", backgroundColor: "#ffffff" });
fadeSets.push({ font: "Georgia" });
for (let i = 0; i < 10; i++) fadeSets.push({ fontSize: Math.round(rnd() * 9000) / 100 + 4 });
const fadeStatic = fadeSets.map((props) => {
  const p = { value: "5", ...props };
  const tags = tagsOf(render("SgFadeDigit", p));
  const [outer, divider, gloss, digit] = tags;
  return {
    props: p,
    card: { width: px(outer.style.width), height: px(outer.style.height), radius: px(outer.style["border-radius"]), background: outer.style["background-color"], shadow: outer.style["box-shadow"] },
    dividerTop: px(divider.style.top),
    text: { fontSize: px(digit.style["font-size"]), color: digit.style.color, fontFamily: digit.style["font-family"] ?? null, fontWeight: digit.style["font-weight"], lineHeight: digit.style["line-height"], opacity: Number(digit.style.opacity), transition: digit.style.transition },
  };
});

// ------------------------------------------------------------------ dinamico (jsdom, relogio real)
const { JSDOM } = requireFromPkg("jsdom");
const dom = new JSDOM('<!doctype html><html><body></body></html>', { pretendToBeVisual: true });
for (const k of ["window", "document", "navigator", "HTMLElement", "Node", "MutationObserver"]) {
  Object.defineProperty(globalThis, k, { value: dom.window[k], configurable: true, writable: true });
}
globalThis.IS_REACT_ACT_ENVIRONMENT = false;
const client = createRequire(import.meta.url)(clientFile);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function runDynamic(Comp, before, after, samples, snapshot) {
  const host = dom.window.document.createElement("div");
  dom.window.document.body.appendChild(host);
  const root = client.createRoot(host);
  root.render(client.React.createElement(client[Comp], before));
  await sleep(60);
  const t0 = Date.now();
  root.render(client.React.createElement(client[Comp], after));
  const taken = [];
  for (const at of samples) {
    const wait = at - (Date.now() - t0);
    if (wait > 0) await sleep(wait);
    taken.push({ atMs: at, ...snapshot(host) });
  }
  root.unmount();
  host.remove();
  return { before, after, samples: taken };
}
const neonSnap = (host) => {
  const [outer, span] = [host.firstElementChild, host.firstElementChild.firstElementChild];
  return { text: span.textContent, opacity: Number(span.style.opacity), lit: span.style.opacity === "1", textShadowLayers: shadowsOf(span.style.textShadow).length, boxShadowLayers: shadowsOf(outer.style.boxShadow).length };
};
const fadeSnap = (host) => {
  const digit = host.firstElementChild.lastElementChild;
  return { text: digit.textContent, opacity: Number(digit.style.opacity) };
};
const neonDynamic = [];
neonDynamic.push(await runDynamic("SgNeonDigit", { value: "1" }, { value: "2" }, [50, 300, 400], neonSnap));
neonDynamic.push(await runDynamic("SgNeonDigit", { value: "1", transitionMs: 1000 }, { value: "2", transitionMs: 1000 }, [100, 350, 800], neonSnap));
neonDynamic.push(await runDynamic("SgNeonDigit", { value: "1", transitionMs: 0 }, { value: "2", transitionMs: 0 }, [400], neonSnap));
neonDynamic.push(await runDynamic("SgNeonDigit", { value: "1", animateOnChange: false }, { value: "2", animateOnChange: false }, [30, 400], neonSnap));
neonDynamic.push(await runDynamic("SgNeonDigit", { value: "1" }, { value: "1" }, [400], neonSnap));
const fadeDynamic = [];
fadeDynamic.push(await runDynamic("SgFadeDigit", { value: "1" }, { value: "2" }, [50, 140, 330, 500], fadeSnap));
fadeDynamic.push(await runDynamic("SgFadeDigit", { value: "1" }, { value: "1" }, [300], fadeSnap));

const doc = { fonte: "@seedgrid/fe-components src/digits (react-dom/server + jsdom)", versaoReact: reactVersion, gerador: "test/widgets/digit_vectors/generate.mjs", sevenSegment, segmentDigit, matrix, neonStatic, neonDynamic, fadeStatic, fadeDynamic };
fs.mkdirSync(path.dirname(out), { recursive: true });
fs.writeFileSync(out, JSON.stringify(doc, null, 1) + "\n");
const count = sevenSegment.length + segmentDigit.length + matrix.length + neonStatic.length + neonDynamic.length + fadeStatic.length + fadeDynamic.length;
console.log(`vetores: ${count} casos (seven ${sevenSegment.length}, segment ${segmentDigit.length}, matrix ${matrix.length}, neon ${neonStatic.length}+${neonDynamic.length}, fade ${fadeStatic.length}+${fadeDynamic.length}) -> ${path.relative(process.cwd(), out)}`);
process.exit(0);
