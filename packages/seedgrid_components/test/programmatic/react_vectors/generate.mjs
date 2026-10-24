// Gera test/programmatic/react_vectors/vectors.json executando o React REAL (dist/sandbox.cjs + jsdom + react-hook-form).
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/programmatic/react_vectors/generate.mjs [pasta do pacote react] [componente...]
// Sem componentes na linha de comando, gera todos. Deterministico (so usa timers curtos reais).
import fs from "node:fs";
import path from "node:path";
import { loadReact, loadDomHarness, runScenario } from "./harness.mjs";
import { ADAPTERS } from "./adapters.mjs";
import { SCENARIOS } from "./scenarios.mjs";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const only = process.argv.slice(3);
const out = path.join(root, "packages/seedgrid_components/test/programmatic/react_vectors/vectors.json");

const env = loadReact(pkg);
env.dom = await loadDomHarness(pkg);

const result = fs.existsSync(out) && only.length ? JSON.parse(fs.readFileSync(out, "utf8")) : {};
let failures = 0;
for (const [comp, scenarios] of Object.entries(SCENARIOS)) {
  if (only.length && !only.includes(comp)) continue;
  const adapter = ADAPTERS[comp];
  if (!adapter) throw new Error("sem adapter para " + comp);
  const list = [];
  for (const sc of scenarios) {
    try {
      const snaps = await runScenario(env, adapter, sc);
      list.push({ ...sc, expected: snaps });
    } catch (e) {
      failures++;
      console.error(`FALHOU ${comp}/${sc.id}:`, e.stack ?? e);
      list.push({ ...sc, expected: [], error: String(e) });
    }
  }
  result[comp] = list;
  console.log(`${comp}: ${list.length} cenarios`);
}
fs.writeFileSync(out, JSON.stringify(result, null, 1) + "\n", "utf8");
console.log("gravado", out);
process.exit(failures ? 1 : 0);
