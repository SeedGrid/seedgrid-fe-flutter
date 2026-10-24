// Vetores de valor PROGRAMATICO (valor inicial, `value` controlado, setValue/reset do formulario,
// validacao depois de setar, foco, disabled) dos inputs de texto, com mascara, data e numericos.
// Roda os componentes REAIS do React (src empacotado com esbuild) num jsdom com react-hook-form
// (`useForm` + `setValue`/`reset`/`trigger`) e grava, a cada passo: o que aparece no campo (display), o
// valor guardado no formulario, o erro visivel, o que saiu em onChange e em onValidation.
// A verdade e o React; o Dart so confere (veja docs/VALOR_PROGRAMATICO.md para os defeitos do React
// que o Dart NAO repete).
// Uso: node packages/seedgrid_components/test/programmatic/vectors/generate.mjs <pacote react>
// Deterministico (mesma entrada, mesmo JSON). Nao altera o repositorio React.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const pkg = path.resolve(process.argv[2] ?? "");
const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\//, ""));
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
for (const k of ["window","document","navigator","HTMLElement","HTMLInputElement","HTMLTextAreaElement","Node","Event","InputEvent","MouseEvent","KeyboardEvent","MutationObserver","getComputedStyle","localStorage"]) {
  Object.defineProperty(globalThis, k, { configurable: true, writable: true, value: k === "window" ? w : (k === "document" ? w.document : (k === "navigator" ? w.navigator : (k === "getComputedStyle" ? w.getComputedStyle.bind(w) : w[k]))) });
}
w.matchMedia = () => ({ matches: false, addEventListener() {}, removeEventListener() {}, addListener() {}, removeListener() {} });
globalThis.IS_REACT_ACT_ENVIRONMENT = true;
globalThis.requestAnimationFrame = (cb) => setTimeout(() => cb(Date.now()), 0);
globalThis.cancelAnimationFrame = (id) => clearTimeout(id);

let React, act, createRoot, useForm, COMPS, setComponentsI18n;
const inputSetter = Object.getOwnPropertyDescriptor(w.HTMLInputElement.prototype, "value").set;
const areaSetter = Object.getOwnPropertyDescriptor(w.HTMLTextAreaElement.prototype, "value").set;

const undef = (v) => (v && typeof v === "object" && v.$undef ? undefined : v);
const toJson = (v) => (v === undefined ? { $undef: 1 } : v);

// regras serializaveis -> RegisterOptions do RHF
const VALIDATORS = {
  noA: (v) => (typeof v === "string" && v.includes("A") ? "sem A" : true),
  evenLen: (v) => (String(v ?? "").length % 2 === 0 ? true : "tamanho impar"),
  positive: (v) => (Number(v) > 0 ? true : "so positivo"),
};
function buildRules(spec) {
  if (!spec) return undefined;
  const r = {};
  for (const [k, v] of Object.entries(spec)) {
    if (k === "validate") r.validate = VALIDATORS[v];
    else if (k === "pattern") r.pattern = typeof v === "string" ? new RegExp(v) : { value: new RegExp(v.value), message: v.message };
    else r[k] = v;
  }
  return r;
}

function applyValueProps(props, kind, init) {
  const keys = ["defaultValue", "value"].filter((k) => k in init);
  if (!keys.length) return;
  if (kind === "stepper") {
    for (const k of keys) { const v = undef(init[k]); if (v !== undefined) props[k] = v; }
    return;
  }
  const bag = kind === "textarea" ? "textareaProps" : "inputProps";
  const next = { ...(props[bag] ?? {}) };
  for (const k of keys) { const v = undef(init[k]); if (v === undefined) delete next[k]; else next[k] = v; }
  props[bag] = next;
}

async function run(s) {
  setComponentsI18n({ locale: s.locale ?? "pt-BR" });
  const kind = s.component;
  const emitted = [];
  const validations = [];
  const searched = [];
  const holder = { form: null, setExtra: null };
  const Comp = COMPS[kind];
  function Harness() {
    const form = useForm({ defaultValues: s.defaultValues ?? {} });
    const [extra, setExtra] = React.useState({});
    holder.form = form;
    holder.setExtra = (p) => setExtra((prev) => ({ ...prev, ...p }));
    const props = { id: "x", ...JSON.parse(JSON.stringify(s.props ?? {})) };
    if (s.props && s.props.minDate) props.minDate = s.props.minDate;
    applyValueProps(props, kind, { ...(s.initial ?? {}), ...extra });
    props.onChange = (v) => emitted.push(toJson(v));
    if (kind !== "stepper") props.onValidation = (m) => validations.push(m);
    if (kind === "search") props.onSearchChange = (v) => searched.push(v);
    if (s.mode === "form") {
      props.name = "f";
      props.control = form.control;
      if (s.rules) props.rules = buildRules(s.rules);
    }
    return React.createElement(Comp, props);
  }

  const el = w.document.createElement("div");
  w.document.body.appendChild(el);
  const root = createRoot(el);
  await act(async () => { root.render(React.createElement(Harness)); });
  const tag = kind === "textarea" ? "textarea" : "input";
  const input = () => el.querySelector(tag);
  const setter = kind === "textarea" ? areaSetter : inputSetter;
  const fire = (text) => {
    const i = input();
    const prev = i.value;
    setter.call(i, text);
    i._valueTracker?.setValue?.(prev);
    i.dispatchEvent(new w.Event("input", { bubbles: true }));
  };

  const snap = (action) => {
    const err = el.querySelector("[data-sg-error]") ?? el.querySelector("p.text-red-600");
    const out = {
      action,
      display: input().value,
      error: err ? err.textContent : null,
      emitted: emitted.splice(0),
      validations: validations.splice(0),
    };
    if (kind === "search") out.searched = searched.splice(0);
    if (s.mode === "form") {
      out.form = toJson(holder.form.getValues("f"));
      const fe = holder.form.getFieldState("f").error;
      out.formError = fe ? (fe.message ?? "") : null;
    }
    return out;
  };

  const steps = [snap("inicial")];
  for (const a of s.actions) {
    await act(async () => {
      if ("setValue" in a) {
        await holder.form.setValue("f", undef(a.setValue), a.opts ?? {});
      } else if ("reset" in a) {
        if (a.reset === null) holder.form.reset();
        else holder.form.reset(a.reset);
      } else if ("trigger" in a) {
        await holder.form.trigger("f");
      } else if ("rerender" in a) {
        holder.setExtra(a.rerender);
      } else if ("typeText" in a) {
        input().focus();
        for (const ch of a.typeText) fire(input().value + ch);
      } else if ("input" in a) {
        fire(a.input);
      } else if ("focus" in a) {
        input().focus();
      } else if ("blur" in a) {
        input().blur();
      } else if ("key" in a) {
        input().focus();
        input().dispatchEvent(new w.KeyboardEvent("keydown", { key: a.key, bubbles: true, cancelable: true }));
      } else if ("clear" in a) {
        el.querySelector("button[aria-label]").dispatchEvent(new w.MouseEvent("click", { bubbles: true, cancelable: true }));
      } else if ("up" in a) {
        el.querySelectorAll("button")[0].dispatchEvent(new w.MouseEvent("click", { bubbles: true, cancelable: true }));
      } else if ("down" in a) {
        el.querySelectorAll("button")[1].dispatchEvent(new w.MouseEvent("click", { bubbles: true, cancelable: true }));
      } else if ("wait" in a) {
        await new Promise((r) => setTimeout(r, a.wait));
      }
    });
    steps.push(snap(a));
  }
  await act(async () => root.unmount());
  el.remove();
  return steps;
}

export async function main(scenarios) {
  const R = await import("react");
  React = R.default; act = R.act;
  ({ createRoot } = await import("react-dom/client"));
  ({ useForm } = await import("react-hook-form"));
  COMPS = {
    text: (await import("${src}/inputs/SgInputText")).SgInputText,
    email: (await import("${src}/inputs/SgInputEmail")).SgInputEmail,
    password: (await import("${src}/inputs/SgInputPassword")).SgInputPassword,
    textarea: (await import("${src}/inputs/SgInputTextArea")).SgInputTextArea,
    search: (await import("${src}/inputs/SgInputTextSearch")).SgInputTextSearch,
    cpf: (await import("${src}/inputs/SgInputCPF")).SgInputCPF,
    cnpj: (await import("${src}/inputs/SgInputCNPJ")).SgInputCNPJ,
    cpfcnpj: (await import("${src}/inputs/SgInputCPFCNPJ")).SgInputCPFCNPJ,
    phone: (await import("${src}/inputs/SgInputPhone")).SgInputPhone,
    postal: (await import("${src}/inputs/SgInputPostalCode")).SgInputPostalCode,
    date: (await import("${src}/inputs/SgInputDate")).SgInputDate,
    birth: (await import("${src}/inputs/SgInputBirthDate")).SgInputBirthDate,
    number: (await import("${src}/inputs/SgInputNumber")).SgInputNumber,
    currency: (await import("${src}/inputs/SgInputCurrency")).SgInputCurrency,
    stepper: (await import("${src}/inputs/SgStepperInput")).SgStepperInput,
  };
  ({ setComponentsI18n } = await import("${src}/i18n"));
  const results = [];
  for (const s of scenarios) {
    try {
      results.push({ ...s, steps: await run(s) });
    } catch (e) {
      results.push({ ...s, steps: [], reactError: String(e && e.stack ? e.stack : e).slice(0, 600) });
    }
  }
  return results;
}
`;

const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-prog-"));
const bundleFile = path.join(tmp, "driver.cjs");
await esbuild.build({
  stdin: { contents: driver, resolveDir: pkg, loader: "tsx", sourcefile: "driver.tsx" },
  bundle: true, platform: "node", format: "cjs", outfile: bundleFile, external: ["jsdom"], logLevel: "error",
  jsx: "automatic", nodePaths: [path.join(pkg, "node_modules")],
});

// ---------------------------------------------------------------- cenarios
const scenarios = (await import(pathToFileURL(path.join(here, "scenarios.mjs")).href)).buildScenarios();

const only = process.argv[3];
const todo = only ? scenarios.filter((s) => s.group === only) : scenarios;

const require = (await import("node:module")).createRequire(import.meta.url);
process.env.NODE_PATH = path.join(pkg, "node_modules");
require("node:module").Module._initPaths();
const { main } = require(bundleFile);
const results = await main(todo);

const pj = JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8"));
const groups = [...new Set(results.map((r) => r.group))];
for (const g of groups) {
  const part = results.filter((r) => r.group === g);
  const file = path.join(here, `${g}.json`);
  fs.writeFileSync(file, JSON.stringify({ fonte: "componentes React (src, jsdom, react-hook-form)", versaoReact: pj.version, node: process.version, scenarios: part }) + "\n");
  console.log(`${g}: ${part.length} cenarios, ${part.reduce((a, r) => a + r.steps.length, 0)} passos, ${part.filter((r) => r.reactError).length} com erro no React -> ${file}`);
}
process.exit(0);
