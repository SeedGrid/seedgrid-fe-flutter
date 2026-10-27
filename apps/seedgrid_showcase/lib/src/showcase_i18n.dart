// Textos fixos do showcase (cabecalho, menu, pagina inicial, tema, playground, props) em pt-BR, pt-PT, en-US, es e fr (os mesmos idiomas dos componentes).
// O idioma escolhido tambem vai para o SgComponentsI18nProvider, entao os textos internos dos
// componentes acompanham. Padrao pt-BR; a escolha fica so na sessao.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart'
    show SgComponentsI18nProvider;

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
    'radius': 'Raio',
    'example': 'Exemplo',
    'playground': 'Playground',
    'propsReference': 'Props Reference',
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
    'progress': 'Andamento do porte (React {version})',
    'statTotal': 'Componentes no React',
    'statPortado': 'Portados',
    'statParcial': 'Parciais',
    'statPendente': 'Pendentes',
    'statusNote':
        '"Parcial" = portado, com diferença documentada em docs/PARIDADE.md. '
        '"Pendente" = ainda sem widget.',
    'of': 'de',
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
  },
  'en-US': {
    'home': 'Home',
    'search': 'Search component',
    'noResults': 'No components found.',
    'toggleTheme': 'Light / dark',
    'language': 'Language',
    'theme': 'Theme',
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
    'progress': 'Port progress (React {version})',
    'statTotal': 'Components in React',
    'statPortado': 'Ported',
    'statParcial': 'Partial',
    'statPendente': 'Pending',
    'statusNote':
        '"Partial" = ported, with a difference documented in docs/PARIDADE.md. '
        '"Pending" = no widget yet.',
    'of': 'of',
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
  },
  'pt-PT': {
    'home': 'Início',
    'search': 'Procurar componente',
    'noResults': 'Nenhum componente encontrado.',
    'toggleTheme': 'Claro / escuro',
    'language': 'Idioma',
    'theme': 'Tema',
    'radius': 'Raio',
    'example': 'Exemplo',
    'playground': 'Playground',
    'propsReference': 'Props Reference',
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
    'progress': 'Progresso do porte (React {version})',
    'statTotal': 'Componentes no React',
    'statPortado': 'Portados',
    'statParcial': 'Parciais',
    'statPendente': 'Pendentes',
    'statusNote':
        '"Parcial" = portado, com diferença documentada em docs/PARIDADE.md. "Pendente" = ainda sem widget.',
    'of': 'de',
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
  },
  'es': {
    'home': 'Inicio',
    'search': 'Buscar componente',
    'noResults': 'No se encontraron componentes.',
    'toggleTheme': 'Claro / oscuro',
    'language': 'Idioma',
    'theme': 'Tema',
    'radius': 'Radio',
    'example': 'Ejemplo',
    'playground': 'Playground',
    'propsReference': 'Props Reference',
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
    'progress': 'Avance del port (React {version})',
    'statTotal': 'Componentes en React',
    'statPortado': 'Portados',
    'statParcial': 'Parciales',
    'statPendente': 'Pendientes',
    'statusNote':
        '"Parcial" = portado, con una diferencia documentada en docs/PARIDADE.md. "Pendiente" = aún sin widget.',
    'of': 'de',
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
  },
  'fr': {
    'home': 'Accueil',
    'search': 'Rechercher un composant',
    'noResults': 'Aucun composant trouvé.',
    'toggleTheme': 'Clair / sombre',
    'language': 'Langue',
    'theme': 'Thème',
    'radius': 'Rayon',
    'example': 'Exemple',
    'playground': 'Playground',
    'propsReference': 'Props Reference',
    'propsTitle': 'Référence des Props',
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
    'progress': 'Avancement du portage (React {version})',
    'statTotal': 'Composants dans React',
    'statPortado': 'Portés',
    'statParcial': 'Partiels',
    'statPendente': 'En attente',
    'statusNote':
        '« Partiel » = porté, avec une différence documentée dans docs/PARIDADE.md. « En attente » = pas encore de widget.',
    'of': 'sur',
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

  @override
  bool updateShouldNotify(ShowcaseI18n old) => old.locale != locale;
}

/// Atalho: `context.tr('home')`.
extension ShowcaseTr on BuildContext {
  String tr(String key, [Map<String, Object> params = const {}]) =>
      ShowcaseI18n.t(this, key, params);
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
  const ShowcaseLanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = ShowcaseI18n.maybeOf(context);
    final current = i18n?.locale ?? 'pt-BR';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr('language')),
          const SizedBox(height: 4),
          Wrap(
            key: const ValueKey('idioma'),
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final l in kShowcaseLocales)
                ChoiceChip(
                  label: Text('${kShowcaseFlags[l] ?? ''} $l'),
                  selected: l == current,
                  visualDensity: VisualDensity.compact,
                  onSelected: (_) => i18n?.setLocale(l),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
