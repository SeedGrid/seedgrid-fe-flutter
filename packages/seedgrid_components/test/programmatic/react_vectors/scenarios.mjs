// Cenarios (JSON puro) executados pelo React (generate.mjs) E pelo Dart (test/programmatic). Mesmos passos nos dois.
// Vias: a = valor inicial, b = prop value controlada mudando, c = name+control (setValue/reset/getValue),
// d = opcoes tardias/mudando/tipo de id, e = o que onChange emite, f = validacao, g = painel aberto/focado, h = disabled.
// Passos: props{set}, items{items}, wait{ms}, form.setValue{value,shouldValidate}, form.reset{values?}, form.trigger,
// passos de UI de cada componente (open, pick, toggle...), snap{label}. Cada `snap` vira um instantaneo comparado.
import combobox from "./scenarios/combobox.mjs";
import autocomplete from "./scenarios/autocomplete.mjs";
import multi from "./scenarios/multiselect.mjs";
import * as choice from "./scenarios/choice.mjs";
import otp from "./scenarios/otp.mjs";

export const SCENARIOS = { combobox, autocomplete, multiselect: multi(false), multiselectchips: multi(true), ...choice, otp };
