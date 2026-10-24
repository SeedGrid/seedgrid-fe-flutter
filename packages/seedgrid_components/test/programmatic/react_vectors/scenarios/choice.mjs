import { snap, setv, fsv, freset, ftrigger } from "../common.mjs";

const OPTS = [
  { label: "Um", value: 1 },
  { label: "Dois", value: 2 },
  { label: "Tres", value: 3 },
  { label: "Quatro", value: 4, disabled: true },
];
const OPTS_STR = [{ label: "Um", value: "1" }, { label: "Dois", value: "2" }];
const tog = (label) => ({ op: "toggle", label });
const pick = (label) => ({ op: "pick", label });

// ---------------------------------------------------------------------------------------------- SgCheckboxGroup
export const checkboxgroup = [
  { id: "a-valor-inicial", items: OPTS, props: { value: [2] }, steps: [snap("inicial")] },
  { id: "a-valor-inicial-inexistente", items: OPTS, props: { value: [99] }, steps: [snap("inicial")] },
  { id: "a-sem-valor", items: OPTS, props: {}, steps: [snap("inicial")] },
  {
    id: "a-inicial-pelo-checked-da-opcao", items: [{ label: "Um", value: 1, checked: true }, { label: "Dois", value: 2 }, { label: "Tres", value: 3, checked: true }], props: {},
    steps: [snap("inicial"), tog("Dois"), snap("marcou Dois"),
      { op: "items", items: [{ label: "Um", value: 1 }, { label: "Dois", value: 2 }, { label: "Tres", value: 3 }] }, snap("opcoes sem checked")],
  },
  {
    id: "b-value-controlado-muda-por-fora", items: OPTS, props: { value: [1] },
    steps: [snap("[1]"), setv([2, 3]), snap("[2,3]"), setv([]), snap("[]"), setv([99]), snap("[99]"), setv([1]), snap("volta [1]"), setv([1]), snap("mesmo")],
  },
  {
    id: "b-controlado-ignora-clique-do-usuario", items: OPTS, props: { value: [1] },
    steps: [tog("Dois"), snap("apos clicar"), setv([1, 2]), snap("pai acompanhou")],
  },
  {
    id: "b-nao-controlado-acumula", items: OPTS, props: {},
    steps: [tog("Um"), tog("Tres"), snap("marcou 1 e 3"), tog("Um"), snap("desmarcou 1"), setv([2]), snap("pai setou [2]"), setv([]), snap("pai limpou")],
  },
  {
    id: "c-form-default", items: OPTS, form: { defaults: { f: [2] } }, props: {},
    steps: [snap("inicial"), fsv([1, 3]), snap("setValue [1,3]"), fsv([]), snap("setValue []"), fsv(null), snap("setValue null"), fsv([99]), snap("setValue inexistente"),
      fsv([1]), snap("setValue [1]"), freset(), snap("reset"), freset({ f: [3] }), snap("reset com valores"), fsv([3]), snap("setValue mesmo")],
  },
  { id: "c-form-sem-default", items: OPTS, form: { defaults: {} }, props: {}, steps: [snap("inicial"), fsv([2]), snap("setValue"), freset(), snap("reset")] },
  {
    id: "c-form-escolha-do-usuario-grava", items: OPTS, form: { defaults: { f: [1] } }, props: {},
    steps: [tog("Dois"), snap("apos marcar"), fsv([3]), snap("setValue"), tog("Um"), snap("marcou mais um")],
  },
  { id: "c-form-value-prop-ignorada", items: OPTS, form: { defaults: { f: [3] } }, props: { value: [1] }, steps: [snap("inicial"), setv([2]), snap("prop mudou")] },
  { id: "c-form-valor-texto-em-opcao-numerica", items: OPTS, form: { defaults: { f: ["2"] } }, props: {}, steps: [snap("inicial"), fsv(["1", "3"]), snap("setValue textos")] },
  {
    id: "d-opcoes-tardias", items: [], props: { value: [2, 3] },
    steps: [snap("sem opcoes"), { op: "items", items: OPTS }, snap("com opcoes"), { op: "items", items: [] }, snap("sumiram"), { op: "items", items: OPTS_STR }, snap("outras opcoes")],
  },
  {
    id: "d-opcoes-tardias-form", items: [], form: { defaults: { f: [1, 2] } }, props: {},
    steps: [snap("sem opcoes"), { op: "items", items: OPTS }, snap("com opcoes"), fsv([3]), snap("setValue")],
  },
  { id: "d-tipo-valor-texto-opcao-numerica", items: OPTS, props: { value: ["2"] }, steps: [snap("valor texto, opcao numero")] },
  { id: "d-tipo-valor-numerico-opcao-texto", items: OPTS_STR, props: { value: [2] }, steps: [snap("valor numero, opcao texto")] },
  {
    id: "e-onchange-emite-lista-completa", items: OPTS, props: { value: [] },
    steps: [tog("Dois"), snap("marcou Dois (pai nao acompanha)"), setv([2]), tog("Um"), snap("marcou Um"), setv([2, 1]), tog("Dois"), snap("desmarcou Dois")],
  },
  {
    id: "e-opcao-desabilitada-nao-alterna", items: OPTS, props: { value: [1] },
    steps: [tog("Quatro"), snap("clicou desabilitada")],
  },
  {
    id: "e-marcar-todos", items: OPTS, props: { value: [], showCheckAll: true },
    steps: [snap("inicial"), { op: "checkAll" }, snap("clicou todos"), setv([1, 2, 3]), snap("pai acompanhou"), { op: "checkAll" }, snap("clicou todos de novo"), setv([1]), snap("parcial")],
  },
  {
    id: "e-marcar-todos-form", items: OPTS, form: { defaults: { f: [] } }, props: { showCheckAll: true },
    steps: [{ op: "checkAll" }, snap("todos"), { op: "checkAll" }, snap("nenhum"), fsv([2]), snap("setValue parcial")],
  },
  { id: "e-set-programatico-nao-emite", items: OPTS, props: { value: [1] }, steps: [setv([2]), setv([3]), snap("props mudaram")] },
  { id: "e-form-set-programatico-nao-emite", items: OPTS, form: { defaults: { f: [1] } }, props: {}, steps: [fsv([2]), freset(), snap("depois")] },
  {
    id: "f-required-form", items: OPTS, form: { defaults: { f: [] }, rules: { required: true } }, props: {},
    steps: [snap("inicial"), ftrigger, snap("trigger vazio"), fsv([1]), snap("setValue sem validar"), ftrigger, snap("trigger preenchido"),
      fsv([], true), snap("setValue vazio validando"), fsv([2], true), snap("setValue [2] validando"), freset(), snap("reset")],
  },
  { id: "f-required-prop-vira-regra", items: OPTS, form: { defaults: { f: [] } }, props: { required: true }, steps: [ftrigger, snap("trigger com required da prop")] },
  { id: "f-required-valor-inexistente", items: OPTS, form: { defaults: { f: [99] }, rules: { required: true } }, props: {}, steps: [ftrigger, snap("trigger com valor inexistente")] },
  {
    id: "f-usuario-marca-com-erro", items: OPTS, form: { defaults: { f: [] }, rules: { required: true } }, props: {},
    steps: [ftrigger, snap("com erro"), tog("Um"), snap("apos marcar")],
  },
  {
    id: "g-interagir-depois-de-setar", items: OPTS, form: { defaults: { f: [1] } }, props: {},
    steps: [fsv([2, 3]), tog("Um"), snap("marcou Um depois do setValue"), tog("Dois"), snap("desmarcou Dois")],
  },
  {
    id: "h-disabled-mostra-valor", items: OPTS, props: { value: [2], disabled: true },
    steps: [snap("inicial"), tog("Um"), snap("tentou marcar"), setv([3]), snap("prop mudou")],
  },
  {
    id: "h-readonly-mostra-valor", items: OPTS, props: { value: [2], readOnly: true },
    steps: [snap("inicial"), tog("Um"), snap("tentou marcar"), setv([3]), snap("prop mudou")],
  },
  {
    id: "h-disabled-form-setvalue", items: OPTS, form: { defaults: { f: [1] } }, props: { disabled: true },
    steps: [snap("inicial"), fsv([3]), snap("setValue"), freset(), snap("reset")],
  },
];

// ---------------------------------------------------------------------------------------------- SgRadioGroup
export const radiogroup = [
  { id: "a-valor-inicial", items: OPTS, props: { value: 2 }, steps: [snap("inicial")] },
  { id: "a-valor-inicial-texto", items: OPTS_STR, props: { value: "2" }, steps: [snap("inicial")] },
  { id: "a-valor-inicial-inexistente", items: OPTS, props: { value: 99 }, steps: [snap("inicial")] },
  { id: "a-sem-valor", items: OPTS, props: {}, steps: [snap("inicial")] },
  {
    id: "b-value-controlado-muda-por-fora", items: OPTS, props: { value: 2 },
    steps: [snap("2"), setv(3), snap("3"), setv(null), snap("null"), setv(99), snap("inexistente"), setv(1), snap("volta 1"), setv(1), snap("mesmo")],
  },
  {
    id: "b-controlado-ignora-clique-do-usuario", items: OPTS, props: { value: 1 },
    steps: [pick("Tres"), snap("apos clicar"), setv(2), snap("pai acompanhou")],
  },
  {
    id: "b-nao-controlado-guarda-escolha", items: OPTS, props: {},
    steps: [pick("Dois"), snap("escolheu Dois"), pick("Tres"), snap("escolheu Tres"), setv(1), snap("pai setou 1"), setv(null), snap("pai limpou")],
  },
  {
    id: "c-form-default", items: OPTS, form: { defaults: { f: 2 } }, props: {},
    steps: [snap("inicial"), fsv(3), snap("setValue 3"), fsv(null), snap("setValue null"), fsv(99), snap("setValue inexistente"), fsv(1), snap("setValue 1"),
      freset(), snap("reset"), freset({ f: 3 }), snap("reset com valores"), fsv(3), snap("setValue mesmo")],
  },
  { id: "c-form-sem-default", items: OPTS, form: { defaults: {} }, props: {}, steps: [snap("inicial"), fsv(2), snap("setValue 2"), freset(), snap("reset")] },
  {
    id: "c-form-escolha-do-usuario-grava", items: OPTS, form: { defaults: { f: 1 } }, props: {},
    steps: [pick("Dois"), snap("apos escolher"), fsv(3), snap("setValue 3"), pick("Um"), snap("escolheu Um")],
  },
  { id: "c-form-value-prop-ignorada", items: OPTS, form: { defaults: { f: 3 } }, props: { value: 1 }, steps: [snap("inicial"), setv(2), snap("prop mudou")] },
  { id: "c-form-valor-texto-em-opcao-numerica", items: OPTS, form: { defaults: { f: "2" } }, props: {}, steps: [snap("inicial"), fsv("3"), snap("setValue texto 3")] },
  {
    id: "d-opcoes-tardias", items: [], props: { value: 2 },
    steps: [snap("sem opcoes"), { op: "items", items: OPTS }, snap("com opcoes"), { op: "items", items: [] }, snap("sumiram"), { op: "items", items: OPTS_STR }, snap("outras opcoes")],
  },
  {
    id: "d-opcoes-tardias-form", items: [], form: { defaults: { f: 1 } }, props: {},
    steps: [snap("sem opcoes"), { op: "items", items: OPTS }, snap("com opcoes"), fsv(3), snap("setValue")],
  },
  { id: "d-tipo-valor-texto-opcao-numerica", items: OPTS, props: { value: "2" }, steps: [snap("valor texto, opcao numero")] },
  { id: "d-tipo-valor-numerico-opcao-texto", items: OPTS_STR, props: { value: 2 }, steps: [snap("valor numero, opcao texto")] },
  {
    id: "e-onchange-emite-valor", items: OPTS, props: {},
    steps: [pick("Dois"), pick("Dois"), snap("escolheu Dois duas vezes"), pick("Um"), snap("escolheu Um")],
  },
  { id: "e-opcao-desabilitada-nao-escolhe", items: OPTS, props: { value: 1 }, steps: [pick("Quatro"), snap("clicou desabilitada")] },
  { id: "e-set-programatico-nao-emite", items: OPTS, props: { value: 1 }, steps: [setv(2), setv(3), snap("props mudaram")] },
  { id: "e-form-set-programatico-nao-emite", items: OPTS, form: { defaults: { f: 1 } }, props: {}, steps: [fsv(2), freset(), snap("depois")] },
  {
    id: "f-required-form", items: OPTS, form: { defaults: { f: null }, rules: { required: true } }, props: {},
    steps: [snap("inicial"), ftrigger, snap("trigger vazio"), fsv(1), snap("setValue sem validar"), ftrigger, snap("trigger preenchido"),
      fsv(null, true), snap("setValue vazio validando"), fsv(2, true), snap("setValue 2 validando"), freset(), snap("reset")],
  },
  { id: "f-required-prop-vira-regra", items: OPTS, form: { defaults: { f: null } }, props: { required: true }, steps: [ftrigger, snap("trigger com required da prop")] },
  { id: "f-required-valor-inexistente", items: OPTS, form: { defaults: { f: 99 }, rules: { required: true } }, props: {}, steps: [ftrigger, snap("trigger com valor inexistente")] },
  {
    id: "f-usuario-escolhe-com-erro", items: OPTS, form: { defaults: { f: null }, rules: { required: true } }, props: {},
    steps: [ftrigger, snap("com erro"), pick("Um"), snap("apos escolher")],
  },
  {
    id: "g-interagir-depois-de-setar", items: OPTS, form: { defaults: { f: 1 } }, props: {},
    steps: [fsv(3), pick("Dois"), snap("escolheu Dois depois do setValue"), fsv(1), snap("setValue 1")],
  },
  {
    id: "h-disabled-mostra-valor", items: OPTS, props: { value: 2, disabled: true },
    steps: [snap("inicial"), pick("Um"), snap("tentou escolher"), setv(3), snap("prop mudou")],
  },
  {
    id: "h-readonly-mostra-valor", items: OPTS, props: { value: 2, readOnly: true },
    steps: [snap("inicial"), pick("Um"), snap("tentou escolher"), setv(3), snap("prop mudou")],
  },
  {
    id: "h-disabled-form-setvalue", items: OPTS, form: { defaults: { f: 1 } }, props: { disabled: true },
    steps: [snap("inicial"), fsv(3), snap("setValue"), freset(), snap("reset")],
  },
];

// ---------------------------------------------------------------------------------------------- SgToggleSwitch
const focus = { op: "focus" };
const blur = { op: "blur" };
const toggle = { op: "toggle" };
export const toggleswitch = [
  { id: "a-checked-inicial", props: { checked: true }, steps: [snap("inicial")] },
  { id: "a-default-checked", props: { defaultChecked: true }, steps: [snap("inicial")] },
  { id: "a-sem-valor", props: {}, steps: [snap("inicial")] },
  {
    id: "b-checked-controlado-muda-por-fora", props: { checked: false },
    steps: [snap("false"), { op: "props", set: { checked: true } }, snap("true"), { op: "props", set: { checked: false } }, snap("false de novo"), { op: "props", set: { checked: false } }, snap("mesmo")],
  },
  {
    id: "b-controlado-ignora-clique-do-usuario", props: { checked: false },
    steps: [toggle, snap("apos clicar"), { op: "props", set: { checked: true } }, snap("pai acompanhou")],
  },
  {
    id: "b-nao-controlado-alterna", props: {},
    steps: [toggle, snap("ligou"), toggle, snap("desligou"), toggle, { op: "props", set: { checked: false } }, snap("pai setou false")],
  },
  {
    id: "b-valor-do-pai-por-texto-e-numero", props: { checked: "true" },
    steps: [snap("texto true"), { op: "props", set: { checked: 0 } }, snap("zero"), { op: "props", set: { checked: "on" } }, snap("on"), { op: "props", set: { checked: "off" } }, snap("off")],
  },
  {
    id: "c-form-default", form: { defaults: { f: true } }, props: {},
    steps: [snap("inicial"), fsv(false), snap("setValue false"), fsv(true), snap("setValue true"), fsv(null), snap("setValue null"), fsv("true"), snap("setValue texto true"),
      fsv(0), snap("setValue 0"), fsv(1), snap("setValue 1"), freset(), snap("reset"), freset({ f: false }), snap("reset com valores"), fsv(false), snap("setValue mesmo")],
  },
  { id: "c-form-sem-default", form: { defaults: {} }, props: {}, steps: [snap("inicial"), fsv(true), snap("setValue true"), freset(), snap("reset")] },
  {
    id: "c-form-clique-do-usuario-grava", form: { defaults: { f: false } }, props: {},
    steps: [toggle, snap("apos clicar"), fsv(false), snap("setValue false"), toggle, snap("clicou de novo")],
  },
  { id: "c-form-checked-prop-ignorada", form: { defaults: { f: true } }, props: { checked: false }, steps: [snap("inicial")] },
  {
    id: "e-onchange-emite-boolean", props: {},
    steps: [toggle, toggle, toggle, snap("tres cliques")],
  },
  { id: "e-set-programatico-nao-emite", props: { checked: false }, steps: [{ op: "props", set: { checked: true } }, { op: "props", set: { checked: false } }, snap("props mudaram")] },
  { id: "e-form-set-programatico-nao-emite", form: { defaults: { f: false } }, props: {}, steps: [fsv(true), freset(), snap("depois")] },
  {
    id: "f-required-form", form: { defaults: { f: false }, rules: { required: true } }, props: {},
    steps: [snap("inicial"), ftrigger, snap("trigger desligado"), fsv(true), snap("setValue sem validar"), ftrigger, snap("trigger ligado"),
      fsv(false, true), snap("setValue false validando"), fsv(true, true), snap("setValue true validando"), freset(), snap("reset")],
  },
  {
    id: "f-required-prop-valida-no-blur", props: { checked: true, required: true },
    steps: [focus, blur, snap("blur ligado"), { op: "props", set: { checked: false } }, focus, blur, snap("blur desligado"), { op: "props", set: { checked: true } }, snap("ligou por fora")],
  },
  {
    id: "f-required-prop-form", form: { defaults: { f: false } }, props: { required: true },
    steps: [ftrigger, snap("trigger com required da prop"), focus, blur, snap("blur desligado")],
  },
  {
    id: "f-usuario-liga-com-erro", form: { defaults: { f: false }, rules: { required: true } }, props: {},
    steps: [ftrigger, snap("com erro"), toggle, snap("apos ligar")],
  },
  {
    id: "g-interagir-depois-de-setar", form: { defaults: { f: false } }, props: {},
    steps: [fsv(true), toggle, snap("clicou depois do setValue"), fsv(true), snap("setValue true")],
  },
  {
    id: "h-disabled-mostra-valor", props: { checked: true, disabled: true },
    steps: [snap("inicial"), toggle, snap("tentou clicar"), { op: "props", set: { checked: false } }, snap("prop mudou")],
  },
  {
    id: "h-readonly-mostra-valor", props: { checked: true, readOnly: true },
    steps: [snap("inicial"), toggle, snap("tentou clicar"), { op: "props", set: { checked: false } }, snap("prop mudou")],
  },
  {
    id: "h-disabled-form-setvalue", form: { defaults: { f: false } }, props: { disabled: true },
    steps: [snap("inicial"), fsv(true), snap("setValue"), freset(), snap("reset")],
  },
];

// ---------------------------------------------------------------------------------------------- SgSlider
const drag = (to) => ({ op: "drag", to });
export const slider = [
  { id: "a-value-inicial", props: { value: 4 }, steps: [snap("inicial")] },
  { id: "a-default-value", props: { defaultValue: 6 }, steps: [snap("inicial")] },
  { id: "a-sem-valor", props: {}, steps: [snap("inicial")] },
  { id: "a-value-fora-da-faixa", props: { value: 99 }, steps: [snap("acima"), setv(-5), snap("abaixo")] },
  {
    id: "b-value-controlado-muda-por-fora", props: { value: 4 },
    steps: [snap("4"), setv(7), snap("7"), setv(0), snap("0"), setv(99), snap("99 vira 10"), setv(2.5), snap("2.5"), setv(2.5), snap("mesmo")],
  },
  { id: "b-controlado-ignora-arraste", props: { value: 4 }, steps: [drag(8), snap("apos arrastar"), setv(8), snap("pai acompanhou")] },
  { id: "b-nao-controlado-guarda-arraste", props: { defaultValue: 2 }, steps: [drag(8), snap("arrastou"), setv(3), snap("pai setou 3")] },
  {
    id: "c-form-default", form: { defaults: { f: 4 } }, props: {},
    steps: [snap("inicial"), fsv(7), snap("setValue 7"), fsv(null), snap("setValue null"), fsv("9"), snap("setValue texto 9"), fsv(99), snap("setValue 99"),
      fsv(-3), snap("setValue -3"), fsv("abc"), snap("setValue texto invalido"), freset(), snap("reset"), freset({ f: 6 }), snap("reset com valores"), fsv(6), snap("setValue mesmo")],
  },
  { id: "c-form-sem-default", form: { defaults: {} }, props: { minValue: 2 }, steps: [snap("inicial"), fsv(5), snap("setValue 5"), freset(), snap("reset")] },
  { id: "c-form-arraste-grava", form: { defaults: { f: 4 } }, props: {}, steps: [drag(8), snap("arrastou"), fsv(1), snap("setValue 1"), drag(3), snap("arrastou de novo")] },
  { id: "c-form-value-prop-ignorada", form: { defaults: { f: 4 } }, props: { value: 9 }, steps: [snap("inicial"), setv(2), snap("prop mudou")] },
  { id: "e-onchange-emite-numero", props: { value: 0 }, steps: [drag(3), drag(7), snap("arrastou"), setv(7), drag(7), snap("mesmo valor")] },
  { id: "e-set-programatico-nao-emite", props: { value: 1 }, steps: [setv(2), setv(3), snap("props mudaram")] },
  { id: "e-form-set-programatico-nao-emite", form: { defaults: { f: 1 } }, props: {}, steps: [fsv(2), freset(), snap("depois")] },
  { id: "e-passo", props: { value: 0, step: 5, maxValue: 20 }, steps: [setv(10), snap("10 com passo 5"), drag(15), snap("arrastou 15")] },
  {
    id: "f-regra-no-formulario", form: { defaults: { f: 3 }, rules: { required: true } }, props: {},
    steps: [ftrigger, snap("trigger com 3"), fsv(0, true), snap("setValue 0 validando"), fsv(null, true), snap("setValue null validando"), freset(), snap("reset")],
  },
  { id: "g-interagir-depois-de-setar", form: { defaults: { f: 1 } }, props: {}, steps: [fsv(9), drag(2), snap("arrastou depois do setValue"), fsv(9), snap("setValue 9")] },
  { id: "h-disabled-mostra-valor", props: { value: 5, disabled: true }, steps: [snap("inicial"), drag(8), snap("tentou arrastar"), setv(7), snap("prop mudou")] },
  { id: "h-disabled-form-setvalue", form: { defaults: { f: 1 } }, props: { disabled: true }, steps: [snap("inicial"), fsv(8), snap("setValue"), freset(), snap("reset")] },
];

// ---------------------------------------------------------------------------------------------- SgRating
const rate = (value) => ({ op: "rate", value });
const cancel = { op: "cancel" };
export const rating = [
  { id: "a-value-inicial", props: { value: 3 }, steps: [snap("inicial")] },
  { id: "a-value-meia-estrela", props: { value: 2.5, allowHalf: true }, steps: [snap("inicial")] },
  { id: "a-value-acima-das-estrelas", props: { value: 7 }, steps: [snap("inicial")] },
  { id: "a-sem-valor", props: {}, steps: [snap("inicial")] },
  {
    id: "b-value-muda-por-fora", props: { value: 2 },
    steps: [snap("2"), setv(4), snap("4"), setv(0), snap("0"), setv(2.5), snap("2.5 sem meia"), setv(5), snap("5"), setv(5), snap("mesmo")],
  },
  { id: "b-clique-do-usuario-vale-ate-o-pai-mudar", props: { value: 2 }, steps: [rate(4), snap("clicou 4"), setv(2), snap("pai reafirmou 2 (mesmo valor)"), setv(3), snap("pai setou 3")] },
  { id: "b-meia-estrela-por-clique", props: { value: 0, allowHalf: true }, steps: [rate(2.5), snap("meia"), rate(3), snap("inteira"), rate(1.5), snap("meia de novo")] },
  {
    id: "c-form-default", form: { defaults: { f: 3 } }, props: {},
    steps: [snap("inicial"), fsv(5), snap("setValue 5"), fsv(0), snap("setValue 0"), fsv(null), snap("setValue null"), fsv(2), snap("setValue 2"), fsv(2.5), snap("setValue 2.5"),
      freset(), snap("reset"), freset({ f: 4 }), snap("reset com valores"), fsv(4), snap("setValue mesmo")],
  },
  { id: "c-form-sem-default", form: { defaults: {} }, props: {}, steps: [snap("inicial"), fsv(2), snap("setValue 2"), freset(), snap("reset")] },
  { id: "c-form-clique-grava", form: { defaults: { f: 1 } }, props: {}, steps: [rate(4), snap("clicou 4"), fsv(2), snap("setValue 2"), rate(5), snap("clicou 5")] },
  { id: "c-form-value-prop-ignorada", form: { defaults: { f: 3 } }, props: { value: 1 }, steps: [snap("inicial"), setv(2), snap("prop mudou")] },
  { id: "d-quantidade-de-estrelas-muda", props: { value: 4, stars: 5 }, steps: [snap("5"), { op: "props", set: { stars: 3 } }, snap("3 estrelas"), { op: "props", set: { stars: 8 } }, snap("8 estrelas")] },
  { id: "e-onchange-emite-nota", props: { value: 0 }, steps: [rate(3), rate(3), snap("duas vezes"), cancel, snap("cancelou")] },
  { id: "e-set-programatico-nao-emite", props: { value: 1 }, steps: [setv(2), setv(3), snap("props mudaram")] },
  { id: "e-form-set-programatico-nao-emite", form: { defaults: { f: 1 } }, props: {}, steps: [fsv(2), freset(), snap("depois")] },
  {
    id: "f-required-form", form: { defaults: { f: null }, rules: { required: true } }, props: {},
    steps: [snap("inicial"), ftrigger, snap("trigger sem nota"), fsv(3), snap("setValue sem validar"), ftrigger, snap("trigger com nota"),
      fsv(0, true), snap("setValue 0 validando"), fsv(2, true), snap("setValue 2 validando"), freset(), snap("reset")],
  },
  { id: "f-required-prop-vira-regra", form: { defaults: { f: null } }, props: { required: true }, steps: [ftrigger, snap("trigger com required da prop")] },
  { id: "f-required-prop-cancelar", props: { value: 3, required: true }, steps: [cancel, snap("cancelou com required"), rate(2), snap("avaliou")] },
  {
    id: "f-usuario-avalia-com-erro", form: { defaults: { f: null }, rules: { required: true } }, props: {},
    steps: [ftrigger, snap("com erro"), rate(2), snap("apos avaliar")],
  },
  { id: "g-interagir-depois-de-setar", form: { defaults: { f: 1 } }, props: {}, steps: [fsv(4), rate(2), snap("clicou 2 depois do setValue"), fsv(4), snap("setValue 4")] },
  { id: "h-disabled-mostra-valor", props: { value: 3, disabled: true }, steps: [snap("inicial"), rate(5), snap("tentou clicar"), setv(1), snap("prop mudou")] },
  { id: "h-readonly-mostra-valor", props: { value: 3, readOnly: true }, steps: [snap("inicial"), rate(5), snap("tentou clicar"), setv(1), snap("prop mudou")] },
  { id: "h-disabled-form-setvalue", form: { defaults: { f: 1 } }, props: { disabled: true }, steps: [snap("inicial"), fsv(4), snap("setValue"), freset(), snap("reset")] },
];
