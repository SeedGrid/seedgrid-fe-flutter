// Utilitarios comuns dos adapters e dos cenarios.
export const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

export async function click(ctx, el) {
  // Um navegador de verdade nao entrega clique a controle desabilitado (o jsdom entrega ao dispatchEvent).
  if (el.disabled) return;
  const W = ctx.h.window;
  await ctx.act(async () => {
    el.dispatchEvent(new W.MouseEvent("mousedown", { bubbles: true, cancelable: true }));
    el.dispatchEvent(new W.MouseEvent("mouseup", { bubbles: true, cancelable: true }));
    el.dispatchEvent(new W.MouseEvent("click", { bubbles: true, cancelable: true }));
  });
}
export const $$ = (ctx, sel) => Array.from(ctx.h.document.querySelectorAll(sel));
export const text = (el) => (el?.textContent ?? "").replace(/\s+/g, " ").trim();

// Atalhos de passos dos cenarios.
export const snap = (label) => ({ op: "snap", label });
export const setv = (value) => ({ op: "props", set: { value } });
export const unset = { op: "props", set: { value: { $unset: true } } };
export const fsv = (value, shouldValidate) => ({ op: "form.setValue", value, ...(shouldValidate ? { shouldValidate: true } : {}) });
export const freset = (values) => ({ op: "form.reset", ...(values ? { values } : {}) });
export const ftrigger = { op: "form.trigger" };

export const NUM = [{ id: 1, label: "Um" }, { id: 2, label: "Dois" }, { id: 3, label: "Tres" }];
export const STR = [{ id: "a", label: "Alfa" }, { id: "b", label: "Beta" }, { id: "c", label: "Gama" }];
export const FR = [{ id: 1, label: "Alfa" }, { id: 2, label: "Beta" }, { id: 3, label: "Gama" }, { id: 4, label: "Delta" }];
