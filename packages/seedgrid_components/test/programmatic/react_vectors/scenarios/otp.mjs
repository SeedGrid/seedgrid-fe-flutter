import { snap, setv, fsv, freset, ftrigger } from "../common.mjs";

const type = (slot, text) => ({ op: "type", slot, text });
const focus = (slot) => ({ op: "focus", slot });
const blur = { op: "blur" };

export default [
  { id: "a-value-inicial", props: { value: "123456" }, steps: [snap("inicial")] },
  { id: "a-default-value", props: { defaultValue: "4321" }, steps: [snap("inicial")] },
  { id: "a-value-com-mascara", props: { value: "12-34", mask: "99-99" }, steps: [snap("com separador")] },
  { id: "a-value-so-digitos-na-mascara", props: { value: "1234", mask: "99-99" }, steps: [snap("sem separador")] },
  { id: "a-value-com-lixo", props: { value: "a1b2c3" }, steps: [snap("letras descartadas")] },
  { id: "a-value-alfanumerico", props: { value: "a1b2", mask: "####" }, steps: [snap("alfanumerico")] },
  { id: "a-value-maior-que-a-mascara", props: { value: "123456789" }, steps: [snap("excesso descartado")] },
  { id: "a-sem-valor", props: {}, steps: [snap("inicial")] },
  {
    id: "b-value-controlado-muda-por-fora", props: { value: "123456" },
    steps: [snap("123456"), setv(""), snap("vazio"), setv("12"), snap("12"), setv("abc"), snap("so letras"), setv("654321"), snap("654321"), setv("654321"), snap("mesmo")],
  },
  {
    id: "b-controlado-digitar-sem-o-pai-acompanhar", props: { value: "12" },
    steps: [type(2, "9"), snap("digitou 9 no slot 2"), setv("12"), snap("pai reafirmou o mesmo"), setv("77"), snap("pai setou 77")],
  },
  {
    id: "b-nao-controlado-digitar-e-pai-setar", props: {},
    steps: [type(0, "1"), type(1, "2"), snap("digitou 12"), setv("999"), snap("pai setou 999"), setv(""), snap("pai limpou")],
  },
  {
    id: "c-form-default", form: { defaults: { f: "123456" } }, props: {},
    steps: [snap("inicial"), fsv("654321"), snap("setValue 654321"), fsv(null), snap("setValue null"), fsv("ab"), snap("setValue letras"), fsv(123456), snap("setValue numero"),
      fsv("12"), snap("setValue 12"), freset(), snap("reset"), freset({ f: "999" }), snap("reset com valores"), fsv("999"), snap("setValue mesmo")],
  },
  { id: "c-form-sem-default", form: { defaults: {} }, props: {}, steps: [snap("inicial"), fsv("123"), snap("setValue"), freset(), snap("reset")] },
  {
    id: "c-form-digitar-grava-o-valor-sem-mascara", form: { defaults: { f: "" } }, props: { mask: "99-99" },
    steps: [type(0, "1"), type(1, "2"), type(2, "3"), snap("digitou 123"), fsv("9999"), snap("setValue 9999"), type(0, "5"), snap("digitou 5 no slot 0")],
  },
  { id: "c-form-value-prop-ignorada", form: { defaults: { f: "111" } }, props: { value: "222" }, steps: [snap("inicial"), setv("333"), snap("prop mudou")] },
  {
    id: "d-mascara-muda-com-valor", props: { value: "1234" },
    steps: [snap("999999"), { op: "props", set: { mask: "99-99" } }, snap("99-99"), { op: "props", set: { mask: "999" } }, snap("999"), { op: "props", set: { mask: "99999999" } }, snap("99999999")],
  },
  {
    id: "d-mascara-muda-nao-controlado", props: {},
    steps: [type(0, "1"), type(1, "2"), type(2, "3"), snap("digitou 123"), { op: "props", set: { mask: "99" } }, snap("mascara 99"), { op: "props", set: { mask: "9999" } }, snap("mascara 9999")],
  },
  {
    id: "d-mascara-muda-no-formulario", form: { defaults: { f: "1234" } }, props: {},
    steps: [{ op: "props", set: { mask: "99-99" } }, snap("99-99"), fsv("56"), snap("setValue 56")],
  },
  {
    id: "e-eventos-ao-digitar", props: { mask: "99-99" },
    steps: [type(0, "1"), snap("1"), type(1, "2"), type(2, "3"), snap("123"), type(3, "4"), snap("completo"), type(3, ""), snap("apagou o ultimo")],
  },
  {
    id: "e-colar-no-primeiro-slot", props: { mask: "99-99" },
    steps: [type(0, "12-34"), snap("colou 12-34"), type(0, "9"), snap("digitou 9 no primeiro")],
  },
  { id: "e-limpar-tudo-chama-onclear", props: { value: "12" }, steps: [type(0, ""), type(1, ""), snap("apagou tudo")] },
  { id: "e-set-programatico-nao-emite", props: { value: "12" }, steps: [setv("34"), setv("56"), snap("props mudaram")] },
  { id: "e-form-set-programatico-nao-emite", form: { defaults: { f: "12" } }, props: {}, steps: [fsv("34"), freset(), snap("depois")] },
  { id: "e-caractere-invalido-e-ignorado", props: { value: "12" }, steps: [type(2, "x"), snap("digitou x no slot de digito")] },
  {
    id: "f-required-form", form: { defaults: { f: "" }, rules: { required: true } }, props: {},
    steps: [snap("inicial"), ftrigger, snap("trigger vazio"), fsv("12"), snap("setValue sem validar"), ftrigger, snap("trigger preenchido"),
      fsv("", true), snap("setValue vazio validando"), fsv("12", true), snap("setValue 12 validando"), freset(), snap("reset")],
  },
  { id: "f-required-prop-vira-regra", form: { defaults: { f: "" } }, props: { required: true }, steps: [ftrigger, snap("trigger com required da prop")] },
  {
    id: "f-required-prop-valida-no-blur", props: { required: true },
    steps: [focus(0), blur, snap("blur vazio"), type(0, "1"), snap("digitou"), blur, snap("blur preenchido"), setv(""), snap("pai limpou")],
  },
  {
    id: "f-usuario-digita-com-erro", form: { defaults: { f: "" }, rules: { required: true } }, props: {},
    steps: [ftrigger, snap("com erro"), type(0, "1"), snap("apos digitar")],
  },
  {
    id: "f-validation-propria", props: { value: "12", validation: "min3" },
    steps: [focus(0), blur, snap("blur com 12"), type(2, "3"), blur, snap("blur com 123")],
  },
  {
    id: "g-focado-setvalue-e-continua-digitando", form: { defaults: { f: "12" } }, props: {},
    steps: [focus(0), fsv("789"), snap("focado + setValue"), type(3, "4"), snap("digitou no slot 3"), blur, snap("depois do blur")],
  },
  {
    id: "h-disabled-mostra-valor", props: { value: "12", disabled: true },
    steps: [snap("inicial"), type(2, "3"), snap("tentou digitar"), setv("99"), snap("prop mudou")],
  },
  {
    id: "h-readonly-mostra-valor", props: { value: "12", readOnly: true },
    steps: [snap("inicial"), type(2, "3"), snap("tentou digitar"), setv("99"), snap("prop mudou")],
  },
  { id: "h-disabled-form-setvalue", form: { defaults: { f: "12" } }, props: { disabled: true }, steps: [snap("inicial"), fsv("999"), snap("setValue"), freset(), snap("reset")] },
];
