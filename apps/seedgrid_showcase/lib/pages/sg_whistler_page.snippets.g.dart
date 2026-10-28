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
      label: Text(context.tx('Com ação')),
      onClick: () => sgWhistle.warning(
        SgWhistleOptions(
          title: context.tx('Rascunho'),
          message: context.tx('Você tem alterações não salvas.'),
          icon: const Icon(Icons.edit),
          duration: 0,
          action: SgWhistleAction(
            label: context.tx('Salvar'),
            onClick: () => sgWhistle.success(
              SgWhistleOptions(
                message: context.tx('Rascunho salvo'),
              ),
            ),
          ),
          onClose: () => debugPrint('whistle fechado'),
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Sem botão de fechar')),
      appearance: SgAppearance.outline,
      onClick: () => sgWhistle.info(
        SgWhistleOptions(
          message: context.tx('Some em 3 segundos'),
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
      label: Text(context.tx('rounded')),
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
      label: Text(context.tx('Disparar 2 avisos')),
      onClick: () {
        sgWhistle.info(
          SgWhistleOptions(
            message: context.tx('Primeiro'),
            duration: 4000,
          ),
        );
        sgWhistle.success(
          SgWhistleOptions(
            message: context.tx('Segundo'),
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
      label: Text(context.tx('Atualizar')),
      onClick: () {
        final id = sgWhistle.loading(
          SgWhistleOptions(
            message: context.tx('Gerando relatório...'),
          ),
        );
        final pronto = context.tx('Relatório pronto');
        Future<void>.delayed(
          const Duration(seconds: 2),
          () => sgWhistle.update(
            id,
            SgWhistleCustomOptions(
              severity: SgWhistleSeverity.success,
              message: pronto,
            ),
          ),
        );
      },
    ),
    SgButton(
      label: Text(context.tx('Promise')),
      appearance: SgAppearance.outline,
      onClick: () => sgWhistle.promise<int>(
        Future<int>.delayed(const Duration(seconds: 2), () => 42),
        SgWhistlePromiseStates<int>(
          loading: SgWhistleOptions(
            message: context.tx('Calculando...'),
          ),
          success: (int v) =>
              SgWhistleOptions(message: 'Resultado: $v'),
          error: SgWhistleOptions(message: context.tx('Deu erro')),
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
      label: Text(context.tx('Padrão')),
      onClick: () => sgWhistle.show(
        SgWhistleOptions(message: context.tx('Aviso simples')),
      ),
    ),
    SgButton(
      label: Text(context.tx('Sucesso')),
      severity: SgSeverity.success,
      onClick: () => sgWhistle.success(
        SgWhistleOptions(
          title: context.tx('Salvo'),
          message: context.tx('As alterações foram gravadas.'),
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Info')),
      severity: SgSeverity.info,
      onClick: () => sgWhistle.info(
        SgWhistleOptions(
          message: context.tx('Há uma nova versão.'),
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Aviso')),
      severity: SgSeverity.warning,
      onClick: () => sgWhistle.warning(
        SgWhistleOptions(
          message: context.tx('Sessão perto de expirar.'),
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Erro')),
      severity: SgSeverity.danger,
      onClick: () => sgWhistle.error(
        SgWhistleOptions(
          title: context.tx('Falha'),
          message: context.tx('Não foi possível salvar.'),
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Limpar tudo')),
      appearance: SgAppearance.ghost,
      onClick: sgWhistle.dismiss,
    ),
  ],
)
''';
}
