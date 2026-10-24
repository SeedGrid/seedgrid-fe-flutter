import { sleep, $$, text } from "../common.mjs";

const slotsOf = (ctx) => $$(ctx, 'input[type="text"]');

export default {
  component: "SgInputOTP",
  toReact(props, items, ctx) {
    const { disabled, validation, ...rest } = props;
    const out = { id: "o", ...rest };
    if (disabled) out.enabled = false;
    // "min3": validacao propria que exige 3 digitos (o JSON nao leva funcoes).
    if (validation === "min3") out.validation = (raw) => (raw.length < 3 ? "Minimo 3" : null);
    out.onChange = (v) => ctx.events.push("c:" + v);
    out.onRawChange = (v) => ctx.events.push("r:" + v);
    out.onComplete = (v) => ctx.events.push("k:" + v);
    out.onClear = () => ctx.events.push("x");
    return out;
  },
  snapshot(ctx) {
    const err = ctx.h.document.querySelector("[data-sg-error]");
    return { slots: slotsOf(ctx).map((i) => i.value), error: err ? text(err) : null };
  },
  async ui(ctx, step) {
    const slots = slotsOf(ctx);
    const settle = () => ctx.act(async () => { await sleep(30); });
    if (step.op === "type") {
      if (slots[step.slot].disabled) return;
      await ctx.dom.dispatchInput(slots[step.slot], step.text);
      await settle();
    } else if (step.op === "focus") {
      await ctx.act(async () => { slots[step.slot ?? 0].focus(); });
      await settle();
    } else if (step.op === "blur") {
      await ctx.act(async () => { ctx.h.document.activeElement?.blur(); });
      await settle();
    } else throw new Error("op desconhecida " + step.op);
  },
};
