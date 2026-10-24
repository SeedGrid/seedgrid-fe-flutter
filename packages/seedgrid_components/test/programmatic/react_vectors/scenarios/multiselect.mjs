import { snap, setv, unset, fsv, freset, ftrigger } from "../common.mjs";

const MS = [
  { value: 1, label: "Um" },
  { value: 2, label: "Dois" },
  { value: 3, label: "Tres" },
  { value: 4, label: "Quatro", disabled: true },
];
const MSTR = [{ value: "1", label: "Um" }, { value: "2", label: "Dois" }];
const MCHIP = [{ value: 1, label: "1 - Filial Centro", chipLabel: "1" }, { value: 2, label: "2 - Filial Norte", chipLabel: "2" }];
const open = { op: "open" };
const tog = (label) => ({ op: "toggle", label });

// `chips` liga os passos que so existem no SgMultiSelectChips (remover chip).
export default function scenarios(chips) {
  const list = [
    { id: "a-valor-inicial", items: MS, props: { value: [2] }, steps: [snap("inicial")] },
    { id: "a-valor-inicial-varios-resumo", items: MS, props: { value: [1, 2, 3] }, steps: [snap("tres valores")] },
    { id: "a-valor-inicial-inexistente", items: MS, props: { value: [99] }, steps: [snap("inicial")] },
    { id: "a-valor-inicial-misto", items: MS, props: { value: [2, 99, 1] }, steps: [snap("inicial")] },
    { id: "a-sem-valor", items: MS, props: {}, steps: [snap("inicial")] },
    { id: "a-chip-label", items: MCHIP, props: { value: [1, 2] }, steps: [snap("inicial"), open, snap("aberto")] },
    {
      id: "b-value-controlado-muda-por-fora", items: MS, props: { value: [1] },
      steps: [snap("[1]"), setv([2, 3]), snap("[2,3]"), setv([]), snap("[]"), setv([99]), snap("[99]"), setv([3, 1]), snap("[3,1]"), setv([3, 1]), snap("mesmo")],
    },
    {
      id: "b-value-controlado-nulo-vira-vazio", items: MS, props: { value: [1] },
      steps: [setv(null), snap("null")],
    },
    {
      id: "b-controlado-ignora-clique-do-usuario", items: MS, props: { value: [1] },
      steps: [open, tog("Dois"), snap("apos clicar"), setv([1, 2]), snap("pai acompanhou")],
    },
    {
      id: "b-nao-controlado-acumula", items: MS, props: {},
      steps: [open, tog("Um"), tog("Tres"), snap("marcou 1 e 3"), tog("Um"), snap("desmarcou 1"), setv([2]), snap("pai setou [2]"), setv([]), snap("pai limpou")],
    },
    {
      id: "c-form-default", items: MS, form: { defaults: { f: [2] } }, props: {},
      steps: [snap("inicial"), fsv([1, 3]), snap("setValue [1,3]"), fsv([]), snap("setValue []"), fsv(null), snap("setValue null"), fsv([99]), snap("setValue inexistente"),
        fsv([1]), snap("setValue [1]"), freset(), snap("reset"), freset({ f: [3] }), snap("reset com valores"), fsv([3]), snap("setValue mesmo")],
    },
    { id: "c-form-sem-default", items: MS, form: { defaults: {} }, props: {}, steps: [snap("inicial"), fsv([2]), snap("setValue"), freset(), snap("reset")] },
    {
      id: "c-form-escolha-do-usuario-grava", items: MS, form: { defaults: { f: [1] } }, props: {},
      steps: [open, tog("Dois"), snap("apos marcar"), fsv([3]), snap("setValue"), tog("Um"), snap("marcou mais um")],
    },
    { id: "c-form-value-prop-ignorada", items: MS, form: { defaults: { f: [3] } }, props: { value: [1] }, steps: [snap("inicial"), setv([2]), snap("prop mudou")] },
    { id: "c-form-valor-texto-em-opcao-numerica", items: MS, form: { defaults: { f: ["2"] } }, props: {}, steps: [snap("inicial"), fsv(["1", "3"]), snap("setValue textos")] },
    {
      id: "d-opcoes-tardias", items: [], props: { value: [2, 3] },
      steps: [snap("sem opcoes"), { op: "items", items: MS }, snap("com opcoes"), { op: "items", items: [] }, snap("sumiram"), { op: "items", items: MSTR }, snap("outras opcoes")],
    },
    {
      id: "d-opcoes-tardias-form", items: [], form: { defaults: { f: [1, 2] } }, props: {},
      steps: [snap("sem opcoes"), { op: "items", items: MS }, snap("com opcoes"), fsv([3]), snap("setValue")],
    },
    {
      id: "d-opcoes-mudam-rotulo", items: MS, props: { value: [2] },
      steps: [{ op: "items", items: [{ value: 1, label: "Um" }, { value: 2, label: "Dois (novo)" }] }, snap("rotulo mudou")],
    },
    { id: "d-tipo-valor-numerico-opcao-texto", items: MSTR, props: { value: [2] }, steps: [snap("valor numero, opcao texto")] },
    { id: "d-tipo-valor-texto-opcao-numerica", items: MS, props: { value: ["2", "1"] }, steps: [snap("valor texto, opcao numero")] },
    {
      id: "e-onchange-emite-lista-completa", items: MS, props: { value: [] },
      steps: [open, tog("Dois"), snap("marcou Dois"), setv([2]), tog("Um"), snap("marcou Um"), setv([2, 1]), tog("Dois"), snap("desmarcou Dois")],
    },
    {
      id: "e-opcao-desabilitada-e-max", items: MS, props: { value: [1], maxSelected: 2 },
      steps: [open, snap("aberto"), tog("Quatro"), snap("clicou desabilitada"), tog("Dois"), setv([1, 2]), tog("Tres"), snap("alem do maximo")],
    },
    {
      id: "e-set-programatico-nao-emite", items: MS, props: { value: [1] },
      steps: [setv([2]), setv([3]), snap("props mudaram")],
    },
    { id: "e-form-set-programatico-nao-emite", items: MS, form: { defaults: { f: [1] } }, props: {}, steps: [fsv([2]), freset(), snap("depois")] },
    {
      id: "e-limpar", items: MS, props: { value: [1, 2], clearable: true },
      steps: [snap("antes"), { op: "clear" }, snap("clicou limpar"), setv([]), snap("pai limpou")],
    },
    {
      id: "e-limpar-form", items: MS, form: { defaults: { f: [1, 2] } }, props: { clearable: true },
      steps: [{ op: "clear" }, snap("clicou limpar")],
    },
    {
      id: "e-busca", items: MS, props: { value: [2], searchable: true },
      steps: [open, { op: "search", text: "tr" }, snap("filtrou tr"), tog("Tres"), snap("marcou Tres")],
    },
    {
      id: "f-required-form", items: MS, form: { defaults: { f: [] }, rules: { required: true } }, props: {},
      steps: [snap("inicial"), ftrigger, snap("trigger vazio"), fsv([1]), snap("setValue sem validar"), ftrigger, snap("trigger preenchido"),
        fsv([], true), snap("setValue vazio validando"), fsv([2], true), snap("setValue [2] validando"), freset(), snap("reset")],
    },
    { id: "f-required-valor-inexistente", items: MS, form: { defaults: { f: [99] }, rules: { required: true } }, props: {}, steps: [ftrigger, snap("trigger com valor inexistente")] },
    { id: "f-required-prop-nao-vira-regra", items: MS, form: { defaults: { f: [] } }, props: { required: true }, steps: [ftrigger, snap("trigger")] },
    {
      id: "f-usuario-marca-com-erro", items: MS, form: { defaults: { f: [] }, rules: { required: true } }, props: {},
      steps: [ftrigger, snap("com erro"), open, tog("Um"), snap("apos marcar")],
    },
    {
      id: "g-painel-aberto-setvalue", items: MS, form: { defaults: { f: [1] } }, props: {},
      steps: [open, snap("aberto"), fsv([2, 3]), snap("setValue com painel aberto"), tog("Um"), snap("marcou depois"), { op: "close" }, snap("fechou")],
    },
    {
      id: "g-painel-aberto-prop", items: MS, props: { value: [1] },
      steps: [open, setv([3]), snap("prop com painel aberto"), tog("Dois"), snap("clicou (pai nao acompanha)")],
    },
    {
      id: "h-disabled-mostra-valor", items: MS, props: { value: [2], disabled: true, clearable: true },
      steps: [snap("inicial"), open, snap("tentou abrir"), setv([3]), snap("prop mudou")],
    },
    {
      id: "h-disabled-form-setvalue", items: MS, form: { defaults: { f: [1] } }, props: { disabled: true },
      steps: [snap("inicial"), fsv([3]), snap("setValue"), freset(), snap("reset")],
    },
  ];
  if (chips) {
    list.push(
      {
        id: "e-remover-chip", items: MS, props: { value: [1, 2] },
        steps: [{ op: "removeChip", label: "Um" }, snap("clicou remover Um"), setv([2]), snap("pai removeu")],
      },
      {
        id: "e-remover-chip-form", items: MS, form: { defaults: { f: [1, 2, 3] } }, props: {},
        steps: [{ op: "removeChip", label: "Dois" }, snap("removeu Dois"), fsv([1, 2, 3]), snap("setValue de novo")],
      },
      { id: "h-disabled-sem-botao-remover", items: MS, props: { value: [1, 2], disabled: true }, steps: [snap("inicial")] },
    );
  }
  return list;
}
