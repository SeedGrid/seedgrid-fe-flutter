// Vetores de paridade do SgNotificationBell (P129): a verdade e o CODIGO DO REACT (notificationBellLogic.ts),
// transpilado com esbuild e executado de verdade. Cobre ordem, contagem, contador (99+), upsert/teto, ler/excluir,
// itens novos, plano do aviso do Pulse, quando usar polling, intervalo com jitter/backoff, metrica e tempo relativo.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/notification_bell_vectors/generate.mjs <pasta do pacote react>
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.join(root, "packages/seedgrid_components/test/widgets/notification_bell_vectors/vectors.json");
const src = path.join(pkg, "src", "notifications", "notificationBellLogic.ts");
if (!fs.existsSync(src)) {
  console.error("notificationBellLogic.ts nao encontrado em " + src);
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
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-bell-"));
const r = await esbuild.transform(fs.readFileSync(src, "utf8"), { loader: "ts", format: "esm", target: "es2022" });
fs.writeFileSync(path.join(tmp, "logic.mjs"), r.code);
const L = await import(pathToFileURL(path.join(tmp, "logic.mjs")).href);

const n = (id, createdAt, extra = {}) => ({
  publicId: id,
  type: "report.ready",
  title: "T " + id,
  message: null,
  payload: null,
  read: false,
  readAt: null,
  createdAt,
  expiresAt: null,
  ...extra
});

const A = n("a", "2026-11-04T10:00:00Z");
const B = n("b", "2026-11-04T11:00:00-03:00"); // 14:00Z, a mais nova
const C = n("c", "2026-11-04T10:00:00Z", { read: true, readAt: "2026-11-04T10:30:00Z" }); // empata com a
const D = n("d", "2026-11-03T09:00:00Z");
const E = n("e", "2026-11-02T09:00:00Z", { type: "backup.finished" });

const vectors = {};

// ordem: mais nova primeiro, empate pelo publicId
vectors.sort = [[A, B, C, D, E], [E, D, C, B, A], [], [A]].map((items) => ({
  items,
  out: L.sortNotifications(items).map((i) => i.publicId)
}));

// lista normalizada: sem repetidos (vale o ultimo), ordenada, teto
const A2 = { ...A, title: "A novo titulo" };
vectors.normalize = [
  { items: [A, B, C, D, E], max: 100 },
  { items: [A, B, C, D, E], max: 3 },
  { items: [A, B, A2], max: 100 },
  { items: [A, B], max: 0 },
  { items: [], max: 100 }
].map((c) => ({ ...c, out: L.normalizeList(c.items, c.max) }));

// microssegundos do servidor: truncados para ms; vencidas fora da lista
const M1 = n("m1", "2026-11-04T10:00:00.123456Z");
const M2 = n("m2", "2026-11-04T10:00:00.123999Z"); // mesmo ms que M1: empata, vale o publicId decrescente
const X = n("x", "2026-11-04T09:00:00Z", { expiresAt: "2026-11-04T11:00:00Z" });
const Y = n("y", "2026-11-04T09:30:00Z", { expiresAt: "2026-11-04T13:00:00Z" });
vectors.micros = [[M1, M2], [M2, M1], [M1, A]].map((items) => ({ items, out: L.sortNotifications(items).map((i) => i.publicId) }));
vectors.expired = [
  { items: [X, Y, A], now: "2026-11-04T12:00:00Z", max: 100 },
  { items: [X, Y, A], now: "2026-11-04T10:59:59Z", max: 100 },
  { items: [X], now: "2026-11-04T11:00:00Z", max: 100 }
].map((c) => ({ ...c, out: L.normalizeList(c.items, c.max, c.now).map((i) => i.publicId) }));

// contador mostrado: o do servidor, se houver
vectors.display = [
  { server: null, items: [A, B, C] },
  { server: 7, items: [A, B, C] },
  { server: 0, items: [A, B] },
  { server: -1, items: [A] },
  { server: 3.9, items: [] }
].map((c) => ({ ...c, out: L.displayUnread(c.server, c.items) }));

// teto da lista
vectors.clamp = [undefined, null, Number.NaN, 0, -5, 1, 2.9, 50, 100, 101, 500].map((v) => ({ value: v === undefined ? null : Number.isNaN(v) ? "NaN" : v, out: L.clampMaxVisible(v) }));

// contagem e contador
vectors.unread = [[], [A], [C], [A, B, C, D, E]].map((items) => ({ items, out: L.unreadCount(items) }));
vectors.badge = [-1, 0, 0.4, 0.9, 1, 1.9, 9, 10, 99, 100, 250, 1000, Number.NaN, Number.POSITIVE_INFINITY].map((count) => ({ count: Number.isNaN(count) ? "NaN" : count === Number.POSITIVE_INFINITY ? "Infinity" : count, out: L.badgeText(count) }));


// ler / ler todas / excluir
vectors.read = [
  { items: [A, B, C], id: "a", at: "2026-11-04T12:00:00Z" },
  { items: [A, B, C], id: "c", at: "2026-11-04T12:00:00Z" },
  { items: [A, B, C], id: "nao-existe", at: "2026-11-04T12:00:00Z" }
].map((c) => ({ ...c, out: L.markRead(c.items, c.id, c.at) }));
vectors.readAll = [
  { items: [A, B, C], at: "2026-11-04T12:00:00Z" },
  { items: [], at: "2026-11-04T12:00:00Z" }
].map((c) => ({ ...c, out: L.markAllRead(c.items, c.at) }));
vectors.remove = [
  { items: [A, B, C], id: "b" },
  { items: [A, B, C], id: "nao-existe" }
].map((c) => ({ ...c, out: L.removeNotification(c.items, c.id).map((i) => i.publicId) }));

// itens novos nao lidos (animacao do sino)
vectors.newUnread = [
  { previous: [A, D], next: [B, A, D] },
  { previous: [A, D], next: [C, A, D] },
  { previous: [A, D], next: [A, D] },
  { previous: [], next: [A, B] },
  { previous: [B], next: [B, A] },
  { previous: [A], next: [B, A] },
  { previous: [A, D], next: [A, D, E] }
].map((c) => ({ ...c, out: L.newUnread(c.previous, c.next).map((i) => i.publicId) }));

// aviso do Pulse -> o que fazer
const P = "user-notification.*";
vectors.event = [
  { pattern: P, channel: "user-notifications", event: "user-notification.created", data: { notificationPublicId: "abc", type: "report.ready" } },
  { pattern: P, channel: "user-notifications", event: "user-notification.created", data: {} },
  { pattern: P, channel: "user-notifications", event: "user-notification.created", data: null },
  { pattern: P, channel: "user-notifications", event: "user-notification.created", data: { notificationPublicId: "" } },
  { pattern: P, channel: "user-notifications", event: "user-notification.changed", data: {} },
  { pattern: P, channel: "backup", event: "user-notification.created", data: { notificationPublicId: "abc" } },
  { pattern: P, channel: "user-notifications", event: "backup.finished.success", data: {} },
  { pattern: "user-notification.created", channel: "user-notifications", event: "user-notification.changed", data: {} },
  { pattern: "*", channel: "user-notifications", event: "qualquer.coisa", data: {} }
].map((c) => ({ ...c, out: L.planEvent(c.pattern, c.channel, c.event, c.data) }));

// polling: quando, e quando reler ao conectar
const STATUS = ["idle", "disabled", "connecting", "connected", "reconnecting", "unavailable", "auth-error"];
vectors.pollingReason = STATUS.map((status) => ({ status, out: L.pollingReason(status) }));
vectors.refreshOnStatus = [];
for (const previous of STATUS) for (const next of STATUS) vectors.refreshOnStatus.push({ previous, next, out: L.shouldRefreshOnStatus(previous, next) });

// intervalo: preso entre 30 e 60 s; jitter de -10% a +10%; backoff em falha seguida ate 5 min
vectors.interval = [undefined, null, 0, 5000, 30000, 45000, 60000, 90000, 45000.4].map((ms) => ({ ms: ms ?? null, out: L.clampPollInterval(ms) }));
vectors.delay = [];
for (const base of [null, 30000, 45000, 60000, 90000])
  for (const failures of [0, 1, 2, 3, 6, 9, 20])
    for (const random of [0, 0.5, 1]) vectors.delay.push({ base, failures, random, out: L.nextPollDelay(base, failures, random) });
for (const [failures, random] of [[Number.NaN, 0.5], [0, Number.NaN], [-3, 0.5], [2.7, 2], [1, -1]])
  vectors.delay.push({ base: 45000, failures: Number.isNaN(failures) ? "NaN" : failures, random: Number.isNaN(random) ? "NaN" : random, out: L.nextPollDelay(45000, failures, random) });

// metrica do polling
{
  let s = L.EMPTY_POLLING_STATS;
  vectors.pollingStats = [];
  for (const [at, reason] of [
    ["2026-11-04T12:00:00Z", "disabled"],
    ["2026-11-04T12:00:45Z", "disabled"],
    ["2026-11-04T12:02:00Z", "unavailable"]
  ]) {
    const before = s;
    s = L.recordPollingTick(s, at, reason);
    vectors.pollingStats.push({ before, at, reason, out: s });
  }
}

// qual tela mostrar
vectors.view = [];
for (const loaded of [false, true]) for (const failed of [false, true]) for (const count of [0, 3]) for (const unreadOnly of [false, true]) vectors.view.push({ loaded, failed, count, unreadOnly, out: L.viewState({ loaded, failed, count, unreadOnly }) });

// interruptor "Nao lidas": o que a lista mostra, a query, o que acontece ao clicar e o valor inicial
vectors.unreadMode = {
  visible: [[A, B, C, D, E], [C], [], [A, C]].flatMap((items) =>
    [false, true].map((unreadOnly) => ({ items, unreadOnly, out: L.visibleItems(items, unreadOnly).map((i) => i.publicId) }))
  ),
  query: [[0, 100], [1, 50]].flatMap(([page, size]) =>
    [false, true].map((unreadOnly) => ({ page, size, unreadOnly, out: L.listQuery(page, size, unreadOnly) }))
  ),
  open: [A, C].flatMap((target) =>
    [false, true].map((unreadOnly) => ({
      items: [A, B, C],
      id: target.publicId,
      unreadOnly,
      readAt: "2026-11-05T12:00:00Z",
      out: L.afterOpen([A, B, C], target.publicId, unreadOnly, "2026-11-05T12:00:00Z")
    }))
  ),
  initial: [undefined, true, false].flatMap((show) =>
    [undefined, true, false].map((def) => ({ show: show ?? null, def: def ?? null, out: L.initialUnreadOnly(show, def) }))
  )
};

// empate de instante com ids estilo UUIDv7 (ordem lexicografica decrescente)
const U1 = n("01934f2a-7c10-7000-8000-000000000001", "2026-11-04T10:00:00Z");
const U2 = n("01934f2a-7c10-7000-8000-00000000000a", "2026-11-04T10:00:00Z");
const U3 = n("01934f2a-7c11-7000-8000-000000000000", "2026-11-04T10:00:00Z");
vectors.uuidTie = [[U1, U2, U3], [U3, U2, U1]].map((items) => ({ items, out: L.sortNotifications(items).map((i) => i.publicId) }));

// createdAt invalido: vai para o fim e nao vira data na tela
const BAD = n("bad", "nao-e-data");
vectors.invalid = [[A, BAD, B], [BAD]].map((items) => ({ items, out: L.sortNotifications(items).map((i) => i.publicId) }));
vectors.valid = ["2026-11-04T10:00:00Z", "2026-11-04T10:00:00.123456Z", "nao-e-data", ""].map((iso) => ({ iso, out: L.isValidInstant(iso) }));

// tempo relativo
const NOW = "2026-11-04T12:00:00Z";
vectors.relative = [
  "2026-11-04T12:00:00Z",
  "2026-11-04T11:59:30Z",
  "2026-11-04T11:59:00Z",
  "2026-11-04T11:15:00Z",
  "2026-11-04T11:00:01Z",
  "2026-11-04T11:00:00Z",
  "2026-11-04T01:00:00Z",
  "2026-11-03T12:00:00Z",
  "2026-10-29T12:00:01Z",
  "2026-10-28T12:00:00Z",
  "2026-11-05T12:00:00Z",
  "2026-11-04T09:00:00-03:00",
  "2026-11-03T12:00:01Z",
  "2026-11-03T12:00:00Z",
  "nao-e-data"
].map((createdAt) => ({ createdAt, now: NOW, out: L.relativeTime(createdAt, NOW) }));

// posicao do painel (placement como no SgPopup): lado, canto e tamanho da janela
vectors.panel = [];
for (const viewport of [{ width: 1280, height: 800 }, { width: 390, height: 800 }, { width: 600, height: 300 }])
  for (const [x, y] of [[20, 20], [300, 40], [1200, 20], [600, 400], [20, 760], [360, 770]])
    for (const panel of [{ width: 416, height: 300 }, { width: 416, height: 700 }])
      for (const placement of ["auto", "bottom", "top", "left", "right"]) {
        const anchor = { left: x, top: y, right: x + 36, bottom: y + 36 };
        vectors.panel.push({ anchor, panel, viewport, placement, out: L.panelPosition(anchor, panel, viewport, placement) });
      }

fs.writeFileSync(out, JSON.stringify(vectors, null, 2) + "\n");
console.log("vetores gravados em " + out);
