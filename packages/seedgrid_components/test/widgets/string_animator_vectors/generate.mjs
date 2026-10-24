// Vetores de paridade do SgStringAnimator. A verdade e o CODIGO REAL do componente React: renderiza com
// react-dom/client + jsdom, com os 6 digitos trocados por um stub que so expoe as props recebidas, e com um
// relogio VIRTUAL (setTimeout falso): cada cenario guarda, por acao, os caracteres exibidos e o atraso do proximo passo.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/string_animator_vectors/generate.mjs <pasta do pacote react>
// Gera test/widgets/string_animator_vectors/vectors.json (deterministico).
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { createRequire } from "node:module";
import { pathToFileURL } from "node:url";

const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.resolve("packages/seedgrid_components/test/widgets/string_animator_vectors/vectors.json");
if (!fs.existsSync(path.join(pkg, "src", "gadgets", "string-animator"))) {
  console.error("src/gadgets/string-animator nao encontrado em " + pkg);
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
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-strani-"));

const stubFile = path.join(tmp, "digits-stub.tsx");
fs.writeFileSync(
  stubFile,
  `import * as React from "react";
const mk = (style: string) => function Stub(props: any) {
  return React.createElement("span", {
    "data-style": style,
    "data-value": props.value,
    "data-font": props.fontSize ?? "",
    "data-color": props.color ?? "",
    "data-bg": props.backgroundColor ?? "",
    "data-items": props.items ? props.items.join("") : "",
  });
};
export const SgFlipDigit = mk("flip");
export const SgRoller3DDigit = mk("roller3d");
export const SgNeonDigit = mk("neon");
export const SgFadeDigit = mk("fade");
export const SgDiscardDigit = mk("discard");
export const SgMatrixDigit = mk("matrix");
`,
);

const stubSource = fs.readFileSync(stubFile, "utf8");
const stubPlugin = {
  name: "stub-digits",
  setup(build) {
    build.onResolve({ filter: /\.\.\/\.\.\/digits\/(flip|roller3d|neon|fade|discard|matrix)-digit$/ }, () => ({ path: "digits-stub", namespace: "stub" }));
    // modulo virtual: precisa de resolveDir para achar o "react" do pacote
    build.onLoad({ filter: /.*/, namespace: "stub" }, () => ({ contents: stubSource, loader: "tsx", resolveDir: pkg }));
  },
};
const entry = path.join(pkg, "src", "gadgets", "string-animator", "SgStringAnimator.tsx").replace(/\\/g, "/");
const res = await esbuild.build({
  stdin: {
    contents: `import * as React from "react";\nimport { act } from "react";\nimport { createRoot } from "react-dom/client";\nimport { SgStringAnimator, SG_STRING_ANIMATOR_DEFAULT_CHARSET } from ${JSON.stringify(entry)};\nexport { React, act, createRoot, SgStringAnimator, SG_STRING_ANIMATOR_DEFAULT_CHARSET };`,
    resolveDir: pkg,
    loader: "tsx",
    sourcefile: "entry.tsx",
  },
  bundle: true,
  platform: "node",
  format: "cjs",
  jsx: "automatic",
  write: false,
  logLevel: "error",
  plugins: [stubPlugin],
  define: { "process.env.NODE_ENV": '"development"' },
});
const bundleFile = path.join(tmp, "bundle.cjs");
fs.writeFileSync(bundleFile, res.outputFiles[0].text);

// ---- ambiente (jsdom) e relogio virtual
const { JSDOM } = requireFromPkg("jsdom");
const dom = new JSDOM("<!doctype html><html><body></body></html>");
for (const k of ["window", "document", "navigator", "HTMLElement", "Node", "MutationObserver"]) {
  Object.defineProperty(globalThis, k, { value: dom.window[k], configurable: true, writable: true });
}
globalThis.IS_REACT_ACT_ENVIRONMENT = true;
let queue = [];
let nextId = 1;
let nowMs = 0;
const delays = [];
dom.window.setTimeout = (fn, ms = 0) => {
  const id = nextId++;
  delays.push(ms);
  queue.push({ id, at: nowMs + ms, fn });
  return id;
};
dom.window.clearTimeout = (id) => {
  queue = queue.filter((t) => t.id !== id);
};
const lib = createRequire(import.meta.url)(bundleFile);
const { React, act, createRoot, SgStringAnimator } = lib;

function snapshot(host) {
  const spans = [...host.querySelectorAll("span[data-style]")];
  return {
    chars: spans.map((s) => s.getAttribute("data-value")),
    styles: [...new Set(spans.map((s) => s.getAttribute("data-style")))],
    first: spans.length
      ? {
          font: spans[0].getAttribute("data-font"),
          color: spans[0].getAttribute("data-color"),
          bg: spans[0].getAttribute("data-bg"),
          items: spans[0].getAttribute("data-items"),
        }
      : null,
    containerClass: host.firstElementChild ? host.firstElementChild.getAttribute("class") : null,
    pending: queue.length,
  };
}

async function advance(ms) {
  const target = nowMs + ms;
  for (;;) {
    queue.sort((a, b) => a.at - b.at || a.id - b.id);
    const next = queue[0];
    if (!next || next.at > target) break;
    queue.shift();
    nowMs = next.at;
    await act(async () => next.fn());
  }
  nowMs = target;
}

async function run(scenario) {
  queue = [];
  nowMs = 0;
  delays.length = 0;
  const host = dom.window.document.createElement("div");
  dom.window.document.body.appendChild(host);
  const root = createRoot(host);
  const ref = React.createRef();
  let props = { ...scenario.props };
  const render = () => act(async () => root.render(React.createElement(SgStringAnimator, { ...props, ref })));
  await render();
  const steps = [{ acao: "montar", t: nowMs, delays: [...delays], ...snapshot(host) }];
  delays.length = 0;
  for (const a of scenario.actions ?? []) {
    if (a.type === "start") await act(async () => ref.current.startAnimation());
    else if (a.type === "advance") await advance(a.ms);
    else if (a.type === "drain") await advance(60000);
    else if (a.type === "rerender") {
      props = { ...props, ...a.patch };
      await render();
    } else if (a.type === "unmount") {
      await act(async () => root.unmount());
    }
    steps.push({ acao: a.type, arg: a.ms ?? a.patch ?? null, t: nowMs, delays: [...delays], ...(a.type === "unmount" ? { chars: [], styles: [], first: null, containerClass: null, pending: queue.length } : snapshot(host)) });
    delays.length = 0;
  }
  if (!(scenario.actions ?? []).some((a) => a.type === "unmount")) await act(async () => root.unmount());
  host.remove();
  return { nome: scenario.nome, props: scenario.props, passos: steps };
}

const base = { sourceString: "LUCIANO", targetString: "MARTA" };
const scenarios = [];
const add = (nome, props, actions) => scenarios.push({ nome, props: { ...base, ...props }, actions });

// estilos: props repassadas a cada digito e espacamento do container
for (const style of ["roller3d", "flip", "neon", "fade", "discard", "matrix"]) {
  add(`estilo ${style}`, { stringAnimatorStyle: style, fontSize: 40, color: "#112233", backgroundColor: "#445566" }, []);
  add(`estilo ${style} sem cores`, { stringAnimatorStyle: style }, []);
}
add("estilo padrao (omitido)", {}, []);
// preenchimento e alinhamento
add("pad left", { sourceString: "AB", targetString: "WXYZ" }, []);
add("pad right", { sourceString: "AB", targetString: "WXYZ", alignTo: "right" }, []);
add("pad source maior left", { sourceString: "ABCDE", targetString: "XY" }, []);
add("pad source maior right", { sourceString: "ABCDE", targetString: "XY", alignTo: "right" }, []);
add("ambos vazios", { sourceString: "", targetString: "" }, []);
add("source vazio", { sourceString: "", targetString: "OK" }, []);
add("emptyChar vazio vira espaco", { sourceString: "A", targetString: "XYZ", emptyChar: "" }, []);
add("emptyChar multi-caractere usa o primeiro", { sourceString: "A", targetString: "XYZ", emptyChar: "*-" }, []);
add("emptyChar custom right", { sourceString: "9", targetString: "123", emptyChar: "0", alignTo: "right" }, []);
add("emoji (code points x unidades UTF-16)", { sourceString: "A\u{1F600}", targetString: "BC" }, []);
add("emoji alvo maior", { sourceString: "AB", targetString: "\u{1F600}\u{1F601}" }, []);
// roller3d: charset
add("roller3d charset sem o vazio", { stringAnimatorStyle: "roller3d", charset: ["A", "B", "C"], sourceString: "AB", targetString: "C" }, []);
add("roller3d caractere fora do charset", { stringAnimatorStyle: "roller3d", charset: [" ", "A", "B"], sourceString: "AZ", targetString: "BB" }, []);
add("roller3d charset customizado completo", { stringAnimatorStyle: "roller3d", charset: [" ", "0", "1", "2"], sourceString: "01", targetString: "21" }, []);
// animacao manual: ordem dos passos e atraso por velocidade
for (const v of [1, 2, 10, 25, 49, 50, 51, 75, 99, 100, 0, -5, 150, 33.3, 66.6]) {
  add(`velocidade ${v}`, { velocity: v, sourceString: "AAAA", targetString: "BCDE" }, [{ type: "start" }, { type: "advance", ms: 1 }, { type: "drain" }]);
}
add("left passo a passo", { velocity: 50 }, [{ type: "start" }, { type: "advance", ms: 0 }, { type: "advance", ms: 319 }, { type: "advance", ms: 1 }, { type: "advance", ms: 320 }, { type: "advance", ms: 320 }, { type: "advance", ms: 320 }, { type: "advance", ms: 320 }, { type: "drain" }]);
add("right passo a passo (unidades primeiro)", { sourceString: "7", targetString: "1234", alignTo: "right", velocity: 100 }, [{ type: "start" }, { type: "advance", ms: 0 }, { type: "advance", ms: 41 }, { type: "advance", ms: 41 }, { type: "advance", ms: 41 }, { type: "drain" }]);
add("sem autoStart nao anima sozinho", { autoStart: false }, [{ type: "advance", ms: 5000 }]);
add("startAnimation duas vezes reinicia", { velocity: 100 }, [{ type: "start" }, { type: "advance", ms: 100 }, { type: "start" }, { type: "advance", ms: 0 }, { type: "drain" }]);
add("startAnimation depois de terminar volta ao alvo", { velocity: 100, sourceString: "AB", targetString: "CD" }, [{ type: "start" }, { type: "drain" }, { type: "start" }, { type: "drain" }]);
// autoStart
add("autoStart na montagem", { autoStart: true, velocity: 100 }, [{ type: "advance", ms: 0 }, { type: "drain" }]);
add("autoStart troca de alvo", { autoStart: true, velocity: 100, sourceString: "AAA", targetString: "BBB" }, [{ type: "drain" }, { type: "rerender", patch: { targetString: "CCC" } }, { type: "advance", ms: 0 }, { type: "drain" }]);
add("autoStart troca de alvo no meio da animacao", { autoStart: true, velocity: 50, sourceString: "AAAA", targetString: "BBBB" }, [{ type: "advance", ms: 400 }, { type: "rerender", patch: { targetString: "CCCC" } }, { type: "advance", ms: 0 }, { type: "drain" }]);
add("autoStart ligado depois da montagem nao dispara", { autoStart: false, velocity: 100 }, [{ type: "rerender", patch: { autoStart: true } }, { type: "drain" }]);
add("alvo muda sem autoStart", { autoStart: false, velocity: 100 }, [{ type: "rerender", patch: { targetString: "XXXXX" } }, { type: "drain" }]);
// troca de origem
add("troca de sourceString zera e cancela", { velocity: 50, sourceString: "AAAA", targetString: "BBBB" }, [{ type: "start" }, { type: "advance", ms: 330 }, { type: "rerender", patch: { sourceString: "ZZZZ" } }, { type: "advance", ms: 1000 }]);
add("troca de sourceString com autoStart", { autoStart: true, velocity: 100, sourceString: "AAA", targetString: "BBB" }, [{ type: "drain" }, { type: "rerender", patch: { sourceString: "ZZZ" } }, { type: "advance", ms: 200 }]);
add("troca de alignTo sem mexer nas strings", { sourceString: "AB", targetString: "WXYZ", alignTo: "left" }, [{ type: "rerender", patch: { alignTo: "right" } }]);
add("troca de emptyChar", { sourceString: "AB", targetString: "WXYZ" }, [{ type: "rerender", patch: { emptyChar: "." } }]);
add("desmontar cancela", { velocity: 50 }, [{ type: "start" }, { type: "advance", ms: 100 }, { type: "unmount" }, { type: "advance", ms: 5000 }]);
add("alvo com 1 caractere", { sourceString: "ABC", targetString: "Z", velocity: 100 }, [{ type: "start" }, { type: "drain" }]);
add("alvo igual a origem", { sourceString: "ABC", targetString: "ABC", velocity: 100 }, [{ type: "start" }, { type: "drain" }]);

const resultados = [];
for (const s of scenarios) resultados.push(await run(s));

// ---------------------------------------------------------------- relogio digital (estilos com digitos)
// O SgClock real, com os 8 digitos trocados por um stub que expoe TODAS as props recebidas (JSON). So os
// digitos entram na comparacao; os "dois pontos" e a celula do periodo sao DOM comum do relogio.
const clockStubSource = `import * as React from "react";
const mk = (style: string) => function Stub(props: any) {
  return React.createElement("span", { "data-style": style, "data-props": JSON.stringify(props) });
};
export const SgFlipDigit = mk("flip");
export const SgRoller3DDigit = mk("roller3d");
export const SgNeonDigit = mk("neon");
export const SgFadeDigit = mk("fade");
export const SgDiscardDigit = mk("discard");
export const SgMatrixDigit = mk("matrix");
export const SgSegmentDigit = mk("segment");
export const SgSevenSegmentDigit = mk("sevenSegment");
`;
const clockPlugin = {
  name: "stub-clock-digits",
  setup(build) {
    build.onResolve({ filter: /\.\.\/\.\.\/digits\/(flip|roller3d|neon|fade|discard|matrix|segment|seven-segment)-digit$/ }, () => ({ path: "clock-digits-stub", namespace: "clockstub" }));
    build.onLoad({ filter: /.*/, namespace: "clockstub" }, () => ({ contents: clockStubSource, loader: "tsx", resolveDir: pkg }));
  },
};
const clockEntry = path.join(pkg, "src", "gadgets", "clock", "SgClock.tsx").replace(/\\/g, "/");
const clockRes = await esbuild.build({
  stdin: {
    contents: `import * as React from "react";\nimport { renderToStaticMarkup } from "react-dom/server";\nimport { SgClock } from ${JSON.stringify(clockEntry)};\nexport { React, renderToStaticMarkup, SgClock };`,
    resolveDir: pkg,
    loader: "tsx",
    sourcefile: "clock-entry.tsx",
  },
  bundle: true,
  platform: "node",
  format: "cjs",
  jsx: "automatic",
  write: false,
  logLevel: "error",
  plugins: [clockPlugin],
  define: { "process.env.NODE_ENV": '"production"' },
});
const clockBundle = path.join(tmp, "clock-bundle.cjs");
fs.writeFileSync(clockBundle, clockRes.outputFiles[0].text);
const clockLib = createRequire(import.meta.url)(clockBundle);
const decode = (s) => s.replace(/&quot;/g, '"').replace(/&#x27;/g, "'").replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">");
function clockDigits(props) {
  const html = clockLib.renderToStaticMarkup(clockLib.React.createElement(clockLib.SgClock, props));
  const digits = [];
  for (const m of html.matchAll(/<span data-style="([^"]+)" data-props="([^"]*)"><\/span>/g)) {
    digits.push({ estilo: m[1], props: JSON.parse(decode(m[2])) });
  }
  return digits;
}
const relogioDigital = [];
const instants = ["2026-03-07T15:04:05Z", "2026-03-07T00:09:59Z", "2026-03-07T12:30:00Z"];
for (const style of ["segment", "sevenSegment", "roller3d", "flip", "fade", "matrix", "neon", "discard"]) {
  for (const size of ["sm", "md", "lg", 20, 5, 40]) {
    for (const format of ["24h", "12h"]) {
      for (const showSeconds of [true, false]) {
        for (const at of instants) {
          const props = { clockStyle: "digital", digitalStyle: style, size, format, showSeconds, locale: "en-US", timezone: "UTC", initialServerTime: at };
          relogioDigital.push({ props, digitos: clockDigits(props) });
        }
      }
    }
  }
}
for (const style of ["roller3d", "segment", "matrix"]) {
  const props = { clockStyle: "digital", digitalStyle: style, size: "md", format: "12h", showSeconds: true, locale: "pt-BR", timezone: "UTC", initialServerTime: "2026-03-07T15:04:05Z" };
  relogioDigital.push({ props, digitos: clockDigits(props) });
}

const reactVersion = JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8")).version;
const doc = {
  fonte: "@seedgrid/fe-components src/gadgets/string-animator e clock (react-dom + jsdom, digitos em stub, relogio virtual)",
  versaoReact: reactVersion,
  gerador: "test/widgets/string_animator_vectors/generate.mjs",
  charsetPadrao: lib.SG_STRING_ANIMATOR_DEFAULT_CHARSET,
  cenarios: resultados,
  relogioDigital,
};
fs.mkdirSync(path.dirname(out), { recursive: true });
fs.writeFileSync(out, JSON.stringify(doc, null, 1) + "\n");
const passos = resultados.reduce((a, r) => a + r.passos.length, 0);
console.log(`cenarios: ${resultados.length}, passos: ${passos} -> ${out}`);
process.exit(0);
