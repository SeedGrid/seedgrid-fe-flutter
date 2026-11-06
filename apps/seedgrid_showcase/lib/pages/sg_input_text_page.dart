// Showcase do SgInputText. Mesmos exemplos, na mesma ordem, do showcase React (a fonte da verdade); so ficam de
// fora os que dependem da linguagem (react-hook-form). O codigo exibido em cada exemplo e o trecho entre
// `// #region` e `// #endregion` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_text_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';
import '../src/showcase_log_box.dart';
import '../src/showcase_i18n.dart';

class SgInputTextPage extends StatefulWidget {
  const SgInputTextPage({super.key});

  @override
  State<SgInputTextPage> createState() => _SgInputTextPageState();
}

class _SgInputTextPageState extends State<SgInputTextPage> {
  final SgFormController _form = SgFormController(
    defaultValues: {'nome': '', 'controlled': 'Texto inicial'},
  );
  String _enviado = '';
  String? _validationMsg;
  String _sufixo = '';
  String _prefixo = '';
  String _ambos = '';
  final List<String> _iconLog = [];
  final List<String> _eventLog = [];
  final Map<String, String> _standalone = {};

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _log(String entry) => setState(() => _eventLog.insert(0, entry));

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Campo ligado a um formulário (SgFormController): name + control; o valor sai no envio.',
        preview:
            // #region sg-input-text-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputText(
                    id: 'demo-basic',
                    labelText: context.tx('Nome completo'),
                    name: 'nome',
                    control: _form,
                  ),
                ),
                const SizedBox(height: 8),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['nome']}'),
                  ),
                ),
                const SizedBox(height: 8),
                Text('${context.tx('Valor')}: $_enviado'),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextBasico,
      ),
      ShowcaseExample(
        title: 'Obrigatório',
        description:
            'required valida ao sair do campo; requiredMessage troca a mensagem.',
        preview:
            // #region sg-input-text-obrigatorio
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputText(
                    id: 'demo-required',
                    labelText: context.tx('Campo obrigatório'),
                    required: true,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputText(
                    id: 'demo-required-custom',
                    labelText: context.tx('Mensagem customizada'),
                    required: true,
                    requiredMessage: context.tx('Preencha este campo!'),
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextObrigatorio,
      ),
      ShowcaseExample(
        title: 'Controlado',
        description:
            'O formulário guarda o valor: setValue preenche ou limpa o campo por fora e o valor atual aparece em tempo real.',
        preview:
            // #region sg-input-text-controlado
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputText(
                    id: 'demo-controlled',
                    labelText: context.tx('Nome do cliente'),
                    name: 'controlled',
                    control: _form,
                  ),
                  const SizedBox(height: 12),
                  ListenableBuilder(
                    listenable: _form,
                    builder: (context, _) => Text(
                      '${context.tx('Estado atual')}: "${_form.getValue('controlled') ?? ''}"',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SgButton(
                        label: Text(
                          context.tx('Simular preenchimento via API'),
                        ),
                        onClick: () => _form.setValue(
                          'controlled',
                          context.tx('Texto vindo da API'),
                        ),
                      ),
                      SgButton(
                        appearance: SgAppearance.outline,
                        label: Text(context.tx('Setar outro valor')),
                        onClick: () => _form.setValue(
                          'controlled',
                          context.tx('Outro valor'),
                        ),
                      ),
                      SgButton(
                        appearance: SgAppearance.outline,
                        severity: SgSeverity.danger,
                        label: Text(context.tx('Limpar campo')),
                        onClick: () => _form.setValue('controlled', ''),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextControlado,
      ),
      ShowcaseExample(
        title: 'Contador de caracteres',
        description:
            'Usa maxLength e showCharCounter para limitar e exibir contagem.',
        preview:
            // #region sg-input-text-contador
            SizedBox(
              width: 320,
              child: SgInputText(
                id: 'demo-counter',
                labelText: context.tx('Máximo 20 caracteres'),
                maxLength: 20,
                showCharCounter: true,
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextContador,
      ),
      ShowcaseExample(
        title: 'Tamanho mínimo',
        description: 'Valida que o texto tem um tamanho mínimo ao perder foco.',
        preview:
            // #region sg-input-text-tamanho-minimo
            SizedBox(
              width: 320,
              child: SgInputText(
                id: 'demo-minlength',
                labelText: context.tx('Mínimo 5 caracteres'),
                minLength: 5,
                showCharCounter: true,
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextTamanhoMinimo,
      ),
      ShowcaseExample(
        title: 'Mínimo de palavras',
        description: 'Valida quantidade mínima de palavras.',
        preview:
            // #region sg-input-text-palavras
            SizedBox(
              width: 320,
              child: SgInputText(
                id: 'demo-words',
                labelText: context.tx('Mínimo 3 palavras'),
                minNumberOfWords: 3,
                minNumberOfWordsMessage: context.tx(
                  'Digite pelo menos 3 palavras.',
                ),
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextPalavras,
      ),
      ShowcaseExample(
        title: 'Validação customizada',
        description:
            'validation devolve a mensagem de erro (ou null) e onValidation informa o resultado.',
        preview:
            // #region sg-input-text-validacao
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputText(
                    id: 'demo-validation',
                    labelText: context.tx('Apenas letras'),
                    validation: (v) =>
                        RegExp(r'[^\p{L}\s]', unicode: true).hasMatch(v)
                        ? context.tx('Apenas letras são permitidas.')
                        : null,
                    onValidation: (msg) => setState(() => _validationMsg = msg),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'onValidation: ${_validationMsg == null ? context.tx('válido') : '"$_validationMsg"'}',
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextValidacao,
      ),
      ShowcaseExample(
        title: 'Ícone de prefixo',
        description: 'Ícone posicionado à esquerda do input.',
        preview:
            // #region sg-input-text-icone
            SizedBox(
              width: 320,
              child: SgInputText(
                id: 'demo-prefix',
                labelText: context.tx('Buscar'),
                prefixIcon: const Icon(Icons.search, size: 16),
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextIcone,
      ),
      ShowcaseExample(
        title: 'Prefixo e sufixo',
        description:
            'prefixText e suffixText aparecem no campo e entram no valor entregue a onChange.',
        preview:
            // #region sg-input-text-afixos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputText(
                    id: 'demo-suffix',
                    labelText: context.tx('Email'),
                    suffixText: '@gmail.com',
                    onChange: (v) => setState(() => _sufixo = v),
                  ),
                ),
                Text('${context.tx('Valor completo')}: $_sufixo'),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputText(
                    id: 'demo-prefix-text',
                    labelText: context.tx('Website'),
                    prefixText: 'www.',
                    onChange: (v) => setState(() => _prefixo = v),
                  ),
                ),
                Text('${context.tx('Valor completo')}: $_prefixo'),
                const SizedBox(height: 12),
                SizedBox(
                  width: 384,
                  child: SgInputText(
                    id: 'demo-both',
                    labelText: context.tx('Domínio'),
                    prefixText: 'www.',
                    suffixText: '.seedgrid.com.br',
                    onChange: (v) => setState(() => _ambos = v),
                  ),
                ),
                Text('${context.tx('Valor completo')}: $_ambos'),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextAfixos,
      ),
      ShowcaseExample(
        title: 'Botões de ícone',
        description:
            'iconButtons recebe uma lista de widgets; cada botão tem o onClick que você definir.',
        preview:
            // #region sg-input-text-botoes
            SizedBox(
              width: 384,
              child: Column(
                children: [
                  SgInputText(
                    id: 'demo-iconbtns',
                    labelText: context.tx('Texto para copiar'),
                    iconButtons: [
                      SgButton(
                        iconOnly: true,
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        leftIcon: const Icon(Icons.copy),
                        onClick: () => setState(
                          () => _iconLog.insert(0, context.tx('Copiado')),
                        ),
                      ),
                      SgButton(
                        iconOnly: true,
                        size: SgSize.sm,
                        appearance: SgAppearance.outline,
                        leftIcon: const Icon(Icons.notifications_outlined),
                        onClick: () => setState(
                          () => _iconLog.insert(
                            0,
                            context.tx('Alerta disparado!'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ShowcaseLogBox(
                    entries: _iconLog,
                    hint: context.tx('Digite algo e clique nos ícones...'),
                    height: 96,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextBotoes,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description:
            'Sem borda (withBorder: false) e preenchido (filled: true).',
        preview:
            // #region sg-input-text-variacoes
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputText(
                    id: 'demo-noborder',
                    labelText: context.tx('Sem borda'),
                    withBorder: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputText(
                    id: 'demo-filled',
                    labelText: context.tx('Preenchido'),
                    filled: true,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextVariacoes,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description: 'clearButton=false remove o X do input.',
        preview:
            // #region sg-input-text-sem-limpar
            SizedBox(
              width: 320,
              child: SgInputText(
                id: 'demo-noclear',
                labelText: context.tx('Sem limpar'),
                clearButton: false,
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextSemLimpar,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description: 'width e borderRadius customizáveis.',
        preview:
            // #region sg-input-text-largura
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SgInputText(
                  id: 'demo-w200',
                  labelText: context.tx('200px'),
                  width: 200,
                ),
                SgInputText(
                  id: 'demo-w300',
                  labelText: context.tx('300px arredondado'),
                  width: 300,
                  borderRadius: 20,
                ),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado e somente leitura',
        description:
            'disabled bloqueia o campo; readOnly deixa copiar, mas não editar.',
        preview:
            // #region sg-input-text-estados
            Column(
              children: [
                SizedBox(
                  width: 320,
                  child: SgInputText(
                    id: 'demo-disabled',
                    labelText: context.tx('Desabilitado'),
                    initialValue: context.tx('Não editável'),
                    enabled: false,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: SgInputText(
                    id: 'demo-readonly',
                    labelText: context.tx('Somente leitura'),
                    initialValue: context.tx('Apenas leitura'),
                    readOnly: true,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextEstados,
      ),
      ShowcaseExample(
        title: 'Erro externo',
        description:
            'Prop error exibe mensagem de erro vinda do pai (server-side, etc).',
        preview:
            // #region sg-input-text-erro-externo
            SizedBox(
              width: 320,
              child: SgInputText(
                id: 'demo-error',
                labelText: context.tx('Com erro externo'),
                error: context.tx('Este email já está cadastrado.'),
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextErroExterno,
      ),
      ShowcaseExample(
        title: 'Standalone (form completo)',
        description:
            'Sem controlador de formulário: cada campo avisa o valor em onChange e o botão monta o resultado.',
        preview:
            // #region sg-input-text-standalone
            SizedBox(
              width: 384,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputText(
                    id: 'standalone-nome',
                    labelText: context.tx('Nome'),
                    onChange: (v) => _standalone['nome'] = v,
                  ),
                  const SizedBox(height: 12),
                  SgInputText(
                    id: 'standalone-email',
                    labelText: context.tx('E-mail'),
                    onChange: (v) => _standalone['email'] = v,
                  ),
                  const SizedBox(height: 12),
                  SgInputText(
                    id: 'standalone-cpf',
                    labelText: context.tx('CPF'),
                    onChange: (v) => _standalone['cpf'] = v,
                  ),
                  const SizedBox(height: 12),
                  SgButton(
                    label: Text(context.tx('Salvar')),
                    onClick: () => _log(
                      '[${context.tx('salvar')}] ${{'nome': _standalone['nome'] ?? '', 'email': _standalone['email'] ?? '', 'cpf': _standalone['cpf'] ?? ''}}',
                    ),
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextStandalone,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description: 'onEnter, onExit, onChange, onClear, onValidation.',
        preview:
            // #region sg-input-text-eventos
            SizedBox(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SgInputText(
                    id: 'demo-events',
                    labelText: context.tx('Digite e observe o log'),
                    required: true,
                    onChange: (v) => _log('onChange: "$v"'),
                    onEnter: () => _log(context.tx('onEnter (focus)')),
                    onExit: () => _log(context.tx('onExit (blur)')),
                    onClear: () => _log('onClear'),
                    onValidation: (msg) =>
                        _log('onValidation: ${msg ?? context.tx('válido')}'),
                  ),
                  const SizedBox(height: 12),
                  ShowcaseLogBox(
                    entries: _eventLog,
                    hint: context.tx('Interaja com o input...'),
                    height: 160,
                  ),
                ],
              ),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextEventos,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        description:
            'Compare os modos de rótulo: flutuante, acima e à esquerda.',
        preview:
            // #region sg-input-text-rotulo
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputText(
                    id: 'sg-input-text-label-float',
                    labelText: context.tx('Flutuante'),
                    labelPosition: SgInputTextLabelPosition.float,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputText(
                    id: 'sg-input-text-label-top',
                    labelText: context.tx('Acima'),
                    labelPosition: SgInputTextLabelPosition.top,
                    elevation: SgInputTextElevation.md,
                    withBorder: false,
                  ),
                ),
                SizedBox(
                  width: 360,
                  child: SgInputText(
                    id: 'sg-input-text-label-left',
                    labelText: context.tx('Esquerda'),
                    labelPosition: SgInputTextLabelPosition.left,
                    labelWidth: 140,
                    labelAlign: SgInputTextLabelAlign.end,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextRotulo,
      ),
      ShowcaseExample(
        title: 'Elevação',
        description: 'Compare os níveis de sombra disponíveis no campo.',
        preview:
            // #region sg-input-text-elevacao
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: SgInputText(
                    id: 'sg-input-text-elevation-none',
                    labelText: context.tx('Elevação none'),
                    elevation: SgInputTextElevation.none,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputText(
                    id: 'sg-input-text-elevation-sm',
                    labelText: context.tx('Elevação sm'),
                    elevation: SgInputTextElevation.sm,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputText(
                    id: 'sg-input-text-elevation-md',
                    labelText: context.tx('Elevação md'),
                    elevation: SgInputTextElevation.md,
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: SgInputText(
                    id: 'sg-input-text-elevation-lg',
                    labelText: context.tx('Elevação lg'),
                    elevation: SgInputTextElevation.lg,
                  ),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextElevacao,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputText',
      description:
          'Campo de texto com rótulo, afixos, validação e ligação a formulário (SgForm).',
      examples: examples,
      propSpecs: sgPropSpecs['SgInputText']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputText']!
            .where(
              (s) => const {
                'labelPosition',
                'filled',
                'enabled',
                'readOnly',
                'clearButton',
                'required',
                'hintText',
                'placeholder',
                'prefixText',
                'suffixText',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputText(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputTextLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          filled: v['filled'] as bool?,
          enabled: v['enabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          clearButton: v['clearButton'] as bool?,
          required: v['required'] as bool?,
          hintText: v['hintText'] as String?,
          placeholder: v['placeholder'] as String?,
          prefixText: v['prefixText'] as String?,
          suffixText: v['suffixText'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Rótulo'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputTextLabelPosition.${SgInputTextLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputText(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
