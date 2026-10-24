import { snap, setv, fsv, freset, ftrigger, FR } from "../common.mjs";

// O valor do Autocomplete e o TEXTO (rotulo escolhido), nao o id.
export default [
  { id: "a-valor-inicial", items: FR, props: { value: "Beta" }, steps: [snap("inicial")] },
  { id: "a-valor-inicial-fora-das-opcoes", items: FR, props: { value: "Zeta" }, steps: [snap("inicial")] },
  { id: "a-sem-valor", items: FR, props: {}, steps: [snap("inicial")] },
  {
    id: "b-value-controlado-muda-por-fora", items: FR, props: { value: "Beta" },
    steps: [snap("Beta"), setv("Gama"), snap("Gama"), setv(""), snap("vazio"), setv("Zeta"), snap("fora das opcoes"), setv("Beta"), snap("volta"), setv("Beta"), snap("mesmo")],
  },
  {
    id: "b-escolha-do-usuario-pai-nao-acompanha", items: FR, props: { value: "Alfa" },
    steps: [{ op: "open" }, { op: "pick", label: "Beta" }, snap("apos escolher"), setv("Gama"), snap("pai setou Gama")],
  },
  {
    id: "b-escolha-e-pai-acompanha", items: FR, props: { value: "" },
    steps: [{ op: "open" }, { op: "pick", label: "Beta" }, snap("apos escolher"), setv("Beta"), snap("pai ecoou"), setv(""), snap("pai limpou")],
  },
  {
    id: "c-form-default", items: FR, form: { defaults: { f: "Beta" } }, props: {},
    steps: [snap("inicial"), fsv("Gama"), snap("setValue Gama"), fsv(null), snap("setValue null"), fsv("Zeta"), snap("setValue fora das opcoes"), fsv("Alfa"), snap("setValue Alfa"),
      freset(), snap("reset"), freset({ f: "Delta" }), snap("reset com valores"), fsv("Delta"), snap("setValue mesmo")],
  },
  { id: "c-form-sem-default", items: FR, form: { defaults: {} }, props: {}, steps: [snap("inicial"), fsv("Beta"), snap("setValue"), freset(), snap("reset")] },
  {
    id: "c-form-escolha-do-usuario-grava", items: FR, form: { defaults: { f: "Alfa" } }, props: {},
    steps: [{ op: "open" }, { op: "pick", label: "Beta" }, snap("apos escolher"), fsv("Gama"), snap("setValue")],
  },
  {
    id: "d-opcoes-chegam-depois", items: [], props: { value: "Beta" },
    steps: [snap("sem opcoes"), { op: "items", items: FR }, snap("com opcoes"), { op: "open" }, snap("lista aberta")],
  },
  {
    id: "d-fonte-assincrona-valor-ja-setado", sourceKind: "async", delay: 300, items: FR, props: { value: "Beta" },
    steps: [snap("antes de carregar"), { op: "wait", ms: 450 }, snap("depois"), { op: "open" }, snap("carregando"), { op: "wait", ms: 450 }, snap("lista carregada")],
  },
  {
    id: "d-opcoes-mudam-com-valor", items: FR, props: { value: "Beta" },
    steps: [{ op: "items", items: [{ id: 9, label: "Omega" }] }, snap("outras opcoes"), { op: "open" }, snap("lista com outras opcoes")],
  },
  {
    id: "e-onchange-ao-escolher", items: FR, props: {},
    steps: [{ op: "open" }, { op: "pick", label: "Beta" }, snap("escolheu Beta"), { op: "open" }, { op: "pick", label: "Beta" }, snap("mesmo"), { op: "open" }, snap("lista aberta com selecao")],
  },
  { id: "e-set-programatico-nao-emite", items: FR, props: { value: "Alfa" }, steps: [setv("Beta"), setv("Gama"), setv(""), snap("props mudaram")] },
  { id: "e-form-set-programatico-nao-emite", items: FR, form: { defaults: { f: "Alfa" } }, props: {}, steps: [fsv("Beta"), freset(), snap("depois")] },
  {
    id: "e-digitar-sem-allowcustom-emite-vazio-e-blur-restaura", items: FR, props: { value: "Beta" },
    steps: [{ op: "focus" }, { op: "type", text: "Al" }, snap("digitou Al"), { op: "blur" }, snap("blur restaura")],
  },
  {
    id: "e-digitar-allowcustom", items: FR, props: { value: "Beta", allowCustomValue: true },
    steps: [{ op: "focus" }, { op: "type", text: "Zeta" }, snap("digitou Zeta"), { op: "blur" }, snap("blur mantem")],
  },
  {
    id: "e-digitar-e-escolher-da-lista", items: FR, props: {},
    steps: [{ op: "focus" }, { op: "type", text: "ga" }, snap("digitou ga"), { op: "pick", label: "Gama" }, snap("escolheu")],
  },
  {
    id: "f-required-form", items: FR, form: { defaults: { f: "" }, rules: { required: true } }, props: {},
    steps: [snap("inicial"), ftrigger, snap("trigger vazio"), fsv("Beta"), snap("setValue sem validar"), ftrigger, snap("trigger preenchido"),
      fsv("", true), snap("setValue vazio validando"), fsv("Beta", true), snap("setValue Beta validando"), freset(), snap("reset")],
  },
  {
    id: "f-required-prop-e-blur-vazio", items: FR, form: { defaults: { f: "" } }, props: { required: true },
    steps: [ftrigger, snap("trigger com required da prop"), { op: "focus" }, { op: "blur" }, snap("blur vazio")],
  },
  {
    id: "f-usuario-escolhe-com-erro", items: FR, form: { defaults: { f: "" }, rules: { required: true } }, props: {},
    steps: [ftrigger, snap("com erro"), { op: "open" }, { op: "pick", label: "Alfa" }, snap("apos escolher")],
  },
  {
    id: "g-campo-focado-setvalue", items: FR, form: { defaults: { f: "Alfa" } }, props: {},
    steps: [{ op: "focus" }, fsv("Gama"), snap("focado + setValue"), { op: "blur" }, snap("depois do blur")],
  },
  {
    id: "g-painel-aberto-setvalue", items: FR, form: { defaults: { f: "Alfa" } }, props: {},
    steps: [{ op: "open" }, snap("aberto"), fsv("Gama"), snap("setValue com painel aberto"), { op: "pick", label: "Delta" }, snap("escolheu depois")],
  },
  {
    id: "g-painel-aberto-prop", items: FR, props: { value: "Alfa" },
    steps: [{ op: "open" }, setv("Beta"), snap("prop com painel aberto"), { op: "pick", label: "Delta" }, snap("escolheu")],
  },
  {
    id: "h-disabled-mostra-valor", items: FR, props: { value: "Beta", disabled: true },
    steps: [snap("inicial"), { op: "open" }, snap("tentou abrir"), setv("Gama"), snap("prop mudou")],
  },
  {
    id: "h-disabled-form-setvalue", items: FR, form: { defaults: { f: "Alfa" } }, props: { disabled: true },
    steps: [snap("inicial"), fsv("Gama"), snap("setValue"), freset(), snap("reset")],
  },
];
