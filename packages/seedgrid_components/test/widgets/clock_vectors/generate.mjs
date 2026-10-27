// Vetores de paridade do relogio: executa os componentes REAIS do React (SgClock, SgTimeProvider, temas
// embutidos) por renderizacao no servidor (react-dom/server) e grava:
//   - themes.json    os 10 temas embutidos convertidos do SVG do React para o formato JSON proprio (ver README.md);
//   - oracle.json    angulos dos ponteiros e texto do relogio digital para centenas de cenarios;
//   - tz.json        deslocamentos de fuso (Intl) usados para conferir as regras de fuso em Dart.
// Tambem escreve lib/src/gadgets/clock/clock_builtin_themes.g.dart a partir de themes.json.
// Uso: node packages/seedgrid_components/test/widgets/clock_vectors/generate.mjs <pacote react>
// Deterministico (mesma entrada, mesmo JSON). Nao altera o repositorio React.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL, fileURLToPath } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const pkg = path.resolve(process.argv[2] ?? "");
const src = path.join(pkg, "src").replace(/\\/g, "/");
const libOut = path.resolve(here, "../../../lib/src/gadgets/clock/clock_builtin_themes.g.dart");

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
  throw new Error("esbuild nao encontrado");
}
const esbuild = await import(pathToFileURL(findEsbuild(pkg)).href);

// ---------------------------------------------------------------- driver (roda dentro do bundle)
const driver = `
import { JSDOM } from "jsdom";
const dom = new JSDOM("<!doctype html><html><body></body></html>", { url: "http://localhost/" });
const w = dom.window;
for (const k of ["window", "document", "navigator", "HTMLElement", "Node", "Event", "MutationObserver"]) {
  Object.defineProperty(globalThis, k, { configurable: true, writable: true, value: k === "window" ? w : k === "document" ? w.document : w[k] });
}
globalThis.requestAnimationFrame = (cb) => setTimeout(() => cb(Date.now()), 0);
globalThis.cancelAnimationFrame = (id) => clearTimeout(id);

export async function run(scenarios) {
  const React = (await import("react")).default ?? (await import("react"));
  const { renderToStaticMarkup } = await import("react-dom/server");
  const { SgClock } = await import("${src}/gadgets/clock/SgClock");
  const { SgTimeProvider } = await import("${src}/gadgets/clock/SgTimeProvider");
  const themes = await import("${src}/gadgets/clock/themes/index");
  themes.registerThemes(themes.sgClockThemesBuiltIn);
  const out = { themes: [], clock: [], provider: [] };
  for (const t of themes.sgClockThemesBuiltIn) {
    out.themes.push({ id: t.id, label: t.label, order: t.order, svg: renderToStaticMarkup(React.createElement("svg", null, t.render({ size: 100, dark: false }))) });
  }
  for (const s of scenarios) {
    let html = "";
    try {
      html = renderToStaticMarkup(React.createElement(SgClock, s.props));
    } catch (e) {
      html = "ERRO:" + String(e && e.message ? e.message : e);
    }
    out.clock.push({ props: s.props, html });
  }
  return out;
}
`;

const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-clock-"));
const bundleFile = path.join(tmp, "driver.cjs");
await esbuild.build({
  stdin: { contents: driver, resolveDir: pkg, loader: "tsx", sourcefile: "driver.tsx" },
  bundle: true, platform: "node", format: "cjs", outfile: bundleFile, external: ["jsdom"], logLevel: "error",
  jsx: "automatic", nodePaths: [path.join(pkg, "node_modules")],
});
const { createRequire } = await import("node:module");
const req = createRequire(path.join(pkg, "package.json"));
// o bundle fica em /tmp: ensina o Node a achar o jsdom (externo) no node_modules do React
process.env.NODE_PATH = path.join(pkg, "node_modules");
(await import("node:module")).default._initPaths();
const driverMod = createRequire(bundleFile)(bundleFile);

// ---------------------------------------------------------------- cenarios
let seed = 20261024;
const rnd = () => {
  seed |= 0; seed = (seed + 0x6d2b79f5) | 0;
  let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
  t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
  return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
};
// "sem fuso" (undefined) usa o fuso da maquina: fica fora dos vetores (nao e deterministico)
const ZONES = ["UTC", "America/Sao_Paulo", "America/New_York", "America/Los_Angeles", "Europe/Lisbon", "Europe/London", "Europe/Paris", "Europe/Madrid", "Asia/Tokyo", "Asia/Kolkata", "Australia/Sydney", "America/Argentina/Buenos_Aires", "Etc/GMT+3", "+03:00", "-05:30"];
const LOCALES = ["pt-BR", "pt-PT", "en-US", "es", "fr", "de-DE"];
// horarios fixos de borda (virada de meio-dia/meia-noite, DST) + aleatorios
const FIXED = [
  "2026-03-08T07:00:00.000Z", "2026-03-08T06:59:59.000Z", "2026-11-01T05:59:59.000Z", "2026-11-01T06:00:00.000Z",
  "2026-03-29T00:59:59.000Z", "2026-03-29T01:00:00.000Z", "2026-10-25T00:59:59.000Z", "2026-10-25T01:00:00.000Z",
  "2026-01-01T00:00:00.000Z", "2026-06-15T12:00:00.000Z", "2026-06-15T23:59:59.999Z", "2026-02-28T03:04:05.678Z",
  "2024-02-29T23:30:00.000Z", "2026-10-04T05:00:00.000Z", "2026-04-05T04:00:00.000Z",
];
const times = [...FIXED];
for (let i = 0; i < 24; i++) times.push(new Date(Date.UTC(2026, 0, 1) + Math.floor(rnd() * 365 * 24 * 3600 * 1000)).toISOString());

const scenarios = [];
const push = (props) => scenarios.push({ props });
// analogico: horario x fuso (locale fixo pt-BR), segundos ligados/desligados e modos do ponteiro
for (const tm of times) {
  for (const z of ZONES) {
    push({ clockStyle: "analog", size: 240, initialServerTime: tm, timezone: z, locale: "pt-BR", showSeconds: true, secondHandMode: "step", themeId: "classic" });
  }
  push({ clockStyle: "analog", size: 140, initialServerTime: tm, timezone: "UTC", showSeconds: false, themeId: "minimal" });
  push({ clockStyle: "analog", size: 320, initialServerTime: tm, timezone: "America/Sao_Paulo", showSeconds: true, secondHandMode: "smooth", themeId: "dark" });
}
// digital: locale x formato x fuso x segundos
for (const tm of times.slice(0, 18)) {
  for (const loc of LOCALES) {
    for (const fmt of ["24h", "12h"]) {
      for (const z of ["UTC", "America/Sao_Paulo", "Asia/Tokyo"]) {
        for (const sec of [true, false]) push({ clockStyle: "digital", size: "md", initialServerTime: tm, timezone: z, locale: loc, format: fmt, showSeconds: sec });
      }
    }
  }
}
// tamanhos do digital e do analogico
for (const sz of ["sm", "md", "lg", 20, 64]) {
  push({ clockStyle: "digital", size: sz, initialServerTime: "2026-06-15T12:34:56.000Z", timezone: "UTC" });
  push({ clockStyle: "analog", size: sz, initialServerTime: "2026-06-15T12:34:56.000Z", timezone: "UTC", themeId: "classic" });
}
// temas por id (inclui id desconhecido -> fallback classic) e todos os temas embutidos
for (const id of ["classic", "minimal", "dark", "seedgrid", "music", "music-notes", "music-staff", "roman-classic", "roman-ornate", "segment", "nao-existe"]) {
  push({ clockStyle: "analog", size: 240, initialServerTime: "2026-06-15T10:08:30.000Z", timezone: "UTC", themeId: id });
}
// estilos digitais nao-padrao (so confere que o relogio responde)
for (const ds of ["default", "segment", "sevenSegment", "roller3d", "flip", "fade", "matrix", "neon", "discard"]) {
  push({ clockStyle: "digital", size: "md", initialServerTime: "2026-06-15T09:07:05.000Z", timezone: "UTC", locale: "en-US", format: "12h", digitalStyle: ds });
}
// varredura das 24 horas por locale (periodo do dia em 12h: pt-PT tem "da manha", "da tarde"...)
for (const loc of [...LOCALES, "pt", "en"]) {
  for (let h = 0; h < 24; h++) {
    push({ clockStyle: "digital", size: "md", initialServerTime: `2026-06-15T${String(h).padStart(2, "0")}:30:00.000Z`, timezone: "UTC", locale: loc, format: "12h", showSeconds: false, __sweep: true });
  }
}
// sem initialServerTime depende do "agora": fora dos vetores.

const data = await driverMod.run(scenarios);
const rawDir = here;

// ---------------------------------------------------------------- SVG -> JSON de tema
// Paleta neutral do Tailwind (v3.4) usada pelos temas.
const NEUTRAL = { "50": "#fafafa", "100": "#f5f5f5", "200": "#e5e5e5", "300": "#d4d4d4", "400": "#a3a3a3", "500": "#737373", "600": "#525252", "700": "#404040", "800": "#262626", "900": "#171717", "950": "#0a0a0a" };

function colorOf(token) {
  // token: neutral-300, neutral-600/60, [#f2e9dc], white, none
  if (token === "none") return "none";
  if (token === "white") return "#ffffff";
  let m = /^\[(#[0-9a-fA-F]{3,8})\]$/.exec(token);
  if (m) return m[1].toLowerCase();
  m = /^neutral-(\d+)(?:\/(\d+))?$/.exec(token);
  if (m) {
    const hex = NEUTRAL[m[1]];
    if (!hex) throw new Error("tom neutral desconhecido: " + token);
    if (m[2]) {
      const a = Math.round((Number(m[2]) / 100) * 255).toString(16).padStart(2, "0");
      return hex + a; // #rrggbbaa
    }
    return hex;
  }
  throw new Error("cor desconhecida: " + token);
}

/** Interpreta as classes de um elemento: devolve { fill, stroke, strokeWidth, fontSize, fontWeight, letterSpacing } com pares claro/escuro. */
function parseClasses(cls) {
  const out = {};
  const base = {};
  const dark = {};
  for (const raw of (cls ?? "").split(/\s+/).filter(Boolean)) {
    const isDark = raw.startsWith("dark:");
    const c = isDark ? raw.slice(5) : raw;
    const bucket = isDark ? dark : base;
    let m;
    if ((m = /^fill-(.+)$/.exec(c))) bucket.fill = colorOf(m[1]);
    else if ((m = /^stroke-\[([0-9.]+)\]$/.exec(c))) out.strokeWidth = Number(m[1]);
    else if ((m = /^stroke-(.+)$/.exec(c))) bucket.stroke = colorOf(m[1]);
    else if ((m = /^text-\[([0-9.]+)px\]$/.exec(c))) out.fontSize = Number(m[1]);
    else if (c === "font-semibold") out.fontWeight = 600;
    else if (c === "font-medium") out.fontWeight = 500;
    else if ((m = /^tracking-\[([0-9.]+)px\]$/.exec(c))) out.letterSpacing = Number(m[1]);
    else throw new Error("classe desconhecida: " + raw);
  }
  for (const prop of ["fill", "stroke"]) {
    if (base[prop] === undefined && dark[prop] === undefined) continue;
    const l = base[prop];
    const d = dark[prop] ?? base[prop];
    out[prop] = l === d ? l : { light: l, dark: d };
  }
  return out;
}

/** Tokenizador minimo para o SVG que o React gera (bem formado, sem CDATA). */
function parseSvg(markup) {
  const tokens = [];
  const re = /<(\/?)([a-zA-Z0-9]+)((?:\s+[a-zA-Z0-9:-]+="[^"]*")*)\s*(\/?)>|([^<]+)/g;
  let m;
  while ((m = re.exec(markup))) {
    if (m[5] !== undefined) { tokens.push({ type: "text", text: m[5] }); continue; }
    const attrs = {};
    for (const a of m[3].matchAll(/([a-zA-Z0-9:-]+)="([^"]*)"/g)) attrs[a[1].replace(/-([a-z])/g, (_, c) => c.toUpperCase())] = a[2]; // o SSR escreve stroke-width etc.
    if (m[1]) tokens.push({ type: "close", name: m[2] });
    else tokens.push({ type: "open", name: m[2], attrs, selfClose: !!m[4] });
  }
  return tokens;
}

function num(v) { return v === undefined ? undefined : Number(v); }
const compact = (o) => Object.fromEntries(Object.entries(o).filter(([, v]) => v !== undefined));

function toOps(markup, themeId) {
  const toks = parseSvg(markup);
  const ops = [];
  const gradients = {};
  const groups = []; // pilha de grupos: { cls, transform }
  let i = 0;
  const stack = [];
  // <g transform="translate(x y)"> acumula um deslocamento que e aplicado as coordenadas de cada elemento filho.
  const emit = (op) => {
    const tx = groups.reduce((s, g) => s + (g.tx ?? 0), 0);
    const ty = groups.reduce((s, g) => s + (g.ty ?? 0), 0);
    if (tx === 0 && ty === 0) { ops.push(op); return; }
    if (op.op === "path") throw new Error("path dentro de grupo com translate nao suportado (" + themeId + ")");
    const r = (n) => Math.round(n * 1000) / 1000;
    for (const k of ["cx", "x", "x1", "x2"]) if (op[k] !== undefined) op[k] = r(op[k] + tx);
    for (const k of ["cy", "y", "y1", "y2"]) if (op[k] !== undefined) op[k] = r(op[k] + ty);
    ops.push(op);
  };
  while (i < toks.length) {
    const t = toks[i++];
    if (t.type === "close") { if (t.name === "g") groups.pop(); stack.pop(); continue; }
    if (t.type === "text") continue;
    const a = t.attrs;
    const inherited = groups.reduce((acc, g) => ({ ...acc, ...g.props }), {});
    const own = parseClasses(a.class);
    const style = { ...inherited, ...own };
    // fill/stroke herdados de <g class>: so valem se o filho nao define
    const merge = (k) => (own[k] !== undefined ? own[k] : inherited[k]);
    switch (t.name) {
      case "svg": stack.push("svg"); break;
      case "g": {
        const props = parseClasses(a.class);
        const tm = /^translate\(([-0-9.]+)[ ,]([-0-9.]+)\)$/.exec(a.transform ?? "");
        if (a.transform && !tm) throw new Error("transform nao suportado: " + a.transform);
        groups.push({ props, tx: tm ? Number(tm[1]) : 0, ty: tm ? Number(tm[2]) : 0 });
        stack.push("g");
        if (t.selfClose) { groups.pop(); stack.pop(); }
        break;
      }
      case "defs": stack.push("defs"); if (t.selfClose) stack.pop(); break;
      case "radialGradient": {
        const gid = a.id; const stops = [];
        gradients[gid] = { cx: a.cx, cy: a.cy, r: a.r, stops };
        let j = i;
        while (j < toks.length && !(toks[j].type === "close" && toks[j].name === "radialGradient")) {
          if (toks[j].type === "open" && toks[j].name === "stop") {
            const rgb = /^rgb\((\d+) (\d+) (\d+)\)$/.exec(toks[j].attrs.stopColor);
            if (!rgb) throw new Error("stopColor inesperado: " + toks[j].attrs.stopColor);
            stops.push({ offset: Number(toks[j].attrs.offset.replace("%", "")) / 100, color: "#" + [1, 2, 3].map((k) => Number(rgb[k]).toString(16).padStart(2, "0")).join("") });
          }
          j++;
        }
        i = j + 1; // consome ate o fechamento
        break;
      }
      case "circle": {
        let fill = merge("fill");
        let gradient;
        const gm = /^url\(#(.+)\)$/.exec(a.fill ?? "");
        if (gm) { gradient = gradients[gm[1]]; fill = undefined; }
        emit(compact({ op: "circle", cx: num(a.cx), cy: num(a.cy), r: num(a.r), fill, stroke: merge("stroke"), strokeWidth: own.strokeWidth ?? inherited.strokeWidth, gradient: gradient ? { cx: gradient.cx, cy: gradient.cy, r: gradient.r, stops: gradient.stops } : undefined }));
        break;
      }
      case "ellipse":
        emit(compact({ op: "ellipse", cx: num(a.cx), cy: num(a.cy), rx: num(a.rx), ry: num(a.ry), fill: merge("fill"), stroke: merge("stroke"), strokeWidth: own.strokeWidth ?? inherited.strokeWidth }));
        break;
      case "line":
        emit(compact({ op: "line", x1: num(a.x1), y1: num(a.y1), x2: num(a.x2), y2: num(a.y2), stroke: merge("stroke"), strokeWidth: own.strokeWidth ?? inherited.strokeWidth, linecap: a.strokeLinecap }));
        break;
      case "rect":
        emit(compact({ op: "rect", x: num(a.x), y: num(a.y), width: num(a.width), height: num(a.height), rx: num(a.rx), fill: merge("fill"), stroke: merge("stroke"), strokeWidth: own.strokeWidth ?? inherited.strokeWidth }));
        break;
      case "path":
        emit(compact({ op: "path", d: a.d, fill: a.fill === "none" ? "none" : merge("fill"), stroke: a.stroke ? a.stroke : merge("stroke"), strokeWidth: a.strokeWidth ? Number(a.strokeWidth) : (own.strokeWidth ?? inherited.strokeWidth) }));
        break;
      case "text": {
        // texto ate o </text>
        let text = "";
        while (i < toks.length && !(toks[i].type === "close" && toks[i].name === "text")) { if (toks[i].type === "text") text += toks[i].text; i++; }
        i++; // fecha
        emit(compact({ op: "text", x: num(a.x), y: num(a.y), text, anchor: a.textAnchor ?? "start", fill: merge("fill"), fontSize: own.fontSize, fontWeight: own.fontWeight, letterSpacing: own.letterSpacing }));
        break;
      }
      default:
        throw new Error("elemento SVG nao suportado no tema " + themeId + ": " + t.name);
    }
  }
  return ops;
}

// agrupa linhas identicas consecutivas em geradores? Nao: o formato JSON e explicito (cada elemento = 1 op).
const themes = data.themes.map((t) => ({
  id: t.id,
  label: t.label,
  order: t.order,
  ops: toOps(t.svg, t.id),
}));

const themesJson = { formato: "sg-clock-theme/1", viewBox: 100, temas: themes };
fs.writeFileSync(path.join(rawDir, "themes.json"), JSON.stringify(themesJson, null, 1) + "\n");

// ---------------------------------------------------------------- oracle do relogio
function stripTags(h) { return h.replace(/<[^>]*>/g, ""); }
const oracle = data.clock.map((c) => {
  const html = c.html;
  if (html.startsWith("ERRO:")) return { props: c.props, erro: html };
  const rot = [...html.matchAll(/transform="rotate\(([-0-9.e]+) 50 50\)"/g)].map((m) => Number(m[1]));
  const analog = c.props.clockStyle === "analog";
  const circleThemes = (html.match(/<g id="theme">([\s\S]*?)<\/g><g id="hands">/) ?? [])[1] ?? "";
  const dig = !analog ? (html.match(/<div class="font-mono[^"]*"[^>]*>([\s\S]*?)<\/div>/) ?? [])[1] ?? "" : "";
  return {
    props: c.props,
    ...(analog ? { rotacoes: rot, temElementosDeTema: circleThemes.length > 0, qtdLinhasDoTema: (circleThemes.match(/<line /g) ?? []).length, qtdTextosDoTema: (circleThemes.match(/<text /g) ?? []).length } : { texto: stripTags(dig), periodo: ((html.match(/<span class="[^"]*ml-2[^"]*">([^<]*)<\/span>/) ?? [])[1]) ?? null }),
  };
});
fs.writeFileSync(path.join(rawDir, "oracle.json"), JSON.stringify({ gerador: "clock_vectors/generate.mjs", casos: oracle }, null, 0) + "\n");

// Periodo do dia (12h) por locale e hora UTC, como o SgClock.tsx o obtem (formatToParts + fallback AM/PM): vira tabela em
// Dart (nao ha Intl completo no Dart). Mesmos 33 locales do calendario.
const DP_LOCALES = ["pt-BR", "pt-PT", "pt", "en-US", "en", "es", "fr", "de-DE", "de", "en-GB", "en-AU", "en-CA", "es-MX", "es-AR", "fr-CA", "de-AT", "de-CH", "it", "nl", "ja", "zh", "ko", "ru", "pl", "sv", "tr", "da", "nb", "fi", "cs", "hu", "uk", "el"];
const dayPeriods = {};
for (const loc of DP_LOCALES) {
  dayPeriods[loc] = Array.from({ length: 24 }, (_, hour) => {
    const d = new Date(Date.UTC(2026, 5, 15, hour, 34, 56));
    const parts = new Intl.DateTimeFormat(loc, { timeZone: "UTC", hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: true }).formatToParts(d);
    const dp = parts.find((p) => p.type === "dayPeriod")?.value;
    return dp || (hour >= 12 ? "PM" : "AM");
  });
}
const dpDart = `// dart format off
// GERADO por test/widgets/clock_vectors/generate.mjs (Intl do Node, ICU ${process.versions.icu}). NAO EDITE A MAO.
// Periodo do dia que o Intl.DateTimeFormat devolve em 12h, por locale e hora (0 a 23).

const Map<String, List<String>> kSgClockDayPeriods = <String, List<String>>{
${Object.entries(dayPeriods).map(([loc, arr]) => `  '${loc}': <String>[${arr.map((s) => `'${s}'`).join(", ")}],`).join("\n")}
};
`;
fs.writeFileSync(path.resolve(here, "../../../lib/src/gadgets/clock/clock_locale_data.g.dart"), dpDart);

// ---------------------------------------------------------------- fusos (para conferir as regras em Dart)
const tzZones = ZONES.filter((z) => z && !z.startsWith("+") && !z.startsWith("-") && z !== "UTC");
const tzOut = {};
for (const z of tzZones) {
  const fmt = new Intl.DateTimeFormat("en-US", { timeZone: z, hourCycle: "h23", year: "numeric", month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit", second: "2-digit" });
  const off = (ms) => {
    const p = Object.fromEntries(fmt.formatToParts(new Date(ms)).map((x) => [x.type, x.value]));
    return Math.round((Date.UTC(+p.year, +p.month - 1, +p.day, +p.hour, +p.minute, +p.second) - ms) / 60000);
  };
  // varre 2019-2036 de hora em hora, acha cada mudanca de deslocamento e refina ate o segundo
  const mudancas = [];
  let prev = off(Date.UTC(2019, 0, 1));
  const inicio = prev;
  for (let ms = Date.UTC(2019, 0, 1) + 3600000; ms < Date.UTC(2036, 0, 1); ms += 3600000) {
    const cur = off(ms);
    if (cur !== prev) {
      let lo = ms - 3600000;
      let hi = ms; // off(lo) = prev, off(hi) = cur
      while (hi - lo > 1000) {
        const mid = Math.floor((lo + hi) / 2000) * 1000;
        if (off(mid) === prev) lo = mid;
        else hi = mid;
      }
      mudancas.push([hi, prev, cur]);
      prev = cur;
    }
  }
  tzOut[z] = { inicio, mudancas };
}
fs.writeFileSync(path.join(rawDir, "tz.json"), JSON.stringify({ de: "2019-01-01T00:00:00Z", ate: "2036-01-01T00:00:00Z", zonas: tzOut }) + "\n");

// ---------------------------------------------------------------- Dart gerado com os temas
const jsonText = JSON.stringify(themesJson);
if (jsonText.includes("'''")) throw new Error("JSON contem ''' (nao suportado)");
const dart = `// dart format off
// GERADO por test/widgets/clock_vectors/generate.mjs a partir de @seedgrid/fe-components (src/gadgets/clock/themes/builtins.tsx).
// NAO EDITE A MAO. Formato: ver lib/src/gadgets/clock/README.md. Mesmo conteudo de test/widgets/clock_vectors/themes.json.

/// Os ${themes.length} temas embutidos do relogio, no formato JSON proprio (\`sg-clock-theme/1\`).
const String kSgClockBuiltInThemesJson = r'''${jsonText}''';
`;
fs.writeFileSync(libOut, dart);
console.log(`temas: ${themes.length} (${themes.map((t) => t.id + ":" + t.ops.length).join(", ")}); oracle: ${oracle.length} cenarios; fusos: ${Object.keys(tzOut).length}`);
fs.rmSync(tmp, { recursive: true, force: true });
