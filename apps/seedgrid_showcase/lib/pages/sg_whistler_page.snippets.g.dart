// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_whistler_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgWhistlerPageSnippets {
  /// Region `sg-whistler-acao`.
  static const String sgWhistlerAcao = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(
      label: const Text('Com ação'),
      onClick: () => sgWhistle.warning(
        SgWhistleOptions(
          title: 'Rascunho',
          message: 'Você tem alterações não salvas.',
          icon: const Icon(Icons.edit),
          duration: 0,
          action: SgWhistleAction(
            label: 'Salvar',
            onClick: () => sgWhistle.success(
              const SgWhistleOptions(message: 'Rascunho salvo'),
            ),
          ),
          onClose: () => debugPrint('whistle fechado'),
        ),
      ),
    ),
    SgButton(
      label: const Text('Sem botão de fechar'),
      appearance: SgAppearance.outline,
      onClick: () => sgWhistle.info(
        const SgWhistleOptions(
          message: 'Some em 3 segundos',
          dismissible: false,
          duration: 3000,
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-whistler-aparencia`.
  static const String sgWhistlerAparencia = r'''
Wrap(
  spacing: 16,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    FilterChip(
      label: const Text('rounded'),
      selected: _rounded,
      onSelected: (v) => setState(() => _rounded = v),
    ),
    SizedBox(
      width: 180,
      child: Slider(
        value: _gap,
        min: 0,
        max: 40,
        divisions: 8,
        label: 'gap ${_gap.round()}',
        onChanged: (v) => setState(() => _gap = v),
      ),
    ),
    SgButton(
      label: const Text('Disparar 2 avisos'),
      onClick: () {
        sgWhistle.info(
          const SgWhistleOptions(
            message: 'Primeiro',
            duration: 4000,
          ),
        );
        sgWhistle.success(
          const SgWhistleOptions(
            message: 'Segundo',
            duration: 4000,
          ),
        );
      },
    ),
  ],
)
''';

  /// Region `sg-whistler-atualizar`.
  static const String sgWhistlerAtualizar = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(
      label: const Text('Atualizar'),
      onClick: () {
        final id = sgWhistle.loading(
          const SgWhistleOptions(message: 'Gerando relatório...'),
        );
        Future<void>.delayed(
          const Duration(seconds: 2),
          () => sgWhistle.update(
            id,
            const SgWhistleCustomOptions(
              severity: SgWhistleSeverity.success,
              message: 'Relatório pronto',
            ),
          ),
        );
      },
    ),
    SgButton(
      label: const Text('Promise'),
      appearance: SgAppearance.outline,
      onClick: () => sgWhistle.promise<int>(
        Future<int>.delayed(const Duration(seconds: 2), () => 42),
        SgWhistlePromiseStates<int>(
          loading: const SgWhistleOptions(message: 'Calculando...'),
          success: (int v) =>
              SgWhistleOptions(message: 'Resultado: $v'),
          error: const SgWhistleOptions(message: 'Deu erro'),
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-whistler-bordas`.
  static const String sgWhistlerBordas = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final style in SgWhistleBorderStyle.values)
      SgButton(
        label: Text(style.value),
        appearance: SgAppearance.outline,
        onClick: () => sgWhistle.info(
          SgWhistleOptions(
            message: 'borderStyle: ${style.value}',
            borderStyle: style,
            duration: 3000,
          ),
        ),
      ),
  ],
)
''';

  /// Region `sg-whistler-severidades`.
  static const String sgWhistlerSeveridades = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(
      label: const Text('Padrão'),
      onClick: () => sgWhistle.show(
        const SgWhistleOptions(message: 'Aviso simples'),
      ),
    ),
    SgButton(
      label: const Text('Sucesso'),
      severity: SgSeverity.success,
      onClick: () => sgWhistle.success(
        const SgWhistleOptions(
          title: 'Salvo',
          message: 'As alterações foram gravadas.',
        ),
      ),
    ),
    SgButton(
      label: const Text('Info'),
      severity: SgSeverity.info,
      onClick: () => sgWhistle.info(
        const SgWhistleOptions(message: 'Há uma nova versão.'),
      ),
    ),
    SgButton(
      label: const Text('Aviso'),
      severity: SgSeverity.warning,
      onClick: () => sgWhistle.warning(
        const SgWhistleOptions(message: 'Sessão perto de expirar.'),
      ),
    ),
    SgButton(
      label: const Text('Erro'),
      severity: SgSeverity.danger,
      onClick: () => sgWhistle.error(
        const SgWhistleOptions(
          title: 'Falha',
          message: 'Não foi possível salvar.',
        ),
      ),
    ),
    SgButton(
      label: const Text('Limpar tudo'),
      appearance: SgAppearance.ghost,
      onClick: sgWhistle.dismiss,
    ),
  ],
)
''';
}
