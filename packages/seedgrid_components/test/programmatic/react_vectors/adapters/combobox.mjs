import { sleep, click, $$, text } from "../common.mjs";

const comboOptions = (ctx) => $$(ctx, 'body > div [class*="cursor-pointer"][class*="px-3"][class*="py-2"]');

export default {
  component: "SgCombobox",
  toReact(props, items, ctx) {
    const { disabled, ...rest } = props;
    const out = { id: "c", ...rest };
    if (disabled) out.enabled = false;
    out.onValueChange = (v) => ctx.events.push(v);
    if ((ctx.sc.sourceKind ?? "list") === "async") {
      out.source = () => new Promise((resolve) => setTimeout(() => resolve(structuredClone(ctx.state.items ?? [])), ctx.sc.delay ?? 30));
    } else out.source = items ?? [];
    return out;
  },
  snapshot(ctx) {
    const input = ctx.h.document.querySelector("input");
    const opts = comboOptions(ctx);
    return {
      text: input.value,
      open: opts.length > 0 || !!ctx.h.document.querySelector('body > div [class*="max-h-64"]'),
      options: opts.map(text),
    };
  },
  async ui(ctx, step) {
    const input = ctx.h.document.querySelector("input");
    if (step.op === "open") {
      await ctx.act(async () => { input.dispatchEvent(new ctx.h.window.MouseEvent("mousedown", { bubbles: true, cancelable: true })); });
      await ctx.act(async () => { await sleep(ctx.sc.delay ? ctx.sc.delay + 50 : 5); });
    } else if (step.op === "pick") {
      const el = comboOptions(ctx).find((e) => text(e) === step.label);
      if (!el) throw new Error("opcao nao encontrada: " + step.label);
      await click(ctx, el);
    } else if (step.op === "close") {
      await ctx.act(async () => { input.dispatchEvent(new ctx.h.window.KeyboardEvent("keydown", { key: "Escape", bubbles: true, cancelable: true })); });
    } else if (step.op === "focus") {
      await ctx.act(async () => { input.focus(); });
    } else throw new Error("op desconhecida " + step.op);
  },
};
