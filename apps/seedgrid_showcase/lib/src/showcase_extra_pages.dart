// Paginas fixas do showcase, as mesmas do React: "Sistema de Tema" (/theme) e "Creditos / Licencas" (/credits).
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart'
    show SgButton, SgSeverity;
import 'package:seedgrid_theme/seedgrid_theme.dart';

import 'sg_showcase_page.dart' show SgCodeBlock;
import 'showcase_i18n.dart';
import 'theme_panel.dart';
import 'theme_tokens_view.dart';

/// Pagina "Sistema de Tema": igual a do React (instalacao, setup, hook, tokens, paletas, semanticas, neutras, tokens de
/// componente, estado atual e persistencia), adaptada ao Flutter. Os controles de cor e raio aplicam ao vivo.
class ShowcaseThemePage extends StatelessWidget {
  const ShowcaseThemePage({super.key});

  static const String _install = '''dependencies:
  seedgrid_theme:
  seedgrid_components:''';

  static const String _setup = '''import 'package:flutter/material.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

void main() => runApp(
  SeedThemeProvider(
    initialTheme: const SeedThemeInput(
      seed: '#16803D',
      mode: SgThemeMode.light,
      radius: 12,
    ),
    child: const MaterialApp(home: Home()),
  ),
);''';

  static const String _hook = '''final sg = useSgTheme(context);

sg.currentMode;                     // Brightness.light ou Brightness.dark
sg.currentTheme.seed;               // '#16803D'
sg.setTheme(seed: '#7C3AED');       // troca a cor semente
sg.setTheme(radius: 8);             // troca o raio
sg.setMode(Brightness.dark);        // troca claro/escuro''';

  static const String _tokensCode = '''final sg = useSgTheme(context);

// Pelo nome do token (os mesmos nomes das CSS variables do React):
final cor = sg.theme.color('--sg-primary-600');
final texto = sg.vars['--sg-primary-600']; // '22 128 61'

// Pelos getters tipados (tira "--sg-" e vira camelCase):
final fundo = sg.theme.btnPrimaryBg;
final tom = sg.theme.primary600;''';

  static const String _persist =
      '''final prefs = await SharedPreferences.getInstance();
final seed = prefs.getString('sg:theme:seed') ?? '#16803D';

SeedThemeProvider(
  initialTheme: SeedThemeInput(seed: seed),
  child: const MyApp(),
);

// ao trocar: sg.setTheme(seed: novo); prefs.setString('sg:theme:seed', novo);''';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final sg = useSgTheme(context);
    final current = sg.theme;
    final seed = sg.currentTheme.seed.toUpperCase();
    final mono = theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace');
    return SingleChildScrollView(
      key: const ValueKey('pagina-tema'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr('themeTitle'), style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(context.tr('themeSubtitle')),
          _Section(
            title: context.tx('Instalação'),
            description: context.tx('Adicione o pacote ao projeto.'),
            child: const SgCodeBlock(code: _install),
          ),
          _Section(
            title: context.tx('Setup básico'),
            description: context.tx(
              'Configure o provider na raiz da aplicação.',
            ),
            child: const SgCodeBlock(code: _setup),
          ),
          _Section(
            title: context.tx('Hook useSgTheme'),
            description: context.tx(
              'Acesse e altere o tema em qualquer widget.',
            ),
            child: const SgCodeBlock(code: _hook),
          ),
          _Section(
            title: context.tx('Lendo os tokens'),
            description: context.tx(
              'Todas as cores ficam disponíveis como tokens, com os mesmos nomes das CSS variables do React.',
            ),
            child: const SgCodeBlock(code: _tokensCode),
          ),
          _Section(
            title: context.tx('Cores predefinidas e cor personalizada'),
            description: context.tx(
              'Escolha uma cor semente, digite um #RRGGBB ou ajuste o raio: o tema muda ao vivo. O botão de tema da barra abre o editor, que só aplica ao clicar em Aplicar.',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Card(child: ShowcaseThemePanel()),
                const SizedBox(height: 16),
                Wrap(
                  key: const ValueKey('tema-amostra'),
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(label: 'Primary', onClick: () {}),
                    SgButton(
                      label: 'Secondary',
                      severity: SgSeverity.secondary,
                      onClick: () {},
                    ),
                    SgButton(
                      label: 'Success',
                      severity: SgSeverity.success,
                      onClick: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          _Section(
            title: context.tx('Paletas de cores'),
            description: context.tx('Cada cor possui escala de 50 a 900.'),
            child: Column(
              key: const ValueKey('tema-paleta'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (family, label) in [
                  ('primary', context.tx('Primary (muda com a semente)')),
                  ('secondary', context.tx('Secondary (muda com a semente)')),
                  ('tertiary', context.tx('Tertiary (muda com a semente)')),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ThemePaletteRow(
                      theme: current,
                      family: family,
                      label: label,
                      keyPrefix: 'pagina-paleta',
                      cellHeight: 56,
                      showStops: true,
                    ),
                  ),
              ],
            ),
          ),
          _Section(
            title: context.tx('Cores semânticas'),
            description: context.tx(
              'Cores fixas para convenções universais de UI/UX.',
            ),
            child: Column(
              key: const ValueKey('tema-semanticas'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (family, label) in [
                  ('success', context.tx('Success (verde fixo)')),
                  ('info', context.tx('Info (azul fixo)')),
                  ('warning', context.tx('Warning (amarelo fixo)')),
                  ('error', context.tx('Error (vermelho fixo)')),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ThemePaletteRow(
                      theme: current,
                      family: family,
                      label: label,
                      keyPrefix: 'pagina-paleta',
                      cellHeight: 56,
                      showStops: true,
                    ),
                  ),
              ],
            ),
          ),
          _Section(
            title: context.tx('Cores neutras'),
            description: context.tx('Cores harmonizadas com a semente.'),
            child: Wrap(
              key: const ValueKey('tema-neutras'),
              spacing: 24,
              runSpacing: 12,
              children: [
                for (final (token, label) in kNeutralTokens)
                  SizedBox(
                    key: ValueKey('pagina-neutra-$token'),
                    width: 280,
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: themeTokenColor(current, token),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: scheme.outline, width: 2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('--sg-$token', style: mono),
                              Text(
                                label,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          _Section(
            title: context.tx('Tokens de componentes'),
            description: context.tx(
              'Variáveis semânticas para componentes específicos.',
            ),
            child: ThemeComponentTokens(
              theme: current,
              keyPrefix: 'pagina-token',
            ),
          ),
          _Section(
            title: context.tx('Estado atual do tema'),
            child: Card(
              key: const ValueKey('tema-estado'),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  spacing: 48,
                  runSpacing: 16,
                  children: [
                    _StateItem(
                      label: context.tx('Modo atual'),
                      child: Text(
                        sg.currentMode == Brightness.dark ? 'dark' : 'light',
                        key: const ValueKey('tema-estado-modo'),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    _StateItem(
                      label: context.tx('Cor semente'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: themeTokenColor(current, 'primary-600'),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: scheme.outline),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            seed,
                            key: const ValueKey('tema-estado-semente'),
                            style: mono,
                          ),
                        ],
                      ),
                    ),
                    _StateItem(
                      label: context.tr('radius'),
                      child: Text(
                        '${current.radius.round()} px',
                        key: const ValueKey('tema-estado-raio'),
                        style: mono,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _Section(
            title: context.tx('Persistência'),
            description: context.tx(
              'No Flutter o tema não é salvo sozinho: a escolha vale só para a sessão.',
            ),
            child: Column(
              key: const ValueKey('tema-persistencia'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tx(
                    'O SeedThemeProvider guarda seed, modo e raio em memória. Para lembrar a escolha entre sessões, salve a seed (por exemplo com shared_preferences) e passe-a em initialTheme ao iniciar o app.',
                  ),
                ),
                const SizedBox(height: 12),
                const SgCodeBlock(code: _persist),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('themeNote'),
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.description, required this.child});

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _StateItem extends StatelessWidget {
  const _StateItem({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 4),
      child,
    ],
  );
}

/// Biblioteca de terceiros usada pelos pacotes Flutter da SeedGrid.
class ShowcaseCredit {
  const ShowcaseCredit(
    this.name,
    this.version,
    this.license,
    this.url,
    this.usedIn,
  );

  final String name;
  final String version;
  final String license;
  final String url;
  final String usedIn;
}

/// Dependencias de `seedgrid_components`, `seedgrid_commons` e do showcase (versoes do pubspec.lock; a licenca e a do
/// arquivo LICENSE de cada pacote). Mudou uma dependencia? Atualize aqui (o teste confere contra o pubspec).
const List<ShowcaseCredit> kShowcaseCredits = [
  ShowcaseCredit(
    'flutter_quill',
    '11.5.0',
    'MIT',
    'https://github.com/singerdmx/flutter-quill',
    'SgTextEditor',
  ),
  ShowcaseCredit(
    'file_picker',
    '11.0.3',
    'MIT',
    'https://github.com/miguelpruivo/flutter_file_picker',
    'SgFileUpload, SgImageUpload',
  ),
  ShowcaseCredit(
    'desktop_drop',
    '0.7.1',
    'Apache-2.0',
    'https://pub.dev/packages/desktop_drop',
    'SgFileUpload, SgImageUpload (drag and drop)',
  ),
  ShowcaseCredit(
    'camera',
    '0.12.0+2',
    'BSD-3-Clause',
    'https://pub.dev/packages/camera',
    'SgCameraCapture',
  ),
  ShowcaseCredit(
    'html',
    '0.15.7',
    'MIT',
    'https://pub.dev/packages/html',
    'SgTextEditor',
  ),
  ShowcaseCredit(
    'intl',
    '0.20.2',
    'BSD-3-Clause',
    'https://pub.dev/packages/intl',
    'seedgrid_components',
  ),
  ShowcaseCredit(
    'shared_preferences',
    '2.5.5',
    'BSD-3-Clause',
    'https://pub.dev/packages/shared_preferences',
    'SgCard, SgDockMenu, SgFloatActionButton (persistence)',
  ),
  ShowcaseCredit(
    'web',
    '1.1.1',
    'BSD-3-Clause',
    'https://pub.dev/packages/web',
    'SgCameraCapture (web)',
  ),
  ShowcaseCredit(
    'http',
    '1.6.0',
    'BSD-3-Clause',
    'https://pub.dev/packages/http',
    'seedgrid_commons',
  ),
  ShowcaseCredit(
    'lucide_icons_flutter',
    '4.0.1',
    'MIT',
    'https://pub.dev/packages/lucide_icons_flutter',
    'Showcase',
  ),
];

/// Pagina "Creditos / Licencas": as bibliotecas de terceiros e o atalho para a pagina de licencas do proprio Flutter.
class ShowcaseCreditsPage extends StatelessWidget {
  const ShowcaseCreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      key: const ValueKey('pagina-creditos'),
      padding: const EdgeInsets.all(24),
      children: [
        Text(context.tr('creditsTitle'), style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(context.tr('creditsSubtitle')),
        const SizedBox(height: 16),
        for (final c in kShowcaseCredits)
          Card(
            key: ValueKey('credito-${c.name}'),
            child: ListTile(
              title: Text('${c.name} ${c.version}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${context.tr('creditsLicense')}: ${c.license}'),
                  Text('${context.tr('creditsUsedIn')}: ${c.usedIn}'),
                  SelectableText(c.url),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          context.tr('creditsCompliance'),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(
            key: const ValueKey('creditos-todas'),
            onPressed: () => showLicensePage(
              context: context,
              applicationName: 'SeedGrid Components for Flutter',
            ),
            child: Text(context.tr('creditsAllLicenses')),
          ),
        ),
      ],
    );
  }
}
