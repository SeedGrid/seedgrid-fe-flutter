// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Registro das paginas do showcase (menu do app e testes automaticos).

import 'package:flutter/widgets.dart';

import 'sg_avatar_page.dart';
import 'sg_avatar_group_page.dart';
import 'sg_badge_page.dart';
import 'sg_badge_overlay_page.dart';
import 'sg_button_page.dart';
import 'sg_checkbox_group_page.dart';
import 'sg_input_birth_date_page.dart';
import 'sg_input_cnpj_page.dart';
import 'sg_input_cpf_page.dart';
import 'sg_input_cpfcnpj_page.dart';
import 'sg_input_currency_page.dart';
import 'sg_input_date_page.dart';
import 'sg_input_email_page.dart';
import 'sg_input_number_page.dart';
import 'sg_input_password_page.dart';
import 'sg_input_phone_page.dart';
import 'sg_input_postal_code_page.dart';
import 'sg_input_text_page.dart';
import 'sg_input_text_area_page.dart';
import 'sg_input_text_search_page.dart';
import 'sg_radio_group_page.dart';
import 'sg_rating_page.dart';
import 'sg_skeleton_page.dart';
import 'sg_slider_page.dart';
import 'sg_stepper_input_page.dart';
import 'sg_toggle_switch_page.dart';
import 'modelo_page.dart';

/// Uma pagina do showcase. `examples` = numero de regioes `// #region` do arquivo (links esperados).
typedef ShowcasePageEntry = ({String name, String file, int examples, WidgetBuilder builder});

final List<ShowcasePageEntry> kShowcasePages = <ShowcasePageEntry>[
  (name: 'SgAvatar', file: 'lib/pages/sg_avatar_page.dart', examples: 6, builder: (_) => const SgAvatarPage()),
  (name: 'SgAvatarGroup', file: 'lib/pages/sg_avatar_group_page.dart', examples: 4, builder: (_) => const SgAvatarGroupPage()),
  (name: 'SgBadge', file: 'lib/pages/sg_badge_page.dart', examples: 6, builder: (_) => const SgBadgePage()),
  (name: 'SgBadgeOverlay', file: 'lib/pages/sg_badge_overlay_page.dart', examples: 4, builder: (_) => const SgBadgeOverlayPage()),
  (name: 'SgButton', file: 'lib/pages/sg_button_page.dart', examples: 5, builder: (_) => const SgButtonPage()),
  (name: 'SgCheckboxGroup', file: 'lib/pages/sg_checkbox_group_page.dart', examples: 5, builder: (_) => const SgCheckboxGroupPage()),
  (name: 'SgInputBirthDate', file: 'lib/pages/sg_input_birth_date_page.dart', examples: 4, builder: (_) => const SgInputBirthDatePage()),
  (name: 'SgInputCNPJ', file: 'lib/pages/sg_input_cnpj_page.dart', examples: 4, builder: (_) => const SgInputCNPJPage()),
  (name: 'SgInputCPF', file: 'lib/pages/sg_input_cpf_page.dart', examples: 5, builder: (_) => const SgInputCPFPage()),
  (name: 'SgInputCPFCNPJ', file: 'lib/pages/sg_input_cpfcnpj_page.dart', examples: 3, builder: (_) => const SgInputCPFCNPJPage()),
  (name: 'SgInputCurrency', file: 'lib/pages/sg_input_currency_page.dart', examples: 5, builder: (_) => const SgInputCurrencyPage()),
  (name: 'SgInputDate', file: 'lib/pages/sg_input_date_page.dart', examples: 4, builder: (_) => const SgInputDatePage()),
  (name: 'SgInputEmail', file: 'lib/pages/sg_input_email_page.dart', examples: 5, builder: (_) => const SgInputEmailPage()),
  (name: 'SgInputNumber', file: 'lib/pages/sg_input_number_page.dart', examples: 5, builder: (_) => const SgInputNumberPage()),
  (name: 'SgInputPassword', file: 'lib/pages/sg_input_password_page.dart', examples: 5, builder: (_) => const SgInputPasswordPage()),
  (name: 'SgInputPhone', file: 'lib/pages/sg_input_phone_page.dart', examples: 3, builder: (_) => const SgInputPhonePage()),
  (name: 'SgInputPostalCode', file: 'lib/pages/sg_input_postal_code_page.dart', examples: 4, builder: (_) => const SgInputPostalCodePage()),
  (name: 'SgInputText', file: 'lib/pages/sg_input_text_page.dart', examples: 5, builder: (_) => const SgInputTextPage()),
  (name: 'SgInputTextArea', file: 'lib/pages/sg_input_text_area_page.dart', examples: 5, builder: (_) => const SgInputTextAreaPage()),
  (name: 'SgInputTextSearch', file: 'lib/pages/sg_input_text_search_page.dart', examples: 4, builder: (_) => const SgInputTextSearchPage()),
  (name: 'SgRadioGroup', file: 'lib/pages/sg_radio_group_page.dart', examples: 4, builder: (_) => const SgRadioGroupPage()),
  (name: 'SgRating', file: 'lib/pages/sg_rating_page.dart', examples: 4, builder: (_) => const SgRatingPage()),
  (name: 'SgSkeleton', file: 'lib/pages/sg_skeleton_page.dart', examples: 4, builder: (_) => const SgSkeletonPage()),
  (name: 'SgSlider', file: 'lib/pages/sg_slider_page.dart', examples: 4, builder: (_) => const SgSliderPage()),
  (name: 'SgStepperInput', file: 'lib/pages/sg_stepper_input_page.dart', examples: 5, builder: (_) => const SgStepperInputPage()),
  (name: 'SgToggleSwitch', file: 'lib/pages/sg_toggle_switch_page.dart', examples: 4, builder: (_) => const SgToggleSwitchPage()),
  (name: 'Modelo', file: 'lib/pages/modelo_page.dart', examples: 6, builder: (_) => const ModeloPage()),
];
