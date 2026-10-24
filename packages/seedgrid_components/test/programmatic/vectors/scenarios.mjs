// Catalogo de cenarios (neutro de linguagem) executados no React pelo generate.mjs e no Dart pelos
// testes de test/programmatic. Cada cenario: { group, component, id, locale, mode, props, initial,
// defaultValues, rules, actions }. `mode: "form"` liga o campo a um useForm/SgFormController pelo
// nome "f"; `initial` e `{defaultValue}` ou `{value}` (valor controlado); `rerender` troca o `value`.
const U = { $undef: 1 };
const K = (...ks) => ks.map((key) => ({ key }));

const SPECS = [
  {
    comp: "text", group: "text", type: [{ typeText: "ab" }],
    values: ["Maria", "João Silva", "  espaço  ", "ação ✓", "A".repeat(40), "0", ""],
    variants: [
      { name: "limites", props: { maxLength: 10, minLength: 3 } },
      { name: "afixos", props: { prefixText: "R$ ", suffixText: " kg" }, values: ["R$ 12 kg", "12", "R$ 12", "12 kg", ""] },
    ],
  },
  {
    comp: "email", group: "text", type: [{ typeText: "a" }],
    values: ["ana@exemplo.com", "ANA@Exemplo.COM", "invalido", "a@b", "ana@mailinator.com", " ana@exemplo.com ", ""],
  },
  {
    comp: "password", group: "text", type: [{ typeText: "x" }],
    values: ["Abc#1234x", "senha", "123456", "Aa1!bcdE", "  ", ""],
  },
  {
    comp: "textarea", group: "text", type: [{ typeText: "z" }],
    values: ["linha1\nlinha2", "texto", "A".repeat(30), "ação ✓", ""],
    variants: [{ name: "limites", type: [], props: { maxLength: 10, minLength: 3 } }],
  },
  {
    comp: "search", group: "text", type: [{ typeText: "xyz" }, { wait: 450 }],
    values: ["abc", "  abc  ", "ab", ""],
    noInitial: true,
  },
  {
    comp: "cpf", group: "br", type: [{ typeText: "1" }],
    values: ["12345678909", "123.456.789-09", "529.982.247-25", "52998224725", "12345678901", "123", "123456789012345", "abc123.456.789-09xyz", "111.111.111-11", ""],
  },
  {
    comp: "cnpj", group: "br", type: [{ typeText: "1" }],
    values: ["11222333000181", "11.222.333/0001-81", "12.ABC.345/01DE-35", "12ABC34501DE35", "12abc34501de35", "1122233300018", "112223330001811111", "abc", "00.000.000/0000-00", ""],
  },
  {
    comp: "cpfcnpj", group: "br", type: [{ typeText: "1" }],
    values: ["12345678909", "123.456.789-09", "11222333000181", "11.222.333/0001-81", "12.ABC.345/01DE-35", "123456789012", "1122233300018", "abc", ""],
  },
  {
    comp: "phone", group: "br", type: [{ typeText: "1" }],
    values: ["11987654321", "(11) 98765-4321", "1134567890", "(11) 3456-7890", "+5511987654321", "5511987654321", "119876", "123456789012345", "abc11987654321", ""],
  },
  {
    comp: "postal", group: "br", type: [{ typeText: "1" }],
    values: ["01310100", "01310-100", "01310", "013101001234", "abc01310100", ""],
    variants: [
      { name: "US", props: { country: "US" }, values: ["12345", "123456789", "12345-6789", "1234", ""] },
      { name: "PT", props: { country: "PT" }, values: ["1000001", "1000-001", "1000", ""] },
      { name: "AR", props: { country: "AR" }, values: ["C1425ABC", "c1425abc", "1425", "C14", ""] },
      { name: "ES", props: { country: "ES" }, values: ["28001", "2800", "280011", ""] },
    ],
  },
  {
    comp: "date", group: "date", type: [{ input: "2021-03-04" }],
    values: ["2020-01-31", "31/01/2020", "2020-01-31T10:20:30Z", "20200131", "2020-02-30", "abc", "2020-1-5", "0001-01-01", "9999-12-31", ""],
    variants: [{ name: "intervalo", props: { minDate: "2020-01-01", maxDate: "2020-12-31" }, values: ["2020-06-15", "2019-12-31", "2021-01-01", "2020-01-01", ""] }],
  },
  {
    comp: "birth", group: "date", type: [{ input: "1991-03-04" }],
    props: { minAge: 18 },
    values: ["1990-01-01", "2099-01-01", "2000-02-30", "2020-01-01", "31/01/1990", "abc", ""],
    variants: [{ name: "idade", props: { minAge: 18, maxAge: 65 }, values: ["1990-01-01", "1900-01-01", "2020-01-01", ""] }],
  },
  {
    comp: "number", group: "number", type: K("1"),
    values: ["1234.5", "1234,50", "1.234,56", "-12.5", "0", "", "abc", "12345678901234567890", "0.005", "1,234.56", 1234.5, -1, 0, 12],
    variants: [
      { name: "d0", props: { decimals: 0 }, values: ["12.7", 12.7, "1234", "-5", ""] },
      { name: "nulo", props: { emptyValue: "null" }, values: ["", "0", "5", 0] },
      { name: "semneg", props: { allowNegative: false }, values: ["-5", -5, "5"] },
      { name: "enUS", locale: "en-US", props: {}, values: ["1234.5", "1,234.56", "1234,50", ""] },
      { name: "limites", props: { minValue: 10, maxValue: 100 }, values: ["5", "50", "500", ""] },
    ],
  },
  {
    comp: "currency", group: "number", type: K("1"),
    props: { currency: "BRL", locale: "pt-BR" },
    values: [1234.5, "1234,50", "1234.5", "-12.5", -12.5, 0, "0", "", "abc", "1.234,56", 12],
    variants: [
      { name: "USD", locale: "en-US", props: { currency: "USD", locale: "en-US" }, values: [1234.5, "1,234.56", "1234.5", -1, ""] },
      { name: "JPY", props: { currency: "JPY", locale: "ja-JP" }, values: [1234, "1234.5", 1234.5, ""] },
      { name: "nulo", props: { currency: "BRL", locale: "pt-BR", emptyValue: "null" }, values: ["", 0, "0", 5] },
    ],
  },
  {
    comp: "stepper", group: "number", type: [{ up: 1 }, { up: 1 }],
    props: { minValue: 0, maxValue: 10, step: 1 },
    values: [5, 11, -3, "7", "", 2.5, 0, 10],
    variants: [{ name: "passo", props: { minValue: 0, maxValue: 100, step: 5 }, values: [50, 52, 100, 101] }],
  },
];

const idv = (v) => (v === null ? "null" : typeof v === "string" ? `s:${JSON.stringify(v)}` : `n:${v}`);

export function buildScenarios() {
  const out = [];
  for (const spec of SPECS) {
    const all = [{ name: "base", props: spec.props ?? {}, values: spec.values, locale: spec.locale }, ...(spec.variants ?? []).map((v) => ({ ...v, props: { ...(spec.props ?? {}), ...v.props } }))];
    for (const variant of all) {
      const base = (id, extra) =>
        out.push({
          group: spec.group, component: spec.comp, id: `${spec.comp}|${variant.name}|${id}`,
          locale: variant.locale ?? "pt-BR", mode: "plain", props: variant.props, actions: [], ...extra,
        });
      const values = variant.values ?? spec.values;
      const strs = values.filter((v) => typeof v === "string");
      const ty = variant.type ?? spec.type;
      for (const v of values) {
        const n = idv(v);
        if (spec.noInitial) {
          base(`form-set|${n}`, { mode: "form", actions: [{ setValue: v }, { focus: 1 }, { blur: 1 }, ...ty, { blur: 1 }, { setValue: "" }, { reset: null }, { reset: { f: v } }] });
          base(`form-valida|${n}`, { mode: "form", props: { ...variant.props, required: true }, actions: [{ setValue: v, opts: { shouldValidate: true } }, { trigger: 1 }, { setValue: "", opts: { shouldValidate: true } }, { trigger: 1 }] });
          base(`foco|${n}`, { mode: "form", actions: [{ focus: 1 }, { setValue: v }, ...ty, { setValue: v }, { blur: 1 }] });
          base(`disabled|${n}`, { mode: "form", props: { ...variant.props, enabled: false }, actions: [{ setValue: v }, { reset: { f: v } }, { reset: null }] });
          continue;
        }
        // (a) valor inicial sem formulario (defaultValue) e controlado (value)
        base(`init|${n}`, { initial: { defaultValue: v }, actions: [{ focus: 1 }, { blur: 1 }, ...ty, { blur: 1 }] });
        base(`valor|${n}`, { initial: { value: v }, actions: [{ focus: 1 }, ...ty, { blur: 1 }] });
        // (c) valor inicial vindo do formulario (defaultValues)
        base(`form-default|${n}`, { mode: "form", defaultValues: { f: v }, actions: [{ focus: 1 }, { blur: 1 }, ...ty, { blur: 1 }] });
        // (d) setValue / reset
        base(`form-set|${n}`, {
          mode: "form",
          actions: [
            { setValue: v }, { focus: 1 }, { blur: 1 }, ...ty, { blur: 1 },
            { setValue: "" }, { setValue: v, opts: { shouldValidate: true } },
            { reset: null }, { reset: { f: v } }, { reset: null },
          ],
        });
        // (f) validacao depois de setar
        base(`form-valida|${n}`, {
          mode: "form", props: { ...variant.props, required: true },
          actions: [
            { setValue: v, opts: { shouldValidate: true } }, { trigger: 1 },
            { setValue: "", opts: { shouldValidate: true } }, { trigger: 1 },
            { setValue: v }, { focus: 1 }, { blur: 1 },
          ],
        });
        // (g) setar com foco e digitar depois
        base(`foco|${n}`, {
          mode: "form",
          actions: [{ focus: 1 }, { setValue: v }, ...ty, { setValue: "" }, { setValue: v }, ...ty, { blur: 1 }],
        });
        // (h) disabled
        base(`disabled|${n}`, {
          mode: "form", props: { ...variant.props, enabled: false },
          actions: [{ setValue: v }, { reset: { f: v } }, { reset: null }, { trigger: 1 }],
        });
        base(`disabled-valor|${n}`, {
          props: { ...variant.props, enabled: false }, initial: { value: values[0] },
          actions: [{ rerender: { value: v } }, { rerender: { value: values[0] } }],
        });
      }
      if (spec.noInitial) {
        base("form-seq", { mode: "form", actions: [...values.map((v) => ({ setValue: v })), { setValue: null }, { reset: null }] });
        continue;
      }
      // (b) value controlado mudando por fora: sequencia, mesmo valor, vazio
      base("valor-seq", {
        initial: { value: values[0] },
        actions: [
          ...values.map((v) => ({ rerender: { value: v } })),
          { rerender: { value: values[0] } }, { rerender: { value: values[0] } },
          { rerender: { value: "" } }, { rerender: { value: values[0] } },
        ],
      });
      base("valor-digitado", {
        initial: { value: values[0] },
        actions: [{ focus: 1 }, ...ty, { rerender: { value: values[0] } }, { rerender: { value: values[values.length - 1] } }, { blur: 1 }],
      });
      // (c/d) sequencia de setValue e reset num mesmo campo
      base("form-seq", {
        mode: "form", defaultValues: { f: values[0] },
        actions: [
          ...values.map((v) => ({ setValue: v })), { setValue: null },
          { setValue: values[0] }, { setValue: values[0] },
          { reset: null }, { reset: { f: values[values.length - 1] } }, { reset: { f: values[0] } },
        ],
      });
      base("form-seq-valida", {
        mode: "form", props: { ...variant.props, required: true }, defaultValues: { f: values[0] },
        actions: [
          ...values.flatMap((v) => [{ setValue: v, opts: { shouldValidate: true } }]),
          { setValue: null, opts: { shouldValidate: true } }, { trigger: 1 }, { reset: null }, { trigger: 1 },
        ],
      });
      // regras proprias (RHF rules) alem das do componente
      base("form-rules", {
        mode: "form", rules: { validate: "evenLen" },
        actions: [...values.slice(0, 5).flatMap((v) => [{ setValue: v, opts: { shouldValidate: true } }]), { focus: 1 }, { blur: 1 }],
      });
      // limpar pelo botao (so campos de texto/numero) e valor nulo/indefinido
      base("limpar", {
        mode: "form", defaultValues: { f: values[0] },
        actions: spec.comp === "stepper" ? [{ up: 1 }, { setValue: values[0] }] : [{ focus: 1 }, { clear: 1 }, { setValue: values[0] }, { clear: 1 }],
      });
      void strs;
    }
  }
  return out;
}
