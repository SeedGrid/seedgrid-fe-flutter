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
import 'crud_clientes_page.dart';

/// Uma pagina do showcase. `examples` = numero de regioes `// #region` do arquivo (links esperados).
typedef ShowcasePageEntry = ({String name, String file, int examples, String description, WidgetBuilder builder});

final List<ShowcasePageEntry> kShowcasePages = <ShowcasePageEntry>[
  (name: 'SgAccordion', file: 'lib/pages/sg_accordion_page.dart', examples: 6, description: 'Lista de painéis que abrem e fecham, na vertical ou na horizontal, em modo controlado ou não.', builder: (_) => const SgAccordionPage()),
  (name: 'SgAutocomplete', file: 'lib/pages/sg_autocomplete_page.dart', examples: 7, description: 'Campo de texto com sugestões vindas de uma fonte (lista ou assíncrona), com busca com atraso, cache, grupos e valor livre.', builder: (_) => const SgAutocompletePage()),
  (name: 'SgAvatar', file: 'lib/pages/sg_avatar_page.dart', examples: 6, description: 'Avatar com imagem, iniciais, ícone ou conteúdo próprio; severidades, tamanhos, formas e estado de erro da imagem.', builder: (_) => const SgAvatarPage()),
  (name: 'SgAvatarGroup', file: 'lib/pages/sg_avatar_group_page.dart', examples: 4, description: 'Agrupa avatares sobrepostos, com limite de exibição e contador do excesso.', builder: (_) => const SgAvatarGroupPage()),
  (name: 'SgBadge', file: 'lib/pages/sg_badge_page.dart', examples: 6, description: 'Selo compacto para status, contagens e rótulos curtos, com estilos, tamanhos, ícones e remoção.', builder: (_) => const SgBadgePage()),
  (name: 'SgBadgeOverlay', file: 'lib/pages/sg_badge_overlay_page.dart', examples: 4, description: 'Posiciona um selo (SgBadge) sobre um canto ou borda de outro widget.', builder: (_) => const SgBadgeOverlayPage()),
  (name: 'SgBreadcrumb', file: 'lib/pages/sg_breadcrumb_page.dart', examples: 4, description: 'Trilha de navegação com separador, ícone de início, colapso dos itens do meio e variantes.', builder: (_) => const SgBreadcrumbPage()),
  (name: 'SgButton', file: 'lib/pages/sg_button_page.dart', examples: 5, description: 'Botão de ação com severidade, aparência, forma, loading e ícones, para ações principais e secundárias.', builder: (_) => const SgButtonPage()),
  (name: 'SgCalendar', file: 'lib/pages/sg_calendar_page.dart', examples: 5, description: 'Calendário mensal em formato de gadget, com locale, vários meses, limites, dias bloqueados e cartão configurável.', builder: (_) => const SgCalendarPage()),
  (name: 'SgCard', file: 'lib/pages/sg_card_page.dart', examples: 7, description: 'Cartão com cabeçalho, corpo e rodapé; pode ser clicável, recolhível ou arrastável.', builder: (_) => const SgCardPage()),
  (name: 'SgCarousel', file: 'lib/pages/sg_carousel_page.dart', examples: 4, description: 'Carrossel de itens com setas, indicadores, reprodução automática, vários itens visíveis e orientação vertical.', builder: (_) => const SgCarouselPage()),
  (name: 'SgCheckboxGroup', file: 'lib/pages/sg_checkbox_group_page.dart', examples: 5, description: 'Grupo de caixas de seleção múltipla com título, orientação, estilo highlight, "selecionar todos" e ligação a formulário.', builder: (_) => const SgCheckboxGroupPage()),
  (name: 'SgClock', file: 'lib/pages/sg_clock_page.dart', examples: 7, description: 'Relógio analógico ou digital, com fuso, 12/24 horas, temas embutidos e cartão recolhível.', builder: (_) => const SgClockPage()),
  (name: 'SgClockThemePicker', file: 'lib/pages/sg_clock_theme_picker_page.dart', examples: 4, description: 'Seletor de tema de relógio: botão com a miniatura atual e um painel com busca e a lista de temas.', builder: (_) => const SgClockThemePickerPage()),
  (name: 'SgClockThemePreview', file: 'lib/pages/sg_clock_theme_preview_page.dart', examples: 4, description: 'Miniatura de um tema de relógio, usada no seletor de temas e para escolher entre os temas embutidos.', builder: (_) => const SgClockThemePreviewPage()),
  (name: 'SgClockThemeProvider', file: 'lib/pages/sg_clock_theme_provider_page.dart', examples: 4, description: 'Fornece um resolvedor de temas de relógio (modo, tema de recuo e temas locais) a toda a árvore.', builder: (_) => const SgClockThemeProviderPage()),
  (name: 'SgCombobox', file: 'lib/pages/sg_combobox_page.dart', examples: 5, description: 'Seleção de um item de uma lista (local ou assíncrona), com escolha por id e busca por tecla digitada.', builder: (_) => const SgComboboxPage()),
  (name: 'SgConfirmationDialog', file: 'lib/pages/sg_confirmation_dialog_page.dart', examples: 4, description: 'Diálogo de confirmação com mensagem, ícone de severidade e botões cancelar e confirmar.', builder: (_) => const SgConfirmationDialogPage()),
  (name: 'SgDatatable', file: 'lib/pages/sg_datatable_page.dart', examples: 10, description: 'Tabela de dados com colunas configuráveis, paginação, ordenação, filtros, seleção, carga sob demanda e layout de colunas persistente.', builder: (_) => const SgDatatablePage()),
  (name: 'SgDialog', file: 'lib/pages/sg_dialog_page.dart', examples: 5, description: 'Diálogo modal com título, corpo e rodapé, foco preso, fechamento por Esc e fundo, severidade, animação e fechamento automático.', builder: (_) => const SgDialogPage()),
  (name: 'SgDiscardDigit', file: 'lib/pages/sg_discard_digit_page.dart', examples: 5, description: 'Pilha de folhas de papel: a de cima é descartada (ou uma nova sobe por baixo) quando o valor muda.', builder: (_) => const SgDiscardDigitPage()),
  (name: 'SgDockLayout', file: 'lib/pages/sg_dock_layout_page.dart', examples: 3, description: 'Contexto das toolbars encaixáveis: guarda a zona, a ordem e o recolhimento de cada toolbar e coordena a prévia de soltura entre zonas.', builder: (_) => const SgDockLayoutPage()),
  (name: 'SgDockMenu', file: 'lib/pages/sg_dock_menu_page.dart', examples: 4, description: 'Menu de ações no estilo dock: zoom por proximidade do mouse, badges, rótulos, oito posições ancoradas e arraste com posição persistida.', builder: (_) => const SgDockMenuPage()),
  (name: 'SgDockScreen', file: 'lib/pages/sg_dock_screen_page.dart', examples: 3, description: 'Tela completa com um SgDockLayout interno e a grade padrão de zonas (topo, base, esquerda, direita e centro livre).', builder: (_) => const SgDockScreenPage()),
  (name: 'SgDockZone', file: 'lib/pages/sg_dock_zone_page.dart', examples: 4, description: 'Área onde as toolbars se encaixam (top, bottom, left, right ou free). Mostra a prévia de soltura quando uma toolbar é arrastada.', builder: (_) => const SgDockZonePage()),
  (name: 'SgEnvironmentProvider', file: 'lib/pages/sg_environment_provider_page.dart', examples: 4, description: 'Ambiente com namespace, escopo e estratégia de persistência (local, API ou as duas) para os componentes SeedGrid e para o estado persistido.', builder: (_) => const SgEnvironmentProviderPage()),
  (name: 'SgExpandablePanel', file: 'lib/pages/sg_expandable_panel_page.dart', examples: 7, description: 'Painel que expande para um lado, empurrando o conteúdo (inline) ou sobre a tela (overlay).', builder: (_) => const SgExpandablePanelPage()),
  (name: 'SgFadeDigit', file: 'lib/pages/sg_fade_digit_page.dart', examples: 3, description: 'Cartão que apaga o dígito atual e acende o novo, como uma lâmpada ou display trocando de valor.', builder: (_) => const SgFadeDigitPage()),
  (name: 'SgFlipDigit', file: 'lib/pages/sg_flip_digit_page.dart', examples: 4, description: 'Cartão que vira como num relógio de aeroporto: um caractere, animado por uma carta com perspectiva 3D.', builder: (_) => const SgFlipDigitPage()),
  (name: 'SgFloatActionButton', file: 'lib/pages/sg_float_action_button_page.dart', examples: 6, description: 'Botão de ação flutuante para a tarefa de maior destaque, com hint, posição, arrastar e speed-dial de ações secundárias.', builder: (_) => const SgFloatActionButtonPage()),
  (name: 'SgGrid', file: 'lib/pages/sg_grid_page.dart', examples: 5, description: 'Grade de colunas 1fr com colunas por breakpoint, largura mínima automática, span e rowSpan.', builder: (_) => const SgGridPage()),
  (name: 'SgGroupBox', file: 'lib/pages/sg_group_box_page.dart', examples: 3, description: 'Caixa com legenda sobre a borda para agrupar campos relacionados.', builder: (_) => const SgGroupBoxPage()),
  (name: 'SgInputBirthDate', file: 'lib/pages/sg_input_birth_date_page.dart', examples: 4, description: 'Data de nascimento: SgInputDate com limites derivados de minAge/maxAge e validação de idade ao sair do campo.', builder: (_) => const SgInputBirthDatePage()),
  (name: 'SgInputCNPJ', file: 'lib/pages/sg_input_cnpj_page.dart', examples: 10, description: 'Campo de CNPJ (numérico e alfanumérico) com máscara 00.000.000/0000-00, validação dos dígitos e consulta opcional na base pública.', builder: (_) => const SgInputCNPJPage()),
  (name: 'SgInputCPF', file: 'lib/pages/sg_input_cpf_page.dart', examples: 10, description: 'Campo de CPF com máscara 000.000.000-00 e validação dos dígitos verificadores.', builder: (_) => const SgInputCPFPage()),
  (name: 'SgInputCPFCNPJ', file: 'lib/pages/sg_input_cpfcnpj_page.dart', examples: 4, description: 'Campo único que aceita CPF ou CNPJ e decide pela quantidade de caracteres.', builder: (_) => const SgInputCPFCNPJPage()),
  (name: 'SgInputCurrency', file: 'lib/pages/sg_input_currency_page.dart', examples: 5, description: 'Campo de moeda com símbolo, posição e separadores do idioma (Intl), casas da moeda, limites e ligação a formulário.', builder: (_) => const SgInputCurrencyPage()),
  (name: 'SgInputDate', file: 'lib/pages/sg_input_date_page.dart', examples: 4, description: 'Campo de data com máscara do idioma e calendário próprio. O valor é a data ISO yyyy-MM-dd.', builder: (_) => const SgInputDatePage()),
  (name: 'SgInputEmail', file: 'lib/pages/sg_input_email_page.dart', examples: 11, description: 'Campo de e-mail com validação de formato, bloqueio de e-mails descartáveis e ligação a formulário.', builder: (_) => const SgInputEmailPage()),
  (name: 'SgInputNumber', file: 'lib/pages/sg_input_number_page.dart', examples: 5, description: 'Campo numérico com formatação por idioma, casas decimais, sinal, limites e ligação a formulário (SgForm).', builder: (_) => const SgInputNumberPage()),
  (name: 'SgInputOTP', file: 'lib/pages/sg_input_otp_page.dart', examples: 6, description: 'Campo de código de uso único com vários campos: máscara, colar o código inteiro, ' 'conclusão, validação, controller e ligação a formulário.', builder: (_) => const SgInputOTPPage()),
  (name: 'SgInputPassword', file: 'lib/pages/sg_input_password_page.dart', examples: 5, description: 'Campo de senha com política configurável, barra de força, lista de senhas comuns, mostrar/ocultar e gerador de senha forte.', builder: (_) => const SgInputPasswordPage()),
  (name: 'SgInputPhone', file: 'lib/pages/sg_input_phone_page.dart', examples: 9, description: 'Telefone brasileiro (10 ou 11 dígitos) com máscara (00) 00000-0000.', builder: (_) => const SgInputPhonePage()),
  (name: 'SgInputPostalCode', file: 'lib/pages/sg_input_postal_code_page.dart', examples: 10, description: 'Código postal por país (BR, PT, US, ES, UY, AR, PY) com máscara e consulta opcional ao ViaCEP.', builder: (_) => const SgInputPostalCodePage()),
  (name: 'SgInputText', file: 'lib/pages/sg_input_text_page.dart', examples: 15, description: 'Campo de texto com rótulo, afixos, validação e ligação a formulário (SgForm).', builder: (_) => const SgInputTextPage()),
  (name: 'SgInputTextArea', file: 'lib/pages/sg_input_text_area_page.dart', examples: 15, description: 'Área de texto com rótulo, limites de caracteres, palavras e linhas, contador e ligação a formulário.', builder: (_) => const SgInputTextAreaPage()),
  (name: 'SgInputTextSearch', file: 'lib/pages/sg_input_text_search_page.dart', examples: 4, description: 'Campo de busca com debounce, mínimo de caracteres e busca distinta, baseado no SgInputText.', builder: (_) => const SgInputTextSearchPage()),
  (name: 'SgLinearGauge', file: 'lib/pages/sg_linear_gauge_page.dart', examples: 4, description: 'Medidor linear horizontal ou vertical com barra, faixas, ponteiros extras e arraste.', builder: (_) => const SgLinearGaugePage()),
  (name: 'SgMatrixDigit', file: 'lib/pages/sg_matrix_digit_page.dart', examples: 4, description: 'Texto desenhado em matriz de pontos 5 x 7 com brilho, cores e medidas configuráveis.', builder: (_) => const SgMatrixDigitPage()),
  (name: 'SgMenu', file: 'lib/pages/sg_menu_page.dart', examples: 7, description: 'Menu de navegação em árvore com variantes painel, tiered e mega, recolher, busca, usuário, gaveta e teclado.', builder: (_) => const SgMenuPage()),
  (name: 'SgMultiSelect', file: 'lib/pages/sg_multi_select_page.dart', examples: 5, description: 'Campo de seleção múltipla: o resumo dos itens marcados aparece no campo e a lista (com busca opcional) abre ancorada ou, em tela estreita, como bottom sheet.', builder: (_) => const SgMultiSelectPage()),
  (name: 'SgMultiSelectChips', file: 'lib/pages/sg_multi_select_chips_page.dart', examples: 5, description: 'Seleção múltipla com os valores marcados como chips removíveis dentro do campo; a lista abre ancorada ou, em tela estreita, como bottom sheet.', builder: (_) => const SgMultiSelectChipsPage()),
  (name: 'SgNeonDigit', file: 'lib/pages/sg_neon_digit_page.dart', examples: 4, description: 'Texto com brilho neon que apaga e acende ao trocar o valor, com cores, intensidade e fonte configuráveis.', builder: (_) => const SgNeonDigitPage()),
  (name: 'SgOrderList', file: 'lib/pages/sg_order_list_page.dart', examples: 5, description: 'Lista ordenável para reordenar itens manualmente, com seleção, botões de mover, teclado e arrastar.', builder: (_) => const SgOrderListPage()),
  (name: 'SgPageControl', file: 'lib/pages/sg_page_control_demo_page.dart', examples: 4, description: 'Abas com painéis: estilo sublinhado ou pílulas, controlado ou não, com navegação por teclado e modo seleção no celular.', builder: (_) => const SgPageControlDemoPage()),
  (name: 'SgPanel', file: 'lib/pages/sg_panel_page.dart', examples: 4, description: 'Painel com borda, docking por align, organização do conteúdo e rolagem.', builder: (_) => const SgPanelPage()),
  (name: 'SgPeriodSelector', file: 'lib/pages/sg_period_selector_page.dart', examples: 5, description: 'Seletor de períodos prontos (hoje, esta semana, mês passado...) ou de um intervalo personalizado; entrega as datas já resolvidas.', builder: (_) => const SgPeriodSelectorPage()),
  (name: 'SgPickList', file: 'lib/pages/sg_pick_list_page.dart', examples: 5, description: 'Lista dupla para mover itens entre origem e destino, com filtros, seleção, botões de mover e ordenar, e arrastar.', builder: (_) => const SgPickListPage()),
  (name: 'SgPopup', file: 'lib/pages/sg_popup_page.dart', examples: 4, description: 'Painel flutuante ancorado em um widget, com título, conteúdo e ações; posiciona sozinho dentro da tela.', builder: (_) => const SgPopupPage()),
  (name: 'SgQRCode', file: 'lib/pages/sg_qr_code_page.dart', examples: 4, description: 'Gera QR Code a partir de um texto, com cores, margem, nível de correção de erro e logo central.', builder: (_) => const SgQRCodePage()),
  (name: 'SgRadialGauge', file: 'lib/pages/sg_radial_gauge_page.dart', examples: 5, description: 'Medidor circular com agulha, marcadores, faixas, anotações e arraste, para velocímetros, mostradores e progresso.', builder: (_) => const SgRadialGaugePage()),
  (name: 'SgRadioGroup', file: 'lib/pages/sg_radio_group_page.dart', examples: 4, description: 'Grupo de escolha única com título, orientação, estilo highlight, navegação por setas e ligação a formulário.', builder: (_) => const SgRadioGroupPage()),
  (name: 'SgRating', file: 'lib/pages/sg_rating_page.dart', examples: 4, description: 'Avaliação por estrelas com meia estrela, cancelar, tooltip, cores, ícones próprios e ligação a formulário.', builder: (_) => const SgRatingPage()),
  (name: 'SgRealtimeProvider', file: 'lib/pages/sg_realtime_provider_page.dart', examples: 4, description: 'Avisos em tempo real para o usuário logado pelo SeedGrid Pulse: pede o token ao backend, conecta, reconecta sozinho e informa o estado para a tela decidir entre aviso e polling.', builder: (_) => const SgRealtimeProviderPage()),
  (name: 'SgRoller3DDigit', file: 'lib/pages/sg_roller3d_digit_page.dart', examples: 4, description: 'Tambor vertical que desliza entre valores (dígitos, números com zero à esquerda, letras ou textos quaisquer).', builder: (_) => const SgRoller3DDigitPage()),
  (name: 'SgScreen', file: 'lib/pages/sg_screen_page.dart', examples: 3, description: 'Área raiz de uma tela: ocupa a janela por padrão e organiza o conteúdo por docking.', builder: (_) => const SgScreenPage()),
  (name: 'SgSegmentDigit', file: 'lib/pages/sg_segment_digit_page.dart', examples: 4, description: 'Dígito desenhado com retângulos (estilo calculadora), com tamanho e cor configuráveis.', builder: (_) => const SgSegmentDigitPage()),
  (name: 'SgSevenSegmentDigit', file: 'lib/pages/sg_seven_segment_digit_page.dart', examples: 4, description: 'Display de sete segmentos estilo LED, com paletas, inclinação, brilho e transição entre valores.', builder: (_) => const SgSevenSegmentDigitPage()),
  (name: 'SgSkeleton', file: 'lib/pages/sg_skeleton_page.dart', examples: 4, description: 'Marcador de carregamento com formas, dimensões flexíveis e animações wave, pulse ou nenhuma.', builder: (_) => const SgSkeletonPage()),
  (name: 'SgSlider', file: 'lib/pages/sg_slider_page.dart', examples: 4, description: 'Controle deslizante numérico com faixa, passo, largura e ligação a formulário.', builder: (_) => const SgSliderPage()),
  (name: 'SgSplitButton', file: 'lib/pages/sg_split_button_page.dart', examples: 5, description: 'Botão de ação com um caminho principal e um menu acoplado de variações da mesma tarefa.', builder: (_) => const SgSplitButtonPage()),
  (name: 'SgStack', file: 'lib/pages/sg_stack_page.dart', examples: 4, description: 'Pilha flex em linha ou coluna, com gap, justify, align, wrap e grow.', builder: (_) => const SgStackPage()),
  (name: 'SgStepperInput', file: 'lib/pages/sg_stepper_input_page.dart', examples: 5, description: 'Campo numérico com botões de aumentar e diminuir, passo configurável e limites.', builder: (_) => const SgStepperInputPage()),
  (name: 'SgStringAnimator', file: 'lib/pages/sg_string_animator_page.dart', examples: 5, description: 'Anima caractere a caractere de uma string para outra, com seis estilos de dígito (roller3d, flip, neon, fade, discard e matrix).', builder: (_) => const SgStringAnimatorPage()),
  (name: 'SgTextEditor', file: 'lib/pages/sg_text_editor_page.dart', examples: 5, description: 'Editor de texto rico (negrito, listas, cores, alinhamento, link e imagem) que entrega e recebe HTML.', builder: (_) => const SgTextEditorPage()),
  (name: 'SgTimeProvider', file: 'lib/pages/sg_time_provider_page.dart', examples: 4, description: 'Fornece a hora do servidor a toda a árvore e avisa a cada segundo; useSgTime lê esse contexto.', builder: (_) => const SgTimeProviderPage()),
  (name: 'SgToaster', file: 'lib/pages/sg_toaster_page.dart', examples: 4, description: 'Renderiza os toasts da API imperativa (toast) em um canto da tela, com cores por tipo, ação, botão de fechar e tempo de vida. Cede a vez quando existe um SgToastHost.', builder: (_) => const SgToasterPage()),
  (name: 'SgToastHost', file: 'lib/pages/sg_toast_host_page.dart', examples: 4, description: 'Marca onde os toasts aparecem. Aceita as mesmas props do SgToaster; com host presente, o SgToaster solto cede a vez.', builder: (_) => const SgToastHostPage()),
  (name: 'SgToggleSwitch', file: 'lib/pages/sg_toggle_switch_page.dart', examples: 7, description: 'Chave liga/desliga com rótulo, descrição, ícones, validação e ligação a formulário. SgSwitch é um alias.', builder: (_) => const SgToggleSwitchPage()),
  (name: 'SgToolBar', file: 'lib/pages/sg_tool_bar_page.dart', examples: 4, description: 'Barra de ferramentas com título, recolher, orientação, botões por linha, arraste livre ou no dock e overflow em menu.', builder: (_) => const SgToolBarPage()),
  (name: 'SgToolbarIconButton', file: 'lib/pages/sg_toolbar_icon_button_page.dart', examples: 3, description: 'Botão de ícone para barras de ferramentas, com rótulo, dica, severidade, estado de carregamento e orientação herdada do SgToolBar.', builder: (_) => const SgToolbarIconButtonPage()),
  (name: 'SgTreeView', file: 'lib/pages/sg_tree_view_page.dart', examples: 9, description: 'Árvore com expansão, seleção (checkbox, modo confirmar), busca, colunas extras (trilhas) e lista virtualizada para muitos nós.', builder: (_) => const SgTreeViewPage()),
  (name: 'SgWhistleHost', file: 'lib/pages/sg_whistle_host_page.dart', examples: 4, description: 'Marca onde os whistles aparecem. Aceita as mesmas props do SgWhistler; com host presente, o SgWhistler solto cede a vez.', builder: (_) => const SgWhistleHostPage()),
  (name: 'SgWhistler', file: 'lib/pages/sg_whistler_page.dart', examples: 5, description: 'Pilha de avisos persistentes ou semi-persistentes, com cores por severidade, ação opcional e máximo visível. Fica no fluxo do layout; cede a vez a um SgWhistleHost.', builder: (_) => const SgWhistlerPage()),
  (name: 'SgWizard', file: 'lib/pages/sg_wizard_demo_page.dart', examples: 4, description: 'Assistente em etapas com stepper numerado ou de ícones, navegação por etapas, guardas assíncronas e validação por etapa no formulário.', builder: (_) => const SgWizardDemoPage()),
  (name: 'SgWizardPage', file: 'lib/pages/sg_wizard_page_page.dart', examples: 3, description: 'Uma etapa do SgWizard: título e ícone do stepper e o conteúdo da etapa.', builder: (_) => const SgWizardPagePage()),
  (name: 'SgYearPartSelector', file: 'lib/pages/sg_year_part_selector_page.dart', examples: 5, description: 'Seletor de recorte de ano: o usuário escolhe ano, recorte (semestre, trimestre ou bimestre) e fatia, e recebe o intervalo de datas resolvido.', builder: (_) => const SgYearPartSelectorPage()),
  (name: 'CrudClientes', file: 'lib/pages/crud_clientes_page.dart', examples: 3, description: 'Exemplo de CRUD completo só com componentes SeedGrid: lista com busca e tabela, tela de novo/editar com formulário, exclusão com confirmação e dados lidos de um JSON local.', builder: (_) => const CrudClientesPage()),
];
