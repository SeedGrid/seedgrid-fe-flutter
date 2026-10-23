// Gera as interfaces de props em Dart a partir de tools/gen_props/props-spec.json (saida de extract.mjs).
// Uso: node tools/gen_props/emit.mjs [spec.json] [pasta-de-saida]
// Saida (por padrao packages/seedgrid_components/lib/src/generated/):
//   <componente>.g.dart  enums, `abstract interface class <Comp>Props` e `const <comp>PropSpecs`
//   generated.dart       barrel
// + tools/gen_props/excecoes.json: tudo que NAO virou tipo exato (nunca silencioso).
// O widget escrito a mao faz `implements <Comp>Props`: o analisador acusa prop faltando ou com tipo incompativel.
import fs from "node:fs";
import path from "node:path";

const specFile = path.resolve(process.argv[2] ?? "tools/gen_props/props-spec.json");
const outDir = path.resolve(process.argv[3] ?? "packages/seedgrid_components/lib/src/generated");
const excFile = path.resolve(path.dirname(specFile), "excecoes.json");
const spec = JSON.parse(fs.readFileSync(specFile, "utf8"));

// So palavras realmente reservadas: required, get, set, on, show etc. sao identificadores validos em Dart.
const RESERVED = new Set(["assert","break","case","catch","class","const","continue","default","do","else","enum","extends","false","final","finally","for","if","in","is","new","null","rethrow","return","super","switch","this","throw","true","try","var","void","while","with"]);
// Props que nao viram campo: estilo (ADR 50), herdadas de HTML/React ou sem sentido em Flutter.
const OMIT = new Map([
  ["className", "estilo: React-only (ADR 50); equivalentes: padding, margin, width, height, customColors"],
  ["labelClassName", "estilo: React-only (ADR 50)"],
  ["inputClassName", "estilo: React-only (ADR 50)"],
  ["style", "estilo: React-only (ADR 50)"],
  ["register", "nao aplicavel: todo campo Flutter e controlado (ADR 49)"],
  ["ref", "React-only: vira controller/GlobalKey por componente"],
  ["key", "React-only: Key do widget"],
]);

const snake = (s) => s.replace(/([a-z0-9])([A-Z])/g, "$1_$2").replace(/([A-Z]+)([A-Z][a-z])/g, "$1_$2").toLowerCase();
const lowerCamel = (s) => s.charAt(0).toLowerCase() + s.slice(1);
const upperCamel = (s) => s.charAt(0).toUpperCase() + s.slice(1);
const stripOpt = (t) => t.replace(/\s*\|\s*(undefined|null)/g, "").trim();
const isIdent = (s) => /^[A-Za-z_][A-Za-z0-9_]*$/.test(s);

function enumMember(v, used) {
  // Sigla toda em maiuscula (BR, US) vira minuscula inteira (br, us), nao bR.
  if (/^[A-Z]{2,}$/.test(v)) v = v.toLowerCase();
  let id = v.replace(/[^A-Za-z0-9]+(.)?/g, (_, c) => (c ? c.toUpperCase() : ""));
  if (!id) id = "empty";
  if (/^[0-9]/.test(id)) id = "v" + id;
  id = lowerCamel(id);
  if (RESERVED.has(id)) id += "Value";
  let n = id, i = 2;
  while (used.has(n)) n = id + i++;
  used.add(n);
  return n;
}
const esc = (s) => s.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\$/g, "\\$").replace(/\r?\n/g, " ");
const docLine = (s) => s.replace(/\r?\n/g, " ").replace(/</g, "&lt;").replace(/>/g, "&gt;");

// ---------------------------------------------------------------- 1) enums compartilhados x locais
const sig = (vals) => JSON.stringify([...vals].sort());
const byAlias = new Map(); // alias|sig -> {alias, vals, uses:Set(componente)}
for (const [comp, c] of Object.entries(spec.components)) {
  for (const p of c.props) {
    if (!p.enum) continue;
    const alias = isIdent(stripOpt(p.ts)) && !["string", "number", "boolean"].includes(stripOpt(p.ts)) ? stripOpt(p.ts) : null;
    p._alias = alias;
    if (!alias) continue;
    const k = alias + "|" + sig(p.enum);
    if (!byAlias.has(k)) byAlias.set(k, { alias, vals: p.enum, uses: new Set() });
    byAlias.get(k).uses.add(comp);
  }
}
const sharedName = new Map(); // key -> nome do enum
const takenNames = new Set();
const aliasCount = new Map();
for (const e of byAlias.values()) aliasCount.set(e.alias, (aliasCount.get(e.alias) ?? 0) + 1);
for (const [k, e] of byAlias) {
  if (e.uses.size < 2) continue;
  // mesmo alias com valores diferentes em outro lugar: nome com sufixo para nao colidir
  let n = e.alias.startsWith("Sg") ? e.alias : "Sg" + upperCamel(e.alias);
  if (aliasCount.get(e.alias) > 1 || takenNames.has(n)) n = n + "V" + (e.vals.length) + [...e.uses].sort()[0].replace(/^Sg/, "");
  takenNames.add(n);
  sharedName.set(k, n);
}

const enumDefs = new Map(); // nome -> {vals}
function enumFor(comp, p) {
  const k = p._alias ? p._alias + "|" + sig(p.enum) : null;
  let name = k && sharedName.get(k);
  if (!name) name = "Sg" + comp.replace(/^Sg/, "") + upperCamel(p.name);
  if (enumDefs.has(name) && sig(enumDefs.get(name)) !== sig(p.enum)) throw new Error("colisao de enum " + name);
  enumDefs.set(name, p.enum);
  return name;
}

// ---------------------------------------------------------------- 2) traducao de tipos
const exceptions = { versaoReact: spec.versaoReact, omitidas: [], tipoGenerico: [], renomeadas: [] };
function dartType(comp, p) {
  const t = stripOpt(p.ts);
  if (p.enum) return { dart: enumFor(comp, p), enumName: enumFor(comp, p) };
  if (t === "string") return { dart: "String" };
  if (t === "number") return { dart: "num" };
  if (t === "boolean") return { dart: "bool" };
  if (/^(React\.)?(ReactNode|ReactElement|JSX\.Element)$/.test(t)) return { dart: "Widget" };
  if (p.fn) {
    exceptions.tipoGenerico.push({ componente: comp, prop: p.name, motivo: "funcao", ts: t });
    return { dart: "Function", generic: true };
  }
  if (/\[\]$|^Array<|^ReadonlyArray</.test(t)) {
    exceptions.tipoGenerico.push({ componente: comp, prop: p.name, motivo: "lista", ts: t });
    return { dart: "List<Object?>", generic: true };
  }
  exceptions.tipoGenerico.push({ componente: comp, prop: p.name, motivo: /\|/.test(t) ? "uniao" : "tipo-nomeado-a-portar", ts: t });
  return { dart: "Object", generic: true };
}

// ---------------------------------------------------------------- 3) emissao
fs.mkdirSync(outDir, { recursive: true });
for (const f of fs.readdirSync(outDir)) if (f.endsWith(".g.dart") || f === "generated.dart") fs.unlinkSync(path.join(outDir, f));

const header = `// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components ${spec.versaoReact}. NAO EDITE A MAO.\n// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato\n// estao em tools/gen_props/excecoes.json.\n// ignore_for_file: constant_identifier_names\n\n`;
const barrel = [];
const emittedEnums = new Set();
const enumSrc = (name, vals) => {
  const used = new Set();
  const members = vals.map((v) => ({ id: enumMember(v, used), v }));
  return `/// Valores aceitos pelo React: ${vals.map((v) => `\`${docLine(v)}\``).join(", ")}.\nenum ${name} {\n${members.map((m) => `  ${m.id}('${esc(m.v)}')`).join(",\n")};\n\n  const ${name}(this.value);\n\n  /// String equivalente no React.\n  final String value;\n\n  static ${name}? fromValue(String? v) {\n    for (final e in values) {\n      if (e.value == v) return e;\n    }\n    return null;\n  }\n}\n`;
};

const compNames = Object.keys(spec.components).sort();
for (const comp of compNames) {
  const c = spec.components[comp];
  let body = "";
  const lines = [];
  const specs = [];
  const usedNames = new Set();
  let usesWidget = false;
  let usesEnum = false;
  for (const p of c.props) {
    if (OMIT.has(p.name)) { exceptions.omitidas.push({ componente: comp, prop: p.name, motivo: OMIT.get(p.name) }); continue; }
    let name = p.name;
    let note = "";
    if (!isIdent(name)) {
      if (name === "aria-label") { name = "semanticLabel"; note = "No React e `aria-label` (Semantics no Flutter)."; exceptions.renomeadas.push({ componente: comp, de: "aria-label", para: "semanticLabel", motivo: "acessibilidade: Semantics" }); }
      else { exceptions.omitidas.push({ componente: comp, prop: p.name, motivo: "nome nao e identificador Dart (atributo HTML)" }); continue; }
    }
    if (name === "enabled" && !c.props.some((x) => x.name === "disabled")) {
      name = "disabled";
      note = "No React a prop se chama `enabled` (valor invertido); ver ADR 50.";
      exceptions.renomeadas.push({ componente: comp, de: "enabled", para: "disabled", motivo: "ADR 50 (valor invertido)" });
    } else if (name === "children") {
      name = "child";
      note = "No React e `children`.";
      exceptions.renomeadas.push({ componente: comp, de: "children", para: "child", motivo: "ADR 50" });
    }
    if (RESERVED.has(name)) { exceptions.renomeadas.push({ componente: comp, de: name, para: name + "Value", motivo: "palavra reservada do Dart" }); note += (note ? " " : "") + `No React e \`${name}\`.`; name += "Value"; }
    usedNames.add(name);
    const ty = dartType(comp, p);
    if (ty.enumName) { emittedEnums.add(ty.enumName); usesEnum = true; }
    if (ty.dart === "Widget") usesWidget = true;
    const nullable = p.optional || name === "disabled" && p.name === "enabled";
    const dartT = ty.dart + (nullable ? "?" : "");
    const desc = docLine(p.description ?? p.doc ?? "");
    const def = p.default !== undefined ? ` Padrão: \`${docLine(String(p.default))}\`.` : "";
    const gen = ty.generic ? ` Tipo TS: \`${docLine(stripOpt(p.ts))}\` (sem tradução exata; ver excecoes.json).` : "";
    const docText = [desc, def.trim(), note, gen.trim()].filter(Boolean).join(" ");
    lines.push(`${docText ? `  /// ${docText}\n` : ""}  ${dartT} get ${name};`);
    specs.push(`  SgPropSpec(\n    name: '${esc(name)}',\n    reactName: '${esc(p.name)}',\n    type: '${esc(dartT)}',\n    tsType: '${esc(stripOpt(p.ts))}',\n    required: ${!p.optional},${p.default !== undefined ? `\n    defaultValue: '${esc(String(p.default))}',` : ""}${p.description || p.doc ? `\n    description: '${esc(p.description ?? p.doc)}',` : ""}${p.enum ? `\n    values: <String>[${p.enum.map((v) => `'${esc(v)}'`).join(", ")}],` : ""}${ty.generic ? "\n    exact: false," : ""}\n  )`);
  }
  const cls = comp + "Props";
  const lc = lowerCamel(comp);
  body += header;
  body += (usesWidget ? "import 'package:flutter/widgets.dart';\n\n" : "") + (usesEnum ? "import 'enums.g.dart';\n" : "") + "import '../props/sg_prop_spec.dart';\n\n";
  body += `/// Props públicas de \`${comp}\` no React${c.description ? ` — ${docLine(c.description)}` : ""}\n/// O widget deve declarar \`implements ${cls}\`.\nabstract interface class ${cls} {\n${lines.join("\n")}\n}\n\n`;
  body += `/// Especificação das props de \`${comp}\` (tabela de props e playground do showcase).\nconst List<SgPropSpec> ${lc}PropSpecs = <SgPropSpec>[\n${specs.join(",\n")}${specs.length ? "," : ""}\n];\n`;
  fs.writeFileSync(path.join(outDir, snake(comp) + ".g.dart"), body);
  barrel.push(snake(comp) + ".g.dart");
}
fs.writeFileSync(path.join(outDir, "enums.g.dart"), header + [...emittedEnums].sort().map((n) => enumSrc(n, enumDefs.get(n))).join("\n"));
barrel.unshift("enums.g.dart");
const registry = header + "import '../props/sg_prop_spec.dart';\n" + compNames.map((n) => `import '${snake(n)}.g.dart';`).join("\n") + "\n\n/// Props de todos os componentes, por nome do widget (showcase e playground).\nconst Map<String, List<SgPropSpec>> sgPropSpecs = <String, List<SgPropSpec>>{\n" + compNames.map((n) => `  '${n}': ${lowerCamel(n)}PropSpecs,`).join("\n") + "\n};\n";
fs.writeFileSync(path.join(outDir, "registry.g.dart"), registry);
barrel.push("registry.g.dart");
fs.writeFileSync(path.join(outDir, "generated.dart"), header.replace("// ignore_for_file: constant_identifier_names\n\n", "") + barrel.map((f) => `export '${f}';`).join("\n") + "\n");

const grp = {};
for (const e of exceptions.tipoGenerico) grp[e.motivo] = (grp[e.motivo] ?? 0) + 1;
exceptions.resumo = { omitidas: exceptions.omitidas.length, renomeadas: exceptions.renomeadas.length, tipoGenerico: grp };
fs.writeFileSync(excFile, JSON.stringify(exceptions, null, 1) + "\n");
console.log(`gerado: ${barrel.length} arquivos, ${emittedEnums.size} enums; omitidas ${exceptions.omitidas.length}, renomeadas ${exceptions.renomeadas.length}, genericas ${JSON.stringify(grp)}`);
