// Tabela das props de validacao: React (props-spec.json) x Flutter (interface gerada + construtor do widget).
// Uso: node tools/parity_table/validacao.mjs [--check]   saida: docs/PARIDADE_VALIDACAO.md
// Colunas: prop, tipo e padrao no React; tipo e padrao no Flutter; situacao (igual | omitida no Flutter | so no Flutter).
import fs from "node:fs";
import path from "node:path";

const root = process.cwd();
const spec = JSON.parse(fs.readFileSync(path.join(root, "tools/gen_props/props-spec.json"), "utf8"));
const exc = JSON.parse(fs.readFileSync(path.join(root, "tools/gen_props/excecoes.json"), "utf8")).omitidas;
const par = JSON.parse(fs.readFileSync(path.join(root, "docs/paridade.json"), "utf8"));
const VAL = /^(required|requiredMessage|rules|validation|onValidation|validateOnBlur|error|invalid\w*|length\w*|min\w*|max\w*|pattern\w*|\w*Message|disabledMessage|enabled)$/;
const IGNORA = /^(minDate|maxDate|minValue|maxValue|minDateTime|maxDateTime|minTime|maxTime|maxHeight|minHeight|maxWidth|minWidth|maxFiles|maxFileSize|maxSize|maxTotalSize|maxRows|minRows|maxLines|minLines|minColumnWidth|maxVisible|minItems|maxItems|maxTagCount|minRating|maxRating|maxZoom|minZoom|minHeightPx|maxHeightPx|minSelected|maxSelected|min|max)$/;
const alvo = process.argv.includes("--check") ? "check" : "write";

const ondeDe = new Map(par.componentes.map((c) => [c.componente, c.onde]));
function dartTypes(nome) {
  const dir = path.join(root, "packages/seedgrid_components/lib/src/generated");
  for (const f of fs.readdirSync(dir)) {
    if (!f.endsWith(".g.dart")) continue;
    const t = fs.readFileSync(path.join(dir, f), "utf8");
    const ini = t.indexOf("abstract interface class " + nome + "Props {");
    if (ini < 0) continue;
    const m = t.slice(ini).match(/\{([\s\S]*?)\n\}/);
    if (!m) continue;
    const out = new Map();
    for (const g of m[1].matchAll(/^\s*([\w<>?, ()]+?)\s+get\s+(\w+);/gm)) out.set(g[2], g[1]);
    return out;
  }
  return new Map();
}
function ctorDefaults(nome, onde) {
  const out = new Map();
  if (!onde) return out;
  const t = fs.readFileSync(path.join(root, onde), "utf8");
  const i = t.search(new RegExp("class " + nome + "\\b"));
  if (i < 0) return out;
  const j = t.indexOf("const " + nome + "(", i);
  if (j < 0) return out;
  const k = t.indexOf("});", j);
  for (const m of t.slice(j, k).matchAll(/(?:required\s+)?this\.(\w+)(?:\s*=\s*([^,]+))?,/g)) out.set(m[1], m[2]?.trim() ?? "-");
  return out;
}
const lin = [];
lin.push("# Paridade das props de validação (React x Flutter)", "",
  "Gerado por `node tools/parity_table/validacao.mjs`; não edite à mão. Fonte do React: `tools/gen_props/props-spec.json`. Fonte do Flutter: a interface gerada `SgXxxProps` (o widget `implements` a interface, então o compilador garante nome e tipo) e os padrões do construtor do widget.", "",
  "Situação: **igual** = mesmo nome, tipo e padrão; **omitida** = prop do React sem par no Flutter (motivo em `tools/gen_props/excecoes.json`); **só Flutter** = prop do Flutter sem par no React.", "");
let difere = 0, total = 0, iguais = 0, omitidas = 0, soFlutter = 0;
for (const [nome, c] of Object.entries(spec.components)) {
  const names = c.props.map((p) => p.name).filter((n) => VAL.test(n) && !IGNORA.test(n) || n === "rules");
  if (!c.props.some((p) => p.name === "rules" || p.name === "required" || p.name === "validation")) continue;
  const tipos = dartTypes(nome);
  const defs = ctorDefaults(nome, ondeDe.get(nome));
  const omit = new Map(exc.filter((e) => e.componente === nome).map((e) => [e.prop, e.motivo]));
  const linhas = [];
  for (const n of names) {
    const p = c.props.find((x) => x.name === n);
    const dt = tipos.get(n);
    const defReact = p.default === undefined ? "-" : JSON.stringify(p.default);
    const defFlutter = defs.has(n) ? defs.get(n) : "-";
    total++;
    let sit;
    const norm = (d) => String(d).replace(/^["']|["']$/g, "").replace(/^const\s+/, "");
    if (dt !== undefined && (norm(defReact) === norm(defFlutter) || (norm(defReact) === "false" && defFlutter === "-"))) { sit = "igual"; iguais++; }
    else if (dt !== undefined && defFlutter === "-") { sit = "igual (nulo aplica o padrão do React no código)"; iguais++; }
    else if (dt !== undefined) { sit = "padrão difere"; difere++; }
    else if (omit.has(n)) { sit = "omitida: " + omit.get(n); omitidas++; }
    else { sit = "FALTA"; }
    linhas.push(`| \`${n}\` | \`${p.ts.replace(/\|/g, "\|")}\` | ${defReact} | ${dt ? "`" + dt.replace(/\|/g, "\|") + "`" : "-"} | ${dt ? defFlutter : "-"} | ${sit} |`);
  }
  const extras = [...defs.keys()].filter((k) => !c.props.some((p) => p.name === k) && VAL.test(k) && !IGNORA.test(k));
  for (const k of extras) { soFlutter++; linhas.push(`| \`${k}\` | - | - | - | ${defs.get(k)} | só Flutter |`); }
  if (!linhas.length) continue;
  lin.push(`## ${nome}`, "", "| Prop | Tipo no React | Padrão no React | Tipo no Flutter | Padrão no Flutter | Situação |", "|---|---|---|---|---|---|", ...linhas, "");
}
lin.splice(5, 0, `Resumo: ${total} props de validação no React; ${iguais} iguais, ${omitidas} omitidas (justificadas), ${difere} com padrão diferente, ${total - iguais - omitidas - difere} faltando; ${soFlutter} só no Flutter.`, "");
const out = lin.join("\n") + "\n";
const arq = path.join(root, "docs/PARIDADE_VALIDACAO.md");
if (alvo === "check") {
  const atual = fs.existsSync(arq) ? fs.readFileSync(arq, "utf8") : "";
  if (atual !== out) { console.error("PARIDADE_VALIDACAO.md desatualizado: rode node tools/parity_table/validacao.mjs"); process.exit(1); }
  console.log("validacao em dia");
} else { fs.writeFileSync(arq, out); console.log(out.split("\n").slice(4, 6).join("\n")); }
