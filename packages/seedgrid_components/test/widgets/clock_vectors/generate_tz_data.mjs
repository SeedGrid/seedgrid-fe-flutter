// Gera lib/src/gadgets/clock/clock_tz_data.g.dart (tabela de fusos IANA do SgClock) e clock_vectors/tz_sample.json
// (instantes sorteados, conferidos pelo teste contra o Intl). O React nao tem tabela: passa `timeZone` ao
// Intl.DateTimeFormat e o navegador traz o banco. O Dart nao tem isso, entao esta tabela e a nossa copia.
// QUANDO REGERAR: sempre que um pais mudar a regra de horario de verao (acompanhe o tzdata/IANA) ou quando o fim do
// intervalo (ATE) chegar perto. Uso: node packages/seedgrid_components/test/widgets/clock_vectors/generate_tz_data.mjs
import fs from "node:fs";
import path from "node:path";

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\//, ""));
const DE = Date.UTC(2019, 0, 1);
const ATE = Date.UTC(2046, 0, 1);
const STEP = 5 * 86400000; // nenhuma regra real muda duas vezes em 5 dias

// Nomes modernos/ligacoes que o Intl aceita mas supportedValuesOf nao lista (ele lista o nome legado, ex. Asia/Calcutta).
const EXTRA = [
  "Africa/Asmara", "America/Argentina/Buenos_Aires", "America/Argentina/Catamarca", "America/Argentina/Cordoba", "America/Argentina/Jujuy",
  "America/Argentina/Mendoza", "America/Indiana/Indianapolis", "America/Kentucky/Louisville", "America/Nuuk", "America/Atikokan",
  "America/Coral_Harbour", "Asia/Kolkata", "Asia/Kathmandu", "Asia/Ho_Chi_Minh", "Asia/Yangon", "Asia/Dhaka", "Asia/Thimphu",
  "Asia/Ulaanbaatar", "Asia/Macau", "Asia/Kashgar", "Atlantic/Faroe", "Europe/Kyiv", "Pacific/Chuuk", "Pacific/Pohnpei",
  "Pacific/Kanton", "Pacific/Honolulu", "US/Eastern", "US/Central", "US/Mountain", "US/Pacific", "US/Hawaii", "US/Alaska",
  "Brazil/East", "Brazil/West", "Brazil/Acre", "Brazil/DeNoronha", "Canada/Eastern", "Canada/Pacific", "Mexico/General",
  "Etc/UTC", "Etc/GMT", "Etc/UCT", "Zulu", "GB", "Japan", "Singapore", "Hongkong", "Israel", "Turkey", "Iran", "Egypt", "Cuba",
];
const accepted = (z) => { try { new Intl.DateTimeFormat("en-US", { timeZone: z }); return true; } catch { return false; } };
const names = [...new Set([...Intl.supportedValuesOf("timeZone"), ...EXTRA.filter(accepted)])].sort();

function offsetFn(z) {
  const fmt = new Intl.DateTimeFormat("en-US", { timeZone: z, hourCycle: "h23", year: "numeric", month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit", second: "2-digit" });
  return (ms) => {
    const p = Object.fromEntries(fmt.formatToParts(new Date(ms)).map((x) => [x.type, x.value]));
    return Math.round((Date.UTC(+p.year, +p.month - 1, +p.day, +p.hour, +p.minute, +p.second) - Math.floor(ms / 1000) * 1000) / 60000);
  };
}

const patterns = new Map(); // json -> indice
const list = [];
const zoneIdx = {};
const offs = {};
for (const z of names) {
  const off = offsetFn(z);
  offs[z] = off;
  const flat = [off(DE)];
  let prev = flat[0];
  for (let ms = DE + STEP; ms <= ATE; ms += STEP) {
    const cur = off(ms);
    if (cur !== prev) {
      let lo = ms - STEP, hi = ms; // off(lo) = prev, off(hi) = cur
      while (hi - lo > 1000) {
        const mid = Math.floor((lo + hi) / 2000) * 1000;
        if (off(mid) === prev) lo = mid; else hi = mid;
      }
      flat.push(hi / 1000, cur);
      prev = cur;
    }
  }
  const key = flat.join(",");
  if (!patterns.has(key)) { patterns.set(key, list.length); list.push(flat); }
  zoneIdx[z] = patterns.get(key);
}

const dart = `// dart format off
// GERADO por test/widgets/clock_vectors/generate_tz_data.mjs (Intl do Node, ICU ${process.versions.icu}). NAO EDITE A MAO.
// Fusos IANA do SgClock: ${names.length} nomes em ${list.length} padroes. Cada padrao e [deslocamento inicial (min), t1 (s UTC), deslocamento a partir de t1, ...],
// valido de ${new Date(DE).toISOString().slice(0, 10)} a ${new Date(ATE).toISOString().slice(0, 10)}; depois disso vale o ultimo deslocamento (regere antes de chegar la).
const int kSgClockTzFrom = ${DE / 1000};
const int kSgClockTzUntil = ${ATE / 1000};

const List<List<int>> kSgClockTzPatterns = <List<int>>[
${list.map((p) => `  <int>[${p.join(", ")}],`).join("\n")}
];

const Map<String, int> kSgClockTzZones = <String, int>{
${names.map((z) => `  '${z}': ${zoneIdx[z]},`).join("\n")}
};
`;
fs.writeFileSync(path.resolve(here, "../../../lib/src/gadgets/clock/clock_tz_data.g.dart"), dart);

// amostra independente: 24 instantes por zona (seed fixa), deslocamento direto do Intl
let seed = 12345;
const rnd = () => (seed = (seed * 1103515245 + 12345) % 2147483648) / 2147483648;
const sample = {};
for (const z of names) {
  sample[z] = Array.from({ length: 24 }, () => { const ms = Math.floor((DE + rnd() * (ATE - DE)) / 1000) * 1000; return [ms, offs[z](ms)]; });
}
fs.writeFileSync(path.join(here, "tz_sample.json"), JSON.stringify(sample) + "\n");
console.log(`tz: ${names.length} nomes, ${list.length} padroes, ${(dart.length / 1024).toFixed(0)} KB`);
