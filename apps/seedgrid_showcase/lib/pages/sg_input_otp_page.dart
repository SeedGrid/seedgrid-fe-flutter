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
  String _concluido = '';
  final SgInputOTPController _controller = SgInputOTPController();
  final SgFormController _form = SgFormController();
  String _enviado = '';

  @override
  void dispose() {
    _form.dispose();
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
                  id: 'basico',
                  label: context.tx('Código de verificação'),
                  hintText: 'Enviamos 6 dígitos por SMS.',
                  onComplete: (v) => setState(() => _concluido = v),
                ),
                if (_concluido.isNotEmpty) Text('Código completo: $_concluido'),
              ],
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpBasico,
      ),
      ShowcaseExample(
        title: 'Máscara com separador',
        description:
            '9 = dígito, # = letra ou dígito, qualquer outro caractere é separador. '
            'onChange recebe o valor com separador e onRawChange, sem.',
        preview:
            // #region sg-input-otp-mascara
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
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpMascara,
      ),
      ShowcaseExample(
        title: 'Validação',
        description:
            'Obrigatório e validação própria (recebe o valor sem e com separador). A mensagem aparece ao sair do campo.',
        preview:
            // #region sg-input-otp-validacao
            SgInputOTP(
              id: 'validacao',
              label: context.tx('Código de convite'),
              mask: '99-99',
              required: true,
              requiredMessage: 'Informe o código.',
              validation: (raw, masked) =>
                  raw.length < 4 ? 'O código tem 4 dígitos.' : null,
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpValidacao,
      ),
      ShowcaseExample(
        title: 'Controller (ref)',
        description:
            'O SgInputOTPController faz o papel do ref do React: focus, clear, getRawValue e getMaskedValue.',
        preview:
            // #region sg-input-otp-controller
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
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpController,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control (equivale ao useForm do react-hook-form). O formulário guarda o valor sem separador.',
        preview:
            // #region sg-input-otp-formulario
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
            ),
        // #endregion
        code: SgInputOtpPageSnippets.sgInputOtpFormulario,
      ),
      ShowcaseExample(
        title: 'Estados',
        preview:
            // #region sg-input-otp-estados
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
                'disabled',
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
          disabled: v['disabled'] as bool?,
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
