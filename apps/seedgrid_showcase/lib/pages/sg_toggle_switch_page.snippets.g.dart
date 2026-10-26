// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_toggle_switch_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgToggleSwitchPageSnippets {
  /// Region `sg-toggle-switch-basico`.
  static const String sgToggleSwitchBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgToggleSwitch(
      id: 'notificar',
      label: 'Receber notificações',
      description: 'Avisos por e-mail',
      onChange: (v) => setState(() => _ligado = v),
    ),
    Text('Estado: ${_ligado ? 'ligado' : 'desligado'}'),
  ],
)
''';

  /// Region `sg-toggle-switch-controlado`.
  static const String sgToggleSwitchControlado = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgToggleSwitch(
      id: 'controlado',
      label: 'Modo escuro',
      checked: _controlado,
      onChange: (v) => setState(() => _controlado = v),
    ),
    const SizedBox(height: 8),
    SgButton(
      label: const Text('Inverter por código'),
      onClick: () => setState(() => _controlado = !_controlado),
    ),
    Text('Valor: $_controlado'),
  ],
)
''';

  /// Region `sg-toggle-switch-erro-externo`.
  static const String sgToggleSwitchErroExterno = r'''
const SgToggleSwitch(
  id: 'erro',
  label: 'Aceito os termos',
  error: 'Aceite os termos para continuar',
  width: 280,
)
''';

  /// Region `sg-toggle-switch-estados`.
  static const String sgToggleSwitchEstados = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgToggleSwitch(
      id: 'icones',
      label: 'Com ícones',
      defaultChecked: true,
      onIcon: Icon(Icons.check, size: 12),
      offIcon: Icon(Icons.close, size: 12),
    ),
    SizedBox(height: 12),
    SgToggleSwitch(
      id: 'leitura',
      label: 'readOnly',
      readOnly: true,
      defaultChecked: true,
    ),
    SizedBox(height: 12),
    SgToggleSwitch(id: 'off', label: 'disabled', disabled: true),
  ],
)
''';

  /// Region `sg-toggle-switch-formulario`.
  static const String sgToggleSwitchFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgToggleSwitch(
      id: 'newsletter',
      name: 'newsletter',
      control: _form,
      label: 'Assinar a newsletter',
      required: true,
      requiredMessage: 'Marque para assinar',
    ),
    const SizedBox(height: 12),
    SgButton(
      label: const Text('Enviar'),
      onClick: () => _form.handleSubmit(
        (values) =>
            setState(() => _enviado = '${values['newsletter']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
  ],
)
''';

  /// Region `sg-toggle-switch-remoto`.
  static const String sgToggleSwitchRemoto = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgToggleSwitch(
      id: 'remoto',
      label: 'Sincronizar',
      checked: _remoto,
      disabled: _salvando,
      onChange: (v) async {
        setState(() => _salvando = true);
        await Future<void>.delayed(
          const Duration(milliseconds: 800),
        );
        if (!mounted) return;
        setState(() {
          _remoto = v;
          _salvando = false;
        });
      },
    ),
    Text(_salvando ? 'Salvando...' : 'Salvo: $_remoto'),
  ],
)
''';

  /// Region `sg-toggle-switch-validacao`.
  static const String sgToggleSwitchValidacao = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SgToggleSwitch(
      id: 'termos',
      label: 'Aceito os termos',
      required: true,
      requiredMessage: 'Aceite os termos para continuar',
    ),
    const SizedBox(height: 12),
    SgToggleSwitch(
      id: 'regra',
      label: 'Não pode ligar',
      validateOnBlur: false,
      validation: (ligado) =>
          ligado ? 'Esta chave deve ficar desligada' : null,
    ),
  ],
)
''';
}
