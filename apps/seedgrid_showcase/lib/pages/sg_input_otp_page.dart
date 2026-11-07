// Showcase do SgInputOTP. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_input_otp_page.snippets.g.dart';

class SgInputOTPPage extends StatefulWidget {
  const SgInputOTPPage({super.key});

  @override
  State<SgInputOTPPage> createState() => _SgInputOTPPageState();
}

class _SgInputOTPPageState extends State<SgInputOTPPage> {
  final SgInputOTPController _controller = SgInputOTPController();
  final SgFormController _form = SgFormController();
  final ValueNotifier<String> _mascara1 = ValueNotifier<String>('');
  final ValueNotifier<String> _bruto1 = ValueNotifier<String>('');
  final ValueNotifier<String> _mascara2 = ValueNotifier<String>('');
  final ValueNotifier<String> _bruto2 = ValueNotifier<String>('');
  final ValueNotifier<String> _mascara3 = ValueNotifier<String>('');
  final ValueNotifier<String> _bruto3 = ValueNotifier<String>('');
  final ValueNotifier<String> _completo = ValueNotifier<String>('');
  final ValueNotifier<String?> _leitura = ValueNotifier<String?>(null);
  final ValueNotifier<String> _confirmado = ValueNotifier<String>('');

  @override
  void dispose() {
    _form.dispose();
    _mascara1.dispose();
    _bruto1.dispose();
    _mascara2.dispose();
    _bruto2.dispose();
    _mascara3.dispose();
    _bruto3.dispose();
    _completo.dispose();
    _leitura.dispose();
    _confirmado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Seis dígitos. Digitar avança, Backspace volta, setas movem, e colar o código inteiro distribui nos campos.',
        preview:
            // #region sg-input-otp-basico
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
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpBasico,
      ),
      ShowcaseExample(
        title: 'Máscara customizada',
        description:
            '9 = dígito, # = letra ou dígito, qualquer outro caractere é separador. '
            'onChange recebe o valor com separador e onRawChange, sem.',
        preview:
            // #region sg-input-otp-mascara
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
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpMascara,
      ),
      ShowcaseExample(
        title: 'Colagem + onComplete',
        description: 'Cole um OTP e receba callback ao completar.',
        preview:
            // #region sg-input-otp-colagem
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
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpColagem,
      ),
      ShowcaseExample(
        title: 'Acesso por ref ou controller',
        description:
            'O SgInputOTPController faz o papel do ref do React: focus, clear, getRawValue e getMaskedValue.',
        preview:
            // #region sg-input-otp-controller
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
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpController,
      ),
      ShowcaseExample(
        title: 'Validação',
        description:
            'Obrigatório e validação própria (recebe o valor sem e com separador). A mensagem aparece ao sair do campo.',
        preview:
            // #region sg-input-otp-validacao
            SgInputOTP(
              id: 'otp-validation',
              label: context.tx('Código de convite'),
              mask: '99-99',
              required: true,
              requiredMessage: context.tx('Informe o código.'),
              validation: (raw, masked) => raw.length < 4
                  ? context.tx('O código tem 4 dígitos.')
                  : null,
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpValidacao,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'O formulário guarda o valor sem separador.',
        preview:
            // #region sg-input-otp-formulario
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
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpFormulario,
      ),
      ShowcaseExample(
        title: 'Estados',
        description: 'Erro externo, desabilitado e somente leitura.',
        preview:
            // #region sg-input-otp-estados
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
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpEstados,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputOTP',
      description:
          'Campo de código de uso único com vários campos: máscara, colar o código inteiro, '
          'conclusão, validação, controller e ligação a formulário.',
      examples: examples,
      propSpecs: sgPropSpecs['SgInputOTP']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputOTP']!
            .where(
              (s) => const {
                'mask',
                'label',
                'hintText',
                'enabled',
                'readOnly',
                'required',
                'validateOnBlur',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputOTP(
          id: 'pg',
          mask: v['mask'] as String?,
          label: v['label'] as String?,
          hintText: v['hintText'] as String?,
          enabled: v['enabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          required: v['required'] as bool?,
          validateOnBlur: v['validateOnBlur'] as bool?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) {
              continue;
            }
            args.add(
              e.value is String
                  ? "${e.key}: '${e.value}'"
                  : '${e.key}: ${e.value}',
            );
          }
          return 'SgInputOTP(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
