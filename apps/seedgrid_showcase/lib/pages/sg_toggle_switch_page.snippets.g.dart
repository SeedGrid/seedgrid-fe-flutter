// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_toggle_switch_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgToggleSwitchPageSnippets {
  /// Region `sg-toggle-switch-basico`.
  static const String sgToggleSwitchBasico = r'''
ValueListenableBuilder<bool>(
  valueListenable: _basico,
  builder: (context, v, _) => SgStack(
    gap: 12,
    align: SgStackAlign.start,
    children: [
      SgToggleSwitch(
        id: 'demo-basic',
        label: context.tx('Ativar notificações'),
        checked: v,
        onChange: (next) => _basico.value = next,
      ),
      Text('${context.tx('Valor atual')}: $v'),
    ],
  ),
)
''';

  /// Region `sg-toggle-switch-controlado`.
  static const String sgToggleSwitchControlado = r'''
ListenableBuilder(
  listenable: Listenable.merge([_externo, _capturado]),
  builder: (context, _) => SgStack(
    gap: 12,
    align: SgStackAlign.start,
    children: [
      SgToggleSwitch(
        id: 'demo-external',
        label: context.tx('Permitir sincronização'),
        checked: _externo.value,
        onChange: (next) {
          _externo.value = next;
          _capturado.value = 'onChange -> $next';
        },
        onIcon: const Icon(Icons.check, size: 12),
        offIcon: const Icon(Icons.close, size: 12),
      ),
      SgStack(
        direction: SgStackDirection.row,
        wrap: true,
        gap: 8,
        children: [
          SgButton(
            label: Text(context.tx('Setar true')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: () => _externo.value = true,
          ),
          SgButton(
            label: Text(context.tx('Setar false')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: () => _externo.value = false,
          ),
          SgButton(
            label: Text(context.tx('Toggle externo')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: () => _externo.value = !_externo.value,
          ),
          SgButton(
            label: Text(context.tx('Capturar agora')),
            size: SgSize.sm,
            appearance: SgAppearance.outline,
            onClick: () => _capturado.value =
                'captura manual -> ${_externo.value}',
          ),
        ],
      ),
      Text('value externo: ${_externo.value}'),
      Text('${context.tx('capturado')}: ${_capturado.value}'),
    ],
  ),
)
''';

  /// Region `sg-toggle-switch-erro-externo`.
  static const String sgToggleSwitchErroExterno = r'''
SgToggleSwitch(
  id: 'erro',
  label: context.tx('Aceito os termos'),
  error: context.tx('Aceite os termos para continuar'),
  width: 280,
)
''';

  /// Region `sg-toggle-switch-estados`.
  static const String sgToggleSwitchEstados = r'''
SgStack(
  direction: SgStackDirection.row,
  wrap: true,
  gap: 24,
  children: [
    SgToggleSwitch(
      id: 'demo-disabled',
      label: context.tx('Desabilitado'),
      checked: true,
      enabled: false,
      onIcon: const Icon(Icons.check, size: 12),
      offIcon: const Icon(Icons.close, size: 12),
    ),
    SgToggleSwitch(
      id: 'demo-readonly',
      label: context.tx('Somente leitura'),
      checked: false,
      readOnly: true,
      onIcon: const Icon(Icons.check, size: 12),
      offIcon: const Icon(Icons.close, size: 12),
    ),
  ],
)
''';

  /// Region `sg-toggle-switch-formulario`.
  static const String sgToggleSwitchFormulario = r'''
SgStack(
  gap: 12,
  align: SgStackAlign.start,
  children: [
    SgToggleSwitch(
      id: 'demo-rhf-notifications',
      name: 'notifications',
      control: _form,
      label: context.tx('Receber notificações por e-mail'),
    ),
    SgToggleSwitch(
      id: 'demo-rhf-control',
      name: 'active',
      control: _form,
      label: context.tx('Conta ativa'),
      onIcon: const Icon(Icons.check, size: 12),
      offIcon: const Icon(Icons.close, size: 12),
    ),
    SgButton(
      label: Text(context.tx('Enviar')),
      onClick: () => _form.handleSubmit(
        (values) => _enviado.value = jsonEncode(values),
      ),
    ),
    ListenableBuilder(
      listenable: Listenable.merge([_form, _enviado]),
      builder: (context, _) => SgStack(
        gap: 4,
        align: SgStackAlign.start,
        children: [
          Text(
            'watch.notifications: ${_form.getValue('notifications')}',
          ),
          Text('watch.active: ${_form.getValue('active')}'),
          Text(
            '${context.tx('Último envio')}: ${_enviado.value}',
          ),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-toggle-switch-icones`.
  static const String sgToggleSwitchIcones = r'''
ValueListenableBuilder<bool>(
  valueListenable: _icone,
  builder: (context, v, _) => SgStack(
    gap: 12,
    align: SgStackAlign.start,
    children: [
      SgToggleSwitch(
        id: 'demo-icons',
        label: context.tx('Status da conta'),
        checked: v,
        onChange: (next) => _icone.value = next,
        onIcon: const Icon(Icons.check, size: 12),
        offIcon: const Icon(Icons.close, size: 12),
      ),
      Text('${context.tx('Valor atual')}: $v'),
    ],
  ),
)
''';

  /// Region `sg-toggle-switch-remoto`.
  static const String sgToggleSwitchRemoto = r'''
ListenableBuilder(
  listenable: Listenable.merge([_remoto, _carregando, _log]),
  builder: (context, _) => SgStack(
    gap: 12,
    align: SgStackAlign.start,
    children: [
      SgToggleSwitch(
        id: 'demo-remote',
        label: _carregando.value
            ? context.tx('Salvando...')
            : context.tx('Publicar automaticamente'),
        checked: _remoto.value,
        enabled: !_carregando.value,
        onIcon: const Icon(Icons.check, size: 12),
        offIcon: const Icon(Icons.close, size: 12),
        onChange: (next) {
          _remoto.value = next;
          _carregando.value = true;
          Future<void>.delayed(
            const Duration(milliseconds: 450),
            () {
              if (!mounted) return;
              _log.value = ['value=$next', ..._log.value]
                  .take(8)
                  .toList();
              _carregando.value = false;
            },
          );
        },
      ),
      if (_log.value.isEmpty)
        Text(context.tx('Altere a chave para registrar eventos.'))
      else
        for (final entrada in _log.value) Text(entrada),
    ],
  ),
)
''';

  /// Region `sg-toggle-switch-validacao`.
  static const String sgToggleSwitchValidacao = r'''
SgStack(
  gap: 12,
  align: SgStackAlign.start,
  children: [
    SgToggleSwitch(
      id: 'termos',
      label: context.tx('Aceito os termos'),
      required: true,
      requiredMessage: context.tx('Aceite os termos para continuar'),
    ),
    SgToggleSwitch(
      id: 'regra',
      label: context.tx('Não pode ligar'),
      validateOnBlur: false,
      validation: (ligado) => ligado
          ? context.tx('Esta chave deve ficar desligada')
          : null,
    ),
  ],
)
''';
}
