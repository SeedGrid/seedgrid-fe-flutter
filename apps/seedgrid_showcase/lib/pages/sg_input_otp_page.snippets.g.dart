// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_otp_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputOtpPageSnippets {
  /// Region `sg-input-otp-basico`.
  static const String sgInputOtpBasico = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputOTP(
      id: 'basico',
      label: context.tx('Código de verificação'),
      hintText: 'Enviamos 6 dígitos por SMS.',
      onComplete: (v) => setState(() => _concluido = v),
    ),
    if (_concluido.isNotEmpty) Text('Código completo: $_concluido'),
  ],
)
''';

  /// Region `sg-input-otp-controller`.
  static const String sgInputOtpController = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputOTP(
      id: 'ctrl',
      mask: '99-99',
      defaultValue: '1234',
      controller: _controller,
    ),
    const SizedBox(height: 12),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SgButton(
          label: Text(context.tx('Focar o 3º')),
          size: SgSize.sm,
          onClick: () => _controller.focus(2),
        ),
        SgButton(
          label: Text(context.tx('Limpar')),
          size: SgSize.sm,
          severity: SgSeverity.secondary,
          onClick: _controller.clear,
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-input-otp-estados`.
  static const String sgInputOtpEstados = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputOTP(
      id: 'erro',
      label: context.tx('Com erro'),
      mask: '9999',
      defaultValue: '1234',
      error: 'Código expirado.',
    ),
    SizedBox(height: 16),
    SgInputOTP(
      id: 'desab',
      label: context.tx('Desabilitado'),
      mask: '9999',
      defaultValue: '12',
      disabled: true,
    ),
    SizedBox(height: 16),
    SgInputOTP(
      id: 'leitura',
      label: context.tx('Somente leitura'),
      mask: '9999',
      defaultValue: '9876',
      readOnly: true,
    ),
  ],
)
''';

  /// Region `sg-input-otp-formulario`.
  static const String sgInputOtpFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputOTP(
      id: 'form',
      name: 'codigo',
      control: _form,
      label: context.tx('Código'),
      mask: '9999',
      required: true,
      requiredMessage: 'Informe o código.',
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Confirmar')),
      onClick: () => _form.handleSubmit(
        (values) =>
            setState(() => _enviado = '${values['codigo']}'),
      ),
    ),
    if (_enviado.isNotEmpty) Text('Confirmado: $_enviado'),
  ],
)
''';

  /// Region `sg-input-otp-mascara`.
  static const String sgInputOtpMascara = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputOTP(
      id: 'sep',
      label: context.tx('Dígitos'),
      mask: '999-999',
    ),
    SizedBox(height: 16),
    SgInputOTP(
      id: 'alfa',
      label: context.tx('Alfanumérico'),
      mask: '##-##-##',
    ),
  ],
)
''';

  /// Region `sg-input-otp-validacao`.
  static const String sgInputOtpValidacao = r'''
SgInputOTP(
  id: 'validacao',
  label: context.tx('Código de convite'),
  mask: '99-99',
  required: true,
  requiredMessage: 'Informe o código.',
  validation: (raw, masked) =>
      raw.length < 4 ? 'O código tem 4 dígitos.' : null,
)
''';
}
