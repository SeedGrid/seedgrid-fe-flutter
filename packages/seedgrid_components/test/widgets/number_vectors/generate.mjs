// Vetores de paridade de SgInputNumber / SgInputCurrency: roda os componentes REAIS do React
// (empacotados do src com esbuild) num jsdom, digita tecla por tecla e grava o que aparece no
// campo (display) e o que sai em onChange. A verdade e sempre o React; o Dart so confere.
// Uso: node packages/seedgrid_components/test/widgets/number_vectors/generate.mjs <pacote react> [saida.json]
// Deterministico (mesma entrada, mesmo JSON). Nao altera o repositorio React.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { pathToFileURL } from "node:url";

const pkg = path.resolve(process.argv[2] ?? "");
const out = path.resolve(process.argv[3] ?? path.join(path.dirname(new URL(import.meta.url).pathname.replace(/^\//, "")), "vectors.json"));
const src = path.join(pkg, "src").replace(/\\/g, "/");

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
for (const k of ["window","document","navigator","HTMLElement","HTMLInputElement","Node","Event","InputEvent","MouseEvent","KeyboardEvent","MutationObserver","getComputedStyle","localStorage"]) {
  Object.defineProperty(globalThis, k, { configurable: true, writable: true, value: k === "window" ? w : (k === "document" ? w.document : (k === "navigator" ? w.navigator : (k === "getComputedStyle" ? w.getComputedStyle.bind(w) : w[k]))) });
}
globalThis.IS_REACT_ACT_ENVIRONMENT = true;
globalThis.requestAnimationFrame = (cb) => setTimeout(() => cb(Date.now()), 0);
globalThis.cancelAnimationFrame = (id) => clearTimeout(id);

let React, act, createRoot, SgInputNumber, SgInputCurrency, setComponentsI18n;
const setter = Object.getOwnPropertyDescriptor(w.HTMLInputElement.prototype, "value").set;

async function run(Comp, props, actions, locale) {
  setComponentsI18n({ locale });
  const emitted = [];
  const el = w.document.createElement("div");
  w.document.body.appendChild(el);
  const root = createRoot(el);
  await act(async () => { root.render(React.createElement(Comp, { id: "x", ...props, onChange: (v) => emitted.push(v) })); });
  const input = el.querySelector("input");
  const affix = () => {
    const spans = [...el.querySelectorAll("span")];
    const pre = spans.find((s) => /absolute left-0 top-0/.test(s.className));
    const suf = spans.find((s) => /absolute right-0 top-0/.test(s.className));
    return { prefix: pre ? pre.textContent : null, suffix: suf ? suf.textContent : null };
  };
  const steps = [{ action: "inicial", display: input.value, emitted: null, ...affix() }];
  for (const a of actions) {
    const before = emitted.length;
    await act(async () => {
      if (a.key !== undefined) {
        input.focus();
        input.dispatchEvent(new w.KeyboardEvent("keydown", { key: a.key, bubbles: true, cancelable: true }));
      } else if (a.input !== undefined) {
        const prev = input.value;
        setter.call(input, a.input);
        input._valueTracker?.setValue?.(prev);
        input.dispatchEvent(new w.Event("input", { bubbles: true }));
      } else if (a.paste !== undefined) {
        const ev = new w.Event("paste", { bubbles: true, cancelable: true });
        Object.defineProperty(ev, "clipboardData", { value: { getData: () => a.paste } });
        input.dispatchEvent(ev);
      } else if (a.clear) {
        el.querySelector("button[aria-label]").dispatchEvent(new w.MouseEvent("click", { bubbles: true, cancelable: true }));
      }
    });
    steps.push({ action: a, display: input.value, emitted: emitted.length > before ? emitted[emitted.length - 1] : null });
  }
  await act(async () => root.unmount());
  el.remove();
  return steps;
}

export async function main(scenarios) {
  // react-dom decide canUseDOM ao ser avaliado: so pode carregar DEPOIS de window existir.
  const R = await import("react");
  React = R.default; act = R.act;
  ({ createRoot } = await import("react-dom/client"));
  ({ SgInputNumber } = await import("${src}/inputs/SgInputNumber"));
  ({ SgInputCurrency } = await import("${src}/inputs/SgInputCurrency"));
  ({ setComponentsI18n } = await import("${src}/i18n"));
  const results = [];
  for (const s of scenarios) {
    const Comp = s.component === "currency" ? SgInputCurrency : SgInputNumber;
    results.push({ ...s, steps: await run(Comp, s.props, s.actions, s.locale) });
  }
  return results;
}
`;

const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-num-"));
const bundleFile = path.join(tmp, "driver.cjs");
await esbuild.build({
  stdin: { contents: driver, resolveDir: pkg, loader: "tsx", sourcefile: "driver.tsx" },
  bundle: true, platform: "node", format: "cjs", outfile: bundleFile, external: ["jsdom"], logLevel: "error",
  jsx: "automatic", nodePaths: [path.join(pkg, "node_modules")],
});

// ---------------------------------------------------------------- cenarios
const LOCALES = ["pt-BR", "pt-PT", "en-US", "es", "fr"];
const K = (...ks) => ks.map((key) => ({ key }));
const SEQS = {
  digitos: K("1", "2", "3", "4", "5", "6", "7"),
  decimal_virgula: K("1", ",", "5"),
  decimal_ponto: K("1", ".", "2", "3", "4"),
  negativo: K("-", "5"),
  negativo_duplo: K("-", "-"),
  apagar_inteiro: K("9", "9", "Backspace", "Backspace", "Backspace", "Backspace"),
  apagar_decimal: K(",", "5", "Backspace", "Backspace", "Backspace"),
  zeros: K("0", "0", "5"),
  ignora: K("a", "Enter", "x"),
  colar: [{ paste: "1.234,56" }, { paste: "-0,5" }, { paste: "abc" }, { paste: "12345678.9" }],
  digitar_texto: [{ input: "1234,5" }, { input: "-7" }, { input: "" }],
  limpar: [...K("4", "2"), { clear: true }],
  delete_vazio: K("Delete", "Backspace"),
};

const scenarios = [];
for (const locale of LOCALES) {
  for (const decimals of [2, 0, 3]) {
    for (const allowNegative of [true, false]) {
      for (const emptyValue of ["zero", "null"]) {
        for (const [name, actions] of Object.entries(SEQS)) {
          scenarios.push({ id: `num|${locale}|d${decimals}|neg${allowNegative}|${emptyValue}|${name}`, component: "number", locale, props: { decimals, allowNegative, emptyValue }, actions });
        }
      }
    }
  }
  for (const value of ["1234.5", "-0.5", "", "12,5", "1.234.567,891", "abc"]) {
    for (const emptyValue of ["zero", "null"]) {
      scenarios.push({ id: `num|${locale}|inicial=${value}|${emptyValue}`, component: "number", locale, props: { emptyValue, inputProps: { value } }, actions: K("1") });
    }
  }
}

const CURRENCIES = ["BRL", "USD", "EUR", "JPY", "GBP"];
const CUR_SEQS = { digitos: SEQS.digitos, decimal: SEQS.decimal_virgula, negativo: SEQS.negativo, apagar: SEQS.apagar_inteiro, colar: SEQS.colar, limpar: SEQS.limpar };
for (const locale of LOCALES) {
  for (const currency of CURRENCIES) {
    for (const [name, actions] of Object.entries(CUR_SEQS)) {
      scenarios.push({ id: `cur|${locale}|${currency}|${name}`, component: "currency", locale, props: { currency, locale }, actions });
    }
  }
  for (const currencyDisplay of ["symbol", "narrowSymbol", "code", "name"]) {
    for (const currencySymbolPlacement of ["auto", "prefix", "suffix"]) {
      scenarios.push({ id: `cur|${locale}|BRL|display=${currencyDisplay}|place=${currencySymbolPlacement}`, component: "currency", locale, props: { currency: "BRL", locale, currencyDisplay, currencySymbolPlacement }, actions: SEQS.digitos });
    }
  }
  const extras = [
    ["semSimbolo", { showCurrencySymbol: false }],
    ["semAgrupamento", { useGrouping: false }],
    ["override", { currencySymbolOverride: "pts" }],
    ["decimais0", { decimals: 0 }],
    ["decimais4", { decimals: 4 }],
    ["afixos", { prefixText: "Total", suffixText: "/mes" }],
    ["nulo", { emptyValue: "null" }],
    ["semNegativo", { allowNegative: false }],
    ["localeProp", { locale: "de-DE" }],
    ["moedaInvalida", { currency: "XXXX" }],
    ["inicial", { inputProps: { value: "1234.56" } }],
  ];
  for (const [n, p] of extras) {
    scenarios.push({ id: `cur|${locale}|extra=${n}`, component: "currency", locale, props: { currency: "BRL", locale, ...p }, actions: [...SEQS.digitos, ...K("Backspace", "-")] });
  }
}

// Defeito do React (nao comparado no Dart): /d/.test(key) vale para teclas como "F1" (tem um digito no nome).
scenarios.push({ id: "defeito|num|F1", component: "number", locale: "pt-BR", props: {}, actions: K("5", "F1", "F2") });
scenarios.push({ id: "defeito|cur|F1", component: "currency", locale: "pt-BR", props: { currency: "BRL", locale: "pt-BR" }, actions: K("5", "F1") });

const require = (await import("node:module")).createRequire(import.meta.url);
process.env.NODE_PATH = path.join(pkg, "node_modules");
require("node:module").Module._initPaths();
const { main } = require(bundleFile);
const results = await main(scenarios);

const pj = JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8"));
fs.mkdirSync(path.dirname(out), { recursive: true });
fs.writeFileSync(out, JSON.stringify({ fonte: "SgInputNumber/SgInputCurrency do React (src, jsdom)", versaoReact: pj.version, node: process.version, scenarios: results }, null, 0) + "\n");
console.log(`vetores: ${results.length} cenarios, ${results.reduce((a, r) => a + r.steps.length, 0)} passos -> ${out}`);
process.exit(0);
