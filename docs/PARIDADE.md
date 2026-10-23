# Paridade React × Flutter

> Gerado por `node tools/parity_table/generate.mjs` a partir do @seedgrid/fe-components 2026.7.1. Não edite à mão.

**89 componentes**: 11 portados, 16 parciais, 62 pendentes, 0 não aplicáveis.

"Props omitidas" = props do React que não existem no Flutter de propósito (`className`, `style`, `register`, HTML; ver ADR 50). "Props genéricas" = props cujo tipo Dart do contrato ainda é genérico (função, união, tipo a portar; ver `tools/gen_props/excecoes.json`).

| Onda | Componente | Estado | Props | Omitidas | Genéricas | Onde / motivo |
|---|---|---|---|---|---|---|
| 0 | SgComponentsI18nProvider | portado | 3 | 0 | 2 | packages/seedgrid_components/lib/src/i18n/i18n.dart (SgComponentsI18nProvider, useComponentsI18n) |
| 0 | SgEnvironmentProvider | pendente | 2 | 0 | 1 |  |
| 1 | SgAvatar | portado | 14 | 0 | 2 | packages/seedgrid_components/lib/src/commons/sg_avatar.dart |
| 1 | SgAvatarGroup | portado | 9 | 0 | 1 | packages/seedgrid_components/lib/src/commons/sg_avatar.dart |
| 1 | SgBadge | portado | 24 | 2 | 4 | packages/seedgrid_components/lib/src/commons/sg_badge.dart |
| 1 | SgBadgeOverlay | portado | 5 | 2 | 0 | packages/seedgrid_components/lib/src/commons/sg_badge_overlay.dart |
| 1 | SgButton | portado | 11 | 0 | 1 | packages/seedgrid_components/lib/src/buttons/sg_button.dart |
| 1 | SgCheckboxGroup | parcial | 23 | 3 | 6 | packages/seedgrid_components/lib/src/inputs/choice/sg_checkbox_group.dart — destaque e relevo aproximados (bordas por Transform); groupBoxProps vira SgChoiceGroupBoxProps; SgChoiceBox provisorio ate o SgGroupBox (T3.1); goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgInputBirthDate | parcial | 50 | 3 | 15 | packages/seedgrid_components/lib/src/inputs/masked/sg_input_birth_date.dart — o React usa input type=date nativo; aqui campo com mascara por idioma e calendario proprio: data impossivel (31/02) mostra Data invalida (no nativo o valor vira vazio) e alwaysFloat nao tem efeito; recriar por key perde o foco (precisa de controller externo no SgInputText); pegadinha de fuso do validateBirthDate mantida |
| 1 | SgInputCNPJ | parcial | 53 | 3 | 17 | packages/seedgrid_components/lib/src/inputs/masked/sg_input_cnpj.dart — consulta de rede por cliente injetavel (SgViaCepResult no lugar do ViaCepResponse que lanca erro; SgHttpClient no CNPJ); placeholder por pais do React nunca e usado e nao foi portado; goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgInputCPF | portado | 48 | 3 | 14 | packages/seedgrid_components/lib/src/inputs/masked/sg_input_cpf.dart |
| 1 | SgInputCPFCNPJ | portado | 48 | 3 | 14 | packages/seedgrid_components/lib/src/inputs/masked/sg_input_cpfcnpj.dart |
| 1 | SgInputCurrency | parcial | 49 | 3 | 13 | packages/seedgrid_components/lib/src/inputs/number/sg_input_currency.dart — sem Intl no Dart: simbolo, posicao e separadores vem de tabela gerada do Node (pt-BR, pt-PT, en-US, es, fr, de-DE; 162 moedas), locale fora da lista cai em en-US; o React trata tecla e o Flutter recebe diferenca de texto (formatter converte); goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgInputDate | parcial | 48 | 3 | 15 | packages/seedgrid_components/lib/src/inputs/masked/sg_input_date.dart — o React usa input type=date nativo; aqui campo com mascara por idioma e calendario proprio: data impossivel (31/02) mostra Data invalida (no nativo o valor vira vazio) e alwaysFloat nao tem efeito; recriar por key perde o foco (precisa de controller externo no SgInputText); pegadinha de fuso do validateBirthDate mantida |
| 1 | SgInputEmail | parcial | 48 | 3 | 14 | packages/seedgrid_components/lib/src/inputs/text/sg_input_email.dart — inputProps/textareaProps ignorados; commonPasswordList sem efeito (igual ao React); usa SgFormController interno quando nao ha name+control; goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgInputNumber | parcial | 46 | 3 | 14 | packages/seedgrid_components/lib/src/inputs/number/sg_input_number.dart — sem Intl no Dart: simbolo, posicao e separadores vem de tabela gerada do Node (pt-BR, pt-PT, en-US, es, fr, de-DE; 162 moedas), locale fora da lista cai em en-US; o React trata tecla e o Flutter recebe diferenca de texto (formatter converte); goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgInputPassword | parcial | 60 | 3 | 14 | packages/seedgrid_components/lib/src/inputs/text/sg_input_password.dart — inputProps/textareaProps ignorados; commonPasswordList sem efeito (igual ao React); usa SgFormController interno quando nao ha name+control; goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgInputPhone | portado | 48 | 3 | 14 | packages/seedgrid_components/lib/src/inputs/masked/sg_input_phone.dart |
| 1 | SgInputPostalCode | parcial | 54 | 3 | 17 | packages/seedgrid_components/lib/src/inputs/masked/sg_input_postal_code.dart — consulta de rede por cliente injetavel (SgViaCepResult no lugar do ViaCepResponse que lanca erro; SgHttpClient no CNPJ); placeholder por pais do React nunca e usado e nao foi portado; goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgInputText | parcial | 46 | 3 | 14 | packages/seedgrid_components/lib/src/inputs/sg_input_text.dart — sem inputProps (atributos do <input> nao tem equivalente; props nomeadas cobrem), value controlado so por initialValue/control, golden com fonte de teste (sem comparacao visual com o React), nao testado em IME/dispositivo; i18n so das mensagens de validacao |
| 1 | SgInputTextArea | parcial | 43 | 3 | 13 | packages/seedgrid_components/lib/src/inputs/text/sg_input_text_area.dart — inputProps/textareaProps ignorados; commonPasswordList sem efeito (igual ao React); usa SgFormController interno quando nao ha name+control; goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgInputTextSearch | parcial | 49 | 3 | 15 | packages/seedgrid_components/lib/src/inputs/text/sg_input_text_search.dart — inputProps/textareaProps ignorados; commonPasswordList sem efeito (igual ao React); usa SgFormController interno quando nao ha name+control; goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgRadioGroup | parcial | 20 | 3 | 6 | packages/seedgrid_components/lib/src/inputs/choice/sg_radio_group.dart — destaque e relevo aproximados (bordas por Transform); groupBoxProps vira SgChoiceGroupBoxProps; SgChoiceBox provisorio ate o SgGroupBox (T3.1); goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgRating | parcial | 26 | 3 | 4 | packages/seedgrid_components/lib/src/inputs/choice/sg_rating.dart — color/emptyColor aceitam texto (#hex, rgb(), hsl(var(--token))) porque o contrato gerado fixa String; value nulo = nao controlado; teclado e extra do Flutter; goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgSkeleton | portado | 6 | 0 | 4 | packages/seedgrid_components/lib/src/commons/sg_skeleton.dart |
| 1 | SgSlider | parcial | 17 | 2 | 5 | packages/seedgrid_components/lib/src/inputs/choice/sg_slider.dart — e o Slider do Material tematizado, nao CustomPainter (o React usa o controle nativo do navegador); goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
| 1 | SgStepperInput | portado | 19 | 3 | 5 | packages/seedgrid_components/lib/src/inputs/number/sg_stepper_input.dart |
| 1 | SgToggleSwitch | parcial | 27 | 3 | 7 | packages/seedgrid_components/lib/src/inputs/choice/sg_toggle_switch.dart — enabled virou disabled (ADR 50); goldens com a fonte de teste do Flutter (sem comparacao visual de texto com o React); nao testado em IME nem em dispositivo; inputProps/className do React nao existem (ADR 50) |
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
