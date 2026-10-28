// Atualiza, no README.md, o bloco entre `<!-- componentes:inicio -->` e `<!-- componentes:fim -->`:
// a visao geral dos componentes por categoria, com o link da pagina de cada um no showcase publicado.
// Fontes: apps/seedgrid_showcase/lib/src/catalog.g.dart (catalogo e categoria) e lib/pages/pages.g.dart (descricao).
// Uso: node tools/readme/generate.mjs [--check]   (--check falha se o README estiver velho)
import fs from "node:fs";
import path from "node:path";

const root = path.resolve(".");
const app = path.join(root, "apps", "seedgrid_showcase", "lib");
const check = process.argv.includes("--check");
const DEMO = "https://components-flutter.seedgrid.com.br";

const slug = (n) =>
  n
    .replace(/([a-z0-9])([A-Z])/g, "$1-$2")
    .replace(/([A-Z]+)([A-Z][a-z])/g, "$1-$2")
    .toLowerCase();

const catalog = [...fs.readFileSync(path.join(app, "src", "catalog.g.dart"), "utf8").matchAll(/\(name: '(\w+)', category: '(\w+)'/g)].map((m) => ({ name: m[1], category: m[2] }));
const descriptions = new Map(
  [...fs.readFileSync(path.join(app, "pages", "pages.g.dart"), "utf8").matchAll(/\(name: '(\w+)'.*?description: '((?:[^'\\]|\\.)*)'/g)].map((m) => [m[1], m[2].replace(/\\'/g, "'").replace(/\\\$/g, "$")]),
);
const pagesWithShowcase = new Set(descriptions.keys());

const categorias = [
  ["action", "🎬 Ação", "Botões e atalhos de ação"],
  ["input", "⌨️ Entrada de dados", "Campos de texto, máscaras, números, datas, escolha e seleção"],
  ["data", "📊 Dados", "Tabela, listas e editor"],
  ["layout", "🧱 Layout", "Grade, painéis, cartões, abas e docks"],
  ["navigation", "🧭 Navegação", "Menus, barras de ferramentas, trilhas e passos"],
  ["feedback", "💬 Feedback e exibição", "Avisos, diálogos, avatares, selos e indicadores"],
  ["gadget", "🎛️ Gadgets", "Dígitos animados, relógios, medidores e QR"],
  ["provider", "🔌 Providers", "Idioma, ambiente e persistência"],
  ["outros", "📚 Exemplos completos", "Telas inteiras montadas só com componentes SeedGrid"],
];

const curta = (t) => {
  if (!t) return "";
  const first = t.split(/(?<=[.!?])\s/)[0];
  const s = first.length > 150 ? first.slice(0, 147).replace(/[\s,;:]+\S*$/, "") + "…" : first;
  return s.replace(/\|/g, "\\|");
};

let out = "";
const porCat = new Map();
// Paginas do showcase que nao sao componente do React (ex.: o CRUD de clientes) entram em "outros".
const noCatalogo = new Set(catalog.map((c) => c.name));
for (const n of descriptions.keys()) if (!noCatalogo.has(n)) catalog.push({ name: n, category: "outros" });
for (const c of catalog) (porCat.get(c.category) ?? porCat.set(c.category, []).get(c.category)).push(c.name);
for (const [id, titulo, sub] of categorias) {
  const nomes = (porCat.get(id) ?? []).sort((a, b) => a.localeCompare(b));
  if (!nomes.length) continue;
  out += `<details>\n<summary><b>${titulo}</b> · ${nomes.length} ${id === "outros" ? (nomes.length === 1 ? "exemplo" : "exemplos") : "componentes"} · <i>${sub}</i></summary>\n\n| Componente | O que faz |\n|---|---|\n`;
  for (const n of nomes) {
    const link = pagesWithShowcase.has(n) ? `[\`${n}\`](${DEMO}/${slug(n)})` : `\`${n}\``;
    out += `| ${link} | ${curta(descriptions.get(n))} |\n`;
  }
  out += "\n</details>\n\n";
}
out = out.replace(/\n+$/, "\n");

const file = path.join(root, "README.md");
const raw = fs.readFileSync(file, "utf8");
const eol = raw.includes("\r\n") ? "\r\n" : "\n"; // preserva o fim de linha do README (Windows ou Unix)
const text = raw.replace(/\r\n/g, "\n");
const re = /(<!-- componentes:inicio -->\n)[\s\S]*?(<!-- componentes:fim -->)/;
if (!re.test(text)) throw new Error("README.md sem os marcadores <!-- componentes:inicio --> / <!-- componentes:fim -->");
const next = text.replace(re, (_, a, b) => `${a}\n${out}\n${b}`);
if (next === text) {
  console.log(`README em dia (${catalog.length} itens)`);
} else if (check) {
  console.error("README desatualizado: rode node tools/readme/generate.mjs");
  process.exit(1);
} else {
  fs.writeFileSync(file, next.replace(/\n/g, eol));
  console.log(`README atualizado (${catalog.length} itens)`);
}
