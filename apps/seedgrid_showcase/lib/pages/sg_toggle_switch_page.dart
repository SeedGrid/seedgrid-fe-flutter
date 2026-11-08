// Showcase do SgToggleSwitch. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_toggle_switch_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';

class SgToggleSwitchPage extends StatefulWidget {
  const SgToggleSwitchPage({super.key});

  @override
  State<SgToggleSwitchPage> createState() => _SgToggleSwitchPageState();
}

class _SgToggleSwitchPageState extends State<SgToggleSwitchPage> {
  final ValueNotifier<bool> _basico = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _icone = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _remoto = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _carregando = ValueNotifier<bool>(false);
  final ValueNotifier<List<String>> _log = ValueNotifier<List<String>>([]);
  final ValueNotifier<bool> _externo = ValueNotifier<bool>(false);
  final ValueNotifier<String> _capturado = ValueNotifier<String>(
    '(sem evento)',
  );
  final ValueNotifier<String> _enviado = ValueNotifier<String>('-');
  final SgFormController _form = SgFormController(
    defaultValues: {'notifications': false, 'active': true},
  );

  @override
  void dispose() {
    _form.dispose();
    for (final n in [
      _basico,
      _icone,
      _remoto,
      _carregando,
      _log,
      _externo,
      _capturado,
      _enviado,
    ]) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Exemplo simples controlado por estado; clique no rótulo ou na chave (Tab foca e Espaço alterna).',
        preview:
            // #region sg-toggle-switch-basico
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
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchBasico,
      ),
      ShowcaseExample(
        title: 'Com ícones (on/off)',
        description:
            'Variação visual com ícones dentro do thumb para indicar ligado e desligado.',
        preview:
            // #region sg-toggle-switch-icones
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
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchIcones,
      ),
      ShowcaseExample(
        title: 'Atualização remota',
        description:
            'Ao alterar a chave, simulamos uma atualização remota para representar um fluxo comum de persistência.',
        preview:
            // #region sg-toggle-switch-remoto
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
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchRemoto,
      ),
      ShowcaseExample(
        title: 'Controlado externamente + captura do valor',
        description: 'Valor controlado por estado externo e captura via onChange.',
        preview:
            // #region sg-toggle-switch-controlado
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
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchControlado,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'Ligado ao formulário por name + control; o valor sai no envio.',
        preview:
            // #region sg-toggle-switch-formulario
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
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchFormulario,
      ),
      ShowcaseExample(
        title: 'Desabilitado e somente leitura',
        description: 'Demonstra os estados enabled: false e readOnly.',
        preview:
            // #region sg-toggle-switch-estados
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
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchEstados,
      ),
      ShowcaseExample(
        title: 'Validação',
        description:
            'required valida ao sair do campo (validateOnBlur) ou a cada mudança (validateOnBlur: false).',
        preview:
            // #region sg-toggle-switch-validacao
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
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchValidacao,
      ),
      ShowcaseExample(
        title: 'Erro externo e largura',
        description:
            'error mostra uma mensagem vinda de fora; width limita a largura do componente.',
        preview:
            // #region sg-toggle-switch-erro-externo
            SgToggleSwitch(
              id: 'erro',
              label: context.tx('Aceito os termos'),
              error: context.tx('Aceite os termos para continuar'),
              width: 280,
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchErroExterno,
      ),
      ShowcaseExample(
        title: 'Estado inicial (defaultChecked)',
        description:
            'defaultChecked define o estado inicial; depois disso a chave controla a si mesma (modo não controlado).',
        preview:
            // #region sg-toggle-switch-estado-inicial
            SgToggleSwitch(
              id: 'demo-default',
              label: context.tx('Receber novidades'),
              defaultChecked: true,
            ),
        // #endregion
        code: SgToggleSwitchPageSnippets.sgToggleSwitchEstadoInicial,
      ),
    ];

    return SgShowcasePage(
      name: 'SgToggleSwitch',
      description:
          'Chave liga/desliga com rótulo, descrição, ícones, validação e ligação a formulário. SgSwitch é um alias.',
      examples: examples,
      propSpecs: sgPropSpecs['SgToggleSwitch']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgToggleSwitch']!
            .where(
              (s) => const {
                'label',
                'description',
                'enabled',
                'readOnly',
                'required',
                'defaultChecked',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgToggleSwitch(
          key: ValueKey('pg-${v['defaultChecked']}'),
          id: 'pg',
          label: (v['label'] as String?) ?? 'Chave',
          description: v['description'] as String?,
          enabled: v['enabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          required: v['required'] as bool?,
          defaultChecked: v['defaultChecked'] as bool?,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "id: 'pg'",
            "label: '${v['label'] ?? 'Chave'}'",
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false || e.key == 'label') {
              continue;
            }
            args.add(
              e.value is String
                  ? "${e.key}: '${e.value}'"
                  : '${e.key}: ${e.value}',
            );
          }
          return 'SgToggleSwitch(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
