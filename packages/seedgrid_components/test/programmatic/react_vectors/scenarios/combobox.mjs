import { snap, setv, unset, fsv, freset, ftrigger, NUM, STR } from "../common.mjs";

export default [
  { id: "a-valor-inicial-numerico", items: NUM, props: { value: 2 }, steps: [snap("inicial")] },
  { id: "a-valor-inicial-texto", items: STR, props: { value: "b" }, steps: [snap("inicial")] },
  { id: "a-valor-inicial-inexistente", items: NUM, props: { value: 99 }, steps: [snap("inicial")] },
  { id: "a-sem-valor", items: NUM, props: {}, steps: [snap("inicial")] },
  {
    id: "b-value-controlado-muda-por-fora", items: NUM, props: { value: 2 },
    steps: [snap("2"), setv(3), snap("3"), setv(null), snap("null"), setv(99), snap("inexistente"), setv(2), snap("volta 2"), setv(2), snap("mesmo 2")],
  },
  { id: "b-value-vazio-texto", items: NUM, props: { value: 2 }, steps: [setv(""), snap("vazio")] },
  {
    id: "b-value-controlado-ignora-escolha-do-usuario", items: NUM, props: { value: 1 },
    steps: [{ op: "open" }, { op: "pick", label: "Tres" }, snap("apos escolher"), setv(2), snap("pai setou 2")],
  },
  {
    id: "b-nulo-inicial-controlado-escolhe", items: NUM, props: { value: null },
    steps: [snap("inicial"), { op: "open" }, { op: "pick", label: "Dois" }, snap("apos escolher"), setv(3), snap("pai 3"), setv(null), snap("pai null")],
  },
  {
    id: "c-form-default", items: NUM, form: { defaults: { f: 2 } }, props: {},
    steps: [snap("inicial"), fsv(3), snap("setValue 3"), fsv(null), snap("setValue null"), fsv(99), snap("setValue inexistente"), fsv(1), snap("setValue 1"),
      freset(), snap("reset"), freset({ f: 3 }), snap("reset com valores"), fsv(3), snap("setValue mesmo")],
  },
  { id: "c-form-sem-default", items: NUM, form: { defaults: {} }, props: {}, steps: [snap("inicial"), fsv(2), snap("setValue 2"), freset(), snap("reset")] },
  {
    id: "c-form-escolha-do-usuario-grava", items: NUM, form: { defaults: { f: 1 } }, props: {},
    steps: [{ op: "open" }, { op: "pick", label: "Dois" }, snap("apos escolher"), fsv(3), snap("setValue 3")],
  },
  { id: "c-form-value-prop-ignorada", items: NUM, form: { defaults: { f: 3 } }, props: { value: 1 }, steps: [snap("inicial"), setv(2), snap("prop mudou")] },
  { id: "c-form-valor-texto-no-id-numerico", items: NUM, form: { defaults: { f: "2" } }, props: {}, steps: [snap("inicial"), fsv("3"), snap("setValue texto 3")] },
  {
    id: "d-opcoes-tardias-lista", items: [], props: { value: 2 },
    steps: [snap("sem opcoes"), { op: "items", items: NUM }, snap("com opcoes"), { op: "items", items: [] }, snap("opcoes sumiram"), { op: "items", items: STR }, snap("outras opcoes")],
  },
  {
    id: "d-opcoes-tardias-assincronas", sourceKind: "async", delay: 300, items: NUM, props: { value: 2 },
    steps: [snap("antes de carregar"), { op: "wait", ms: 450 }, snap("depois de carregar")],
  },
  {
    id: "d-opcoes-tardias-assincronas-form", sourceKind: "async", delay: 300, items: NUM, form: { defaults: { f: 3 } }, props: {},
    steps: [snap("antes"), { op: "wait", ms: 450 }, snap("depois"), fsv(1), snap("setValue 1"), fsv(99), { op: "wait", ms: 450 }, snap("setValue inexistente")],
  },
  {
    id: "d-opcoes-mudam-rotulo", items: NUM, props: { value: 2 },
    steps: [snap("antes"), { op: "items", items: [{ id: 1, label: "Um" }, { id: 2, label: "Dois (novo)" }, { id: 3, label: "Tres" }] }, snap("rotulo mudou")],
  },
  { id: "d-tipo-id-numerico-valor-texto", items: NUM, props: { value: "2" }, steps: [snap("valor texto, id numero")] },
  { id: "d-tipo-id-texto-valor-numerico", items: [{ id: "1", label: "Um" }, { id: "2", label: "Dois" }], props: { value: 2 }, steps: [snap("valor numero, id texto")] },
  {
    id: "e-onchange-emite-id-original", items: NUM, props: {},
    steps: [{ op: "open" }, { op: "pick", label: "Dois" }, snap("escolheu 2"), { op: "open" }, { op: "pick", label: "Dois" }, snap("mesmo item"), { op: "open" }, { op: "pick", label: "Um" }, snap("escolheu 1")],
  },
  {
    id: "e-set-programatico-nao-emite", items: NUM, props: { value: 1 },
    steps: [setv(2), setv(3), snap("props mudaram"), { op: "open" }, { op: "pick", label: "Um" }, snap("usuario escolheu")],
  },
  { id: "e-form-set-programatico-nao-emite", items: NUM, form: { defaults: { f: 1 } }, props: {}, steps: [fsv(2), freset(), snap("depois de setValue e reset")] },
  {
    id: "e-nao-controlado-guarda-escolha", items: STR, props: {},
    steps: [{ op: "open" }, { op: "pick", label: "Beta" }, snap("escolheu"), setv("c"), snap("pai setou c"), unset, snap("pai tirou value")],
  },
  {
    id: "f-required-form", items: NUM, form: { defaults: { f: null }, rules: { required: true } }, props: {},
    steps: [snap("inicial"), ftrigger, snap("trigger vazio"), fsv(2), snap("setValue sem validar"), ftrigger, snap("trigger preenchido"),
      fsv(null, true), snap("setValue vazio validando"), fsv(2, true), snap("setValue 2 validando"), freset(), snap("reset")],
  },
  { id: "f-required-valor-inexistente", items: NUM, form: { defaults: { f: 99 }, rules: { required: true } }, props: {}, steps: [ftrigger, snap("trigger com id inexistente")] },
  {
    id: "f-usuario-escolhe-com-erro", items: NUM, form: { defaults: { f: null }, rules: { required: true } }, props: {},
    steps: [ftrigger, snap("com erro"), { op: "open" }, { op: "pick", label: "Um" }, snap("apos escolher")],
  },
  {
    id: "g-painel-aberto-setvalue", items: NUM, form: { defaults: { f: 1 } }, props: {},
    steps: [{ op: "open" }, snap("aberto"), fsv(3), snap("setValue com painel aberto"), { op: "pick", label: "Um" }, snap("escolheu depois")],
  },
  {
    id: "g-painel-aberto-prop", items: NUM, props: { value: 1 },
    steps: [{ op: "open" }, setv(2), snap("prop com painel aberto"), { op: "pick", label: "Tres" }, snap("escolheu"), { op: "close" }, snap("fechado")],
  },
  {
    id: "g-campo-focado-setvalue", items: NUM, form: { defaults: { f: 1 } }, props: {},
    steps: [{ op: "focus" }, fsv(2), snap("focado + setValue"), { op: "open" }, { op: "pick", label: "Tres" }, snap("escolheu")],
  },
  {
    id: "h-disabled-mostra-valor", items: NUM, props: { value: 2, disabled: true },
    steps: [snap("inicial"), { op: "open" }, snap("tentou abrir"), setv(3), snap("prop mudou")],
  },
  {
    id: "h-disabled-form-setvalue", items: NUM, form: { defaults: { f: 1 } }, props: { disabled: true },
    steps: [snap("inicial"), fsv(3), snap("setValue"), freset(), snap("reset")],
  },
];
