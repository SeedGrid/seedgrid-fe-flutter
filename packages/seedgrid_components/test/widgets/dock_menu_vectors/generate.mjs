// Vetores de paridade do SgDockMenu. A verdade e o CODIGO DO REACT, executado de verdade:
// menus/dock-menu-logic.ts (layout, curva do zoom, estilo do rotulo, posicao do container, estado do menu de
// contexto) e layout/drag-position.ts (chave de persistencia e leitura da posicao salva) sao empacotados com
// esbuild e chamados com entradas variadas.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/dock_menu_vectors/generate.mjs <pasta do pacote react>
// Gera dock_menu_vectors/vectors.json. Deterministico.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.join(root, "packages/seedgrid_components/test/widgets/dock_menu_vectors/vectors.json");
const logic = path.join(pkg, "src", "menus", "dock-menu-logic.ts");
const drag = path.join(pkg, "src", "layout", "drag-position.ts");
for (const f of [logic, drag]) {
  if (!fs.existsSync(f)) {
    console.error("nao encontrado: " + f);
    process.exit(2);
  }
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
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-dock-"));
const entry = path.join(tmp, "entry.ts");
fs.writeFileSync(
  entry,
  `export * from ${JSON.stringify(logic.replace(/\\/g, "/"))};\nexport * from ${JSON.stringify(drag.replace(/\\/g, "/"))};\n`
);
const outfile = path.join(tmp, "bundle.mjs");
await esbuild.build({ entryPoints: [entry], bundle: true, format: "esm", platform: "node", outfile, logLevel: "error" });
const L = await import(pathToFileURL(outfile).href);
fs.rmSync(tmp, { recursive: true, force: true });

const positions = ["left-top", "left-center", "left-bottom", "center-top", "center-bottom", "right-top", "right-center", "right-bottom"];
const vectors = { react: JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8")).version };

// JSON nao guarda -0: normaliza para 0 (o teste Dart compara com tolerancia).
const z = (n) => (Object.is(n, -0) ? 0 : n);

vectors.layout = positions.map((position) => ({ position, out: L.buildDockMenuLayout(position) }));

vectors.motion = [];
for (const orientation of ["horizontal", "vertical"]) {
  for (const liftDirection of [-1, 1]) {
    for (const magnify of [true, false]) {
      for (const magnifyScale of [1.5, 2, 0.8]) {
        for (const [itemSize, gap] of [[48, 16], [32, 0], [100, 30]]) {
          for (const count of [1, 6]) {
            for (const hoveredIndex of [null, 0, 2, count - 1]) {
              if (hoveredIndex !== null && hoveredIndex >= count) continue;
              for (let index = 0; index < count; index++) {
                const o = L.buildDockMenuItemMotion({ index, hoveredIndex, magnify, magnifyScale, itemSize, gap, orientation, liftDirection });
                vectors.motion.push({
                  index, hoveredIndex, magnify, magnifyScale, itemSize, gap, orientation, liftDirection,
                  out: { scale: o.scale, translateX: z(o.translateX), translateY: z(o.translateY), transformOrigin: o.transformOrigin, zIndex: o.zIndex }
                });
              }
            }
          }
        }
      }
    }
  }
}

vectors.labelStyle = [];
for (const position of positions) {
  for (const orientation of ["horizontal", "vertical"]) {
    vectors.labelStyle.push({ position, orientation, out: L.buildDockMenuLabelStyle(orientation, position) });
  }
}

vectors.containerStyle = [];
const offsets = [undefined, {}, { x: 0, y: 0 }, { x: 10 }, { y: 7 }, { x: -12, y: 30 }, { x: 5, y: -9 }];
const dragPositions = [null, { x: 0, y: 0 }, { x: 120, y: 80 }];
for (const position of positions) {
  for (const enableDragDrop of [false, true]) {
    for (const dragPos of dragPositions) {
      for (const offset of offsets) {
        const args = { position, zIndex: 50, enableDragDrop, dragPos, offset };
        const o = L.buildDockMenuContainerStyle(args);
        vectors.containerStyle.push({ position, enableDragDrop, dragPos, offset: offset ?? null, out: { style: o.style, transform: o.transform } });
      }
    }
  }
}

vectors.contextMenu = [];
for (const enableDragDrop of [false, true]) {
  for (const dragId of [undefined, "", "a"]) {
    for (const hasStoredPosition of [false, true]) {
      vectors.contextMenu.push({ enableDragDrop, dragId: dragId ?? null, hasStoredPosition, out: L.buildDockMenuContextMenuState({ enableDragDrop, dragId, hasStoredPosition }) });
    }
  }
}

vectors.storageKey = [[undefined, false], [null, false], ["", false], ["main", false], ["main", true], ["a:b", false]].map(([dragId, abs]) => ({
  dragId: dragId ?? null, absolute: abs, out: L.buildDockMenuStorageKey(dragId, abs)
}));

// parseStoredPanelDragPosition: o valor de entrada precisa caber em JSON; os que nao cabem (NaN, Infinity) vao como texto marcado.
const parseInputs = [
  '{"x":10,"y":20}', '{"x":1.5,"y":-2.5}', '{"x":"1","y":2}', '{"x":1}', "null", "[]", "42", '"s"', "not json", "", '{"x":0,"y":0}',
  { x: 3, y: 4 }, { x: 3 }, { x: "3", y: 4 }, null, 7, [], { x: 1, y: 2, z: 3 }
];
vectors.parseStored = parseInputs.map((input) => ({ input, out: L.parseStoredPanelDragPosition(input) }));
vectors.parseStoredNonFinite = [
  { label: "NaN", out: L.parseStoredPanelDragPosition({ x: NaN, y: 1 }) },
  { label: "Infinity", out: L.parseStoredPanelDragPosition({ x: 1, y: Infinity }) }
];

fs.mkdirSync(path.dirname(out), { recursive: true });
// Uma linha por caso (arquivo compacto e diff legivel).
const body = Object.entries(vectors)
  .map(([k, v]) => (Array.isArray(v) ? ` ${JSON.stringify(k)}: [\n  ${v.map((x) => JSON.stringify(x)).join(",\n  ")}\n ]` : ` ${JSON.stringify(k)}: ${JSON.stringify(v)}`))
  .join(",\n");
fs.writeFileSync(out, "{\n" + body + "\n}\n");
console.log(
  `dock menu: layout ${vectors.layout.length}, motion ${vectors.motion.length}, label ${vectors.labelStyle.length}, container ${vectors.containerStyle.length}, ctx ${vectors.contextMenu.length}, parse ${vectors.parseStored.length} -> ${path.relative(root, out)}`
);
