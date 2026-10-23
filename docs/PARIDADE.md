# Paridade React × Flutter

> Gerado por `node tools/parity_table/generate.mjs` a partir do @seedgrid/fe-components 2026.7.1. Não edite à mão.

**89 componentes**: 2 portados, 1 parciais, 86 pendentes, 0 não aplicáveis.

"Props omitidas" = props do React que não existem no Flutter de propósito (`className`, `style`, `register`, HTML; ver ADR 50). "Props genéricas" = props cujo tipo Dart do contrato ainda é genérico (função, união, tipo a portar; ver `tools/gen_props/excecoes.json`).

| Onda | Componente | Estado | Props | Omitidas | Genéricas | Onde / motivo |
|---|---|---|---|---|---|---|
| 0 | SgComponentsI18nProvider | portado | 3 | 0 | 2 | packages/seedgrid_components/lib/src/i18n/i18n.dart (SgComponentsI18nProvider, useComponentsI18n) |
| 0 | SgEnvironmentProvider | pendente | 2 | 0 | 1 |  |
| 1 | SgAvatar | pendente | 14 | 0 | 2 |  |
| 1 | SgAvatarGroup | pendente | 9 | 0 | 1 |  |
| 1 | SgBadge | pendente | 24 | 2 | 4 |  |
| 1 | SgBadgeOverlay | pendente | 5 | 2 | 0 |  |
| 1 | SgButton | portado | 11 | 0 | 1 | packages/seedgrid_components/lib/src/buttons/sg_button.dart |
| 1 | SgCheckboxGroup | pendente | 23 | 3 | 6 |  |
| 1 | SgInputBirthDate | pendente | 50 | 3 | 15 |  |
| 1 | SgInputCNPJ | pendente | 53 | 3 | 17 |  |
| 1 | SgInputCPF | pendente | 48 | 3 | 14 |  |
| 1 | SgInputCPFCNPJ | pendente | 48 | 3 | 14 |  |
| 1 | SgInputCurrency | pendente | 49 | 3 | 13 |  |
| 1 | SgInputDate | pendente | 48 | 3 | 15 |  |
| 1 | SgInputEmail | pendente | 48 | 3 | 14 |  |
| 1 | SgInputNumber | pendente | 46 | 3 | 14 |  |
| 1 | SgInputPassword | pendente | 60 | 3 | 14 |  |
| 1 | SgInputPhone | pendente | 48 | 3 | 14 |  |
| 1 | SgInputPostalCode | pendente | 54 | 3 | 17 |  |
| 1 | SgInputText | parcial | 46 | 3 | 14 | packages/seedgrid_components/lib/src/inputs/sg_input_text.dart — sem inputProps (atributos do <input> nao tem equivalente; props nomeadas cobrem), value controlado so por initialValue/control, golden com fonte de teste (sem comparacao visual com o React), nao testado em IME/dispositivo; i18n so das mensagens de validacao |
| 1 | SgInputTextArea | pendente | 43 | 3 | 13 |  |
| 1 | SgInputTextSearch | pendente | 49 | 3 | 15 |  |
| 1 | SgRadioGroup | pendente | 20 | 3 | 6 |  |
| 1 | SgRating | pendente | 26 | 3 | 4 |  |
| 1 | SgSkeleton | pendente | 6 | 0 | 4 |  |
| 1 | SgSlider | pendente | 17 | 2 | 5 |  |
| 1 | SgStepperInput | pendente | 19 | 3 | 5 |  |
| 1 | SgToggleSwitch | pendente | 27 | 3 | 7 |  |
| 2 | SgAccordion | pendente | 17 | 0 | 7 |  |
| 2 | SgBreadcrumb | pendente | 15 | 2 | 3 |  |
| 2 | SgCard | pendente | 30 | 0 | 4 |  |
| 2 | SgCarousel | pendente | 18 | 2 | 5 |  |
| 2 | SgConfirmationDialog | pendente | 39 | 2 | 9 |  |
| 2 | SgDialog | pendente | 33 | 2 | 6 |  |
| 2 | SgDockLayout | pendente | 5 | 2 | 1 |  |
| 2 | SgDockScreen | pendente | 9 | 0 | 4 |  |
| 2 | SgDockZone | pendente | 4 | 2 | 0 |  |
| 2 | SgExpandablePanel | pendente | 30 | 2 | 4 |  |
| 2 | SgGrid | pendente | 9 | 0 | 5 |  |
| 2 | SgGroupBox | pendente | 6 | 2 | 2 |  |
| 2 | SgPageControl | pendente | 21 | 2 | 3 |  |
| 2 | SgPageControlPage | pendente | 11 | 2 | 0 |  |
| 2 | SgPanel | pendente | 20 | 0 | 7 |  |
| 2 | SgPopup | pendente | 21 | 2 | 6 |  |
| 2 | SgRealtimeProvider | pendente | 8 | 0 | 4 |  |
| 2 | SgScreen | pendente | 5 | 0 | 3 |  |
| 2 | SgStack | pendente | 7 | 0 | 1 |  |
| 2 | SgToaster | pendente | 8 | 0 | 1 |  |
| 2 | SgToastHost | pendente | 8 | 0 | 1 |  |
| 2 | SgWhistleHost | pendente | 6 | 0 | 1 |  |
| 2 | SgWhistler | pendente | 6 | 0 | 1 |  |
| 2 | SgWizard | pendente | 13 | 2 | 6 |  |
| 2 | SgWizardPage | pendente | 5 | 2 | 0 |  |
| 3 | SgAutocomplete | pendente | 72 | 3 | 26 |  |
| 3 | SgCalendar | pendente | 18 | 0 | 11 |  |
| 3 | SgCombobox | pendente | 56 | 3 | 21 |  |
| 3 | SgInputOTP | pendente | 30 | 2 | 12 |  |
| 3 | SgMultiSelect | pendente | 46 | 3 | 13 |  |
| 3 | SgMultiSelectChips | pendente | 25 | 3 | 9 |  |
| 3 | SgOrderList | pendente | 25 | 3 | 9 |  |
| 3 | SgPeriodSelector | pendente | 20 | 1 | 6 |  |
| 3 | SgPickList | pendente | 36 | 3 | 12 |  |
| 3 | SgTreeView | pendente | 31 | 2 | 13 |  |
| 3 | SgYearPartSelector | pendente | 11 | 1 | 3 |  |
| 4 | SgClock | pendente | 16 | 2 | 3 |  |
| 4 | SgClockThemePicker | pendente | 10 | 1 | 2 |  |
| 4 | SgClockThemePreview | pendente | 3 | 1 | 1 |  |
| 4 | SgClockThemeProvider | pendente | 2 | 0 | 1 |  |
| 4 | SgDiscardDigit | pendente | 13 | 2 | 1 |  |
| 4 | SgFadeDigit | pendente | 6 | 1 | 0 |  |
| 4 | SgFlipDigit | pendente | 5 | 1 | 0 |  |
| 4 | SgLinearGauge | pendente | 32 | 2 | 5 |  |
| 4 | SgMatrixDigit | pendente | 12 | 2 | 0 |  |
| 4 | SgNeonDigit | pendente | 16 | 2 | 1 |  |
| 4 | SgQRCode | pendente | 16 | 0 | 1 |  |
| 4 | SgRadialGauge | pendente | 37 | 2 | 6 |  |
| 4 | SgRoller3DDigit | pendente | 5 | 1 | 1 |  |
| 4 | SgSegmentDigit | pendente | 5 | 2 | 0 |  |
| 4 | SgSevenSegmentDigit | pendente | 15 | 2 | 0 |  |
| 4 | SgStringAnimator | pendente | 12 | 1 | 1 |  |
| 4 | SgTimeProvider | pendente | 2 | 0 | 0 |  |
| 5 | SgDatatable | pendente | 41 | 3 | 14 |  |
| 5 | SgDockMenu | pendente | 18 | 2 | 2 |  |
| 5 | SgFloatActionButton | pendente | 32 | 2 | 3 |  |
| 5 | SgMenu | pendente | 49 | 2 | 19 |  |
| 5 | SgSplitButton | pendente | 14 | 2 | 3 |  |
| 5 | SgToolBar | pendente | 18 | 2 | 3 |  |
| 5 | SgToolbarIconButton | pendente | 11 | 2 | 1 |  |
| 6 | SgTextEditor | pendente | 22 | 3 | 7 |  |
