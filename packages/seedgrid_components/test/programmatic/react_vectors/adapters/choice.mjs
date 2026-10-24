import { sleep, click, $$, text } from "../common.mjs";

const redText = (ctx) => {
  const el = ctx.h.document.querySelector(".text-red-500, .text-red-600, [data-sg-error]");
  return el ? text(el) : null;
};

// ---------------------------------------------------------------------------------------------- SgCheckboxGroup
function cbLabels(ctx) {
  return $$(ctx, 'label').filter((l) => l.querySelector('input[type="checkbox"]'));
}
export const checkboxgroup = {
  component: "SgCheckboxGroup",
  toReact(props, items, ctx) {
    const out = { id: "g", ...props, source: structuredClone(items ?? []) };
    out.onChange = (v) => ctx.events.push(v);
    return out;
  },
  snapshot(ctx) {
    const labels = cbLabels(ctx);
    const checkAll = ctx.sc.props?.showCheckAll ? labels.find((l) => /all|todos/i.test(text(l))) : null;
    const options = labels.filter((l) => l !== checkAll);
    const out = {
      checked: options.filter((l) => l.querySelector("input").checked).map(text),
      error: redText(ctx),
    };
    if (checkAll) {
      const i = checkAll.querySelector("input");
      out.checkAll = i.indeterminate ? "some" : i.checked ? "all" : "none";
    }
    return out;
  },
  async ui(ctx, step) {
    if (step.op === "toggle") {
      const l = cbLabels(ctx).find((x) => text(x) === step.label);
      if (!l) throw new Error("opcao nao encontrada " + step.label);
      await click(ctx, l.querySelector("input"));
    } else if (step.op === "checkAll") {
      const l = cbLabels(ctx).find((x) => /all|todos/i.test(text(x)));
      await click(ctx, l.querySelector("input"));
    } else throw new Error("op desconhecida " + step.op);
  },
};

// ---------------------------------------------------------------------------------------------- SgRadioGroup
const radioLabels = (ctx) => $$(ctx, "label").filter((l) => l.querySelector('input[type="radio"]'));
export const radiogroup = {
  component: "SgRadioGroup",
  toReact(props, items, ctx) {
    const out = { id: "g", ...props, source: structuredClone(items ?? []) };
    out.onChange = (v) => ctx.events.push(v);
    return out;
  },
  snapshot(ctx) {
    const sel = radioLabels(ctx).find((l) => l.querySelector("input").checked);
    return { selected: sel ? text(sel) : null, error: redText(ctx) };
  },
  async ui(ctx, step) {
    if (step.op === "pick") {
      const l = radioLabels(ctx).find((x) => text(x) === step.label);
      if (!l) throw new Error("opcao nao encontrada " + step.label);
      await click(ctx, l.querySelector("input"));
    } else throw new Error("op desconhecida " + step.op);
  },
};

// ---------------------------------------------------------------------------------------------- SgToggleSwitch
export const toggleswitch = {
  component: "SgToggleSwitch",
  toReact(props, items, ctx) {
    const { disabled, ...rest } = props;
    const out = { id: "t", label: "Ativo", ...rest };
    if (disabled) out.enabled = false;
    out.onChange = (v) => ctx.events.push(v);
    return out;
  },
  snapshot(ctx) {
    const i = ctx.h.document.querySelector("input");
    const err = ctx.h.document.querySelector("[data-sg-error]");
    return { checked: i.checked, error: err ? text(err) : null };
  },
  async ui(ctx, step) {
    const i = ctx.h.document.querySelector("input");
    if (step.op === "toggle") await click(ctx, i);
    else if (step.op === "focus") await ctx.act(async () => { i.focus(); });
    else if (step.op === "blur") await ctx.act(async () => { i.blur(); });
    else throw new Error("op desconhecida " + step.op);
  },
};

// ---------------------------------------------------------------------------------------------- SgSlider
export const slider = {
  component: "SgSlider",
  toReact(props, items, ctx) {
    const out = { id: "s", minValue: 0, maxValue: 10, ...props };
    out.onChange = (v) => ctx.events.push(v);
    return out;
  },
  snapshot(ctx) {
    const i = ctx.h.document.querySelector("input");
    const err = ctx.h.document.querySelector("p.text-red-600");
    return { value: Number(i.value), error: err ? text(err) : null };
  },
  async ui(ctx, step) {
    const i = ctx.h.document.querySelector("input");
    if (step.op === "drag") {
      if (i.disabled) return;
      await ctx.dom.dispatchInput(i, String(step.to));
    } else throw new Error("op desconhecida " + step.op);
  },
};

// ---------------------------------------------------------------------------------------------- SgRating
function stars(ctx) {
  return $$(ctx, "div.relative.inline-flex");
}
export const rating = {
  component: "SgRating",
  toReact(props, items, ctx) {
    const { disabled, ...rest } = props;
    const out = { id: "r", ...rest };
    if (disabled) out.disabled = true;
    out.onChange = (v) => ctx.events.push(v);
    return out;
  },
  snapshot(ctx) {
    const fills = stars(ctx).map((s) => {
      const clipped = Array.from(s.children).find((c) => /clip-path/.test(c.getAttribute("style") ?? ""));
      const m = /inset\(0(?:px)? ([\d.]+)%/.exec(clipped?.getAttribute("style") ?? "");
      return m ? Math.round((100 - Number(m[1])) * 100) / 100 : 0;
    });
    const err = ctx.h.document.querySelector("p.text-red-600");
    return { fills, error: err ? text(err) : null };
  },
  async ui(ctx, step) {
    if (step.op === "rate") {
      const v = step.value;
      const idx = Math.ceil(v) - 1;
      const half = v % 1 !== 0;
      const s = stars(ctx)[idx];
      const kids = Array.from(s.children);
      const target = ctx.sc.props?.allowHalf ? (half ? kids[2] : kids[3]) : kids[2];
      await click(ctx, target);
    } else if (step.op === "cancel") {
      const b = ctx.h.document.querySelector("button");
      await click(ctx, b);
    } else throw new Error("op desconhecida " + step.op);
  },
};
void sleep;
