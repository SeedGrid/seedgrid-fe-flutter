// Tabela de paridade: componente do React x estado no Flutter. Gerada, nao editada a mao.
// Uso: node tools/parity_table/generate.mjs [--check]
//   fontes: tools/gen_props/props-spec.json (lista dos componentes do React e props),
//           packages/*/lib (classes Dart `class SgXxx`), tools/parity_table/{ondas,estado}.json.
//   status: portado | parcial | pendente | nao-aplicavel. Componente sem widget Dart e sem estado manual = pendente.
//   saida: docs/PARIDADE.md e docs/paridade.json
import fs from "node:fs";
import path from "node:path";

const root = process.cwd();
const spec = JSON.parse(fs.readFileSync(path.join(root, "tools/gen_props/props-spec.json"), "utf8"));
const ondas = JSON.parse(fs.readFileSync(path.join(root, "tools/parity_table/ondas.json"), "utf8"));
const estado = JSON.parse(fs.readFileSync(path.join(root, "tools/parity_table/estado.json"), "utf8"));
const exc = JSON.parse(fs.readFileSync(path.join(root, "tools/gen_props/excecoes.json"), "utf8"));
// Componentes que so existem no Flutter (sem contrapartida no React, sem exigencia de paridade).
const somenteFlutter = JSON.parse(fs.readFileSync(path.join(root, "tools/parity_table/somente_flutter.json"), "utf8")).componentes;

// classes Dart escritas a mao (fora de generated/ e de tools)
const classes = new Map();
(function walk(d) {
  for (const f of fs.readdirSync(d, { withFileTypes: true })) {
    const p = path.join(d, f.name);
    if (f.isDirectory()) {
      if (["generated", ".dart_tool", "build", "test"].includes(f.name)) continue;
      walk(p);
    } else if (f.name.endsWith(".dart") && !f.name.endsWith(".g.dart")) {
      const t = fs.readFileSync(p, "utf8");
      for (const m of t.matchAll(/^\s*(?:abstract\s+|final\s+|base\s+)*class\s+(Sg[A-Za-z0-9]+)\b([^{]*)\{/gm)) {
        classes.set(m[1], { file: path.relative(root, p).replace(/\\/g, "/"), implementsProps: new RegExp("\\bimplements\\b[^{]*\\b" + m[1] + "Props\\b").test(m[2]) });
      }
    }
  }
})(path.join(root, "packages"));

const omitidas = {};
for (const o of exc.omitidas) omitidas[o.componente] = (omitidas[o.componente] ?? 0) + 1;
const genericas = {};
for (const o of exc.tipoGenerico) genericas[o.componente] = (genericas[o.componente] ?? 0) + 1;

const rows = [];
const problemas = [];
for (const name of Object.keys(spec.components).sort()) {
  const manual = estado[name];
  const dart = classes.get(name);
  let status = "pendente";
  let motivo = "";
  let onde = "";
  if (manual) {
    status = manual.status;
    motivo = manual.motivo ?? "";
    onde = manual.onde ?? "";
    if ((status === "parcial" || status === "nao-aplicavel") && !motivo) problemas.push(`${name}: status ${status} sem motivo`);
  }
  if (dart) {
    if (!manual) status = "portado";
    onde = onde || dart.file;
    // Estado manual (ex.: provider portado antes do gerador) fica fora desta checagem; a pendencia aparece no 'motivo'.
    if (!manual && !dart.implementsProps) problemas.push(`${name}: widget Dart existe mas nao declara implements ${name}Props`);
  } else if (status === "portado" && !onde) {
    problemas.push(`${name}: marcado portado sem widget Dart nem 'onde'`);
  }
  const props = spec.components[name].props.length;
  rows.push({ componente: name, onda: ondas[name], status, motivo, onde, props, propsOmitidas: omitidas[name] ?? 0, propsGenericas: genericas[name] ?? 0 });
}
const sf = [];
for (const name of Object.keys(somenteFlutter).sort()) {
  const c = somenteFlutter[name];
  if (spec.components[name]) problemas.push(`${name}: esta em somente_flutter.json mas existe no React (use estado.json)`);
  if (!classes.has(name)) problemas.push(`${name}: somente-flutter sem widget Dart`);
  for (const k of ["categoria", "descricao", "motivo", "arquivo"]) if (!c[k]) problemas.push(`${name}: somente_flutter.json sem '${k}'`);
  if (c.arquivo && !fs.existsSync(path.join(root, c.arquivo))) problemas.push(`${name}: arquivo '${c.arquivo}' nao existe`);
  sf.push({ componente: name, status: "somente-flutter", categoria: c.categoria, descricao: c.descricao, motivo: c.motivo, onde: c.arquivo });
}
for (const n of Object.keys(ondas)) if (!spec.components[n]) problemas.push(`ondas.json tem '${n}' que nao existe no React`);
for (const n of Object.keys(spec.components)) if (!(n in ondas)) problemas.push(`${n}: sem onda em ondas.json`);

const count = (s) => rows.filter((r) => r.status === s).length;
let md = `# Paridade React × Flutter\n\n> Gerado por \`node tools/parity_table/generate.mjs\` a partir do @seedgrid/fe-components ${spec.versaoReact}. Não edite à mão.\n\n`;
md += `**${rows.length} componentes**: ${count("portado")} portados, ${count("parcial")} parciais, ${count("pendente")} pendentes, ${count("nao-aplicavel")} não aplicáveis.\n\n`;
md += `**Somente Flutter (sem paridade com o React)**: ${sf.length} (${sf.map((s) => s.componente).join(", ")}); listados na seção própria abaixo e fora dos totais acima.\n\n`;
md += `"Props omitidas" = props do React que não existem no Flutter de propósito (\`className\`, \`style\`, \`register\`, HTML; ver ADR 50). \`enabled\` tem o mesmo nome nos dois lados (padronizado; a regra antiga do ADR 50 que o renomeava para \`disabled\` foi substituída). "Props genéricas" = props cujo tipo Dart do contrato ainda é genérico (função, união, tipo a portar; ver \`tools/gen_props/excecoes.json\`).\n\n`;
md += "| Onda | Componente | Estado | Props | Omitidas | Genéricas | Onde / motivo |\n|---|---|---|---|---|---|---|\n";
for (const r of [...rows].sort((a, b) => a.onda - b.onda || a.componente.localeCompare(b.componente))) {
  md += `| ${r.onda} | ${r.componente} | ${r.status} | ${r.props} | ${r.propsOmitidas} | ${r.propsGenericas} | ${[r.onde, r.motivo].filter(Boolean).join(" — ")} |\n`;
}
md += "\n## Somente Flutter (sem paridade com o React)\n\nComponentes que existem só no Flutter. Não contam como pendentes nem entram nos totais do React; ver \`tools/parity_table/somente_flutter.json\`.\n\n| Componente | Categoria | Estado | Onde | Motivo |\n|---|---|---|---|---|\n";
for (const s of sf) md += `| ${s.componente} | ${s.categoria} | ${s.status} | ${s.onde} | ${s.motivo} |\n`;
const json = JSON.stringify({ versaoReact: spec.versaoReact, resumo: { total: rows.length, portado: count("portado"), parcial: count("parcial"), pendente: count("pendente"), naoAplicavel: count("nao-aplicavel"), somenteFlutter: sf.length }, componentes: rows, somenteFlutter: sf }, null, 1) + "\n";

if (problemas.length) {
  console.error("problemas:\n  " + problemas.join("\n  "));
  process.exit(1);
}
// Catalogo para o menu e a pagina inicial do showcase (o app nao le arquivos em tempo de execucao).
const catalogFile = path.join(root, "apps/seedgrid_showcase/lib/src/catalog.g.dart");
const catalogLines = [
  "// dart format off",
  "// GERADO por tools/parity_table/generate.mjs. NAO EDITE A MAO.",
  "// Catalogo dos componentes do React com categoria, onda e estado do porte (menu e pagina inicial do showcase).",
  "",
  "typedef CatalogEntry = ({String name, String category, int wave, String status});",
  "",
  `const String kCatalogReactVersion = '${spec.versaoReact}';`,
  "",
  "const List<CatalogEntry> kCatalog = <CatalogEntry>[",
  ...[...rows]
    .sort((a, b) => a.componente.localeCompare(b.componente))
    .map((r) => `  (name: '${r.componente}', category: '${spec.components[r.componente].category ?? "outros"}', wave: ${r.onda}, status: '${r.status}'),`),
  // Somente Flutter: onda 0 = fora do porte do React.
  ...sf.map((s) => `  (name: '${s.componente}', category: '${s.categoria}', wave: 0, status: 'somente-flutter'),`),
  "];",
  "",
];
const catalog = catalogLines.join("\n");
const mdFile = path.join(root, "docs/PARIDADE.md");
const jsonFile = path.join(root, "docs/paridade.json");
if (process.argv.includes("--check")) {
  const ok = fs.existsSync(mdFile) && fs.readFileSync(mdFile, "utf8") === md && fs.readFileSync(jsonFile, "utf8") === json && fs.existsSync(catalogFile) && fs.readFileSync(catalogFile, "utf8") === catalog;
  if (!ok) { console.error("docs/PARIDADE.md desatualizado: rode node tools/parity_table/generate.mjs"); process.exit(1); }
  console.log(`paridade em dia (${rows.length} componentes)`);
} else {
  fs.mkdirSync(path.dirname(mdFile), { recursive: true });
  fs.writeFileSync(mdFile, md);
  fs.writeFileSync(jsonFile, json);
  fs.writeFileSync(catalogFile, catalog);
  console.log(`paridade: ${rows.length} componentes (${count("portado")} portados, ${count("parcial")} parciais, ${count("pendente")} pendentes, ${count("nao-aplicavel")} nao aplicaveis) + ${sf.length} somente Flutter`);
}
