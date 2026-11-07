// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_toaster_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgToasterPageSnippets {
  /// Region `sg-toaster-acoes`.
  static const String sgToasterAcoes = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    SgButton(
      label: Text(context.tx('Toast com ação')),
      severity: SgSeverity.warning,
      onClick: () => toast.warning(
        context.tx('Item arquivado'),
        SgToastOptions(
          description: context.tx('Clique em desfazer para restaurar.'),
          action: SgToastAction(
            label: context.tx('Desfazer'),
            onClick: () => toast.success(
              context.tx('Ação desfeita'),
              SgToastOptions(
                description: context.tx('O item voltou para a lista.'),
              ),
            ),
          ),
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Toast personalizado')),
      appearance: SgAppearance.outline,
      onClick: () => toast.custom(
        (String id) => Container(
          width: 280,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7F1),
            border: Border.all(color: const Color(0x80C56A2D)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tx('Toast personalizado'),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8F4B1F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.tx('Conteúdo renderizado via toast.custom(...)'),
                style: const TextStyle(color: Color(0xFF6B4B33)),
              ),
              const SizedBox(height: 8),
              SgButton(
                label: Text(context.tx('Fechar')),
                size: SgSize.sm,
                onClick: () => toast.dismiss(id),
              ),
            ],
          ),
        ),
        const SgToastOptions(duration: 8000, closeButton: false),
      ),
    ),
  ],
)
''';

  /// Region `sg-toaster-arredondados`.
  static const String sgToasterArredondados = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 16,
  children: [
    ValueListenableBuilder<bool>(
      valueListenable: _rounded,
      builder: (context, v, _) => FilterChip(
        label: Text(context.tx('rounded')),
        selected: v,
        onSelected: (value) => _rounded.value = value,
      ),
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _closeButton,
      builder: (context, v, _) => FilterChip(
        label: Text(context.tx('closeButton')),
        selected: v,
        onSelected: (value) => _closeButton.value = value,
      ),
    ),
    SgButton(
      label: Text(context.tx('Disparar')),
      onClick: () => toast.success(context.tx('Operação concluída')),
    ),
  ],
)
''';

  /// Region `sg-toaster-basico`.
  static const String sgToasterBasico = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    SgButton(
      label: Text('toast.message'),
      onClick: () => toast.message(context.tx('Mensagem básica')),
    ),
    SgButton(
      label: Text('toast.success'),
      severity: SgSeverity.success,
      onClick: () => toast.success(context.tx('Operação concluída')),
    ),
    SgButton(
      label: Text('toast.dismiss (all)'),
      appearance: SgAppearance.outline,
      onClick: toast.dismiss,
    ),
  ],
)
''';

  /// Region `sg-toaster-cores-personalizadas`.
  static const String sgToasterCoresPersonalizadas = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    ValueListenableBuilder<bool>(
      valueListenable: _richColors,
      builder: (context, v, _) => FilterChip(
        label: Text(context.tx('richColors')),
        selected: v,
        onSelected: (value) => _richColors.value = value,
      ),
    ),
    SgButton(
      label: Text(context.tx('Cores personalizadas')),
      severity: SgSeverity.success,
      onClick: () {
        _coresPersonalizadas.value = true;
        toast.success(context.tx('Operação concluída'));
      },
    ),
    SgButton(
      label: Text(context.tx('Cores padrão')),
      appearance: SgAppearance.outline,
      onClick: () {
        _coresPersonalizadas.value = false;
        toast.success(context.tx('Operação concluída'));
      },
    ),
  ],
)
''';

  /// Region `sg-toaster-fechar-por-codigo`.
  static const String sgToasterFecharPorCodigo = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    SgButton(
      label: Text(context.tx('Abrir toast')),
      onClick: () => toast.loading(context.tx('Processando lote...'), const SgToastOptions(id: 'lote')),
    ),
    SgButton(
      label: Text("dismissSgToast('lote')"),
      appearance: SgAppearance.outline,
      onClick: () => dismissSgToast('lote'),
    ),
    SgButton(
      label: Text('dismissSgToast()'),
      appearance: SgAppearance.outline,
      onClick: dismissSgToast,
    ),
  ],
)
''';

  /// Region `sg-toaster-loading-por-id`.
  static const String sgToasterLoadingPorId = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    SgButton(
      label: Text(context.tx('Iniciar loading')),
      onClick: () => _loadingId.value = toast.loading(
        context.tx('Processando lote...'),
        SgToastOptions(
          description: context.tx(
            'Este toast fica aberto até você atualizá-lo ou fechá-lo.',
          ),
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Concluir com sucesso')),
      severity: SgSeverity.success,
      onClick: () {
        final id = _loadingId.value;
        if (id == null) {
          toast.warning(context.tx('Nenhum loading ativo'));
          return;
        }
        toast.success(
          context.tx('Processamento concluído'),
          SgToastOptions(
            id: id,
            description: context.tx('Atualizado usando o mesmo id.'),
          ),
        );
        _loadingId.value = null;
      },
    ),
    SgButton(
      label: Text(context.tx('Concluir com erro')),
      severity: SgSeverity.danger,
      onClick: () {
        final id = _loadingId.value;
        if (id == null) {
          toast.warning(context.tx('Nenhum loading ativo'));
          return;
        }
        toast.error(
          context.tx('Processamento falhou'),
          SgToastOptions(
            id: id,
            description: context.tx('Loading atualizado para erro.'),
          ),
        );
        _loadingId.value = null;
      },
    ),
    SgButton(
      label: Text(context.tx('Limpar todos')),
      appearance: SgAppearance.outline,
      onClick: toast.dismiss,
    ),
    ValueListenableBuilder<String?>(
      valueListenable: _loadingId,
      builder: (context, id, _) => Text('loadingId: ${id ?? 'none'}'),
    ),
  ],
)
''';

  /// Region `sg-toaster-observar-a-fila`.
  static const String sgToasterObservarAFila = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    StreamBuilder<List<SgToastRecord>>(
      stream: Stream<List<SgToastRecord>>.multi((controller) {
        controller.onCancel = subscribeSgToasts(controller.add);
      }),
      builder: (context, snapshot) => Text(
        '${context.tx('Toasts abertos')}: ${snapshot.data?.length ?? 0}',
      ),
    ),
    SgButton(
      label: Text(context.tx('Abrir toast')),
      onClick: () => toast.message(context.tx('Mensagem básica')),
    ),
    SgButton(
      label: Text(context.tx('descartar todos')),
      appearance: SgAppearance.outline,
      onClick: toast.dismiss,
    ),
  ],
)
''';

  /// Region `sg-toaster-opcoes`.
  static const String sgToasterOpcoes = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    SgButton(
      label: Text(context.tx('Disparar toast com opções')),
      onClick: () => toast.info(
        context.tx('Toast com opções personalizadas'),
        SgToastOptions(
          description: context.tx('Duração de 10s, sem closeButton.'),
          duration: 10000,
          closeButton: false,
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('1 segundo')),
      appearance: SgAppearance.outline,
      onClick: () => toast('Rápido', const SgToastOptions(duration: 1000)),
    ),
    SgButton(
      label: Text(context.tx('Fixo (duration: 0)')),
      appearance: SgAppearance.outline,
      onClick: () => toast.info(
        'Fica até fechar',
        const SgToastOptions(duration: 0),
      ),
    ),
  ],
)
''';

  /// Region `sg-toaster-promise`.
  static const String sgToasterPromise = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    SgButton(
      label: Text(context.tx('Rodar demo de promise')),
      onClick: () async {
        final salvando = context.tx('Salvando pedido...');
        final salvo = context.tx('Pedido salvo');
        final falha = context.tx('Falha');
        try {
          await toast.promise<String>(
            Future<String>.delayed(const Duration(milliseconds: 1200), () {
              if (Random().nextDouble() < 0.35) {
                throw Exception('Random demo error');
              }
              return 'ORD-2026-001';
            }),
            SgToastPromiseMessages<String>(
              loading: salvando,
              success: (String id) => '$salvo: $id',
              error: (Object e) => '$falha: $e',
            ),
          );
        } catch (_) {
          // o erro já foi tratado pelo toast.promise
        }
      },
    ),
  ],
)
''';

  /// Region `sg-toaster-tipos`.
  static const String sgToasterTipos = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    SgButton(
      label: Text('default'),
      onClick: () => toast.message(context.tx('Mensagem neutra')),
    ),
    SgButton(
      label: Text('success'),
      severity: SgSeverity.success,
      onClick: () => toast.success(context.tx('Operação concluída')),
    ),
    SgButton(
      label: Text('info'),
      severity: SgSeverity.info,
      onClick: () => toast.info(context.tx('Informação importante')),
    ),
    SgButton(
      label: Text('warning'),
      severity: SgSeverity.warning,
      onClick: () => toast.warning(context.tx('Atenção no fluxo')),
    ),
    SgButton(
      label: Text('error'),
      severity: SgSeverity.danger,
      onClick: () => toast.error(context.tx('Falha ao salvar')),
    ),
    SgButton(
      label: Text('loading'),
      appearance: SgAppearance.outline,
      onClick: () => toast.loading(context.tx('Processando...')),
    ),
    SgButton(
      label: Text(context.tx('descartar todos')),
      appearance: SgAppearance.ghost,
      onClick: toast.dismiss,
    ),
  ],
)
''';

  /// Region `sg-toaster-transparencia`.
  static const String sgToasterTransparencia = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    SgButton(
      label: Text(context.tx('Com transparência (80%)')),
      severity: SgSeverity.success,
      onClick: () {
        _transparency.value = 80;
        toast.success(context.tx('Operação concluída'));
      },
    ),
    SgButton(
      label: Text(context.tx('Sem transparência')),
      appearance: SgAppearance.outline,
      onClick: () {
        _transparency.value = 0;
        toast.success(context.tx('Operação concluída'));
      },
    ),
    SgButton(
      label: Text(context.tx('descartar todos')),
      appearance: SgAppearance.ghost,
      onClick: toast.dismiss,
    ),
  ],
)
''';
}
