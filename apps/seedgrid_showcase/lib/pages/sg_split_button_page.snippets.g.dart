// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_split_button_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgSplitButtonPageSnippets {
  /// Region `sg-split-button-basico`.
  static const String sgSplitButtonBasico = r'''
Builder(
  builder: (context) {
    final itens = [
      SgSplitButtonItem(
        label: context.tx('Update'),
        icon: const Icon(Icons.refresh),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Delete'),
        icon: const Icon(Icons.delete),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Home'),
        icon: const Icon(Icons.home),
        onClick: () {},
      ),
    ];
    return SgSplitButton(
      label: context.tx('Save'),
      leftIcon: const Icon(Icons.save),
      onClick: () {},
      items: itens,
    );
  },
)
''';

  /// Region `sg-split-button-com-icones`.
  static const String sgSplitButtonComIcones = r'''
Builder(
  builder: (context) {
    final itens = [
      SgSplitButtonItem(
        label: context.tx('Update'),
        icon: const Icon(Icons.refresh),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Delete'),
        icon: const Icon(Icons.delete),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Home'),
        icon: const Icon(Icons.home),
        onClick: () {},
      ),
    ];
    final itensArquivo = [
      SgSplitButtonItem(
        label: context.tx('Copiar'),
        icon: const Icon(Icons.copy),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Imprimir'),
        icon: const Icon(Icons.print),
        onClick: () {},
      ),
      SgSplitButtonItem(
        separator: true,
        label: context.tx('Exportar PDF'),
        icon: const Icon(Icons.picture_as_pdf),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Compartilhar por e-mail'),
        icon: const Icon(Icons.mail),
        onClick: () {},
      ),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SgSplitButton(
          label: context.tx('Save'),
          leftIcon: const Icon(Icons.save),
          severity: SgSeverity.primary,
          onClick: () {},
          items: itens,
        ),
        SgSplitButton(
          label: context.tx('Novo'),
          leftIcon: const Icon(Icons.add),
          severity: SgSeverity.success,
          onClick: () {},
          items: [
            SgSplitButtonItem(
              label: context.tx('Importar'),
              icon: const Icon(Icons.upload),
              onClick: () {},
            ),
            SgSplitButtonItem(
              label: context.tx('Baixar modelo'),
              icon: const Icon(Icons.download),
              onClick: () {},
            ),
          ],
        ),
        SgSplitButton(
          label: context.tx('Compartilhar'),
          leftIcon: const Icon(Icons.share),
          severity: SgSeverity.info,
          onClick: () {},
          items: itensArquivo,
        ),
      ],
    );
  },
)
''';

  /// Region `sg-split-button-disabled`.
  static const String sgSplitButtonDisabled = r'''
Builder(
  builder: (context) {
    final itens = [
      SgSplitButtonItem(
        label: context.tx('Update'),
        icon: const Icon(Icons.refresh),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Delete'),
        icon: const Icon(Icons.delete),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Home'),
        icon: const Icon(Icons.home),
        onClick: () {},
      ),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SgSplitButton(
          label: context.tx('Save'),
          leftIcon: const Icon(Icons.save),
          enabled: false,
          onClick: () {},
          items: itens,
        ),
        SgSplitButton(
          label: context.tx('Disabled outline'),
          severity: SgSeverity.danger,
          appearance: SgAppearance.outline,
          enabled: false,
          onClick: () {},
          items: itens,
        ),
      ],
    );
  },
)
''';

  /// Region `sg-split-button-elevated`.
  static const String sgSplitButtonElevated = r'''
Builder(
  builder: (context) {
    final itens = [
      SgSplitButtonItem(
        label: context.tx('Update'),
        icon: const Icon(Icons.refresh),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Delete'),
        icon: const Icon(Icons.delete),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Home'),
        icon: const Icon(Icons.home),
        onClick: () {},
      ),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final (nome, severity) in const [
          ('Primary', SgSeverity.primary),
          ('Secondary', SgSeverity.secondary),
          ('Success', SgSeverity.success),
          ('Info', SgSeverity.info),
          ('Warning', SgSeverity.warning),
          ('Help', SgSeverity.help),
          ('Danger', SgSeverity.danger),
        ])
          SgSplitButton(
            label: context.tx(nome),
            severity: severity,
            appearance: SgAppearance.solid,
            elevation: SgElevation.sm,
            onClick: () {},
            items: itens,
          ),
      ],
    );
  },
)
''';

  /// Region `sg-split-button-ghost`.
  static const String sgSplitButtonGhost = r'''
Builder(
  builder: (context) {
    final itens = [
      SgSplitButtonItem(
        label: context.tx('Update'),
        icon: const Icon(Icons.refresh),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Delete'),
        icon: const Icon(Icons.delete),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Home'),
        icon: const Icon(Icons.home),
        onClick: () {},
      ),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final (nome, severity) in const [
          ('Primary', SgSeverity.primary),
          ('Secondary', SgSeverity.secondary),
          ('Success', SgSeverity.success),
          ('Info', SgSeverity.info),
          ('Warning', SgSeverity.warning),
          ('Help', SgSeverity.help),
          ('Danger', SgSeverity.danger),
        ])
          SgSplitButton(
            label: context.tx(nome),
            severity: severity,
            appearance: SgAppearance.ghost,
            onClick: () {},
            items: itens,
          ),
      ],
    );
  },
)
''';

  /// Region `sg-split-button-itens-desabilitados`.
  static const String sgSplitButtonItensDesabilitados = r'''
SgSplitButton(
  label: context.tx('Ações'),
  severity: SgSeverity.primary,
  onClick: () {},
  items: [
    SgSplitButtonItem(
      label: context.tx('Update'),
      icon: const Icon(Icons.refresh),
      onClick: () {},
    ),
    SgSplitButtonItem(
      label: context.tx('Delete (disabled)'),
      icon: const Icon(Icons.delete),
      onClick: () {},
      enabled: false,
    ),
    SgSplitButtonItem(
      label: context.tx('Home'),
      icon: const Icon(Icons.home),
      onClick: () {},
    ),
  ],
)
''';

  /// Region `sg-split-button-loading`.
  static const String sgSplitButtonLoading = r'''
Builder(
  builder: (context) {
    final itens = [
      SgSplitButtonItem(
        label: context.tx('Update'),
        icon: const Icon(Icons.refresh),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Delete'),
        icon: const Icon(Icons.delete),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Home'),
        icon: const Icon(Icons.home),
        onClick: () {},
      ),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SgSplitButton(
          label: context.tx('Salvando...'),
          leftIcon: const Icon(Icons.save),
          loading: true,
          onClick: () {},
          items: itens,
        ),
        SgSplitButton(
          label: context.tx('Processando...'),
          severity: SgSeverity.success,
          loading: true,
          onClick: () {},
          items: itens,
        ),
      ],
    );
  },
)
''';

  /// Region `sg-split-button-outlined`.
  static const String sgSplitButtonOutlined = r'''
Builder(
  builder: (context) {
    final itens = [
      SgSplitButtonItem(
        label: context.tx('Update'),
        icon: const Icon(Icons.refresh),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Delete'),
        icon: const Icon(Icons.delete),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Home'),
        icon: const Icon(Icons.home),
        onClick: () {},
      ),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final (nome, severity) in const [
          ('Primary', SgSeverity.primary),
          ('Secondary', SgSeverity.secondary),
          ('Success', SgSeverity.success),
          ('Info', SgSeverity.info),
          ('Warning', SgSeverity.warning),
          ('Help', SgSeverity.help),
          ('Danger', SgSeverity.danger),
        ])
          SgSplitButton(
            label: context.tx(nome),
            severity: severity,
            appearance: SgAppearance.outline,
            onClick: () {},
            items: itens,
          ),
      ],
    );
  },
)
''';

  /// Region `sg-split-button-separadores`.
  static const String sgSplitButtonSeparadores = r'''
Builder(
  builder: (context) {
    final itensArquivo = [
      SgSplitButtonItem(
        label: context.tx('Copiar'),
        icon: const Icon(Icons.copy),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Imprimir'),
        icon: const Icon(Icons.print),
        onClick: () {},
      ),
      SgSplitButtonItem(
        separator: true,
        label: context.tx('Exportar PDF'),
        icon: const Icon(Icons.picture_as_pdf),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Compartilhar por e-mail'),
        icon: const Icon(Icons.mail),
        onClick: () {},
      ),
    ];
    return SgSplitButton(
      label: context.tx('Arquivo'),
      leftIcon: const Icon(Icons.description),
      severity: SgSeverity.secondary,
      onClick: () {},
      items: itensArquivo,
    );
  },
)
''';

  /// Region `sg-split-button-severidades`.
  static const String sgSplitButtonSeveridades = r'''
Builder(
  builder: (context) {
    final itens = [
      SgSplitButtonItem(
        label: context.tx('Update'),
        icon: const Icon(Icons.refresh),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Delete'),
        icon: const Icon(Icons.delete),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Home'),
        icon: const Icon(Icons.home),
        onClick: () {},
      ),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final (nome, severity) in const [
          ('Primary', SgSeverity.primary),
          ('Secondary', SgSeverity.secondary),
          ('Success', SgSeverity.success),
          ('Info', SgSeverity.info),
          ('Warning', SgSeverity.warning),
          ('Help', SgSeverity.help),
          ('Danger', SgSeverity.danger),
        ])
          SgSplitButton(
            label: context.tx(nome),
            severity: severity,
            onClick: () {},
            items: itens,
          ),
      ],
    );
  },
)
''';

  /// Region `sg-split-button-tamanhos`.
  static const String sgSplitButtonTamanhos = r'''
Builder(
  builder: (context) {
    final itens = [
      SgSplitButtonItem(
        label: context.tx('Update'),
        icon: const Icon(Icons.refresh),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Delete'),
        icon: const Icon(Icons.delete),
        onClick: () {},
      ),
      SgSplitButtonItem(
        label: context.tx('Home'),
        icon: const Icon(Icons.home),
        onClick: () {},
      ),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SgSplitButton(
          label: context.tx('Small'),
          size: SgSize.sm,
          leftIcon: const Icon(Icons.save),
          onClick: () {},
          items: itens,
        ),
        SgSplitButton(
          label: context.tx('Medium'),
          size: SgSize.md,
          leftIcon: const Icon(Icons.save),
          onClick: () {},
          items: itens,
        ),
        SgSplitButton(
          label: context.tx('Large'),
          size: SgSize.lg,
          leftIcon: const Icon(Icons.save),
          onClick: () {},
          items: itens,
        ),
      ],
    );
  },
)
''';
}
