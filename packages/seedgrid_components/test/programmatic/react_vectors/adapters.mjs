// Adapters React: como montar cada componente a partir do cenario (JSON), ler o que o usuario ve e agir na UI.
// Nomes de prop do cenario = nomes do Flutter (disabled etc.); cada adapter converte para os do React (enabled: false).
import combobox from "./adapters/combobox.mjs";
import autocomplete from "./adapters/autocomplete.mjs";
import { multiselect, multiselectchips } from "./adapters/multiselect.mjs";
import { checkboxgroup, radiogroup, toggleswitch, slider, rating } from "./adapters/choice.mjs";
import otp from "./adapters/otp.mjs";

export const ADAPTERS = { combobox, autocomplete, multiselect, multiselectchips, checkboxgroup, radiogroup, toggleswitch, slider, rating, otp };
