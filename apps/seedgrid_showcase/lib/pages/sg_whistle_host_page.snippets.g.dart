// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_whistle_host_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgWhistleHostPageSnippets {
  /// Region `sg-whistle-host-acoes`.
  static const String sgWhistleHostAcoes = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  gap: 8,
  children: [
    SgButton(
      label: Text(context.tx('Ação + desfazer')),
      severity: SgSeverity.warning,
      onClick: () => sgWhistle.warning(
        SgWhistleOptions(
          title: context.tx('Seção arquivada'),
          message: context.tx('A ação é reversível por alguns segundos.'),
          borderStyle: SgWhistleBorderStyle.leftAccent,
          opacity: 0.96,
          action: SgWhistleAction(
            label: context.tx('Desfazer'),
            onClick: () => sgWhistle.success(
              SgWhistleOptions(
                title: context.tx('Desfazer aplicado'),
                message: context.tx('A seção arquivada voltou para a lista ativa.'),
                borderStyle: SgWhistleBorderStyle.soft,
              ),
            ),
          ),
        ),
      ),
    ),
    for (final style in SgWhistleBorderStyle.values)
      SgButton(
        label: Text(style.value),
        appearance: SgAppearance.outline,
        onClick: () => sgWhistle.info(
          SgWhistleOptions(
            title: context.txf('Estilo de borda: {style}', {'style': style.value}),
            message: context.tx(
              'Use borderStyle e opacity para ênfase contextual sem sair do fluxo do layout.',
            ),
            borderStyle: style,
            opacity: style == SgWhistleBorderStyle.none ? 0.88 : 1,
          ),
        ),
      ),
  ],
)
''';

  /// Region `sg-whistle-host-atualizar`.
  static const String sgWhistleHostAtualizar = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    SgButton(
      label: Text(context.tx('Iniciar carregamento')),
      onClick: () => _activeId.value = sgWhistle.loading(
        SgWhistleOptions(
          title: context.tx('Sincronizando'),
          message: context.tx(
            'O mesmo id de whistle será atualizado quando a requisição terminar.',
          ),
          borderStyle: SgWhistleBorderStyle.leftAccent,
          dismissible: false,
        ),
      ),
    ),
    for (final ok in [true, false])
      SgButton(
        label: ok
            ? Text(context.tx('Concluir com sucesso'))
            : Text(context.tx('Concluir com erro')),
        severity: ok ? SgSeverity.success : SgSeverity.danger,
        onClick: () {
          final id = _activeId.value;
          if (id == null) {
            sgWhistle.warning(
              SgWhistleOptions(
                title: context.tx('Nenhum loading ativo'),
                message: context.tx(
                  'Inicie um whistle de loading antes de tentar atualizá-lo.',
                ),
              ),
            );
            return;
          }
          sgWhistle.update(
            id,
            SgWhistleCustomOptions(
              severity: ok
                  ? SgWhistleSeverity.success
                  : SgWhistleSeverity.error,
              title: ok
                  ? context.tx('Sincronização concluída')
                  : context.tx('Sincronização falhou'),
              message: ok
                  ? context.tx('O whistle de loading foi atualizado no lugar.')
                  : context.tx(
                      'O mesmo id de whistle agora renderiza o estado de erro.',
                    ),
              dismissible: true,
              duration: 5000,
            ),
          );
          _activeId.value = null;
        },
      ),
    SgButton(
      label: Text(context.tx('Descartar ativo')),
      appearance: SgAppearance.outline,
      onClick: () {
        final id = _activeId.value;
        if (id != null) sgWhistle.dismiss(id);
      },
    ),
    ValueListenableBuilder<String?>(
      valueListenable: _activeId,
      builder: (context, id, _) => Text('activeId: ${id ?? 'none'}'),
    ),
  ],
)
''';

  /// Region `sg-whistle-host-basico`.
  static const String sgWhistleHostBasico = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  gap: 8,
  children: [
  SgButton(
    label: const Text('sgWhistle.show'),
    onClick: () => sgWhistle.show(
    SgWhistleOptions(
      title: context.tx('Exemplo base'),
      message: context.tx('Um whistle padrão apareceu no rodapé da página.'),
    ),
  ),
  ),
  SgButton(
    label: const Text('sgWhistle.success'),
    severity: SgSeverity.success,
    onClick: () => sgWhistle.success(
    SgWhistleOptions(
      title: context.tx('Salvo'),
      message: context.tx('Esta mensagem permaneceu no fluxo do documento.'),
    ),
  ),
  ),
  SgButton(
    label: const Text('sgWhistle.dismiss'),
    appearance: SgAppearance.outline,
    onClick: sgWhistle.dismiss,
  ),
  ],
)
''';

  /// Region `sg-whistle-host-custom`.
  static const String sgWhistleHostCustom = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  gap: 8,
  children: [
    SgButton(
      label: Text(context.tx('Whistle personalizado')),
      onClick: () => sgWhistle.custom(
        (String id) => SgStack(
          gap: 8,
          children: [
            Text(
              context.tx('Renderizador personalizado'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              context.tx(
                'Este whistle renderiza JSX arbitrário e ainda usa o mesmo ciclo de vida imperativo.',
              ),
            ),
            SgStack(
              direction: SgStackDirection.row,
              wrap: true,
              gap: 8,
              children: [
                SgButton(
                  label: Text(context.tx('Fechar')),
                  size: SgSize.sm,
                  onClick: () => sgWhistle.dismiss(id),
                ),
                SgButton(
                  label: Text(context.tx('Escalar')),
                  size: SgSize.sm,
                  appearance: SgAppearance.outline,
                  onClick: () {
                    sgWhistle.dismiss(id);
                    sgWhistle.success(
                      SgWhistleOptions(
                        title: context.tx('Escalado'),
                        message: context.tx(
                          'O whistle personalizado disparou uma ação de acompanhamento.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        const SgWhistleCustomOptions(
          message: 'custom',
          duration: 0,
          dismissible: false,
          borderStyle: SgWhistleBorderStyle.fullAccent,
        ),
      ),
    ),
    SgButton(
      label: Text(context.tx('Alternar paleta do host')),
      appearance: SgAppearance.outline,
      onClick: () => _warm.value = !_warm.value,
    ),
  ],
)
''';

  /// Region `sg-whistle-host-prevalece`.
  static const String sgWhistleHostPrevalece = r'''
SgStack(
  gap: 8,
  align: SgStackAlign.start,
  children: [
    SgButton(
      label: Text(context.tx('Disparar')),
      onClick: () => sgWhistle.info(
        SgWhistleOptions(message: context.tx('Só aparece no host')),
      ),
    ),
    const SgWhistler(),
  ],
)
''';

  /// Region `sg-whistle-host-promise`.
  static const String sgWhistleHostPromise = r'''
SgButton(
  label: Text(context.tx('Rodar demo de promise')),
  onClick: () async {
    final enviando = context.tx('Enviando relatório');
    final aguardando = context.tx('Aguardando o servidor...');
    final enviado = context.tx('Relatório enviado');
    final falhou = context.tx('Envio falhou');
    try {
      await sgWhistle.promise<String>(
        () async {
          await Future<void>.delayed(const Duration(milliseconds: 1200));
          if (Random().nextDouble() < 0.35) {
            throw Exception('simulated network error');
          }
          return 'SG-2026-031';
        },
        SgWhistlePromiseStates<String>(
          loading: SgWhistleOptions(title: enviando, message: aguardando),
          success: (String protocolo) => SgWhistleOptions(
            title: enviado,
            message: context.txf('Protocolo {protocol} gerado com sucesso.', {
              'protocol': protocolo,
            }),
            borderStyle: SgWhistleBorderStyle.soft,
          ),
          error: (Object erro) => SgWhistleOptions(
            title: falhou,
            message: erro.toString(),
            borderStyle: SgWhistleBorderStyle.fullAccent,
          ),
        ),
      );
    } catch (_) {
      // o erro ja foi mostrado pelo sgWhistle.promise
    }
  },
)
''';

  /// Region `sg-whistle-host-severidades`.
  static const String sgWhistleHostSeveridades = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  gap: 8,
  children: [
  SgButton(
    label: const Text('default'),
    onClick: () => sgWhistle.show(
    SgWhistleOptions(
      title: context.tx('Nota de contexto'),
      message: context.tx('Feedback inline renderizado dentro do fluxo do layout.'),
      duration: 5000,
    ),
  ),
  ),
  SgButton(
    label: const Text('success'),
    severity: SgSeverity.success,
    onClick: () => sgWhistle.success(
    SgWhistleOptions(
      title: context.tx('Salvo'),
      message: context.tx('O registro foi persistido com sucesso.'),
      duration: 5000,
    ),
  ),
  ),
  SgButton(
    label: const Text('info'),
    severity: SgSeverity.info,
    onClick: () => sgWhistle.info(
    SgWhistleOptions(
      title: context.tx('Atenção'),
      message: context.tx('Esta seção pode mostrar progresso ou dicas contextuais.'),
      duration: 5000,
    ),
  ),
  ),
  SgButton(
    label: const Text('warning'),
    severity: SgSeverity.warning,
    onClick: () => sgWhistle.warning(
    SgWhistleOptions(
      title: context.tx('Revisão pendente'),
      message: context.tx('A ação precisa de confirmação antes de continuar.'),
      duration: 5000,
    ),
  ),
  ),
  SgButton(
    label: const Text('error'),
    severity: SgSeverity.danger,
    onClick: () => sgWhistle.error(
    SgWhistleOptions(
      title: context.tx('Ação falhou'),
      message: context.tx('A requisição retornou um erro e precisa de atenção.'),
      duration: 5000,
    ),
  ),
  ),
  SgButton(
    label: const Text('loading'),
    appearance: SgAppearance.outline,
    onClick: () => sgWhistle.loading(
    SgWhistleOptions(
      title: context.tx('Processando...'),
      message: context.tx('Processando sem bloquear o layout da página.'),
      duration: 0,
    ),
  ),
  ),
  ],
)
''';

  /// Region `sg-whistle-host-varios`.
  static const String sgWhistleHostVarios = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  align: SgStackAlign.center,
  gap: 8,
  children: [
    ValueListenableBuilder<bool>(
      valueListenable: _extraHost,
      builder: (context, ativo, _) => SgButton(
        label: Text('${context.tx('Segundo host (cantos retos)')}: $ativo'),
        appearance: SgAppearance.outline,
        onClick: () => _extraHost.value = !ativo,
      ),
    ),
    SgButton(
      label: Text(context.tx('Disparar')),
      onClick: () => sgWhistle.warning(
        SgWhistleOptions(
          message: context.tx('Quem está ativo?'),
          duration: 3000,
        ),
      ),
    ),
  ],
)
''';
}
