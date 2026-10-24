import { sleep, click, $$, text } from "../common.mjs";

const panel = (ctx) => ctx.h.document.querySelector('body > div [class*="max-h-64"]');
const options = (ctx) => $$(ctx, 'body > div [class*="cursor-pointer"][class*="px-3"][class*="py-2"]');

export default {
  component: "SgAutocomplete",
  toReact(props, items, ctx) {
    const { disabled, ...rest } = props;
    const out = { id: "ac", minLengthForSearch: 0, delay: 0, cacheEnabled: false, showDropDownButton: true, ...rest };
    if (disabled) out.enabled = false;
    out.onChange = (v) => ctx.events.push(v);
    const filter = (q) => structuredClone(ctx.state.items ?? []).filter((i) => i.label.toLowerCase().includes(String(q).toLowerCase()));
    if ((ctx.sc.sourceKind ?? "list") === "async") {
      out.source = (q) => new Promise((resolve) => setTimeout(() => resolve(filter(q)), ctx.sc.delay ?? 300));
    } else out.source = (q) => filter(q);
    return out;
  },
  snapshot(ctx) {
    const input = ctx.h.document.querySelector("input");
    return { text: input.value, open: !!panel(ctx), options: options(ctx).map(text) };
  },
  async ui(ctx, step) {
    const input = ctx.h.document.querySelector("input");
    const wait = () => ctx.act(async () => { await sleep(ctx.sc.delay ? ctx.sc.delay + 50 : 20); });
    if (step.op === "focus") {
      await ctx.act(async () => { input.focus(); });
    } else if (step.op === "open") {
      const btn = $$(ctx, "button").find((b) => /list/i.test(b.getAttribute("aria-label") ?? ""));
      if (!btn) throw new Error("botao de lista nao encontrado: " + $$(ctx, "button").map((b) => b.getAttribute("aria-label")));
      await click(ctx, btn);
      await wait();
    } else if (step.op === "type") {
      await ctx.dom.dispatchInput(input, step.text);
      await wait();
    } else if (step.op === "pick") {
      const el = options(ctx).find((e) => text(e) === step.label);
      if (!el) throw new Error("opcao nao encontrada: " + step.label + " em " + options(ctx).map(text));
      await click(ctx, el);
    } else if (step.op === "blur") {
      await ctx.act(async () => { input.blur(); });
      await ctx.act(async () => { await sleep(10); });
    } else throw new Error("op desconhecida " + step.op);
  },
};
