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
