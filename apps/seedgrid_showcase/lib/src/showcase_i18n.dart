// Textos fixos do showcase (cabecalho, menu, pagina inicial, tema, playground, props) em pt-BR, pt-PT, en-US, es e fr (os mesmos idiomas dos componentes).
// O idioma escolhido tambem vai para o SgComponentsI18nProvider, entao os textos internos dos
// componentes acompanham. Padrao pt-BR; a escolha fica so na sessao.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart'
    show SgComponentsI18nProvider;

import 'showcase_texts.g.dart';

const List<String> kShowcaseLocales = ['pt-BR', 'pt-PT', 'en-US', 'es', 'fr'];

/// Bandeira de cada idioma do seletor.
const Map<String, String> kShowcaseFlags = {
  'pt-BR': '🇧🇷',
  'pt-PT': '🇵🇹',
  'en-US': '🇺🇸',
  'es': '🇪🇸',
  'fr': '🇫🇷',
};

const Map<String, Map<String, String>> kShowcaseMessages = {
  'pt-BR': {
    'home': 'Início',
    'search': 'Buscar componente',
    'noResults': 'Nenhum componente encontrado.',
    'toggleTheme': 'Claro / escuro',
    'language': 'Idioma',
    'theme': 'Tema',
    'themeSystem': 'Sistema de Tema',
    'creditsLicenses': 'Créditos / Licenças',
    'expandGroups': 'Expandir todos os grupos',
    'collapseGroups': 'Recolher todos os grupos',
    'themeTitle': 'SeedThemeProvider',
    'themeSubtitle':
        'Sistema de temas baseado em uma cor semente que gera paletas harmoniosas automaticamente.',
    'themePalette': 'Paleta gerada',
    'paletteSeed': 'Semente (primary)',
    'paletteSecondary': 'Secondary',
    'paletteTertiary': 'Tertiary',
    'paletteSurface': 'Superfície',
    'themeNote':
        'Ao trocar a cor semente, o raio ou o modo claro/escuro, todos os componentes desta página acompanham. A escolha vale só para esta sessão.',
    'creditsTitle': 'Créditos e Bibliotecas de Terceiros',
    'creditsSubtitle':
        'Lista das bibliotecas open-source usadas nos componentes SeedGrid para Flutter, com a licença e o link de cada uma.',
    'creditsUsedIn': 'Usada em',
    'creditsLicense': 'Licença',
    'creditsAllLicenses': 'Ver todas as licenças do Flutter',
    'creditsCompliance':
        'Todas as bibliotecas listadas acima são distribuídas sob licenças compatíveis com uso open-source e comercial. Os créditos acima são fornecidos conforme exigido por cada licença.',
    'radius': 'Raio',
    'example': 'Exemplo',
    'playground': 'Playground',
    'propsReference': 'Referência de Props',
    'propsTitle': 'Referência de Props',
    'colProp': 'Prop',
    'colType': 'Tipo',
    'colDefault': 'Padrão',
    'colDescription': 'Descrição',
    'default': '(padrão)',
    'notEditable': 'Não editáveis aqui',
    'homeTitle': 'SeedGrid para Flutter',
    'homeIntro':
        'Porte dos componentes SeedGrid do React: mesmos nomes de widget, de props e de valores, '
        'para quem já conhece os componentes React usar estes com facilidade. '
        'Escolha um componente no menu; cada página tem exemplos com o código igual ao renderizado, '
        'um playground de props e a referência de props.',
    'status.parcial': 'parcial',
    'status.pendente': 'pendente',
    'cat.action': 'Ação',
    'cat.input': 'Entrada de dados',
    'cat.data': 'Dados',
    'cat.layout': 'Layout',
    'cat.navigation': 'Navegação',
    'cat.feedback': 'Feedback e exibição',
    'cat.gadget': 'Gadgets',
    'cat.provider': 'Providers',
    'cat.outros': 'Outros',
    'color.#EA580C': 'Laranja',
    'color.#16803D': 'Verde SeedGrid',
    'color.#0EA5E9': 'Azul',
    'color.#7C3AED': 'Roxo',
    'color.#EC4899': 'Rosa',
    'color.#F97316': 'Laranja',
    'color.#EF4444': 'Vermelho',
    'color.#F59E0B': 'Amarelo',
    'color.#10B981': 'Verde',
    'customColor': 'Cor personalizada (#RRGGBB)',
    'editorTitle': 'Editor de Tema',
    'editorMode': 'Modo',
    'editorToDark': 'Mudar para escuro',
    'editorToLight': 'Mudar para claro',
    'editorCustomColor': 'Cor personalizada',
    'editorInvalidHex': 'Cor hexadecimal inválida',
    'editorPresets': 'Cores predefinidas',
    'editorTokenPreview': 'Prévia de tokens',
    'editorPalette': 'Paleta de cores',
    'editorSemantic': 'Tokens semânticos',
    'editorComponentTokens': 'Tokens de componentes',
    'editorComponents': 'Componentes',
    'editorCancel': 'Cancelar',
    'editorApply': 'Aplicar',
    'editorCustom': 'Personalizada',
    'editorPickColor': 'Escolher cor',
    'editorHue': 'Matiz',
    'editorSaturation': 'Saturação',
    'editorBrightness': 'Brilho',
  },
  'en-US': {
    'home': 'Home',
    'search': 'Search component',
    'noResults': 'No components found.',
    'toggleTheme': 'Light / dark',
    'language': 'Language',
    'theme': 'Theme',
    'themeSystem': 'Theme System',
    'creditsLicenses': 'Credits / Licenses',
    'expandGroups': 'Expand all groups',
    'collapseGroups': 'Collapse all groups',
    'themeTitle': 'SeedThemeProvider',
    'themeSubtitle':
        'Theme system based on a single seed color that automatically generates harmonic palettes.',
    'themePalette': 'Generated palette',
    'paletteSeed': 'Seed (primary)',
    'paletteSecondary': 'Secondary',
    'paletteTertiary': 'Tertiary',
    'paletteSurface': 'Surface',
    'themeNote':
        'When you change the seed color, the radius or light/dark mode, every component on this page follows. The choice lasts for this session only.',
    'creditsTitle': 'Credits and Third-Party Libraries',
    'creditsSubtitle':
        'List of the open-source libraries used by the SeedGrid components for Flutter, with each license and link.',
    'creditsUsedIn': 'Used in',
    'creditsLicense': 'License',
    'creditsAllLicenses': 'See all Flutter licenses',
    'creditsCompliance':
        'All libraries listed above are distributed under licenses compatible with open-source and commercial use. Credits are provided as required by each license.',
    'radius': 'Radius',
    'example': 'Example',
    'playground': 'Playground',
    'propsReference': 'Props Reference',
    'propsTitle': 'Props Reference',
    'colProp': 'Prop',
    'colType': 'Type',
    'colDefault': 'Default',
    'colDescription': 'Description',
    'default': '(default)',
    'notEditable': 'Not editable here',
    'homeTitle': 'SeedGrid for Flutter',
    'homeIntro':
        'Port of the SeedGrid React components: same widget, prop and value names, '
        'so anyone who knows the React components can use these with ease. '
        'Pick a component in the menu; each page has examples whose code matches what is rendered, '
        'a props playground and the props reference.',
    'status.parcial': 'partial',
    'status.pendente': 'pending',
    'cat.action': 'Action',
    'cat.input': 'Data entry',
    'cat.data': 'Data',
    'cat.layout': 'Layout',
    'cat.navigation': 'Navigation',
    'cat.feedback': 'Feedback and display',
    'cat.gadget': 'Gadgets',
    'cat.provider': 'Providers',
    'cat.outros': 'Other',
    'color.#EA580C': 'Orange',
    'color.#16803D': 'SeedGrid Green',
    'color.#0EA5E9': 'Blue',
    'color.#7C3AED': 'Purple',
    'color.#EC4899': 'Pink',
    'color.#F97316': 'Orange',
    'color.#EF4444': 'Red',
    'color.#F59E0B': 'Yellow',
    'color.#10B981': 'Green',
    'customColor': 'Custom color (#RRGGBB)',
    'editorTitle': 'Theme Editor',
    'editorMode': 'Mode',
    'editorToDark': 'Switch to dark',
    'editorToLight': 'Switch to light',
    'editorCustomColor': 'Custom color',
    'editorInvalidHex': 'Invalid hex color',
    'editorPresets': 'Preset colors',
    'editorTokenPreview': 'Token preview',
    'editorPalette': 'Color palette',
    'editorSemantic': 'Semantic tokens',
    'editorComponentTokens': 'Component tokens',
    'editorComponents': 'Components',
    'editorCancel': 'Cancel',
    'editorApply': 'Apply',
    'editorCustom': 'Custom',
    'editorPickColor': 'Pick a color',
    'editorHue': 'Hue',
    'editorSaturation': 'Saturation',
    'editorBrightness': 'Brightness',
  },
  'pt-PT': {
    'home': 'Início',
    'search': 'Procurar componente',
    'noResults': 'Nenhum componente encontrado.',
    'toggleTheme': 'Claro / escuro',
    'language': 'Idioma',
    'theme': 'Tema',
    'themeSystem': 'Sistema de Tema',
    'creditsLicenses': 'Créditos / Licenças',
    'expandGroups': 'Expandir todos os grupos',
    'collapseGroups': 'Recolher todos os grupos',
    'themeTitle': 'SeedThemeProvider',
    'themeSubtitle':
        'Sistema de temas baseado numa cor semente que gera paletas harmoniosas automaticamente.',
    'themePalette': 'Paleta gerada',
    'paletteSeed': 'Semente (primary)',
    'paletteSecondary': 'Secondary',
    'paletteTertiary': 'Tertiary',
    'paletteSurface': 'Superfície',
    'themeNote':
        'Ao mudar a cor semente, o raio ou o modo claro/escuro, todos os componentes desta página acompanham. A escolha vale só para esta sessão.',
    'creditsTitle': 'Créditos e Bibliotecas de Terceiros',
    'creditsSubtitle':
        'Lista das bibliotecas open-source usadas nos componentes SeedGrid para Flutter, com a licença e a ligação de cada uma.',
    'creditsUsedIn': 'Usada em',
    'creditsLicense': 'Licença',
    'creditsAllLicenses': 'Ver todas as licenças do Flutter',
    'creditsCompliance':
        'Todas as bibliotecas acima são distribuídas sob licenças compatíveis com uso open-source e comercial. Estes créditos são apresentados conforme exigido por cada licença.',
    'radius': 'Raio',
    'example': 'Exemplo',
    'playground': 'Playground',
    'propsReference': 'Referência de Props',
    'propsTitle': 'Referência de Props',
    'colProp': 'Prop',
    'colType': 'Tipo',
    'colDefault': 'Predefinição',
    'colDescription': 'Descrição',
    'default': '(predefinição)',
    'notEditable': 'Não editáveis aqui',
    'homeTitle': 'SeedGrid para Flutter',
    'homeIntro':
        'Porte dos componentes SeedGrid do React: mesmos nomes de widget, de props e de valores, '
        'para quem já conhece os componentes React os usar com facilidade. '
        'Escolha um componente no menu; cada página tem exemplos com o código igual ao renderizado, '
        'um playground de props e a referência de props.',
    'status.parcial': 'parcial',
    'status.pendente': 'pendente',
    'cat.action': 'Ação',
    'cat.input': 'Introdução de dados',
    'cat.data': 'Dados',
    'cat.layout': 'Layout',
    'cat.navigation': 'Navegação',
    'cat.feedback': 'Feedback e apresentação',
    'cat.gadget': 'Gadgets',
    'cat.provider': 'Providers',
    'cat.outros': 'Outros',
    'color.#EA580C': 'Laranja',
    'color.#16803D': 'Verde SeedGrid',
    'color.#0EA5E9': 'Azul',
    'color.#7C3AED': 'Roxo',
    'color.#EC4899': 'Rosa',
    'color.#F97316': 'Laranja',
    'color.#EF4444': 'Vermelho',
    'color.#F59E0B': 'Amarelo',
    'color.#10B981': 'Verde',
    'customColor': 'Cor personalizada (#RRGGBB)',
    'editorTitle': 'Editor de Tema',
    'editorMode': 'Modo',
    'editorToDark': 'Mudar para escuro',
    'editorToLight': 'Mudar para claro',
    'editorCustomColor': 'Cor personalizada',
    'editorInvalidHex': 'Cor hexadecimal inválida',
    'editorPresets': 'Cores predefinidas',
    'editorTokenPreview': 'Pré-visualização de tokens',
    'editorPalette': 'Paleta de cores',
    'editorSemantic': 'Tokens semânticos',
    'editorComponentTokens': 'Tokens de componentes',
    'editorComponents': 'Componentes',
    'editorCancel': 'Cancelar',
    'editorApply': 'Aplicar',
    'editorCustom': 'Personalizada',
    'editorPickColor': 'Escolher cor',
    'editorHue': 'Matiz',
    'editorSaturation': 'Saturação',
    'editorBrightness': 'Brilho',
  },
  'es': {
    'home': 'Inicio',
    'search': 'Buscar componente',
    'noResults': 'No se encontraron componentes.',
    'toggleTheme': 'Claro / oscuro',
    'language': 'Idioma',
    'theme': 'Tema',
    'themeSystem': 'Sistema de Tema',
    'creditsLicenses': 'Créditos / Licencias',
    'expandGroups': 'Expandir todos los grupos',
    'collapseGroups': 'Contraer todos los grupos',
    'themeTitle': 'SeedThemeProvider',
    'themeSubtitle':
        'Sistema de temas basado en un color semilla que genera paletas armoniosas automáticamente.',
    'themePalette': 'Paleta generada',
    'paletteSeed': 'Semilla (primary)',
    'paletteSecondary': 'Secondary',
    'paletteTertiary': 'Tertiary',
    'paletteSurface': 'Superficie',
    'themeNote':
        'Al cambiar el color semilla, el radio o el modo claro/oscuro, todos los componentes de esta página lo siguen. La elección vale solo para esta sesión.',
    'creditsTitle': 'Créditos y Bibliotecas de Terceros',
    'creditsSubtitle':
        'Lista de las bibliotecas open-source usadas en los componentes SeedGrid para Flutter, con la licencia y el enlace de cada una.',
    'creditsUsedIn': 'Usada en',
    'creditsLicense': 'Licencia',
    'creditsAllLicenses': 'Ver todas las licencias de Flutter',
    'creditsCompliance':
        'Todas las bibliotecas listadas arriba se distribuyen con licencias compatibles con uso open-source y comercial. Los créditos se muestran según lo exigido por cada licencia.',
    'radius': 'Radio',
    'example': 'Ejemplo',
    'playground': 'Playground',
    'propsReference': 'Referencia de Props',
    'propsTitle': 'Referencia de Props',
    'colProp': 'Prop',
    'colType': 'Tipo',
    'colDefault': 'Predeterminado',
    'colDescription': 'Descripción',
    'default': '(predeterminado)',
    'notEditable': 'No editables aquí',
    'homeTitle': 'SeedGrid para Flutter',
    'homeIntro':
        'Port de los componentes SeedGrid de React: mismos nombres de widget, de props y de valores, '
        'para que quien ya conoce los componentes React los use con facilidad. '
        'Elija un componente en el menú; cada página tiene ejemplos con el código igual al renderizado, '
        'un playground de props y la referencia de props.',
    'status.parcial': 'parcial',
    'status.pendente': 'pendiente',
    'cat.action': 'Acción',
    'cat.input': 'Entrada de datos',
    'cat.data': 'Datos',
    'cat.layout': 'Layout',
    'cat.navigation': 'Navegación',
    'cat.feedback': 'Feedback y visualización',
    'cat.gadget': 'Gadgets',
    'cat.provider': 'Providers',
    'cat.outros': 'Otros',
    'color.#EA580C': 'Naranja',
    'color.#16803D': 'Verde SeedGrid',
    'color.#0EA5E9': 'Azul',
    'color.#7C3AED': 'Morado',
    'color.#EC4899': 'Rosa',
    'color.#F97316': 'Naranja',
    'color.#EF4444': 'Rojo',
    'color.#F59E0B': 'Amarillo',
    'color.#10B981': 'Verde',
    'customColor': 'Color personalizado (#RRGGBB)',
    'editorTitle': 'Editor de Tema',
    'editorMode': 'Modo',
    'editorToDark': 'Cambiar a oscuro',
    'editorToLight': 'Cambiar a claro',
    'editorCustomColor': 'Color personalizado',
    'editorInvalidHex': 'Color hexadecimal inválido',
    'editorPresets': 'Colores predefinidos',
    'editorTokenPreview': 'Vista previa de tokens',
    'editorPalette': 'Paleta de colores',
    'editorSemantic': 'Tokens semánticos',
    'editorComponentTokens': 'Tokens de componentes',
    'editorComponents': 'Componentes',
    'editorCancel': 'Cancelar',
    'editorApply': 'Aplicar',
    'editorCustom': 'Personalizado',
    'editorPickColor': 'Elegir color',
    'editorHue': 'Matiz',
    'editorSaturation': 'Saturación',
    'editorBrightness': 'Brillo',
  },
  'fr': {
    'home': 'Accueil',
    'search': 'Rechercher un composant',
    'noResults': 'Aucun composant trouvé.',
    'toggleTheme': 'Clair / sombre',
    'language': 'Langue',
    'theme': 'Thème',
    'themeSystem': 'Système de Thème',
    'creditsLicenses': 'Crédits / Licences',
    'expandGroups': 'Déplier tous les groupes',
    'collapseGroups': 'Replier tous les groupes',
    'themeTitle': 'SeedThemeProvider',
    'themeSubtitle':
        'Système de thèmes basé sur une couleur de départ qui génère automatiquement des palettes harmonieuses.',
    'themePalette': 'Palette générée',
    'paletteSeed': 'Départ (primary)',
    'paletteSecondary': 'Secondary',
    'paletteTertiary': 'Tertiary',
    'paletteSurface': 'Surface',
    'themeNote':
        'Quand vous changez la couleur de départ, le rayon ou le mode clair/sombre, tous les composants de cette page suivent. Le choix ne vaut que pour cette session.',
    'creditsTitle': 'Crédits et Bibliothèques Tierces',
    'creditsSubtitle':
        'Liste des bibliothèques open-source utilisées par les composants SeedGrid pour Flutter, avec la licence et le lien de chacune.',
    'creditsUsedIn': 'Utilisée dans',
    'creditsLicense': 'Licence',
    'creditsAllLicenses': 'Voir toutes les licences de Flutter',
    'creditsCompliance':
        "Toutes les bibliothèques listées ci-dessus sont distribuées sous des licences compatibles avec un usage open-source et commercial. Les crédits sont fournis comme exigé par chaque licence.",
    'radius': 'Rayon',
    'example': 'Exemple',
    'playground': 'Playground',
    'propsReference': 'Référence des props',
    'propsTitle': 'Référence des props',
    'colProp': 'Prop',
    'colType': 'Type',
    'colDefault': 'Par défaut',
    'colDescription': 'Description',
    'default': '(par défaut)',
    'notEditable': 'Non modifiables ici',
    'homeTitle': 'SeedGrid pour Flutter',
    'homeIntro':
        'Portage des composants SeedGrid de React : mêmes noms de widget, de props et de valeurs, '
        'pour que les personnes qui connaissent déjà les composants React les utilisent facilement. '
        'Choisissez un composant dans le menu ; chaque page propose des exemples dont le code est identique au rendu, '
        'un playground de props et la référence des props.',
    'status.parcial': 'partiel',
    'status.pendente': 'en attente',
    'cat.action': 'Action',
    'cat.input': 'Saisie de données',
    'cat.data': 'Données',
    'cat.layout': 'Layout',
    'cat.navigation': 'Navigation',
    'cat.feedback': 'Retours et affichage',
    'cat.gadget': 'Gadgets',
    'cat.provider': 'Providers',
    'cat.outros': 'Autres',
    'color.#EA580C': 'Orange',
    'color.#16803D': 'Vert SeedGrid',
    'color.#0EA5E9': 'Bleu',
    'color.#7C3AED': 'Violet',
    'color.#EC4899': 'Rose',
    'color.#F97316': 'Orange',
    'color.#EF4444': 'Rouge',
    'color.#F59E0B': 'Jaune',
    'color.#10B981': 'Vert',
    'customColor': 'Couleur personnalisée (#RRGGBB)',
    'editorTitle': 'Éditeur de thème',
    'editorMode': 'Mode',
    'editorToDark': 'Passer en sombre',
    'editorToLight': 'Passer en clair',
    'editorCustomColor': 'Couleur personnalisée',
    'editorInvalidHex': 'Couleur hexadécimale invalide',
    'editorPresets': 'Couleurs prédéfinies',
    'editorTokenPreview': 'Aperçu des tokens',
    'editorPalette': 'Palette de couleurs',
    'editorSemantic': 'Tokens sémantiques',
    'editorComponentTokens': 'Tokens de composants',
    'editorComponents': 'Composants',
    'editorCancel': 'Annuler',
    'editorApply': 'Appliquer',
    'editorCustom': 'Personnalisée',
    'editorPickColor': 'Choisir une couleur',
    'editorHue': 'Teinte',
    'editorSaturation': 'Saturation',
    'editorBrightness': 'Luminosité',
  },
};

/// Idioma e textos do showcase para a subarvore. Sem escopo acima, cai em pt-BR.
class ShowcaseI18n extends InheritedWidget {
  const ShowcaseI18n({
    super.key,
    required this.locale,
    required this.setLocale,
    required super.child,
  });

  final String locale;
  final ValueChanged<String> setLocale;

  static ShowcaseI18n? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShowcaseI18n>();

  /// Texto da chave no idioma atual; `{nome}` e trocado por [params]. Chave ausente volta a propria chave.
  static String t(
    BuildContext context,
    String key, [
    Map<String, Object> params = const {},
  ]) {
    final locale = maybeOf(context)?.locale ?? 'pt-BR';
    var text =
        kShowcaseMessages[locale]?[key] ?? kShowcaseMessages['pt-BR']![key];
    text ??= key;
    params.forEach((k, v) => text = text!.replaceAll('{$k}', '$v'));
    return text!;
  }

  /// Texto de pagina (titulo/descricao de exemplo, descricao da pagina) no idioma atual. O texto em pt-BR escrito
  /// na pagina e a chave; sem traducao (ou em pt-BR) volta o proprio texto.
  static String tx(BuildContext context, String text) {
    final locale = maybeOf(context)?.locale ?? 'pt-BR';
    final i = kShowcaseTextLocales.indexOf(locale);
    if (i < 0) return text;
    return kShowcaseTexts[text]?[i] ?? text;
  }

  @override
  bool updateShouldNotify(ShowcaseI18n old) => old.locale != locale;
}

/// Atalho: `context.tr('home')`.
extension ShowcaseTr on BuildContext {
  String tr(String key, [Map<String, Object> params = const {}]) =>
      ShowcaseI18n.t(this, key, params);

  /// Texto de pagina traduzido: `context.tx('Texto em pt-BR')`.
  String tx(String text) => ShowcaseI18n.tx(this, text);

  /// Texto de pagina com parametros: o modelo (com `{nome}`) e a chave; `{nome}` e trocado por [params].
  String txf(String template, Map<String, Object> params) {
    var text = ShowcaseI18n.tx(this, template);
    params.forEach((k, v) => text = text.replaceAll('{$k}', '$v'));
    return text;
  }
}

/// Guarda o idioma escolhido e o repassa aos componentes (SgComponentsI18nProvider).
class ShowcaseI18nScope extends StatefulWidget {
  const ShowcaseI18nScope({super.key, required this.child});

  final Widget child;

  @override
  State<ShowcaseI18nScope> createState() => _ShowcaseI18nScopeState();
}

class _ShowcaseI18nScopeState extends State<ShowcaseI18nScope> {
  String _locale = 'pt-BR';

  @override
  Widget build(BuildContext context) => ShowcaseI18n(
    locale: _locale,
    setLocale: (l) => setState(() => _locale = l),
    child: SgComponentsI18nProvider(locale: _locale, child: widget.child),
  );
}

/// Seletor de idioma (menu lateral).
class ShowcaseLanguagePicker extends StatelessWidget {
  const ShowcaseLanguagePicker({super.key, this.trailing = const []});

  /// Acoes no fim da linha (tema e claro/escuro).
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final i18n = ShowcaseI18n.maybeOf(context);
    final current = i18n?.locale ?? 'pt-BR';
    // Faixa no alto da pagina (como a barra de idioma do React): rotulo e as bandeiras em uma linha.
    return Container(
      key: const ValueKey('faixa-idioma'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              key: const ValueKey('idioma'),
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(context.tr('language')),
                for (final l in kShowcaseLocales)
                  ChoiceChip(
                    label: Text('${kShowcaseFlags[l] ?? ''} $l'),
                    selected: l == current,
                    visualDensity: VisualDensity.compact,
                    onSelected: (_) => i18n?.setLocale(l),
                  ),
              ],
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
