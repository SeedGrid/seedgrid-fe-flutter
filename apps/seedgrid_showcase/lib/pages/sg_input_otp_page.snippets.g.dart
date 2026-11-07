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
      id: 'otp-basic',
      label: context.tx('Código OTP'),
      hintText: context.tx('Digite os 6 dígitos'),
      onChange: (value) => _mascara1.value = value,
      onRawChange: (value) => _bruto1.value = value,
    ),
    const SizedBox(height: 12),
    ListenableBuilder(
      listenable: Listenable.merge([_mascara1, _bruto1]),
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'masked: ${_mascara1.value.isEmpty ? context.tx('(vazio)') : _mascara1.value}',
          ),
          Text(
            'raw: ${_bruto1.value.isEmpty ? context.tx('(vazio)') : _bruto1.value}',
          ),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-input-otp-colagem`.
  static const String sgInputOtpColagem = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputOTP(
      id: 'otp-paste',
      label: context.tx('Cole o código'),
      hintText: context.tx('Teste colando: "AB1-CD2-34"'),
      mask: '###-###-99',
      onChange: (value) => _mascara3.value = value,
      onRawChange: (value) => _bruto3.value = value,
      onComplete: (value) => _completo.value = value,
    ),
    const SizedBox(height: 12),
    ListenableBuilder(
      listenable: Listenable.merge([_mascara3, _bruto3, _completo]),
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'masked: ${_mascara3.value.isEmpty ? context.tx('(vazio)') : _mascara3.value}',
          ),
          Text(
            'raw: ${_bruto3.value.isEmpty ? context.tx('(vazio)') : _bruto3.value}',
          ),
          Text(
            'onComplete: ${_completo.value.isEmpty ? context.tx('(aguardando)') : _completo.value}',
          ),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-input-otp-controller`.
  static const String sgInputOtpController = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputOTP(
      id: 'otp-ref',
      label: context.tx('OTP por controle'),
      hintText: context.tx('Use os botões abaixo'),
      mask: '###-###-99',
      controller: _controller,
    ),
    const SizedBox(height: 12),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SgButton(
          label: Text(context.tx('Focar')),
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          onClick: _controller.focus,
        ),
        SgButton(
          label: Text(context.tx('Limpar')),
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          onClick: _controller.clear,
        ),
        SgButton(
          label: Text(context.tx('Ler conteúdo')),
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          onClick: () {
            final masked = _controller.getMaskedValue();
            final raw = _controller.getRawValue();
            _leitura.value =
                'masked="${masked.isEmpty ? context.tx('(vazio)') : masked}" | raw="${raw.isEmpty ? context.tx('(vazio)') : raw}"';
          },
        ),
      ],
    ),
    const SizedBox(height: 12),
    ValueListenableBuilder<String?>(
      valueListenable: _leitura,
      builder: (context, leitura, _) => Text(
        '${context.tx('saída')}: ${leitura ?? context.tx('Clique em "Ler conteúdo".')}',
      ),
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
      id: 'otp-error',
      label: context.tx('Com erro'),
      mask: '9999',
      defaultValue: '1234',
      error: context.tx('Código expirado.'),
    ),
    const SizedBox(height: 16),
    SgInputOTP(
      id: 'otp-disabled',
      label: context.tx('Desabilitado'),
      mask: '9999',
      defaultValue: '12',
      enabled: false,
    ),
    const SizedBox(height: 16),
    SgInputOTP(
      id: 'otp-readonly',
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
      id: 'otp-form',
      name: 'codigo',
      control: _form,
      label: context.tx('Código'),
      mask: '9999',
      required: true,
      requiredMessage: context.tx('Informe o código.'),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Confirmar')),
      onClick: () => _form.handleSubmit(
        (values) => _confirmado.value = '${values['codigo']}',
      ),
    ),
    ValueListenableBuilder<String>(
      valueListenable: _confirmado,
      builder: (context, confirmado, _) => confirmado.isEmpty
          ? const SizedBox.shrink()
          : Text(
              context.txf('Confirmado: {valor}', {
                'valor': confirmado,
              }),
            ),
    ),
  ],
)
''';

  /// Region `sg-input-otp-mascara`.
  static const String sgInputOtpMascara = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgInputOTP(
      id: 'otp-mask',
      label: context.tx('Token de acesso'),
      hintText: context.tx('Formato: ###-###-99'),
      mask: '###-###-99',
      onChange: (value) => _mascara2.value = value,
      onRawChange: (value) => _bruto2.value = value,
    ),
    const SizedBox(height: 12),
    ListenableBuilder(
      listenable: Listenable.merge([_mascara2, _bruto2]),
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'masked: ${_mascara2.value.isEmpty ? context.tx('(vazio)') : _mascara2.value}',
          ),
          Text(
            'raw: ${_bruto2.value.isEmpty ? context.tx('(vazio)') : _bruto2.value}',
          ),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-input-otp-validacao`.
  static const String sgInputOtpValidacao = r'''
SgInputOTP(
  id: 'otp-validation',
  label: context.tx('Código de convite'),
  mask: '99-99',
  required: true,
  requiredMessage: context.tx('Informe o código.'),
  validation: (raw, masked) => raw.length < 4
      ? context.tx('O código tem 4 dígitos.')
      : null,
)
''';
}
