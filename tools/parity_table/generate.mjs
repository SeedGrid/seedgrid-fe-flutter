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
for (const n of Object.keys(ondas)) if (!spec.components[n]) problemas.push(`ondas.json tem '${n}' que nao existe no React`);
for (const n of Object.keys(spec.components)) if (!(n in ondas)) problemas.push(`${n}: sem onda em ondas.json`);

const count = (s) => rows.filter((r) => r.status === s).length;
let md = `# Paridade React × Flutter\n\n> Gerado por \`node tools/parity_table/generate.mjs\` a partir do @seedgrid/fe-components ${spec.versaoReact}. Não edite à mão.\n\n`;
md += `**${rows.length} componentes**: ${count("portado")} portados, ${count("parcial")} parciais, ${count("pendente")} pendentes, ${count("nao-aplicavel")} não aplicáveis.\n\n`;
md += `"Props omitidas" = props do React que não existem no Flutter de propósito (\`className\`, \`style\`, \`register\`, HTML; ver ADR 50). "Props genéricas" = props cujo tipo Dart do contrato ainda é genérico (função, união, tipo a portar; ver \`tools/gen_props/excecoes.json\`).\n\n`;
md += "| Onda | Componente | Estado | Props | Omitidas | Genéricas | Onde / motivo |\n|---|---|---|---|---|---|---|\n";
for (const r of [...rows].sort((a, b) => a.onda - b.onda || a.componente.localeCompare(b.componente))) {
  md += `| ${r.onda} | ${r.componente} | ${r.status} | ${r.props} | ${r.propsOmitidas} | ${r.propsGenericas} | ${[r.onde, r.motivo].filter(Boolean).join(" — ")} |\n`;
}
const json = JSON.stringify({ versaoReact: spec.versaoReact, resumo: { total: rows.length, portado: count("portado"), parcial: count("parcial"), pendente: count("pendente"), naoAplicavel: count("nao-aplicavel") }, componentes: rows }, null, 1) + "\n";

if (problemas.length) {
  console.error("problemas:\n  " + problemas.join("\n  "));
  process.exit(1);
}
const mdFile = path.join(root, "docs/PARIDADE.md");
const jsonFile = path.join(root, "docs/paridade.json");
if (process.argv.includes("--check")) {
  const ok = fs.existsSync(mdFile) && fs.readFileSync(mdFile, "utf8") === md && fs.readFileSync(jsonFile, "utf8") === json;
  if (!ok) { console.error("docs/PARIDADE.md desatualizado: rode node tools/parity_table/generate.mjs"); process.exit(1); }
  console.log(`paridade em dia (${rows.length} componentes)`);
} else {
  fs.mkdirSync(path.dirname(mdFile), { recursive: true });
  fs.writeFileSync(mdFile, md);
  fs.writeFileSync(jsonFile, json);
  console.log(`paridade: ${rows.length} componentes (${count("portado")} portados, ${count("parcial")} parciais, ${count("pendente")} pendentes, ${count("nao-aplicavel")} nao aplicaveis)`);
}
