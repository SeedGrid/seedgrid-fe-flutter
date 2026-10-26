// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Registro das paginas do showcase (menu do app e testes automaticos).

import 'package:flutter/widgets.dart';

import 'sg_accordion_page.dart';
import 'sg_autocomplete_page.dart';
import 'sg_avatar_page.dart';
import 'sg_avatar_group_page.dart';
import 'sg_badge_page.dart';
import 'sg_badge_overlay_page.dart';
import 'sg_breadcrumb_page.dart';
import 'sg_button_page.dart';
import 'sg_calendar_page.dart';
import 'sg_card_page.dart';
import 'sg_carousel_page.dart';
import 'sg_checkbox_group_page.dart';
import 'sg_clock_page.dart';
import 'sg_clock_theme_picker_page.dart';
import 'sg_clock_theme_preview_page.dart';
import 'sg_clock_theme_provider_page.dart';
import 'sg_combobox_page.dart';
import 'sg_confirmation_dialog_page.dart';
import 'sg_datatable_page.dart';
import 'sg_dialog_page.dart';
import 'sg_discard_digit_page.dart';
import 'sg_dock_layout_page.dart';
import 'sg_dock_menu_page.dart';
import 'sg_dock_screen_page.dart';
import 'sg_dock_zone_page.dart';
import 'sg_environment_provider_page.dart';
import 'sg_expandable_panel_page.dart';
import 'sg_fade_digit_page.dart';
import 'sg_flip_digit_page.dart';
import 'sg_float_action_button_page.dart';
import 'sg_grid_page.dart';
import 'sg_group_box_page.dart';
import 'sg_input_birth_date_page.dart';
import 'sg_input_cnpj_page.dart';
import 'sg_input_cpf_page.dart';
import 'sg_input_cpfcnpj_page.dart';
import 'sg_input_currency_page.dart';
import 'sg_input_date_page.dart';
import 'sg_input_email_page.dart';
import 'sg_input_number_page.dart';
import 'sg_input_otp_page.dart';
import 'sg_input_password_page.dart';
import 'sg_input_phone_page.dart';
import 'sg_input_postal_code_page.dart';
import 'sg_input_text_page.dart';
import 'sg_input_text_area_page.dart';
import 'sg_input_text_search_page.dart';
import 'sg_linear_gauge_page.dart';
import 'sg_matrix_digit_page.dart';
import 'sg_menu_page.dart';
import 'sg_multi_select_page.dart';
import 'sg_multi_select_chips_page.dart';
import 'sg_neon_digit_page.dart';
import 'sg_order_list_page.dart';
import 'sg_page_control_demo_page.dart';
import 'sg_panel_page.dart';
import 'sg_period_selector_page.dart';
import 'sg_pick_list_page.dart';
import 'sg_popup_page.dart';
import 'sg_qr_code_page.dart';
import 'sg_radial_gauge_page.dart';
import 'sg_radio_group_page.dart';
import 'sg_rating_page.dart';
import 'sg_realtime_provider_page.dart';
import 'sg_roller3d_digit_page.dart';
import 'sg_screen_page.dart';
import 'sg_segment_digit_page.dart';
import 'sg_seven_segment_digit_page.dart';
import 'sg_skeleton_page.dart';
import 'sg_slider_page.dart';
import 'sg_split_button_page.dart';
import 'sg_stack_page.dart';
import 'sg_stepper_input_page.dart';
import 'sg_string_animator_page.dart';
import 'sg_text_editor_page.dart';
import 'sg_time_provider_page.dart';
import 'sg_toaster_page.dart';
import 'sg_toast_host_page.dart';
import 'sg_toggle_switch_page.dart';
import 'sg_tool_bar_page.dart';
import 'sg_toolbar_icon_button_page.dart';
import 'sg_tree_view_page.dart';
import 'sg_whistle_host_page.dart';
import 'sg_whistler_page.dart';
import 'sg_wizard_demo_page.dart';
import 'sg_wizard_page_page.dart';
import 'sg_year_part_selector_page.dart';
import 'modelo_page.dart';

/// Uma pagina do showcase. `examples` = numero de regioes `// #region` do arquivo (links esperados).
typedef ShowcasePageEntry = ({String name, String file, int examples, WidgetBuilder builder});

final List<ShowcasePageEntry> kShowcasePages = <ShowcasePageEntry>[
  (name: 'SgAccordion', file: 'lib/pages/sg_accordion_page.dart', examples: 5, builder: (_) => const SgAccordionPage()),
  (name: 'SgAutocomplete', file: 'lib/pages/sg_autocomplete_page.dart', examples: 6, builder: (_) => const SgAutocompletePage()),
  (name: 'SgAvatar', file: 'lib/pages/sg_avatar_page.dart', examples: 6, builder: (_) => const SgAvatarPage()),
  (name: 'SgAvatarGroup', file: 'lib/pages/sg_avatar_group_page.dart', examples: 4, builder: (_) => const SgAvatarGroupPage()),
  (name: 'SgBadge', file: 'lib/pages/sg_badge_page.dart', examples: 6, builder: (_) => const SgBadgePage()),
  (name: 'SgBadgeOverlay', file: 'lib/pages/sg_badge_overlay_page.dart', examples: 4, builder: (_) => const SgBadgeOverlayPage()),
  (name: 'SgBreadcrumb', file: 'lib/pages/sg_breadcrumb_page.dart', examples: 4, builder: (_) => const SgBreadcrumbPage()),
  (name: 'SgButton', file: 'lib/pages/sg_button_page.dart', examples: 5, builder: (_) => const SgButtonPage()),
  (name: 'SgCalendar', file: 'lib/pages/sg_calendar_page.dart', examples: 5, builder: (_) => const SgCalendarPage()),
  (name: 'SgCard', file: 'lib/pages/sg_card_page.dart', examples: 5, builder: (_) => const SgCardPage()),
  (name: 'SgCarousel', file: 'lib/pages/sg_carousel_page.dart', examples: 4, builder: (_) => const SgCarouselPage()),
  (name: 'SgCheckboxGroup', file: 'lib/pages/sg_checkbox_group_page.dart', examples: 5, builder: (_) => const SgCheckboxGroupPage()),
  (name: 'SgClock', file: 'lib/pages/sg_clock_page.dart', examples: 7, builder: (_) => const SgClockPage()),
  (name: 'SgClockThemePicker', file: 'lib/pages/sg_clock_theme_picker_page.dart', examples: 4, builder: (_) => const SgClockThemePickerPage()),
  (name: 'SgClockThemePreview', file: 'lib/pages/sg_clock_theme_preview_page.dart', examples: 4, builder: (_) => const SgClockThemePreviewPage()),
  (name: 'SgClockThemeProvider', file: 'lib/pages/sg_clock_theme_provider_page.dart', examples: 4, builder: (_) => const SgClockThemeProviderPage()),
  (name: 'SgCombobox', file: 'lib/pages/sg_combobox_page.dart', examples: 5, builder: (_) => const SgComboboxPage()),
  (name: 'SgConfirmationDialog', file: 'lib/pages/sg_confirmation_dialog_page.dart', examples: 4, builder: (_) => const SgConfirmationDialogPage()),
  (name: 'SgDatatable', file: 'lib/pages/sg_datatable_page.dart', examples: 8, builder: (_) => const SgDatatablePage()),
  (name: 'SgDialog', file: 'lib/pages/sg_dialog_page.dart', examples: 5, builder: (_) => const SgDialogPage()),
  (name: 'SgDiscardDigit', file: 'lib/pages/sg_discard_digit_page.dart', examples: 5, builder: (_) => const SgDiscardDigitPage()),
  (name: 'SgDockLayout', file: 'lib/pages/sg_dock_layout_page.dart', examples: 3, builder: (_) => const SgDockLayoutPage()),
  (name: 'SgDockMenu', file: 'lib/pages/sg_dock_menu_page.dart', examples: 4, builder: (_) => const SgDockMenuPage()),
  (name: 'SgDockScreen', file: 'lib/pages/sg_dock_screen_page.dart', examples: 3, builder: (_) => const SgDockScreenPage()),
  (name: 'SgDockZone', file: 'lib/pages/sg_dock_zone_page.dart', examples: 4, builder: (_) => const SgDockZonePage()),
  (name: 'SgEnvironmentProvider', file: 'lib/pages/sg_environment_provider_page.dart', examples: 4, builder: (_) => const SgEnvironmentProviderPage()),
  (name: 'SgExpandablePanel', file: 'lib/pages/sg_expandable_panel_page.dart', examples: 4, builder: (_) => const SgExpandablePanelPage()),
  (name: 'SgFadeDigit', file: 'lib/pages/sg_fade_digit_page.dart', examples: 3, builder: (_) => const SgFadeDigitPage()),
  (name: 'SgFlipDigit', file: 'lib/pages/sg_flip_digit_page.dart', examples: 4, builder: (_) => const SgFlipDigitPage()),
  (name: 'SgFloatActionButton', file: 'lib/pages/sg_float_action_button_page.dart', examples: 6, builder: (_) => const SgFloatActionButtonPage()),
  (name: 'SgGrid', file: 'lib/pages/sg_grid_page.dart', examples: 5, builder: (_) => const SgGridPage()),
  (name: 'SgGroupBox', file: 'lib/pages/sg_group_box_page.dart', examples: 3, builder: (_) => const SgGroupBoxPage()),
  (name: 'SgInputBirthDate', file: 'lib/pages/sg_input_birth_date_page.dart', examples: 4, builder: (_) => const SgInputBirthDatePage()),
  (name: 'SgInputCNPJ', file: 'lib/pages/sg_input_cnpj_page.dart', examples: 4, builder: (_) => const SgInputCNPJPage()),
  (name: 'SgInputCPF', file: 'lib/pages/sg_input_cpf_page.dart', examples: 5, builder: (_) => const SgInputCPFPage()),
  (name: 'SgInputCPFCNPJ', file: 'lib/pages/sg_input_cpfcnpj_page.dart', examples: 3, builder: (_) => const SgInputCPFCNPJPage()),
  (name: 'SgInputCurrency', file: 'lib/pages/sg_input_currency_page.dart', examples: 5, builder: (_) => const SgInputCurrencyPage()),
  (name: 'SgInputDate', file: 'lib/pages/sg_input_date_page.dart', examples: 4, builder: (_) => const SgInputDatePage()),
  (name: 'SgInputEmail', file: 'lib/pages/sg_input_email_page.dart', examples: 5, builder: (_) => const SgInputEmailPage()),
  (name: 'SgInputNumber', file: 'lib/pages/sg_input_number_page.dart', examples: 5, builder: (_) => const SgInputNumberPage()),
  (name: 'SgInputOTP', file: 'lib/pages/sg_input_otp_page.dart', examples: 6, builder: (_) => const SgInputOTPPage()),
  (name: 'SgInputPassword', file: 'lib/pages/sg_input_password_page.dart', examples: 5, builder: (_) => const SgInputPasswordPage()),
  (name: 'SgInputPhone', file: 'lib/pages/sg_input_phone_page.dart', examples: 3, builder: (_) => const SgInputPhonePage()),
  (name: 'SgInputPostalCode', file: 'lib/pages/sg_input_postal_code_page.dart', examples: 4, builder: (_) => const SgInputPostalCodePage()),
  (name: 'SgInputText', file: 'lib/pages/sg_input_text_page.dart', examples: 15, builder: (_) => const SgInputTextPage()),
  (name: 'SgInputTextArea', file: 'lib/pages/sg_input_text_area_page.dart', examples: 15, builder: (_) => const SgInputTextAreaPage()),
  (name: 'SgInputTextSearch', file: 'lib/pages/sg_input_text_search_page.dart', examples: 4, builder: (_) => const SgInputTextSearchPage()),
  (name: 'SgLinearGauge', file: 'lib/pages/sg_linear_gauge_page.dart', examples: 4, builder: (_) => const SgLinearGaugePage()),
  (name: 'SgMatrixDigit', file: 'lib/pages/sg_matrix_digit_page.dart', examples: 4, builder: (_) => const SgMatrixDigitPage()),
  (name: 'SgMenu', file: 'lib/pages/sg_menu_page.dart', examples: 6, builder: (_) => const SgMenuPage()),
  (name: 'SgMultiSelect', file: 'lib/pages/sg_multi_select_page.dart', examples: 5, builder: (_) => const SgMultiSelectPage()),
  (name: 'SgMultiSelectChips', file: 'lib/pages/sg_multi_select_chips_page.dart', examples: 5, builder: (_) => const SgMultiSelectChipsPage()),
  (name: 'SgNeonDigit', file: 'lib/pages/sg_neon_digit_page.dart', examples: 4, builder: (_) => const SgNeonDigitPage()),
  (name: 'SgOrderList', file: 'lib/pages/sg_order_list_page.dart', examples: 5, builder: (_) => const SgOrderListPage()),
  (name: 'SgPageControl', file: 'lib/pages/sg_page_control_demo_page.dart', examples: 4, builder: (_) => const SgPageControlDemoPage()),
  (name: 'SgPanel', file: 'lib/pages/sg_panel_page.dart', examples: 4, builder: (_) => const SgPanelPage()),
  (name: 'SgPeriodSelector', file: 'lib/pages/sg_period_selector_page.dart', examples: 5, builder: (_) => const SgPeriodSelectorPage()),
  (name: 'SgPickList', file: 'lib/pages/sg_pick_list_page.dart', examples: 5, builder: (_) => const SgPickListPage()),
  (name: 'SgPopup', file: 'lib/pages/sg_popup_page.dart', examples: 4, builder: (_) => const SgPopupPage()),
  (name: 'SgQRCode', file: 'lib/pages/sg_qr_code_page.dart', examples: 4, builder: (_) => const SgQRCodePage()),
  (name: 'SgRadialGauge', file: 'lib/pages/sg_radial_gauge_page.dart', examples: 5, builder: (_) => const SgRadialGaugePage()),
  (name: 'SgRadioGroup', file: 'lib/pages/sg_radio_group_page.dart', examples: 4, builder: (_) => const SgRadioGroupPage()),
  (name: 'SgRating', file: 'lib/pages/sg_rating_page.dart', examples: 4, builder: (_) => const SgRatingPage()),
  (name: 'SgRealtimeProvider', file: 'lib/pages/sg_realtime_provider_page.dart', examples: 4, builder: (_) => const SgRealtimeProviderPage()),
  (name: 'SgRoller3DDigit', file: 'lib/pages/sg_roller3d_digit_page.dart', examples: 4, builder: (_) => const SgRoller3DDigitPage()),
  (name: 'SgScreen', file: 'lib/pages/sg_screen_page.dart', examples: 3, builder: (_) => const SgScreenPage()),
  (name: 'SgSegmentDigit', file: 'lib/pages/sg_segment_digit_page.dart', examples: 4, builder: (_) => const SgSegmentDigitPage()),
  (name: 'SgSevenSegmentDigit', file: 'lib/pages/sg_seven_segment_digit_page.dart', examples: 4, builder: (_) => const SgSevenSegmentDigitPage()),
  (name: 'SgSkeleton', file: 'lib/pages/sg_skeleton_page.dart', examples: 4, builder: (_) => const SgSkeletonPage()),
  (name: 'SgSlider', file: 'lib/pages/sg_slider_page.dart', examples: 4, builder: (_) => const SgSliderPage()),
  (name: 'SgSplitButton', file: 'lib/pages/sg_split_button_page.dart', examples: 5, builder: (_) => const SgSplitButtonPage()),
  (name: 'SgStack', file: 'lib/pages/sg_stack_page.dart', examples: 4, builder: (_) => const SgStackPage()),
  (name: 'SgStepperInput', file: 'lib/pages/sg_stepper_input_page.dart', examples: 5, builder: (_) => const SgStepperInputPage()),
  (name: 'SgStringAnimator', file: 'lib/pages/sg_string_animator_page.dart', examples: 5, builder: (_) => const SgStringAnimatorPage()),
  (name: 'SgTextEditor', file: 'lib/pages/sg_text_editor_page.dart', examples: 5, builder: (_) => const SgTextEditorPage()),
  (name: 'SgTimeProvider', file: 'lib/pages/sg_time_provider_page.dart', examples: 4, builder: (_) => const SgTimeProviderPage()),
  (name: 'SgToaster', file: 'lib/pages/sg_toaster_page.dart', examples: 4, builder: (_) => const SgToasterPage()),
  (name: 'SgToastHost', file: 'lib/pages/sg_toast_host_page.dart', examples: 4, builder: (_) => const SgToastHostPage()),
  (name: 'SgToggleSwitch', file: 'lib/pages/sg_toggle_switch_page.dart', examples: 4, builder: (_) => const SgToggleSwitchPage()),
  (name: 'SgToolBar', file: 'lib/pages/sg_tool_bar_page.dart', examples: 4, builder: (_) => const SgToolBarPage()),
  (name: 'SgToolbarIconButton', file: 'lib/pages/sg_toolbar_icon_button_page.dart', examples: 3, builder: (_) => const SgToolbarIconButtonPage()),
  (name: 'SgTreeView', file: 'lib/pages/sg_tree_view_page.dart', examples: 5, builder: (_) => const SgTreeViewPage()),
  (name: 'SgWhistleHost', file: 'lib/pages/sg_whistle_host_page.dart', examples: 4, builder: (_) => const SgWhistleHostPage()),
  (name: 'SgWhistler', file: 'lib/pages/sg_whistler_page.dart', examples: 5, builder: (_) => const SgWhistlerPage()),
  (name: 'SgWizard', file: 'lib/pages/sg_wizard_demo_page.dart', examples: 4, builder: (_) => const SgWizardDemoPage()),
  (name: 'SgWizardPage', file: 'lib/pages/sg_wizard_page_page.dart', examples: 3, builder: (_) => const SgWizardPagePage()),
  (name: 'SgYearPartSelector', file: 'lib/pages/sg_year_part_selector_page.dart', examples: 5, builder: (_) => const SgYearPartSelectorPage()),
  (name: 'Modelo', file: 'lib/pages/modelo_page.dart', examples: 6, builder: (_) => const ModeloPage()),
];
