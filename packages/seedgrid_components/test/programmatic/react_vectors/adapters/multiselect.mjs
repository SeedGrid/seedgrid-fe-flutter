import { sleep, click, $$, text } from "../common.mjs";

const listbox = (ctx) => ctx.h.document.querySelector('body > div[role="listbox"]');
const optionEls = (ctx) => $$(ctx, 'body > div[role="listbox"] [role="option"]');

function make(component, chips) {
  return {
    component,
    toReact(props, items, ctx) {
      const { disabled, ...rest } = props;
      const out = { id: "m", ...rest, options: structuredClone(items ?? []) };
      if (disabled) out.enabled = false;
      out.onChange = (v) => ctx.events.push(v);
      return out;
    },
    snapshot(ctx) {
      const doc = ctx.h.document;
      let shown;
      if (chips) {
        const trig = doc.querySelector('[role="combobox"]');
        shown = $$(ctx, '[role="combobox"] span.truncate').map(text);
        void trig;
      } else {
        shown = doc.querySelector("input").value;
      }
      return {
        text: chips ? shown.join("|") : shown,
        open: !!listbox(ctx),
        options: optionEls(ctx).map((e) => text(e) + ":" + (e.getAttribute("aria-selected") === "true" ? 1 : 0)),
      };
    },
    async ui(ctx, step) {
      const doc = ctx.h.document;
      const trigger = chips ? doc.querySelector('[role="combobox"]') : doc.querySelector("input");
      if (step.op === "open") {
        await ctx.act(async () => { trigger.dispatchEvent(new ctx.h.window.MouseEvent("mousedown", { bubbles: true, cancelable: true })); });
      } else if (step.op === "toggle") {
        const el = optionEls(ctx).find((e) => text(e) === step.label);
        if (!el) throw new Error("opcao nao encontrada: " + step.label);
        await click(ctx, el);
      } else if (step.op === "close") {
        await ctx.act(async () => { trigger.dispatchEvent(new ctx.h.window.KeyboardEvent("keydown", { key: "Escape", bubbles: true, cancelable: true })); });
      } else if (step.op === "clear") {
        const btn = $$(ctx, "button").find((b) => /clear|limpar/i.test(b.getAttribute("aria-label") ?? ""));
        if (!btn) throw new Error("botao limpar nao encontrado");
        await click(ctx, btn);
      } else if (step.op === "removeChip") {
        const btn = $$(ctx, "button[data-sg-chip-remove]").find((b) => (b.getAttribute("aria-label") ?? "").includes(step.label));
        if (!btn) throw new Error("botao remover nao encontrado: " + step.label);
        await click(ctx, btn);
      } else if (step.op === "search") {
        const input = doc.querySelector('body > div[role="listbox"] input');
        await ctx.dom.dispatchInput(input, step.text);
      } else throw new Error("op desconhecida " + step.op);
      await ctx.act(async () => { await sleep(5); });
    },
  };
}

export const multiselect = make("SgMultiSelect", false);
export const multiselectchips = make("SgMultiSelectChips", true);
