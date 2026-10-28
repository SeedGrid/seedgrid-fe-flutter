// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_toaster_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgToasterPageSnippets {
  /// Region `sg-toaster-acao`.
  static const String sgToasterAcao = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(
      label: Text(context.tx('Com ação')),
      onClick: () => toast(
        'Item removido',
        SgToastOptions(
          action: SgToastAction(
            label: context.tx('Desfazer'),
            onClick: () => toast.success('Restaurado'),
          ),
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Sem botão de fechar')),
      appearance: SgAppearance.outline,
      onClick: () => toast(
        'Sem x',
        const SgToastOptions(closeButton: false, duration: 2500),
      ),
    ),
  ],
)
''';

  /// Region `sg-toaster-aparencia`.
  static const String sgToasterAparencia = r'''
Wrap(
  spacing: 16,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    FilterChip(
      label: Text(context.tx('richColors')),
      selected: _richColors,
      onSelected: (v) => setState(() => _richColors = v),
    ),
    FilterChip(
      label: Text(context.tx('rounded')),
      selected: _rounded,
      onSelected: (v) => setState(() => _rounded = v),
    ),
    FilterChip(
      label: Text(context.tx('closeButton')),
      selected: _closeButton,
      onSelected: (v) => setState(() => _closeButton = v),
    ),
    SgButton(
      label: Text(context.tx('Disparar')),
      onClick: () => toast.success(
        'Toast de teste',
        SgToastOptions(
          description: context.tx('Veja as cores e os cantos.'),
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-toaster-duracao`.
  static const String sgToasterDuracao = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(
      label: Text(context.tx('1 segundo')),
      onClick: () =>
          toast('Rápido', const SgToastOptions(duration: 1000)),
    ),
    SgButton(
      label: Text(context.tx('8 segundos')),
      onClick: () =>
          toast('Devagar', const SgToastOptions(duration: 8000)),
    ),
    SgButton(
      label: Text(context.tx('Fixo')),
      onClick: () => toast.info(
        'Fica até fechar',
        const SgToastOptions(duration: 0),
      ),
    ),
  ],
)
''';

  /// Region `sg-toaster-tipos`.
  static const String sgToasterTipos = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(
      label: Text(context.tx('Padrão')),
      onClick: () => toast('Mensagem simples'),
    ),
    SgButton(
      label: Text(context.tx('Sucesso')),
      severity: SgSeverity.success,
      onClick: () => toast.success(
        'Salvo!',
        SgToastOptions(
          description: context.tx('As alterações foram gravadas.'),
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Info')),
      severity: SgSeverity.info,
      onClick: () => toast.info('Nova versão disponível'),
    ),
    SgButton(
      label: Text(context.tx('Aviso')),
      severity: SgSeverity.warning,
      onClick: () => toast.warning('Sessão expira em 5 minutos'),
    ),
    SgButton(
      label: Text(context.tx('Erro')),
      severity: SgSeverity.danger,
      onClick: () => toast.error('Falha ao salvar'),
    ),
    SgButton(
      label: Text(context.tx('Carregando')),
      severity: SgSeverity.secondary,
      onClick: () => toast.loading(
        'Processando...',
        const SgToastOptions(id: 'processando'),
      ),
    ),
    SgButton(
      label: Text(context.tx('Promise')),
      appearance: SgAppearance.outline,
      onClick: () => toast.promise<String>(
        Future<String>.delayed(
          const Duration(seconds: 2),
          () => 'ok',
        ),
        SgToastPromiseMessages<String>(
          loading: 'Enviando...',
          success: (String v) => 'Enviado: $v',
          error: 'Não foi possível enviar',
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Limpar tudo')),
      appearance: SgAppearance.ghost,
      onClick: toast.dismiss,
    ),
  ],
)
''';
}
