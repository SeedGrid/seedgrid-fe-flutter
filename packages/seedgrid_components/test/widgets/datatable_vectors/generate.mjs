// Vetores de paridade de SgDatatable. A verdade e o CODIGO REAL DO REACT, executado de verdade:
//   - o SgDatatable.tsx inteiro e empacotado (esbuild) com um sufixo `export { ... }` das funcoes puras
//     (normalizeFilters, matchesFilter, compareValues, buildPageTokens...), sem alterar o arquivo do React;
//   - o componente e renderizado no servidor (react-dom/server) para cada caso e o HTML e lido (jsdom):
//     cabecalhos, linhas, rodape, relatorio de pagina, botoes do paginador, filtros.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/datatable_vectors/generate.mjs <pasta do pacote react>
// Gera packages/seedgrid_components/test/widgets/datatable_vectors/vectors.json (deterministico).
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { createRequire, } from "node:module";
import { pathToFileURL } from "node:url";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.join(root, "packages/seedgrid_components/test/widgets/datatable_vectors/vectors.json");
const tsx = path.join(pkg, "src", "inputs", "SgDatatable.tsx");
if (!fs.existsSync(tsx)) {
  console.error("SgDatatable.tsx nao encontrado em " + tsx);
  process.exit(2);
}

function findEsbuild(start) {
  let dir = start;
  for (let i = 0; i < 8; i++) {
    const pnpm = path.join(dir, "node_modules", ".pnpm");
    if (fs.existsSync(pnpm)) {
      const hit = fs.readdirSync(pnpm).filter((n) => /^esbuild@/.test(n)).sort().pop();
      if (hit) return path.join(pnpm, hit, "node_modules", "esbuild", "lib", "main.js");
    }
    dir = path.dirname(dir);
  }
  throw new Error("esbuild nao encontrado a partir de " + start);
}
const esbuild = await import(pathToFileURL(findEsbuild(pkg)).href);
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-datatable-"));
const bundleFile = path.join(tmp, "bundle.cjs");

const EXPORTS = [
  "normalizeFilters", "getFieldValue", "normalizeText", "matchesFilter", "compareValues",
  "buildPageTokens", "resolveMaxPageButtons", "moveItem", "getColumnKey",
];
const suffixPlugin = {
  name: "datatable-exports",
  setup(build) {
    build.onLoad({ filter: /SgDatatable\.tsx$/ }, async (args) => ({
      contents: fs.readFileSync(args.path, "utf8") + `\nexport { ${EXPORTS.join(", ")} };\n`,
      loader: "tsx",
      resolveDir: path.dirname(args.path),
    }));
  },
};
await esbuild.build({
  stdin: {
    contents: `export * from ${JSON.stringify(tsx.replace(/\\/g, "/"))};
import React from "react";
import { renderToStaticMarkup } from "react-dom/server";
export { React, renderToStaticMarkup };`,
    resolveDir: pkg,
    loader: "ts",
  },
  bundle: true,
  platform: "node",
  format: "cjs",
  outfile: bundleFile,
  jsx: "automatic",
  logLevel: "error",
  define: { "process.env.NODE_ENV": '"production"' },
  plugins: [suffixPlugin],
});
const dt = createRequire(import.meta.url)(bundleFile);
const { JSDOM } = createRequire(path.join(pkg, "package.json"))("jsdom");

// ------------------------------------------------------------ dados
const owners = ["Xavier", "Yara", "Zuleica", "xavier", "Wagner"];
const names = [
  "Alice", "alice", "Álvaro", "Bruno", "bruna", "Édson", "ana", "Zé", "élida", "João 10", "João 2", "João 1",
  "Carlos", "Ísis", "Óscar", "Ursula", "úrsula", "Yuri", "Beatriz", "Caio", "Débora", "Elias", "Fabio", "Gabi",
  "Hugo", "Iara", "Jonas", "Karla",
];
const cities = ["São Paulo", "sao jose", "Salvador", "Recife", "Santos", "Rio", "Curitiba", "Sapucaí", null];
const ROWS = names.map((name, i) => ({
  id: i + 1,
  name,
  age: i % 9 === 4 ? null : 18 + ((i * 7) % 40),
  ageText: i % 9 === 4 ? "?" : String(18 + ((i * 7) % 40)),
  city: cities[i % cities.length],
  active: i % 3 !== 0,
  score: [3.5, 10, 2, 7.25, 7.25, 0, -1.5][i % 7],
  code: ["A10", "a9", "A100", "A2", "b1", "a09", "item_1", "item-1"][i % 8],
  owner: { name: owners[i % owners.length] },
}));

// especificacao de coluna -> coluna do React (rodapes e sortFunction viram funcoes)
function buildColumns(spec) {
  return spec.map((c) => {
    const col = { ...c };
    if (c.footer === "count") col.footer = (rows) => `count:${rows.length}`;
    else if (c.footer === "sumAge") col.footer = (rows) => String(rows.reduce((a, r) => a + (typeof r.age === "number" ? r.age : 0), 0));
    else if (c.footer === "text") col.footer = "Rodape";
    if (c.sortFunction === "byNameLength") col.sortFunction = (a, b) => String(a.name).length - String(b.name).length;
    return col;
  });
}

const COLS_BASIC = [
  { field: "id", header: "Id", sortable: true, align: "right" },
  { field: "name", header: "Nome", sortable: true, filter: true, footer: "count" },
  { field: "age", header: "Idade", sortable: true, filter: true, footer: "sumAge" },
  { field: "city", header: "Cidade", sortable: true, filter: true, filterMatchMode: "startsWith" },
  { field: "active", header: "Ativo", sortable: true },
  { field: "owner.name", header: "Dono", sortable: true, filter: true, filterMatchMode: "equals" },
  { field: "score", header: "Nota", sortable: true, excludeGlobalFilter: true },
  { field: "code", header: "Codigo", sortable: true, filter: true, filterMatchMode: "endsWith" },
];
const COLS_OVERRIDE = [
  { field: "id", header: "Id" },
  { field: "ageText", header: "Idade", sortable: true, sortField: "age", filterField: "ageText", filter: true },
  { field: "name", header: "Nome", sortable: true, sortFunction: "byNameLength" },
  { columnId: "extra", header: "Extra" },
];
const COLS_HIDDEN = [
  { field: "id", header: "Id" },
  { field: "name", header: "Nome", sortable: true, filter: true },
  { field: "city", header: "Cidade", hidden: true, filter: true, sortable: true },
  { field: "age", header: "Idade", sortable: true },
];

const cases = [];
const add = (name, props) => cases.push({ name, props });

add("plain", { columns: COLS_BASIC });
for (const first of [0, 5, 10, 25, 27, 100]) add(`page rows=5 first=${first}`, { columns: COLS_BASIC, paginator: true, rows: 5, first });
add("page rows=10 default", { columns: COLS_BASIC, paginator: true });
add("page rows=1 first=13 (28 paginas)", { columns: COLS_BASIC, paginator: true, rows: 1, first: 13 });
add("page rows=1 first=0", { columns: COLS_BASIC, paginator: true, rows: 1, first: 0 });
add("page rows=1 first=27", { columns: COLS_BASIC, paginator: true, rows: 1, first: 27 });
add("page rowsPerPageOptions", { columns: COLS_BASIC, paginator: true, rows: 10, rowsPerPageOptions: [5, 10, 25] });
for (const order of [1, -1, 0]) {
  for (const f of ["name", "age", "owner.name", "score", "active", "code", "city", "id"]) {
    add(`sort ${f} ${order}`, { columns: COLS_BASIC, sortField: f, sortOrder: order });
  }
}
add("sort paginated desc name page2", { columns: COLS_BASIC, sortField: "name", sortOrder: -1, paginator: true, rows: 7, first: 7 });
add("sort sortField override (age)", { columns: COLS_OVERRIDE, sortField: "age", sortOrder: 1 });
add("sort sortField override desc", { columns: COLS_OVERRIDE, sortField: "age", sortOrder: -1 });
add("sort sortFunction asc", { columns: COLS_OVERRIDE, sortField: "name", sortOrder: 1 });
add("sort sortFunction desc", { columns: COLS_OVERRIDE, sortField: "name", sortOrder: -1 });
add("sort unknown field", { columns: COLS_BASIC, sortField: "inexistente", sortOrder: 1 });
add("sort hidden column field", { columns: COLS_HIDDEN, sortField: "city", sortOrder: 1 });
for (const q of ["a", "JOÃO", "jo", "ana", "1", "true", "x", "são", "sao", "  ana  ", "", "zzz", "item_1", "-1", "7.25"]) {
  add(`globalFilter ${JSON.stringify(q)}`, { columns: COLS_BASIC, showGlobalFilter: true, globalFilter: q });
}
add("globalFilter hidden column", { columns: COLS_HIDDEN, globalFilter: "sao" });
add("globalFilter + page", { columns: COLS_BASIC, globalFilter: "a", paginator: true, rows: 4, first: 4 });
add("globalFilter + sort", { columns: COLS_BASIC, globalFilter: "a", sortField: "name", sortOrder: -1 });
const FILTERS = [
  { name: "a" }, { city: "sa" }, { "owner.name": "xavier" }, { "owner.name": "x" }, { code: "1" }, { code: "a9" },
  { age: "3" }, { name: "  ana " }, { name: "" }, { name: "a", city: "s" }, { city: "zzz" }, { inexistente: "a" },
  { name: "a", age: "2", code: "0" },
];
for (const f of FILTERS) add(`filters ${JSON.stringify(f)}`, { columns: COLS_BASIC, showColumnFilters: true, filters: f });
add("filters hidden column ignored", { columns: COLS_HIDDEN, filters: { city: "sao" } });
add("filters + global", { columns: COLS_BASIC, filters: { name: "a" }, globalFilter: "s" });
add("filters override filterField", { columns: COLS_OVERRIDE, showColumnFilters: true, filters: { ageText: "3" } });
add("showColumnFilters without filter cols", { columns: [{ field: "id", header: "Id" }], showColumnFilters: true });
add("lazy first=20 total=100", { columns: COLS_BASIC, lazy: true, paginator: true, rows: 10, first: 20, totalRecords: 100 });
add("lazy no totalRecords", { columns: COLS_BASIC, lazy: true, paginator: true, rows: 10 });
add("lazy ignores filter/sort", { columns: COLS_BASIC, lazy: true, globalFilter: "zzz", sortField: "name", sortOrder: 1 });
add("lazy first beyond", { columns: COLS_BASIC, lazy: true, paginator: true, rows: 10, first: 500, totalRecords: 100 });
add("lazy totalRecords=0", { columns: COLS_BASIC, lazy: true, paginator: true, rows: 10, totalRecords: 0 });
add("selection single", { columns: COLS_BASIC, dataKey: "id", selectionMode: "single", selection: { id: 3 } });
add("selection single no match", { columns: COLS_BASIC, dataKey: "id", selectionMode: "single", selection: { id: 999 } });
add("selection multiple", { columns: COLS_BASIC, dataKey: "id", selectionMode: "multiple", selection: [{ id: 2 }, { id: 5 }, { id: 999 }] });
add("selection multiple non-array", { columns: COLS_BASIC, dataKey: "id", selectionMode: "multiple", selection: { id: 2 } });
add("selection single array", { columns: COLS_BASIC, dataKey: "id", selectionMode: "single", selection: [{ id: 2 }] });
add("selection no mode", { columns: COLS_BASIC, dataKey: "id", selection: { id: 3 } });
add("loading", { columns: COLS_BASIC, loading: true });
add("loading + paginator", { columns: COLS_BASIC, loading: true, paginator: true, rows: 5 });
add("empty default", { columns: COLS_BASIC, rowsData: [] });
add("empty custom", { columns: COLS_BASIC, rowsData: [], emptyMessage: "Nada aqui" });
add("empty paginator", { columns: COLS_BASIC, rowsData: [], paginator: true, rows: 5 });
add("hidden column", { columns: COLS_HIDDEN });
add("footer text", { columns: [{ field: "id", header: "Id", footer: "text" }, { field: "name", header: "Nome" }] });
add("footer filtered all pages", { columns: COLS_BASIC, globalFilter: "a", paginator: true, rows: 3 });
add("align + extra column (no field)", { columns: COLS_OVERRIDE });
add("globalFilterPlaceholder", { columns: COLS_BASIC, showGlobalFilter: true, globalFilterPlaceholder: "Procurar" });
add("clear filters button", { columns: COLS_BASIC, showGlobalFilter: true, showClearFiltersButton: true });
add("columnFilterPlaceholder", { columns: [{ field: "name", header: "Nome", filter: true, filterPlaceholder: "so nome" }, { field: "age", header: "Idade", filter: true }], showColumnFilters: true });
add("rows prop with 0", { columns: COLS_BASIC, paginator: true, rows: 0 });
add("first negative", { columns: COLS_BASIC, paginator: true, rows: 5, first: -5 });
add("dataValues nested/null/array", { columns: [{ field: "a.b.c", header: "ABC" }, { field: "list.1", header: "L1" }, { field: "n", header: "N" }, { field: "b", header: "B" }, { field: "o", header: "O" }], rowsData: [
  { a: { b: { c: 1 } }, list: [1, 2], n: null, b: false, o: {} },
  { a: null, list: "xy", n: 0, b: true, o: { x: 1 } },
  { a: { b: 5 }, list: [], n: 1.5, b: null, o: [1, [2, 3]] },
] });

// ------------------------------------------------------------ renderizacao
function render(props, rowsData) {
  const p = { ...props };
  delete p.rowsData;
  p.value = rowsData ?? props.rowsData ?? ROWS;
  p.columns = buildColumns(props.columns);
  return dt.renderToStaticMarkup(dt.React.createElement(dt.SgDatatable, p));
}

function txt(el) {
  return (el.textContent ?? "").replace(/\s+/g, " ").trim();
}

function extract(html) {
  const doc = new JSDOM(`<body>${html}</body>`).window.document;
  const headRows = [...doc.querySelectorAll("thead tr")];
  const headers = headRows.length ? [...headRows[0].querySelectorAll("th")].map(txt) : [];
  const filterInputs = headRows.length > 1
    ? [...headRows[1].querySelectorAll("th")].map((th) => {
        const i = th.querySelector("input");
        return i ? { placeholder: i.getAttribute("placeholder"), value: i.getAttribute("value") ?? "" } : null;
      })
    : null;
  const body = [...doc.querySelectorAll("tbody tr")].map((tr) => ({
    cells: [...tr.querySelectorAll("td")].map(txt),
    selected: tr.getAttribute("aria-selected") === "true",
  }));
  const footer = [...doc.querySelectorAll("tfoot td")].map(txt);
  const nav = doc.querySelector("nav");
  const pager = nav
    ? [...nav.querySelectorAll("button")].map((b) => ({
        label: b.getAttribute("aria-label"),
        text: txt(b),
        current: b.getAttribute("aria-current") === "page",
        disabled: b.hasAttribute("disabled"),
      }))
    : null;
  const reportEl = doc.querySelector("span.min-w-\\[180px\\]");
  const select = doc.querySelector("select");
  const toolbarInput = doc.querySelector("input[placeholder]:not(thead input)");
  const globalInput = [...doc.querySelectorAll("input")].find((i) => !i.closest("thead"));
  return {
    headers,
    filterInputs,
    body,
    footer,
    pager,
    report: reportEl ? txt(reportEl) : null,
    rowsPerPage: select
      ? { value: select.querySelector("option[selected]")?.getAttribute("value") ?? select.getAttribute("value") ?? null, options: [...select.querySelectorAll("option")].map((o) => o.getAttribute("value")) }
      : null,
    globalInput: globalInput ? { placeholder: globalInput.getAttribute("placeholder"), value: globalInput.getAttribute("value") ?? "" } : null,
    clearButton: [...doc.querySelectorAll("button")].some((b) => txt(b) === "Clear filters"),
    toolbarInputPresent: Boolean(toolbarInput),
  };
}

const rendered = cases.map((c) => {
  const html = render(c.props);
  const ex = extract(html);
  return { name: c.name, props: c.props, expected: ex };
});

// ------------------------------------------------------------ funcoes puras
const SAMPLE_TEXT = [
  "a", "A", "á", "Á", "b", "B", "ab", "Ab", "aB", "abc", "ação", "acao", "Ação", "zebra", "Zebra", "écu", "ecu", "ÉCU",
  "casa", "Casa", "çedilha", "cedilha", "ñandu", "nandu", "Ñandu", "ß", "ss", "straße", "strasse", "æ", "ae",
  "1", "2", "10", "02", "2a", "10a", "a1", "a2", "a10", "a9", "A10", "a09", "A100", "item 1", "item 10", "item 2",
  "item_1", "item-1", "item.1", "item,1", "item1", " a", "a ", "", " ", "-", "_", "x-y", "x_y", "x y", "x.y", "(a)", "[a]",
  "$a", "#a", "@a", "+a", "Joao", "João", "joao 2", "João 10", "João 2", "João 1", "true", "false", "null", "Ω", "ω", "я",
];
const SAMPLE_VALUES = [...SAMPLE_TEXT, 0, 1, 2, -1, 1.5, 2.25, 10, 100, true, false, null];
const enc = (v) => (v instanceof Date ? { $date: v.getTime() } : v);
const compare = [];
for (const a of SAMPLE_VALUES) for (const b of SAMPLE_VALUES) {
  const r = dt.compareValues(a, b);
  compare.push([enc(a), enc(b), Math.sign(r)]);
}
const D = [new Date(Date.UTC(2020, 0, 1)), new Date(Date.UTC(2021, 5, 15, 3, 4, 5, 6)), new Date(Date.UTC(1999, 11, 31))];
for (const a of D) for (const b of [...D, 5, "x", null]) compare.push([enc(a), enc(b), Math.sign(dt.compareValues(a, b))]);

const MATCH_VALUES = ["Alice", "alice", "ÁLVARO", "João", "São Paulo", "", " x ", "abc", "ABC", 0, 1, 12, 1.5, -2, true, false, null, new Date(Date.UTC(2020, 0, 2, 3, 4, 5, 6)), "2020-01-02t03:04:05.006z"];
const QUERIES = ["a", "A", "al", "ice", "ALICE", "", " ", "  a  ", "ã", "a", "o", "são", "1", "12", "1.5", "-2", "true", "false", "2020", "2020-01-02", "z", "t03", "x"];
const MODES = ["contains", "startsWith", "endsWith", "equals"];
const match = [];
for (const v of MATCH_VALUES) for (const q of QUERIES) for (const m of MODES) {
  match.push([enc(v), q, m, dt.matchesFilter(v, q, m)]);
}
const normalizeText = MATCH_VALUES.map((v) => [enc(v), dt.normalizeText(v)]);

const tokens = [];
for (const max of [1, 5, 6, 7, 10, 15, 20]) {
  for (const count of [0, 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 15, 16, 17, 20, 28, 40, 100]) {
    for (let cur = 1; cur <= Math.min(count, 100); cur++) {
      if (count > 40 && cur % 7 !== 1 && cur !== count) continue;
      tokens.push([cur, count, max, dt.buildPageTokens(cur, count, max).map((t) => (t.type === "page" ? { page: t.page } : { ellipsis: t.direction, target: t.target }))]);
    }
  }
}
const maxButtons = [0, 300, 639, 640, 641, 1023, 1024, 2000].map((w) => [w, dt.resolveMaxPageButtons(w)]);
const normalizeFilters = [
  [{}, dt.normalizeFilters({})],
  [{ a: " x ", b: "", c: "  ", d: "y" }, dt.normalizeFilters({ a: " x ", b: "", c: "  ", d: "y" })],
  [{ a: 1, b: null, c: false }, dt.normalizeFilters({ a: 1, b: null, c: false })],
];
const moveItem = [];
for (const [list, f, t] of [[[1, 2, 3, 4], 0, 3], [[1, 2, 3, 4], 3, 0], [[1, 2, 3, 4], 1, 1], [[1, 2, 3, 4], -1, 2], [[1, 2, 3, 4], 2, 9], [[1, 2, 3, 4], 1, 2], [[1, 2, 3, 4], 2, 1], [[], 0, 0]]) {
  moveItem.push({ list, from: f, to: t, result: dt.moveItem(list, f, t) });
}
const columnKeys = [
  [{ columnId: " id ", field: "x" }, 3, dt.getColumnKey({ columnId: " id ", field: "x" }, 3)],
  [{ field: " name " }, 2, dt.getColumnKey({ field: " name " }, 2)],
  [{ columnId: "  ", field: "f" }, 1, dt.getColumnKey({ columnId: "  ", field: "f" }, 1)],
  [{}, 4, dt.getColumnKey({}, 4)],
];
const fieldValue = [
  [{ a: { b: { c: 1 } } }, "a.b.c"], [{ a: null }, "a.b"], [{ a: 5 }, "a.b"], [{ a: [1, 2] }, "a.1"], [{ "x.y": 1, x: { y: 2 } }, "x.y"],
  [{ a: 1 }, ""], [{ a: 1 }, "a"], [{ a: { b: 0 } }, "a.b"], [{}, "q.w"],
].map(([row, field]) => [row, field, dt.getFieldValue(row, field) ?? null]);

fs.mkdirSync(path.dirname(out), { recursive: true });
fs.writeFileSync(
  out,
  JSON.stringify(
    { rows: ROWS, cases: rendered, compare, match, normalizeText, tokens, maxButtons, normalizeFilters, moveItem, columnKeys, fieldValue },
    null,
    0,
  ) + "\n",
  "utf8",
);
fs.rmSync(tmp, { recursive: true, force: true });
console.log(`vetores: ${rendered.length} casos, ${compare.length} comparacoes, ${match.length} filtros, ${tokens.length} janelas -> ${out}`);
