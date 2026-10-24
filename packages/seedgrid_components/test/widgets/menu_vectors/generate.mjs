// Vetores de paridade do SgMenu e da SgToolBar. A verdade e o CODIGO DO REACT, executado de verdade:
// src/layout/menu-logic.ts, toolbar-logic.ts e drag-position.ts sao transpilados (esbuild) e importados.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/menu_vectors/generate.mjs <pasta do pacote react>
// Gera packages/seedgrid_components/test/widgets/menu_vectors/vectors.json. Deterministico (PRNG fixo).
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.join(root, "packages/seedgrid_components/test/widgets/menu_vectors/vectors.json");
const layout = path.join(pkg, "src", "layout");
if (!fs.existsSync(path.join(layout, "menu-logic.ts"))) {
  console.error("menu-logic.ts nao encontrado em " + layout);
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
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-menu-"));
async function load(name) {
  const source = fs.readFileSync(path.join(layout, name + ".ts"), "utf8");
  const r = await esbuild.transform(source, { loader: "ts", format: "esm", target: "es2022" });
  const file = path.join(tmp, name + ".mjs");
  fs.writeFileSync(file, r.code);
  return import(pathToFileURL(file).href);
}
const M = await load("menu-logic");
const T = await load("toolbar-logic");
const D = await load("drag-position");
const ROOT = "__sg_menu_root__";

// PRNG deterministico (mulberry32)
let seed = 20261024;
const rnd = () => {
  seed |= 0;
  seed = (seed + 0x6d2b79f5) | 0;
  let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
  t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
  return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
};
const pick = (arr) => arr[Math.floor(rnd() * arr.length)];
const chance = (p) => rnd() < p;

// ---------------------------------------------------------------- arvores de exemplo (JSON puro)
const trees = {
  A: [
    { id: "home", label: "Inicio", url: "/home" },
    {
      id: "sales", label: "Vendas", children: [
        { id: "orders", label: "Pedidos", url: "/orders" },
        { id: "customers", label: "Clientes", children: [
          { id: "vip", label: "VIP", url: "/vip" },
          { id: "all", label: "Todos", hasOnClick: true },
          { id: "off", label: "Inativos", disabled: true }
        ] }
      ]
    },
    {
      id: "reports", label: "Relatórios", children: [
        { id: "monthly", label: "Mensal", url: "/monthly" },
        { id: "dupe", label: "Pedidos (atalho)", url: "/orders" }
      ]
    },
    { id: "settings", label: "Configurações", disabled: true },
    { id: "help", label: "Ajuda", hasOnClick: true },
    { id: "empty", label: "Vazio", children: [] },
    { id: "both", label: "Ambos", url: "/both", children: [{ id: "both-a", label: "Filho de Ambos", url: "/both/a" }] }
  ],
  B: [
    { id: "a", label: "Alfa", children: [{ id: "a1", label: "Alfa 1" }, { id: "a2", label: "Alfa 2", children: [{ id: "a2x", label: "Alfa 2 X" }] }] },
    { id: "b", label: "Beta", children: [{ id: "b1", label: "Beta 1", url: "/b1" }] },
    { id: "c", label: "Gama" }
  ]
};
const toTs = (nodes) => nodes.map((n) => {
  const o = { id: n.id, label: n.label };
  if (n.url) o.url = n.url;
  if (n.disabled) o.disabled = true;
  if (n.hasOnClick) o.onClick = () => {};
  if (n.children) o.children = toTs(n.children);
  return o;
});
const ts = { A: toTs(trees.A), B: toTs(trees.B) };
const allIds = (nodes, acc = []) => { for (const n of nodes) { acc.push(n.id); if (n.children) allIds(n.children, acc); } return acc; };
const ids = { A: allIds(trees.A), B: allIds(trees.B) };

const mapObj = (m) => Object.fromEntries(m);
const cases = {};

// buildMenuMaps / collectParentChain
cases.maps = Object.keys(ts).map((name) => {
  const m = M.buildMenuMaps(ts[name]);
  return {
    tree: name,
    parentById: mapObj(m.parentById),
    nodeIds: Array.from(m.nodeById.keys()),
    childrenByParent: mapObj(m.childrenByParent),
    firstByUrl: mapObj(m.firstByUrl),
    chains: Object.fromEntries(ids[name].map((id) => [id, M.collectParentChain(m.parentById, id)]))
  };
});

// computeActiveSets / resolveEffectiveActiveId
const activeIds = [undefined, "", "vip", "orders", "sales", "nada", "a2x", "b1"];
const activeUrls = [undefined, "", "/orders", "/vip", "/b1", "/nada", "/both/a"];
cases.activeSets = [];
cases.effectiveActive = [];
for (const name of Object.keys(ts)) {
  const maps = M.buildMenuMaps(ts[name]);
  for (const activeId of activeIds) for (const activeUrl of activeUrls) {
    const s = M.computeActiveSets(ts[name], activeId, activeUrl);
    cases.activeSets.push({ tree: name, activeId: activeId ?? null, activeUrl: activeUrl ?? null, exact: Array.from(s.exact), branch: Array.from(s.branch) });
    for (const localActiveId of [undefined, "home", ""]) {
      cases.effectiveActive.push({
        tree: name, activeId: activeId ?? null, activeUrl: activeUrl ?? null, localActiveId: localActiveId ?? null,
        out: M.resolveEffectiveActiveId({ activeId, activeUrl, localActiveId, firstByUrl: maps.firstByUrl }) ?? null
      });
    }
  }
}

// mergeExpandedIdsForActivePath
cases.merge = [];
for (let i = 0; i < 40; i++) {
  const pool = ["sales", "customers", "reports", "a", "a2", "b", "x"];
  const cur = pool.filter(() => chance(0.4));
  const chain = pool.filter(() => chance(0.4));
  cases.merge.push({ current: cur, chain, out: M.mergeExpandedIdsForActivePath(cur, chain) });
}

// resolveTieredActiveState
cases.tieredActive = [];
for (const name of Object.keys(ts)) {
  const maps = M.buildMenuMaps(ts[name]);
  for (const effectiveActiveId of [undefined, "", ...ids[name], "nada"]) {
    const r = M.resolveTieredActiveState({ effectiveActiveId, maps, menu: ts[name] });
    cases.tieredActive.push({ tree: name, effectiveActiveId: effectiveActiveId ?? null, tieredPath: r.tieredPath, megaActiveId: r.megaActiveId ?? null });
  }
}
cases.tieredActive.push({ tree: "empty", effectiveActiveId: null, tieredPath: [], megaActiveId: null });

// resolveMenuLayoutState (amostra grande)
const zones = [null, "top", "bottom", "left", "right", "free"];
const dirs = [undefined, "horizontal-left", "horizontal-right", "vertical-up", "vertical-top", "vertical-down"];
const styles = ["sidebar", "drawer", "inline", "hybrid"];
const effStyles = ["panel", "tiered", "mega-horizontal", "mega-vertical"];
cases.layoutState = [];
for (let i = 0; i < 700; i++) {
  const a = {
    dockMode: chance(0.6),
    effectiveDockZone: pick(zones),
    orientationDirection: pick(dirs),
    position: pick(["left", "right"]),
    horizontalDockAlign: pick([null, "left", "right"]),
    isCollapsed: chance(0.5),
    menuStyle: pick(styles),
    effectiveMenuStyle: pick(effStyles),
    pinnedState: chance(0.5),
    expandedWidthCss: pick(["280px", "20rem", "100%"]),
    collapsedWidthCss: pick(["72px", "4rem"])
  };
  cases.layoutState.push({ args: { ...a, orientationDirection: a.orientationDirection ?? null }, out: M.resolveMenuLayoutState(a) });
}

// resolveMenuNodeActionIntent
cases.actionIntent = [];
for (const variant of ["panel", "flat"]) for (const hasChildren of [false, true]) for (const hasActionTarget of [false, true]) for (const isCollapsed of [undefined, false, true]) {
  cases.actionIntent.push({ variant, hasChildren, hasActionTarget, isCollapsed: isCollapsed ?? null, out: M.resolveMenuNodeActionIntent({ variant, hasChildren, hasActionTarget, isCollapsed }) });
}

// resolveExpandedIdsToggle
cases.toggle = [];
for (const name of Object.keys(ts)) {
  const maps = M.buildMenuMaps(ts[name]);
  for (let i = 0; i < 60; i++) {
    const currentIds = ids[name].filter(() => chance(0.3));
    const nodeId = pick(ids[name]);
    const mode = pick(["accordion", "multiple"]);
    cases.toggle.push({
      tree: name, currentIds, nodeId, mode,
      out: M.resolveExpandedIdsToggle({ currentIds, nodeId, mode, parentById: maps.parentById, childrenByParent: maps.childrenByParent })
    });
  }
}

// resolveHorizontalDockAlign
cases.horizontalAlign = [];
for (let i = 0; i < 30; i++) {
  const left = Math.floor(rnd() * 200), width = 100 + Math.floor(rnd() * 800), clientX = Math.floor(rnd() * 1200);
  cases.horizontalAlign.push({ clientX, left, width, out: M.resolveHorizontalDockAlign(clientX, { left, width }) });
}
cases.horizontalAlign.push({ clientX: 500, left: 0, width: 1000, out: M.resolveHorizontalDockAlign(500, { left: 0, width: 1000 }) });

// tiered: hover / click
cases.tieredHover = [];
cases.tieredClick = [];
for (let i = 0; i < 120; i++) {
  const currentPath = pick([[], ["sales"], ["sales", "customers"], ["a", "a2"], ["x"]]);
  const depth = Math.floor(rnd() * 4);
  const nodeId = pick(["sales", "customers", "vip", "a", "z"]);
  const hasChildren = chance(0.5), hasActionTarget = chance(0.5), openSubmenuOnHover = chance(0.5);
  cases.tieredHover.push({
    currentPath, depth, nodeId, hasChildren, openSubmenuOnHover,
    path: M.resolveTieredHoverPath(currentPath, depth, nodeId, hasChildren),
    intent: M.resolveTieredHoverIntent({ currentPath, depth, nodeId, hasChildren, openSubmenuOnHover }) ?? null
  });
  cases.tieredClick.push({
    currentPath, depth, nodeId, hasChildren, hasActionTarget,
    state: M.resolveTieredClickState(currentPath, depth, nodeId),
    intent: M.resolveTieredNodeClickIntent({ currentPath, depth, nodeId, hasChildren, hasActionTarget })
  });
}

// resolveMenuSearchSelectionState
cases.searchSelection = [];
for (const name of Object.keys(ts)) {
  const maps = M.buildMenuMaps(ts[name]);
  for (const nodeId of ids[name]) {
    const node = maps.nodeById.get(nodeId);
    const parentChain = M.collectParentChain(maps.parentById, nodeId);
    const rootToParent = [...parentChain].reverse();
    const currentExpandedIds = ids[name].filter(() => chance(0.25));
    const hasChildren = Boolean(node.children?.length);
    const hasActionTarget = Boolean(node.url || node.onClick);
    const r = M.resolveMenuSearchSelectionState({ currentExpandedIds, parentChain, rootToParent, nodeId, hasChildren, hasActionTarget });
    cases.searchSelection.push({
      tree: name, currentExpandedIds, nodeId,
      out: { expandedIds: r.expandedIds, tieredPath: r.tieredPath, megaActiveId: r.megaActiveId ?? null, localActiveId: r.localActiveId ?? null, shouldActivateNode: r.shouldActivateNode }
    });
  }
}

// mega menu
cases.mega = [];
for (const name of Object.keys(ts)) {
  for (const megaActiveId of [undefined, ...ids[name], "nada"]) {
    cases.mega.push({ tree: name, megaActiveId: megaActiveId ?? null, active: M.resolveMegaMenuActiveNode(ts[name], megaActiveId)?.id ?? null });
  }
}
cases.megaInteraction = [];
for (const hasChildren of [false, true]) {
  const i = M.resolveMegaMenuInteraction({ nodeId: "n", hasChildren });
  cases.megaInteraction.push({ hasChildren, nextMegaActiveId: i.nextMegaActiveId ?? null, shouldActivateNode: i.shouldActivateNode, hover: M.resolveMegaMenuHoverActiveId({ nodeId: "n", hasChildren }) ?? null });
}

// busca: filterMenuNodes / collectMenuSearchEntries / autocomplete
const queries = ["", "  ", "ped", "PEDIDOS", "vip", "clientes", "x", "alfa", "alfa 2", "rela", "ç", "configura", "nada aqui", "ajuda"];
const shape = (nodes) => nodes.map((n) => ({ id: n.id, children: n.children ? shape(n.children) : null }));
cases.filter = [];
cases.autocomplete = [];
cases.entries = [];
for (const name of Object.keys(ts)) {
  const entries = M.collectMenuSearchEntries(ts[name]);
  cases.entries.push({ tree: name, entries });
  for (const query of queries) {
    cases.filter.push({ tree: name, query, out: shape(M.filterMenuNodes(ts[name], query)) });
    for (const limit of [undefined, 3]) {
      cases.autocomplete.push({ tree: name, query, limit: limit ?? null, out: M.resolveMenuAutocompleteItems(entries, query, limit) });
    }
  }
}

// flattenVisibleNodes + teclado
cases.flatten = [];
cases.keyboard = [];
const keys = ["ArrowDown", "ArrowUp", "ArrowRight", "ArrowLeft", "Enter", " ", "Tab", "Escape", "Home"];
for (const name of Object.keys(ts)) {
  const maps = M.buildMenuMaps(ts[name]);
  for (let i = 0; i < 40; i++) {
    const expanded = ids[name].filter(() => chance(0.5));
    const collapsed = chance(0.2), forceExpand = chance(0.2);
    const visible = M.flattenVisibleNodes(ts[name], new Set(expanded), collapsed, forceExpand);
    cases.flatten.push({ tree: name, expanded, collapsed, forceExpand, out: visible.map((v) => ({ id: v.node.id, depth: v.depth, parentId: v.parentId })) });
  }
  for (let i = 0; i < 400; i++) {
    const expanded = ids[name].filter(() => chance(0.5));
    const collapsed = chance(0.15), hasSearch = chance(0.15);
    const visible = M.flattenVisibleNodes(ts[name], new Set(expanded), collapsed, hasSearch);
    const focusedId = pick([undefined, "nada", ...ids[name]]);
    const key = pick(keys);
    const action = M.resolveMenuKeyboardAction({ key, visibleNodes: visible, focusedId, expandedIds: new Set(expanded), hasSearch, isCollapsed: collapsed, parentById: maps.parentById, rootParentId: ROOT });
    cases.keyboard.push({ tree: name, key, focusedId: focusedId ?? null, expanded, hasSearch, isCollapsed: collapsed, out: { type: action.type, id: action.id ?? null } });
  }
}

// ---------------------------------------------------------------- toolbar
const tbDirs = ["horizontal-left", "horizontal-right", "vertical-up", "vertical-down"];
const tbZones = ["top", "bottom", "left", "right", "free"];
cases.toolbarOrientation = tbDirs.map((d) => ({ d, out: T.resolveToolbarOrientationDirection(d) }));
cases.toolbarDockOrientation = [];
for (const d of tbDirs) for (const inDock of [false, true]) for (const zone of tbZones) {
  cases.toolbarDockOrientation.push({ d, inDock, zone, out: T.resolveToolbarDockOrientationDirection(d, inDock, zone) });
}
cases.toolbarLayout = [];
for (const orientationDirection of tbDirs) for (const inDock of [false, true]) for (const freeDrag of [false, true])
  for (const hover of [null, ...tbZones]) for (const effectiveZone of tbZones) for (const showContent of [false, true]) {
    const r = T.buildToolbarLayoutState({ orientationDirection, inDock, zone: effectiveZone, freeDrag, dragHoverZone: hover, effectiveZone, showContent });
    cases.toolbarLayout.push({ orientationDirection, inDock, freeDrag, hover, effectiveZone, showContent, out: r });
  }
const raws = [
  { x: 1, y: 2 }, { x: 1.5, y: -3 }, '{"x":10,"y":20}', '{"x":"1","y":2}', '{"x":1}', "abc", "null", "[]", "5", '{"x":1e999,"y":1}',
  { x: 1, y: "2" }, null, [], '{"x":0,"y":0}', "", '{"y":3,"x":4,"z":5}'
];
cases.storedPosition = raws.map((raw) => ({ raw, out: D.parseStoredPanelDragPosition(raw) }));
cases.storageKey = ["a", "toolbar-1", "x y"].map((id) => ({ id, out: D.buildToolbarStorageKey(id) }));

fs.rmSync(tmp, { recursive: true, force: true });
fs.writeFileSync(out, JSON.stringify({ rootParentId: ROOT, trees, cases }) + "\n", "utf8");
console.log("vetores gravados em " + out);
