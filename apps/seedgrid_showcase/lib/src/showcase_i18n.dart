// Textos fixos do showcase (cabecalho, menu, pagina inicial, tema, playground, props) em pt-BR e en-US.
// O idioma escolhido tambem vai para o SgComponentsI18nProvider, entao os textos internos dos
// componentes acompanham. Padrao pt-BR; a escolha fica so na sessao.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart'
    show SgComponentsI18nProvider;

const List<String> kShowcaseLocales = ['pt-BR', 'en-US'];

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
    'color.#2563EB': 'Azul',
    'color.#16A34A': 'Verde',
    'color.#DC2626': 'Vermelho',
    'color.#9333EA': 'Roxo',
    'color.#EA580C': 'Laranja',
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
    'color.#2563EB': 'Blue',
    'color.#16A34A': 'Green',
    'color.#DC2626': 'Red',
    'color.#9333EA': 'Purple',
    'color.#EA580C': 'Orange',
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
          SegmentedButton<String>(
            key: const ValueKey('idioma'),
            showSelectedIcon: false,
            style: const ButtonStyle(visualDensity: VisualDensity.compact),
            segments: [
              for (final l in kShowcaseLocales)
                ButtonSegment<String>(value: l, label: Text(l)),
            ],
            selected: {current},
            onSelectionChanged: (s) => i18n?.setLocale(s.first),
          ),
        ],
      ),
    );
  }
}
