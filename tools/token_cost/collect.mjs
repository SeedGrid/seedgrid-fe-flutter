// Coleta as saidas REAIS do MCP de componentes (stdio, uma instancia por plataforma) para a medicao de tokens (MC.0).
// Grava saidas.<plataforma>.json ao lado deste arquivo. A contagem de tokens e feita por medir.py.
// Uso: node tools/token_cost/collect.mjs [--mcp <pasta do seedgrid-components-mcp>]
//   O .env do MCP (QDRANT_*, OPENAI_API_KEY) e lido e repassado so ao processo do servidor; nada dele e impresso.
import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const argMcp = process.argv.indexOf("--mcp");
const MCP = path.resolve(argMcp > 0 ? process.argv[argMcp + 1] : "../../java/seedgrid-components-mcp");
const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1"));
const sdk = (p) => import(pathToFileURL(path.join(MCP, "node_modules/@modelcontextprotocol/sdk/dist/esm", p)).href);
const { Client } = await sdk("client/index.js");
const { StdioClientTransport } = await sdk("client/stdio.js");

const COMPONENTES = ["SgButton", "SgInputText", "SgInputCPF", "SgInputCurrency", "SgCombobox", "SgDatatable", "SgDialog", "SgCalendar", "SgMenu", "SgToggleSwitch", "SgGrid", "SgToolBar"];
const BUSCAS = [
  "campo para digitar CPF",
  "tabela com paginacao e ordenacao",
  "dialogo de confirmacao ao excluir",
  "escolher uma data",
  "lista dupla para mover itens entre duas colunas",
  "campo de valor em moeda",
];

const env = { ...process.env };
const dotenv = path.join(MCP, ".env");
if (fs.existsSync(dotenv)) {
  for (const l of fs.readFileSync(dotenv, "utf8").split(/\r?\n/)) {
    const m = /^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/.exec(l);
    if (m && !l.trim().startsWith("#")) env[m[1]] = m[2].replace(/^["']|["']$/g, "");
  }
}

for (const platform of ["react", "flutter"]) {
  const transport = new StdioClientTransport({ command: "node", args: ["dist/server.js", `--platform=${platform}`], cwd: MCP, env, stderr: "pipe" });
  const client = new Client({ name: "token-cost", version: "1" });
  await client.connect(transport);
  const texto = (r) => r.content.map((c) => c.text ?? "").join("\n");
  const call = async (name, args) => {
    const r = await client.callTool({ name, arguments: args });
    return { args, isError: !!r.isError, text: texto(r) };
  };

  const out = { platform, mcpVersion: (await client.listTools()).tools.length, tools: (await client.listTools()).tools, componentes: {}, buscas: {} };
  for (const nome of COMPONENTES) {
    const full = await call("get_component", { name: nome });
    const propsOnly = await call("get_component", { name: nome, fields: "props" });
    const exemplos = await call("get_component_examples", { name: nome });
    let nomesProps = [];
    try {
      nomesProps = (JSON.parse(full.text)?.sgMeta?.props ?? []).map((p) => p.name);
    } catch {}
    const props = Object.fromEntries([...nomesProps.slice(0, 3).map((n) => [n, true]), ["propInexistenteXyz", 1]]);
    const validar = await call("validate_props", { name: nome, props });
    out.componentes[nome] = { get_component_full: full, get_component_props: propsOnly, get_component_examples: exemplos, validate_props: validar };
  }
  for (const q of BUSCAS) {
    out.buscas[q] = { search_components_semantic: await call("search_components_semantic", { query: q, topK: 5 }), find_components_by_semantic: await call("find_components_by_semantic", { semantic: q, limit: 5 }) };
  }
  await client.close();
  fs.writeFileSync(path.join(here, `saidas.${platform}.json`), JSON.stringify(out, null, 1));
  const fontes = new Set(Object.values(out.buscas).map((b) => { try { return JSON.parse(b.search_components_semantic.text).source; } catch { return "?"; } }));
  console.log(`${platform}: ${COMPONENTES.length} componentes, ${BUSCAS.length} buscas, fonte da busca vetorial: ${[...fontes].join(",")}`);
}
