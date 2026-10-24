// Harness do React REAL para os vetores de "valor programatico" dos campos de selecao/escolha.
// Carrega dist/sandbox.cjs (build do @seedgrid/fe-components) num jsdom, monta o componente, executa os
// passos de um cenario (props, setValue/reset/trigger do react-hook-form, abrir/escolher...) e devolve
// instantaneos (snapshots) do que o usuario ve + o que onChange emitiu + o que o formulario guarda.
// O mesmo cenario (JSON) e executado pelo Dart (test/programmatic/support) e os instantaneos sao comparados.
import path from "node:path";
import { createRequire } from "node:module";
import { pathToFileURL } from "node:url";

export function loadReact(pkgDir) {
  const req = createRequire(path.join(pkgDir, "package.json"));
  const Module = req("node:module");
  const original = Module._load;
  // O build do sandbox nao traz o tiptap/text-style (so o SgTextEditor usa); mesmo remendo dos testes do React.
  Module._load = function patched(request, parent, isMain) {
    if (request === "@tiptap/extension-text-style") {
      return { extend() { return { configure() { return this; } }; } };
    }
    return original.call(this, request, parent, isMain);
  };
  const sandbox = req(path.join(pkgDir, "dist", "sandbox.cjs"));
  Module._load = original;
  const React = req("react");
  const rhf = req("react-hook-form");
  const { act } = req("react");
  return { React, rhf, act, sandbox, req };
}

export async function loadDomHarness(pkgDir) {
  return import(pathToFileURL(path.join(pkgDir, "tests", "dom-harness.mjs")).href);
}

const norm = (v) => (v === undefined ? null : JSON.parse(JSON.stringify(v)));

/**
 * Executa um cenario. `adapter` descreve o componente (ver adapters.mjs):
 *   toReact(props, items, ctx) -> props do React; snapshot(ctx) -> objeto; ui(ctx, step) -> executa passo de UI.
 */
export async function runScenario(env, adapter, sc) {
  const { React, rhf, act, sandbox } = env;
  const dom = env.dom;
  const h = dom.setupDomHarness();
  const events = [];
  const api = { form: null };
  const state = { props: structuredClone(sc.props ?? {}), items: structuredClone(sc.items ?? null) };
  const Comp = sandbox[adapter.component];
  if (!Comp) throw new Error("componente nao exportado: " + adapter.component);

  function FormHost({ render }) {
    const form = rhf.useForm({ defaultValues: sc.form?.defaults ?? {} });
    api.form = form;
    void form.formState.errors; // assina os erros
    void form.formState.isSubmitted;
    return render(form.control);
  }

  const ctx = {
    h, api, events, state, React, act, dom, sandbox, sc,
    get container() { return h.document.body; },
  };

  const element = () => {
    const rp = adapter.toReact(state.props, state.items, ctx);
    if (!sc.form) return React.createElement(Comp, rp);
    const rules = sc.form.rules ? { required: sc.form.rules.required === true ? "Obrigatorio" : sc.form.rules.required } : undefined;
    return React.createElement(FormHost, {
      render: (control) => React.createElement(Comp, { ...rp, name: "f", control, rules }),
    });
  };

  const { root, container } = await h.render(element());
  ctx.root = root;
  ctx.mount = container;
  const rerender = async () => {
    await act(async () => { root.render(element()); });
  };
  ctx.rerender = rerender;

  const snaps = [];
  try {
    for (const step of sc.steps) {
      switch (step.op) {
        case "props": {
          for (const [k, v] of Object.entries(step.set ?? {})) {
            if (v && typeof v === "object" && v.$unset) delete state.props[k];
            else state.props[k] = structuredClone(v);
          }
          await rerender();
          break;
        }
        case "items": {
          state.items = structuredClone(step.items);
          await rerender();
          break;
        }
        case "wait": {
          await act(async () => { await new Promise((r) => setTimeout(r, step.ms ?? 20)); });
          break;
        }
        case "form.setValue": {
          await act(async () => {
            api.form.setValue("f", structuredClone(step.value), {
              shouldValidate: !!step.shouldValidate,
              shouldDirty: true,
              shouldTouch: !!step.shouldTouch,
            });
          });
          break;
        }
        case "form.reset": {
          await act(async () => {
            if (step.values) api.form.reset(structuredClone(step.values));
            else api.form.reset();
          });
          break;
        }
        case "form.trigger": {
          await act(async () => { await api.form.trigger("f"); });
          break;
        }
        case "snap": {
          if (step.settle !== false) await act(async () => { await new Promise((r) => setTimeout(r, 5)); });
          const s = await adapter.snapshot(ctx);
          const out = { label: step.label, ...s, events: norm(events) };
          if (sc.form) {
            out.form = {
              value: norm(api.form.getValues("f")),
              error: api.form.formState.errors.f?.message ?? null,
            };
          }
          snaps.push(out);
          break;
        }
        default:
          await adapter.ui(ctx, step);
      }
    }
  } finally {
    h.restore();
  }
  return snaps;
}
